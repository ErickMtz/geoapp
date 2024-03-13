require 'rails_helper'

RSpec.describe Geolocation, type: :model do
  it 'is valid with valid attributes' do
    geolocation = Geolocation.new(
      ip: '8.8.8.8',
      country_code: 'US'
    )
    expect(geolocation).to be_valid
  end

  it 'is not valid without an IP address' do
    geolocation = Geolocation.new(ip: nil)
    expect(geolocation).not_to be_valid
    expect(geolocation.errors[:ip]).to include("can't be blank")
  end

  it 'is not valid without a country code' do
    geolocation = Geolocation.new(country_code: nil)
    expect(geolocation).not_to be_valid
    expect(geolocation.errors[:country_code]).to include("can't be blank")
  end

  it 'is not valid with a duplicate IP address' do
    Geolocation.create(ip: '8.8.8.8', country_code: 'US')
    geolocation = Geolocation.new(ip: '8.8.8.8', country_code: 'CA')
    expect(geolocation).not_to be_valid
    expect(geolocation.errors[:ip]).to include('has already been taken')
  end
end