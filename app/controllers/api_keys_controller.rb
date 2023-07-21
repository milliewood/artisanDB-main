class ApiKeysController < ApplicationController
    def create 
        @api_key = ApiKey.new
        if @api_key.save
            render json: { key: @api_key.key, secret: @api_key.secret }, status: :created
        else
            render json: @api_key.errors, status: :unprocessable_entity
        end
    end
end
