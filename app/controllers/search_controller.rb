# frozen_string_literal: true

require 'google/apis/civicinfo_v2'

class SearchController < ApplicationController
    def search
        address = params[:address]
        service = Google::Apis::CivicinfoV2::CivicInfoService.new
        service.key = Rails.application.credentials[:GOOGLE_API_KEY]
        #         begin
        result = service.representative_info_by_address(address: address)
        @representatives = Representative.civic_api_to_representative_params(result)
        #         rescue StandardError
        #             redirect_to representatives_path
        #             flash[:notice] = 'Invalid address'
        #             return
        #         end
        render 'representatives/search'
    end

    def show
        @name = if params[:format].nil?
                    params[:name]
                else
                    "#{params[:name]}.#{params[:format]}"
                end

        @representatives = Representative.where(name: @name).limit(1)
        render 'representatives/show'
    end
end
