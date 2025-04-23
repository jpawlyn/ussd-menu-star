# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
COUNTRIES = [
  { name: 'Ghana', country_code: 'GHA', short_name: 'testing' },
  { name: 'Kenya', country_code: 'KEN', short_name: 'testing' },
  { name: 'Malawi', country_code: 'MWI', short_name: 'testing' },
  { name: 'Namibia', country_code: 'NAM', short_name: 'testing' },
  { name: 'Nigeria', country_code: 'NGA', short_name: 'testing' },
  { name: 'Rwanda', country_code: 'RWA', short_name: 'testing' },
  { name: 'South Africa', country_code: 'ZAF', short_name: 'testing' },
  { name: 'Tanzania', country_code: 'TZA', short_name: 'testing' },
  { name: 'Uganda', country_code: 'UGA', short_name: 'testing' },
  { name: 'Zambia', country_code: 'ZMB', short_name: 'testing' }
]

COUNTRIES.each do |country_hash|
  service_code = ServiceCode.find_or_create_by!(country_hash)
  service_code.accounts.find_or_create_by!(name: "#{country_hash[:name]} test account")
end

# Create a default admin user
user = User.find_or_initialize_by(email_address: 'admin@example.com')
if user.new_record?
  user.password = 'pleasechangeme'
  user.save!
end
