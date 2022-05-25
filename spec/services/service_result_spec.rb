#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2022 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

require 'spec_helper'

describe ServiceResult, type: :model do
  let(:instance) { ServiceResult.new }

  describe 'success' do
    it 'is what the service is initialized with' do
      instance = ServiceResult.new success: true

      expect(instance.success).to be_truthy
      expect(instance.success?).to be_truthy

      instance = ServiceResult.new success: false

      expect(instance.success).to be_falsey
      expect(instance.success?).to be_falsey
    end

    it 'returns what is provided' do
      instance.success = true

      expect(instance.success).to be_truthy
      expect(instance.success?).to be_truthy

      instance.success = false

      expect(instance.success).to be_falsey
      expect(instance.success?).to be_falsey
    end

    it 'is false by default' do
      expect(instance.success).to be_falsey
      expect(instance.success?).to be_falsey
    end
  end

  describe 'errors' do
    let(:errors) { ['errors'] }

    it 'is what has been provided' do
      instance.errors = errors

      expect(instance.errors).to eql errors
    end

    it 'is what the object is initialized with' do
      instance = ServiceResult.new errors: errors

      expect(instance.errors).to eql errors
    end

    it 'is an empty ActiveModel::Errors by default' do
      expect(instance.errors).to be_a ActiveModel::Errors
    end

    context 'providing errors from user' do
      let(:result) { build :work_package }

      it 'creates a new errors instance' do
        instance = ServiceResult.new result: result
        expect(instance.errors).not_to eq result.errors
      end
    end
  end

  describe 'result' do
    let(:result) { double('result') }

    it 'is what the object is initialized with' do
      instance = ServiceResult.new result: result

      expect(instance.result).to eql result
    end

    it 'is what has been provided' do
      instance.result = result

      expect(instance.result).to eql result
    end

    it 'is nil by default' do
      instance = ServiceResult.new

      expect(instance.result).to be_nil
    end
  end

  describe 'apply_flash_message!' do
    let(:service_result) { described_class.new(message: message, **params) }
    let(:params) { {} }
    let(:message) { 'some message' }

    subject(:flash) do
      {}.tap { service_result.apply_flash_message!(_1) }
    end

    context 'when successful' do
      let(:params) { { success: true } }

      it { is_expected.to include(notice: message) }
    end

    context 'when failure' do
      let(:params) { { success: false } }

      it { is_expected.to include(error: message) }
    end

    context 'when setting message_type to :info' do
      let(:params) { { message_type: :info } }

      it { is_expected.to include(info: message) }
    end
  end
end
