class UserMailer < ApplicationMailer
    default from: 'twoyak4u@gmail.com'

    def photo_added(sub_user_id)
        mail(to: 'twoyak4u@gmail.com', subject: "sub_user_id: #{sub_user_id} 사진이 추가 되었습니다.")
    end
end
