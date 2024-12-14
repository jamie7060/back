class HealthNewsController < ApplicationController
  before_action :set_health_news, only: [:show, :update, :destroy]
  before_action :authenticate_request!
  before_action :is_admin?

  # GET /health_news
  def index
    @health_news = HealthNews.all

    render json: @health_news
  end

  # GET /health_news/1
  def show
    render json: @health_news
  end

  # POST /health_news
  def create
    @health_news = HealthNews.new(health_news_params)

    if @health_news.save
      render json: @health_news, status: :created, location: @health_news
    else
      render json: @health_news.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /health_news/1
  def update
    if @health_news.update(health_news_params)
      render json: @health_news
    else
      render json: @health_news.errors, status: :unprocessable_entity
    end
  end

  # DELETE /health_news/1
  def destroy
    @health_news.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_health_news
      @health_news = HealthNews.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def health_news_params
      params.require(:health_news).permit(:url, :press)
    end
end

def is_admin?
  if current_user.has_role? "admin"
    return
  else
    render json: { errors: ['접속 권한이 없습니다.'] }, status: :unauthorized
  end
end