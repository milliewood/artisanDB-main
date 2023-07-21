class Api::V1::DatabasesController < ApplicationController
    before_action :authenticate_user!
  
    def index
        databases = current_user.databases
        render json: databases
    end
    
    def upload_file
        database = Database.find(params[:id])
        file = params[:file]
    
        s3_client = Aws::S3::Client.new(credentials: Rails.application.config.aws_credentials)
        bucket_name = 'your-s3-bucket-name'
    
        object_key = "databases/#{database.id}/#{file.original_filename}"
        s3_client.put_object(bucket: bucket_name, key: object_key, body: file.read)
    
        database.update(file_url: "https://#{bucket_name}.s3.amazonaws.com/#{object_key}")
    
        render json: database
    end

    def create
        database = current_user.databases.build(database_params)

        if database.save
          render json: database, status: :created
        else
          render json: { errors: database.errors.full_messages }, status: :unprocessable_entity
        end
    end
  
    def show
        database = current_user.databases.find(params[:id])
        render json: database
    end
  
    def update
        database = current_user.databases.find(params[:id])

        if database.update(database_params)
          render json: database
        else
          render json: { errors: database.errors.full_messages }, status: :unprocessable_entity
        end
    end
  
    def destroy
        database = current_user.databases.find(params[:id])
        database.destroy
        head :no_content
    end
  
    private
  
    def database_params
      params.require(:database).permit(:name)
    end
  
    def authenticate_user!
        # Check if the request contains the API key in the headers
        api_key = request.headers['HTTP_API_KEY']
    
        if api_key.blank?
          render json: { error: 'Unauthorized' }, status: :unauthorized
          return
        end
    
        # Find the user based on the API key
        @current_user = User.find_by(api_key: api_key)
    
        if @current_user.nil?
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
    end
  end
  
