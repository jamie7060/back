class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :update, :destroy]
  before_action :authenticate_request!
  before_action :is_admin?

  # GET /contents
  def index
    if params[:category].nil?
      @contents = ContentSerializer.new(Content.all.paginate(page: params[:page].nil? ? 1 : params[:page], per_page: 20)).serialized_json
    else
      @contents = ContentSerializer.new(Content.where(category: params[:category]).paginate(page: params[:page], per_page: 6)).serialized_json
    end
    response.set_header('Total-Count', Content.all.size)

    render json: @contents
  end

  # GET /contents/1
  def show
    @content.thumbnail_url = rails_blob_url(@content.thumbnail_image)
    @content.save
    render json: ContentSerializer.new(@content).serialized_json
  end

  # POST /contents
  def create
    @content = Content.new(content_params)

    if @content.save
      render json: ContentSerializer.new(@content).serialized_json, status: :created, location: @content
    else
      render json: @content.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contents/1
  def update
    if @content.update(content_params)
      render json: @content
    else
      render json: @content.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contents/1
  def destroy
    @content.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_content
      @content = Content.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def content_params
      params.permit(:title, :category, :thumbnail_url, :body, :thumbnail_image)
    end

    def is_admin?
      if current_user.has_role? "admin"
        return
      else
        render json: { errors: ['접속 권한이 없습니다.'] }, status: :unauthorized
      end
    end
end
