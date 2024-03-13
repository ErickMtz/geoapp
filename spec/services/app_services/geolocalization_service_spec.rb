require 'rails_helper'

describe AppServices::GeolocalizationService do
  let(:ipstack_api_key) { "your_api_key" }

  describe '#initialize' do
    context 'when no IP is provided' do
      it 'raises an error' do
        expect { described_class.new({}) }.to raise_error(StandardError, "You must provide either ip or url")
      end
    end
  end

  describe '#call' do
    let(:ip) { '8.8.8.8' }
    let(:params) { { ip: ip } }
    let(:response_body) { { city: 'Mountain View', country: 'United States' }.to_json }

    before do
      stub_const('ENV', {'IPSTACK_API_KEY' => ipstack_api_key})
      stub_request(:get, "#{AppServices::GeolocalizationService::BASE_URL}#{ip}?access_key=#{ipstack_api_key}")
        .to_return(status: 200, body: response_body)
    end

    context 'when the API call is successful' do
      it 'returns a successful response' do
        result = described_class.new(params).call
        expect(result.success?).to eq(true)
        expect(result.payload[:city]).to eq('Mountain View')
        expect(result.payload[:country]).to eq('United States')
      end
    end

    context 'when the API call returns an error' do
      let(:error_message) { 'Invalid API key' }

      before do
        stub_request(:get, "#{AppServices::GeolocalizationService::BASE_URL}#{ip}?access_key=#{ipstack_api_key}")
          .to_return(status: 200, body: { error: error_message }.to_json)
      end

      it 'returns a failed response with the error message' do
        result = described_class.new(params).call
        expect(result.success?).to eq(false)
        expect(result.payload).to eq(error_message)
      end
    end

    context 'when the API call encounters an error' do
      let(:error_message) { 'Connection failed' }

      before do
        stub_request(:get, "#{AppServices::GeolocalizationService::BASE_URL}#{ip}?access_key=#{ipstack_api_key}")
          .to_raise(Faraday::Error.new(error_message))
      end

      it 'returns a failed response with the error' do
        result = described_class.new(params).call
        expect(result.success?).to eq(false)
        expect(result.payload).to be_an_instance_of(Faraday::Error)
      end
    end
  end
end
