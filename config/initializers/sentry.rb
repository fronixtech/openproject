if OpenProject::Logging::SentryLogger.enabled?
  Sentry.init do |config|
    config.dsn = OpenProject::Logging::SentryLogger.sentry_dsn
    config.breadcrumbs_logger = OpenProject::Configuration.sentry_breadcrumb_loggers.map(&:to_sym)

    # Output debug info for sentry
    config.before_send = lambda do |event, hint|
      Rails.logger.debug do
        payload_sizes = event.to_json_compatible.transform_values { |v| JSON.generate(v).bytesize }.inspect
        "[Sentry] will send event #{hint}. Payload sizes are #{payload_sizes.inspect}"
      end

      event
    end

    # Add plugins with openproject/open_project in backtraces to internal
    config.app_dirs_pattern = /(bin|exe|app|config|lib|open_?project)/

    # Don't send loaded modules
    config.send_modules = false

    # Disable sentry's internal client reports
    config.send_client_reports = false

    # Cleanup backtrace
    config.backtrace_cleanup_callback = lambda do |backtrace|
      Rails.backtrace_cleaner.clean(backtrace)
    end

    # Sample rate for performance
    # 0.0 = disabled
    # 1.0 = all samples are traced
    sample_factor = OpenProject::Configuration.sentry_trace_factor.to_f

    # Define a tracing sample handler
    trace_sampler = lambda do |sampling_context|
      # if this is the continuation of a trace, just use that decision (rate controlled by the caller)
      next sampling_context[:parent_sampled] unless sampling_context[:parent_sampled].nil?

      # transaction_context is the transaction object in hash form
      # keep in mind that sampling happens right after the transaction is initialized
      # for example, at the beginning of the request
      transaction_context = sampling_context[:transaction_context]

      # transaction_context helps you sample transactions with more sophistication
      # for example, you can provide different sample rates based on the operation or name
      op = transaction_context[:op]
      transaction_name = transaction_context[:name]

      rate = case op
             when /request/
               case transaction_name
               when /health_check/
                 0.0
               else
                 [0.1 * sample_factor, 1.0].min
               end
             when /delayed_job/
               [0.01 * sample_factor, 1.0].min
             else
               0.0 # ignore all other transactions
             end

      Rails.logger.debug { "[SENTRY TRACE SAMPLER] Decided on sampling rate #{rate} for #{op}: #{transaction_name} " }

      rate
    end

    # Assign the sampler conditionally to avoid running the lambda
    # when we don't trace anyway
    if sample_factor.zero?
      Rails.logger.debug { "[SENTRY TRACE SAMPLER] Requested factor is zero, skipping performance tracing" }
      config.traces_sample_rate = 0
      config.traces_sampler = nil
    else
      Rails.logger.debug { "[SENTRY TRACE SAMPLER] Requested factor is #{sample_factor}, setting up performance tracing" }
      config.traces_sampler = trace_sampler
    end

    # Set release info
    config.release = OpenProject::VERSION.to_s
  end

  # Extend the core log delegator
  handler = ::OpenProject::Logging::SentryLogger.method(:log)
  ::OpenProject::Logging::LogDelegator.register(:sentry, handler)
end
