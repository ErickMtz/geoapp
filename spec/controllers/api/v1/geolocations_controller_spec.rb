require 'rails_helper'

RSpec.describe Api::V1::GeolocationsController, type: :controller do
  describe 'POST #create' do
    context 'when geolocation exists' do
      let!(:geolocation) { FactoryBot.create(:geolocation) }

      it 'returns the existing geolocation' do
        post :create, params: { geolocation: { ip: geolocation.ip } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(JSON.parse(geolocation.to_json))
      end
    end

    context 'when geolocation does not exist' do
      let(:ip) { '8.8.8.8' }
      let(:geolocation_data) { { "country_code" => 'US', "city" => 'Mountain View', "latitude" => 37.386, "longitude" => -122.0838 } }

      before do
        allow_any_instance_of(AppServices::GeolocalizationService).to receive(:call).and_return(double(success?: true, payload: geolocation_data))
      end

      it 'creates a new geolocation' do
        post :create, params: { geolocation: { ip: ip } }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include(geolocation_data)
      end
    end

    context 'when geolocation service fails' do
      before do
        allow_any_instance_of(AppServices::GeolocalizationService).to receive(:call).and_return(double(success?: false, payload: { error: 'Service unavailable' }))
      end

      it 'renders error message' do
        post :create, params: { geolocation: { ip: '8.8.8.8' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Service unavailable' })
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:geolocation) { FactoryBot.create(:geolocation) }

    it 'destroys the geolocation' do
      delete :destroy, params: { ip: geolocation.ip }
      expect(response).to have_http_status(:no_content)
      expect(Geolocation.exists?(geolocation.id)).to be_falsey
    end
  end

  describe 'GET #show' do
    let!(:geolocation) { FactoryBot.create(:geolocation) }

    it 'returns the geolocation' do
      get :show, params: { ip: geolocation.ip }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(JSON.parse(geolocation.to_json))
    end
  end

  describe 'GET #index' do
    let!(:geolocations) { FactoryBot.create_list(:geolocation, 3) }

    it 'returns all geolocations' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end
