# frozen_string_literal: true

require 'rails_helper'
require 'google/apis/civicinfo_v2'

describe Representative do
    describe 'can get valid address from API' do
        before(:each) do
            @representative = Representative.new(state: 'CA')
        end

        it 'sets state' do
            expect(@representative.state).to eq 'CA'
        end
    end

    describe 'stores information from civic_api_to_representative_params' do
        before(:each) do
            address = 'Dwight Way Berkeley, CA'
            service = Google::Apis::CivicinfoV2::CivicInfoService.new
            service.key = 'AIzaSyAbujzbnI9l-Jd-EKjKaJD9DNX1GFEUUwk'
            @rep_info = service.representative_info_by_address(address: address)
            @representatives = Representative.civic_api_to_representative_params(@rep_info)
        end

        it 'sets address state' do
            state = @rep_info.officials[0].address[0].state
            expect(@representatives[0].state).to eq state
        end
    end
end
