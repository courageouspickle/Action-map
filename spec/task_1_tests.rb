# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'ostruct'

# civic_result1 = OpenStruct.new(
#     { officials: [OpenStruct.new({ address:   [OpenStruct.new({
#                                                                   city:  'Washington',
#                                                                   state: 'DC',
#                                                                   zip:   '20500',
#                                                                   line1: '1600 Pennsylvania Avenue Northwest'
#                                                               })],
#                                    name:      'Donald J. Trump',
#                                    party:     'Republican Party',
#                                    photo_url: 'https://www.whitehouse.gov/sites/whitehouse.gov/
#                                    files/images/45/PE%20Color.jpg' }),
#                   OpenStruct.new({ address:   [OpenStruct.new({
#                                                                   city:  'Berkeley',
#                                                                   state: 'CA',
#                                                                   zip:   '00000',
#                                                                   line1: 'test address'
#                                                               })],
#                                    name:      'test',
#                                    party:     'Democratic Party',
#                                    photo_url: 'test url' })],
#       offices:   [OpenStruct.new({ division_id:      'ocd-division/country:us',
#                                    official_indices: [0],
#                                    name:             'President of the United States' }),
#                   OpenStruct.new({ division_id:      'test division',
#                                    official_indices: [1],
#                                    name:             'test' })] }
# )

civic_result2 = OpenStruct.new(
    { officials: [OpenStruct.new({ name: 'Donald J. Trump' })],
      offices:   [OpenStruct.new({ division_id:      'ocd-division/country:us',
                                   official_indices: [0],
                                   name:             'President of the United States' })] }
)

# Rspec.describe Representative do
# 	describe RepresentativesController, type: :controller do
# 		before :each do
# 					service = Google::Apis::CivicinfoV2::CivicInfoService.new
# 					service.key = Rails.application.credentials.dig(:GOOGLE_API_KEY)
# 					@rep_info = service.representative_info_by_address(address: 'California')
# 					Representative.civic_api_to_representative_params(@rep_info)
# 			end

# 			context 'when civic_api_to_representative_params is called' do
# 					it 'updates the database according to the given response' do
# 							@trump = Representative.find_by(name: 'Donald J. Trump')
# 							expect(@trump.title).to eq 'President of the United States'
# 							expect(@trump.ocdid).to eq 'ocd-division/country:us'
# 							expect(@trump.city).to eq 'Washington'
# 					end

# 					it 'should not create duplicates to the database' do
# 							Representative.civic_api_to_representative_params(@rep_info)
# 							@trumps = Representative.where({ name: 'Donald J. Trump' })
# 							expect(@trumps.length).to eq 1
# 					end
# 			end
# end

describe 'Representatives' do
    describe RepresentativesController, type: :controller do
        before :each do
            @representatives = [
                { name: 'rep1', ocdid: '123', title: 'AAA', address: 'Berkeley, CA',
                  party: 'Democrats', photo_url: 'a' },
                { name: 'rep2', ocdid: '123', title: 'AAA', address: 'Berkeley, CA',
                  party: 'Democrats', photo_url: 'a' },
                { name: 'rep3', ocdid: '123', title: 'AAA', address: 'Berkeley, CA',
                  party: 'Democrats', photo_url: 'a' }
            ]
            @representatives.each do |r|
                Representative.create!(r)
            end
        end

        it 'show the representative with all the attributes' do
            rep = Representative.find_by(name: 'rep1')
            get :show, params: { id: rep.id }
            assigns(:representative).each do |r|
                expect(r[:name]).to eq rep.name
                expect(r[:ocdid]).to eq rep.ocdid
                expect(r[:title]).to eq rep.title
                expect(r[:address]).to eq rep.address
                expect(r[:party]).to eq rep.party
                expect(r[:photo_url]).to eq rep.photo_url
            end
        end

        it 'show all representatives' do
            get :index
            expect(assigns(:representatives).length).to eq @representatives.length
        end
    end

    describe Representative, type: :model do
        before :each do
            @representatives = [
                { name: 'rep1', ocdid: '123', title: 'AAA', address: 'Berkeley, CA',
                  party: 'Democrats', photo_url: 'a' },
                { name: 'rep2', ocdid: '123', title: 'AAA', address: 'Berkeley, CA',
                  party: 'Democrats', photo_url: 'a' },
                { name: 'rep3', ocdid: '123', title: 'AAA', address: 'Berkeley, CA',
                  party: 'Democrats', photo_url: 'a' }
            ]
            @representatives.each do |r|
                Representative.create!(r)
            end
        end

        def extract_address(address)
            address_temp = ''

            address.each do |addr|
                address_temp += '\n' if address_temp != ''
                addr_temp = "#{addr.line1}, #{addr.city}, #{addr.state}, #{addr.zip}"
                address_temp += addr_temp
            end
            address_temp
        end

        it 'create the representatives' do
            reps = Representative.civic_api_to_representative_params(civic_result)
            expect(!reps.empty?)
        end

        it 'create the representatives with the correct attributes' do
            reps = Representative.civic_api_to_representative_params(civic_result)
            reps.each_with_index do |r, index|
                expect(r.name).to eq civic_result.officials[index].name
                expect(r.address).to eq extract_address(civic_result.officials[index].address)
                expect(r.party).to eq civic_result.officials[index].party
                expect(r.photo_url).to eq civic_result.officials[index].photo_url
                expect(r.ocdid).to eq civic_result.offices[index].division_id
                expect(r.title).to eq civic_result.offices[index].name
            end
        end

        it 'create the representatives without address, party, and photo_url' do
            reps = Representative.civic_api_to_representative_params(civic_result2)
            reps.each_with_index do |r, index|
                expect(r.name).to eq civic_result2.officials[index].name
                expect(r.ocdid).to eq civic_result2.offices[index].division_id
                expect(r.title).to eq civic_result2.offices[index].name
            end
        end

        it 'insert each representative only once' do
            Representative.civic_api_to_representative_params(civic_result2)
            reps = Representative.civic_api_to_representative_params(civic_result2)
            reps.each do |r|
                expect(Representative.where(name: r.name, ocdid: r.ocdid, title: r.title,
                                            address: r.address, party: r.party, photo_url: r.photo_url).size).to eq 1
            end
        end
    end
end
