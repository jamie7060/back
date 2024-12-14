Rails.application.routes.draw do
  resources :contents
  resources :health_news
  resources :hospitals
  resources :adverse_effects, :except => [:index]
  resources :suggestions
  resources :drug_ingrs
  #s3 upload
  resources :uploads
  resources :prescription_photos, :except => [:update]

  # 속하는 의약품 보여주기
  get "related_drugs/:drug_ingr_id" => "drug_associations#show"


  #관리자용
  get "admin" => "admin#index"
  get "admin/user_analysis" => "admin#user_analysis"

  #유저 업데이트
  get "users/:id" => "users#show"
  patch "users" => "users#update"
  #모바일 버전 정보
  get "mobile/version" => "mobile#version"

  post "admin/check" => "admin#check"
  post "admin/push" => "admin#push"
  post "admin/push_all" => "admin#push_all"

  namespace :user do
    resources :mypage, :except => [:show]
    get 'mypage/test' => 'mypage#test'
    resources :sub_users, :except => [:index]
    #의약품으로 직접 안전정보(DUR) 가져오기
    get 'analysis/get_by_drug'
    #관심약물 추가
    resources :watch_drugs, :except => [:update, :destroy]
    scope ':sub_user_id' do
      #DUR 정보
      resources :diseases
      get 'analysis/get'
      get "analysis/single/:drug_id" => "single_drug#cautions"


      #가족력
      get "family_med_histories" => "family_med_histories#show"
      post "family_med_histories/:search_id" => "family_med_histories#create"
      delete "family_med_histories/:search_id" => "family_med_histories#destroy"
      #과거 병력
      get "past_diseases" => "past_diseases#show"
      post "past_diseases/:search_id" => "past_diseases#create"
      patch "past_diseases/:id" => "past_diseases#update"
      delete "past_diseases/:id" => "past_diseases#destroy"
      #현재 앓고있는 질환
      get "current_diseases" => "current_diseases#show"
      post "current_diseases/:search_id" => "current_diseases#create"
      patch "current_diseases/:id" => "current_diseases#update"
      delete "current_diseases/:id" => "current_diseases#destroy"
      delete "current_diseases/:id/to_past" => "current_diseases#destroy_to_past"
      #과거 복용 약물
      get "past_drugs" => "past_drugs#show"
      post "past_drugs/:search_id" => "past_drugs#create"
      patch "past_drugs/:id" => "past_drugs#update"
      delete "past_drugs/:id" => "past_drugs#destroy"
      #현재 복용 약물
      get "current_drugs" => "current_drugs#show"
      post "current_drugs/:search_id" => "current_drugs#create"
      patch "current_drugs/:id" => "current_drugs#update"
      delete "current_drugs/:id" => "current_drugs#destroy"
      delete "current_drugs/:id/to_past" => "current_drugs#destroy_to_past"
      #과거 복용 건강기능식품
      get "past_supplements" => "past_supplements#show"
      post "past_supplements/:search_id" => "past_supplements#create"
      patch "past_supplements/:id" => "past_supplements#update"
      delete "past_supplements/:id" => "past_supplements#destroy"
      #현재 복용 건강기능식품
      get "current_supplements" => "current_supplements#show"
      post "current_supplements/:search_id" => "current_supplements#create"
      patch "current_supplements/:id" => "current_supplements#update"
      delete "current_supplements/:id" => "current_supplements#destroy"
      delete "current_supplements/:id/to_past" => "current_supplements#destroy_to_past"

    end
  end
  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks', confirmations: 'users/confirmations', passwords: 'users/passwords' },
                       path_names: { sign_in: :login }
    # resources :user, only: [:show, :update]
    # social login
    post 'social' => 'users/social_login#sign_in'
  end

  root :to => redirect("http://twoyak.com/")

  #모바일 토큰 변환
  post "change" => "change_token#change"

  #전체 리뷰(관리자용)
  get "reviews" => "drug_reviews#all"
  #최근 리뷰 받기
  get "reviews/recent" => "drug_reviews#recent"
  #좋아요 순으로 받기
  get "reviews/popular" => "drug_reviews#popular"
  #평점 높은 리뷰 순으로 보기
  get "reviews/high_rating" => "drug_reviews#high_rating"
  #나의 리뷰 모아보기(내가 남긴 리뷰) // 토큰 필요
  get "reviews/my_reviews" => "drug_reviews#my_reviews"
  resources :drug_reviews, :except =>[:index, :show, :create, :update, :destroy] do
    #좋아요 눌렀는지 확인
    get '/like' => 'drug_review_likes#show'
    post '/like' => 'drug_review_likes#like_toggle'
  end

  #drug 사진
  get "drugs/:id/pics" => "drugs#show_pics"
  #drug dur
  get "drugs/:id/dur_check" => "drugs#dur_check"
  resources :drugs, :except => [:index] do
    resources :drug_reviews
     #좋아요 눌렀는지 확인
     get '/"id/like' => 'drug_review_likes#show'
     post '/:id/like' => 'drug_review_likes#like_toggle'
  end
  resources :supplements do
    resources :sup_reviews
  end
  # get "drugs/:search_term" => "drugs#show"
  resources :drug_imprints
  get 'analysis/interaction'
  # resources :search_terms
  # 각각에 대한 autocomplete search_term 제공
  get 'autocomplete/disease' => 'autocomplete#disease'
  get 'autocomplete/drug' => 'autocomplete#drug'
  get 'autocomplete/sup' => 'autocomplete#sup'
  get 'autocomplete/adverse_effect' => 'autocomplete#adverse_effect'

  resources :supplements, :except => [:show, :index]
  get "supplements/:search_term" => "supplements#show"
  # resources :supplement_ingrs_supplements
  resources :supplement_ingrs, :except => [:index]
  resources :interactions
  resources :dur_ingrs, :except => [:show]
  get "dur_ingrs/:search_term" => "dur_ingrs#show"
  # resources :drugs_dur_ingrs
  resources :classifications
  get 'search_terms' => 'search_terms#index'
  get 'singleSearch/' => 'drugs#find_drug_mobile'
  get 'searchSingle/' => 'drugs#find_drug_web'
  #user_id와 user_info_id 매치 시키기
  get 'infos_for_mobile/:id' => 'users#infos_for_mobile'
  get '/multiSearch' => "analysis#interaction"
  # #jwt authentication
  # post 'auth_user' => 'authentication#authenticate_user'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #social login
  match 'finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  # #for generating search_terms
  # get 'autocomplete/gen' => 'autocomplete#generate'
end
