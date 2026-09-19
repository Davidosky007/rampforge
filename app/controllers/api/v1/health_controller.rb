module Api
  module V1
    class HealthController < ApplicationController
      def show
        render json: {
          status: "ok",
          service: "rampforge"
        }
      end
    end
  end
end
