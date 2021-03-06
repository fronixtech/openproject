RSpec.describe Airbrake::RemoteSettings do
  let(:project_id) { 123 }
  let(:host) { 'https://v1-production-notifier-configs.s3.amazonaws.com' }

  let(:endpoint) do
    "#{host}/2020-06-18/config/#{project_id}/config.json"
  end

  let(:body) do
    {
      'poll_sec' => 1,
      'settings' => [
        {
          'name' => 'apm',
          'enabled' => false,
        },
        {
          'name' => 'errors',
          'enabled' => true,
        },
      ],
    }
  end

  let!(:stub) do
    stub_request(:get, Regexp.new(endpoint))
      .to_return(status: 200, body: body.to_json)
  end

  describe ".poll" do
    describe "config loading" do
      let(:settings_data) { described_class::SettingsData.new(project_id, body) }

      before do
        allow(described_class::SettingsData).to receive(:new).and_return(settings_data)
      end

      it "yields the config to the block twice" do
        block = proc {}
        allow(block).to receive(:call)

        remote_settings = described_class.poll(project_id, host, &block)
        sleep(0.2)
        remote_settings.stop_polling

        expect(stub).to have_been_requested.once
        expect(block).to have_received(:call).twice
      end
    end

    context "when no errors are raised" do
      it "makes a request to AWS S3" do
        remote_settings = described_class.poll(project_id, host) { anything }
        sleep(0.1)
        remote_settings.stop_polling

        expect(stub).to have_been_requested.at_least_once
      end

      it "sends params about the environment with the request" do
        remote_settings = described_class.poll(project_id, host) { anything }
        sleep(0.1)
        remote_settings.stop_polling

        stub_with_query_params = stub.with(
          query: URI.decode_www_form(described_class::QUERY_PARAMS).to_h,
        )
        expect(stub_with_query_params).to have_been_requested.at_least_once
      end

      # rubocop:disable RSpec/MultipleExpectations
      it "fetches remote settings" do
        settings = nil
        remote_settings = described_class.poll(project_id, host) do |data|
          settings = data
        end
        sleep(0.1)
        remote_settings.stop_polling

        expect(settings.error_notifications?).to be(true)
        expect(settings.performance_stats?).to be(false)
        expect(settings.interval).to eq(1)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context "when an error is raised while making a HTTP request" do
      let(:https) { instance_double(Net::HTTP) }

      before do
        allow(Net::HTTP).to receive(:new).and_return(https)
        allow(https).to receive(:use_ssl=).with(true)
        allow(https).to receive(:request).and_raise(StandardError)
      end

      it "doesn't fetch remote settings" do
        settings = nil
        remote_settings = described_class.poll(project_id, host) do |data|
          settings = data
        end
        sleep(0.1)
        remote_settings.stop_polling

        expect(stub).not_to have_been_requested
        expect(settings.interval).to eq(600)
      end
    end

    context "when an error is raised while parsing returned JSON" do
      before do
        allow(JSON).to receive(:parse).and_raise(JSON::ParserError)
      end

      it "doesn't update settings data" do
        settings = nil
        remote_settings = described_class.poll(project_id, host) do |data|
          settings = data
        end
        sleep(0.1)
        remote_settings.stop_polling

        expect(stub).to have_been_requested.once
        expect(settings.interval).to eq(600)
      end
    end

    context "when API returns a non-200 response" do
      let!(:stub) do
        stub_request(:get, Regexp.new(endpoint))
          .to_return(status: 201, body: body.to_json)
      end

      it "doesn't update settings data" do
        settings = nil
        remote_settings = described_class.poll(project_id, host) do |data|
          settings = data
        end
        sleep(0.1)
        remote_settings.stop_polling

        expect(stub).to have_been_requested.once
        expect(settings.interval).to eq(600)
      end

      it "logs error" do
        allow(Airbrake::Loggable.instance).to receive(:error)

        remote_settings = described_class.poll(project_id, host) { anything }
        sleep(0.1)
        remote_settings.stop_polling

        expect(Airbrake::Loggable.instance).to have_received(:error).with(body.to_json)
      end
    end

    context "when API returns a 200 response" do
      let!(:stub) do
        stub_request(:get, Regexp.new(endpoint))
          .to_return(status: 200, body: body.to_json)
      end

      it "doesn't log errors" do
        allow(Airbrake::Loggable.instance).to receive(:error)

        remote_settings = described_class.poll(project_id, host) { anything }
        sleep(0.1)
        remote_settings.stop_polling

        expect(Airbrake::Loggable.instance).not_to have_received(:error)
        expect(stub).to have_been_requested.once
      end
    end

    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context "when a config route is specified in the returned data" do
      let(:new_config_route) do
        '213/config/111/config.json'
      end

      let(:body) do
        { 'config_route' => new_config_route, 'poll_sec' => 0.1 }
      end

      let!(:new_stub) do
        stub_request(:get, Regexp.new(new_config_route))
          .to_return(status: 200, body: body.to_json)
      end

      it "makes the next request to the specified config route" do
        remote_settings = described_class.poll(project_id, host) { anything }
        sleep(0.2)

        remote_settings.stop_polling

        expect(stub).to have_been_requested.once
        expect(new_stub).to have_been_requested.once
      end
    end
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end
end
