class UploadsController < ApplicationController
  before_action :authenticate_request!
  before_action :is_admin?
  def new
  end

  def create
    #Uploading an object using a presigned URL for SDK for Ruby - Version 3.

    # require 'aws-sdk-s3'
    # require 'net/http'

    s3 = Aws::S3::Resource.new(region:'ap-northeast-2')
    # Make an object in your bucket for your upload
    obj = s3.bucket('twoyak-direct-uploads').object(permitted_params[:name])
    obj.upload_file(permitted_params[:file].tempfile)
    
    # Create an object for the upload
    @upload = Upload.new(
    		url: obj.public_url,
		    name: obj.key
    	)

    # Save the upload
    if @upload.save
      render json: @upload
    else
      render json: @upload.errors
    end
  end

  def index
    @uploads = Upload.all
    render json: @uploads
  end

  private

  def permitted_params
    params.permit(:name, :file)
  end

  def is_admin?
      if current_user.has_role? "admin"
          return
      else
          render json: { errors: ['접속 권한이 없습니다.'] }, status: :unauthorized
      end
  end
end