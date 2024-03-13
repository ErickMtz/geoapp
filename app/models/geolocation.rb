class Geolocation < ApplicationRecord
  validates :ip, presence: true, uniqueness: true
  validates :country_code, presence: true
end
