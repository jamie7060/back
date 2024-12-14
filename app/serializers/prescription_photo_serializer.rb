class PrescriptionPhotoSerializer
  include FastJsonapi::ObjectSerializer
  attributes :sub_user_id, :url, :memo, :check
end
