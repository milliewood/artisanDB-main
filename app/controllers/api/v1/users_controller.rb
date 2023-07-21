# app/controllers/api/v1/users_controller.rb
class Api::V1::UsersController < ApplicationController
    def create
      user = User.new(user_params)
  
      if user.save
        render json: { api_key: user.api_key }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
  