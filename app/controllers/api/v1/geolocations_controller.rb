# app/controllers/api/v1/geolocations_controller.rb
module Api
  module V1
    class GeolocationsController < ApplicationController
      before_action :set_geolocation, only: [:show, :destroy]

      def create
        @geolocation = Geolocation.find_by(ip: geolocation_params[:ip])
        return render json: @geolocation if @geolocation

        response = fetch_geolocation_from_service(geolocation_params[:ip])
        if response.success?
          begin
            @geolocation = Geolocation.create(response.payload)
            render json: @geolocation, status: :created
          rescue ActiveRecord::RecordInvalid => e
            render json: { error: e.message }, status: :unprocessable_entity
          end
        else
          render json: response.payload, status: :unprocessable_entity
        end
      end

      def destroy
        return render json: { error: 'Geolocation not found' }, status: :not_found unless @geolocation

        @geolocation.destroy
        head :no_content
      end

      def show
        return render json: { error: 'Geolocation not found' }, status: :not_found unless @geolocation

        render json: @geolocation
      end

      def index
        @geolocations = Geolocation.all
        render json: @geolocations
      end

      private

      def set_geolocation
        ip = Resolv.getaddress(params[:ip]) # Resolve URL to IP
        @geolocation = Geolocation.find_by(ip: ip)
      rescue Resolv::ResolvError
      end

      def geolocation_params
        params.require(:geolocation).permit(:ip)
      end

      def fetch_geolocation_from_service(ip)
        AppServices::GeolocalizationService.new(ip: ip).call
      end
    end
  end
end
