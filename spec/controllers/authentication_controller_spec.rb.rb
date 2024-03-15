# spec/controllers/authentication_controller_spec.rb
require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe 'POST #authenticate' do
    let(:user) { FactoryBot.create(:user, email: 'user@example.com', password: 'password') }

    context 'with valid credentials' do
      it 'returns a JWT token' do
        post :authenticate, params: { email: user.email, password: 'password' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post :authenticate, params: { email: 'wrong_email@example.com', password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
