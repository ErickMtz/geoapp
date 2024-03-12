
module AppServices
    class GeolocalizationService

      BASE_URL = "http://api.ipstack.com/"

      def initialize(params)
        @ip = params[:ip]

        raise StandardError.new "You must provide either ip or url" unless @ip
      end

      def call
        response = Faraday.get("#{BASE_URL}#{ip}?access_key=#{ipstack_api_key}")
        parsed_response = JSON.parse(response.body).transform_keys { |k| k == "type" ? "ip_type" : k }.with_indifferent_access

        return OpenStruct.new({success?: false, payload: parsed_response[:error]}) if parsed_response[:error].present?

        OpenStruct.new({success?: true, payload: parsed_response})
      rescue Faraday::Error => error
        OpenStruct.new({success?: false, payload: error})
      end

      private

      attr_reader :ip

      def ipstack_api_key
        ENV["IPSTACK_API_KEY"]
      end
    end
end