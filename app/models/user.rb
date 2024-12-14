class User < ApplicationRecord
  rolify :role_cname => 'UserRole'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable, :omniauthable,
         :omniauth_providers => [:facebook, :google_oauth2, :naver]

  has_many :sub_users, :dependent => :destroy
  #의약품/건강기능식품 리뷰
  has_many :drug_reviews
  #내가 남긴 리뷰 이상반응들
  has_many :adverse_effects, :through => :drug_reviews

  has_many :sup_reviews
  #리뷰 댓글 남기기
  has_many :drug_review_comments
  has_many :sup_review_comments

  #건의 사항 남기기
  has_many :suggestions, dependent: :destroy 

  #관심 의약품/건강기능식품
  has_many :watch_drugs
  has_many :watch_drug, :through => :watch_drugs
  has_many :watch_supplements
  has_many :watch_supplement, :through => :watch_supplements

  has_many :identities, dependent: :destroy

  #리뷰 좋아요
  has_many :drug_review_likes
  has_many :l_drug_reviews, through: :drug_review_likes, source: :drug_review

  

  #이메일 형식
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  # validates :email, presence: true,
  # length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  
  # after_create :set_default_role, if: Proc.new { User.count > 1 }

  # #for fast json
  # attr_accessor :id, :email, :sub_user_ids, :drug_review_ids, :sup_review_ids, :drug_review_comment_ids, :sup_review_comment_ids, :suggestion_ids, :watch_drug_ids, :watch_supplement_ids, :identity_ids, :drug_review_like_ids, :l_drug_review_ids

  #소셜 로그인시 두개로 로그인하지 않도록
  def self.find_for_oauth(auth, signed_in_resource = nil)
    #이메일 설정하기
    email = auth.info.email

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    #이메일 이미 존재하는 경우
    if !identity.persisted? && !User.where(:email => email).empty?
      user = User.where(:email => email).first
      if !user.blank?
        return {error: "#{user.email}(으)로 이미 가입하셨습니다."}
      else
        return {error: "회원가입 도중 오류가 발생했습니다. 관리자에게 문의해주세요."}
      end
    end

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup

      unless self.where(email: email).exists?
        #이메일 없으면 새로운 데이터 생성
        if user.nil?
          
            # Create the user if it's a new registration
          user = User.new(
            email: email,
            password: Devise.friendly_token[0,20]
          )
          user.skip_confirmation!
          user.save!
          if(auth.provider == "naver")
            sub_user = auth.info.nickname.blank? ? SubUser.new(user_name: email[/[^@]+/]) : SubUser.new(user_name: auth.info.nickname)
            sub_user.user = user
            if (auth.extra.raw_info.response.gender == "M")
              sub_user.sex = 1
            elsif (auth.extra.raw_info.response.gender == "F")
              sub_user.sex = 0
            end
            sub_user.save!
          else
            sub_user = SubUser.new(user_name: auth.info.name)
            sub_user.user_id = user.id
            sub_user.save!
          end

        end
      end
    end

        # Associate the identity with the user if needed
        if identity.user != user
          identity.user = user
          identity.save!
        end
    
        user
    
  end
    
      def email_verified?
        self.email && self.email !~ TEMP_EMAIL_REGEX
      end
    
      # private
      # def set_default_role
      #   add_role :user
      # end

end
