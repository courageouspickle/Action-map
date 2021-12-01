 # frozen_string_literal: true

class Representative < ApplicationRecord
    has_many :news_items, dependent: :delete_all
	
	  def self.get_ocdid_and_title(rep_info, index)
        ocdid_temp = ''
				title_temp = ''
        rep_info.offices.each do |office|
            if office.official_indices.include? index
                title_temp = office.name
                ocdid_temp = office.division_id
            end
        end
        [ocdid_temp, title_temp]
    end
	
	 def self.get_address(official)
        if official.address.nil? || official.address.blank? || official.address.empty?
            city = ' '
            street = ' '
            state = ' '
            zip = ' '
        else
            official.address&.each do |a|
                city = a.city
                street = a.line1
                state = a.state
                zip = a.zip
            end
        end

        {city: city, street: street, state: state, zip: zip}
    end
	
	  def self.get_party(official)
        if official.party.nil? || official.party.blank? || official.party.empty?
					party = ' ' 
				else 
					party = official.party
				end
			
        {party: party}
    end
	
		def self.get_photo(official)
        if official.photo_url.nil? || official.photo_url.blank? || official.photo_url.empty?
					photo = ' ' 
				else 
					photo = official.photo_url
				end
			
        {photo: photo}
    end


# 		def self.get_phones(official)
# 				if official.phones.nil? || official.phones.blank? || official.phones.empty?
# 					phones = ' ' 
# 				else 
# 					phones = ''
#         	official.phones&.each do |p|
#           phones += p + ' '
# 				end			
    
#         {phones: phones}
#     end
	
	  def self.parse_official(official, title, ocdid)
			
        address = get_address(official)
				party = get_party(official)
				photo = get_photo(official)
# 				phones = get_phones(official)
        

#         {name:   official.name, ocdid: ocdid, title: title, city: address[:city],
#           street: address[:street], state: address[:state], zip: address[:zip], party: party[:party],
#           phones: phones[:phones], photo: photo[:photo]}
              {name:   official.name, ocdid: ocdid, title: title, city: address[:city],
          street: address[:street], state: address[:state], zip: address[:zip], party: party[:party],
          photo: photo[:photo]}
    end
	
		def self.civic_api_to_representative_params(rep_info)
        reps = []

        rep_info.officials.each_with_index do |official, index|

#             ocdid_temp = ''
#             title_temp = ''
#             city, street, state, zip = ''

#             rep_info.offices.each do |office|
#                 if office.official_indices.include? index
#                     title_temp = office.name
#                     ocdid_temp = office.division_id
#                 end
#             end
          
#             official.address&.each do |location|
#                 city = location.city, street = location.line1, state = location.state, zip = location.zip
#             end
          
#             party = official.party unless official.party.nil?
#             photo = official.photo_url unless official.photo_url.nil?            

#             rep = Representative.create!({ name: official.name, ocdid: ocdid_temp,
#                 title: title_temp, city: city, state: state, street: street, zip: zip, party: party, photo: photo})

					
						ocdid_temp, title_temp = get_ocdid_and_title(rep_info, index)

            params = parse_official(official, title_temp, ocdid_temp)

            rep = Representative.where({name: official.name, title: title_temp }).limit(1).take
            if rep.nil? || rep.empty? || rep.blank?
                rep = Representative.create!(params)
                rep.save
            end

            reps.push(rep)
        end
        reps
    end
		
		private_class_method :get_ocdid_and_title
		private_class_method :get_address
		private_class_method :get_party
# 		private_class_method :get_phones
		private_class_method :parse_official

end
