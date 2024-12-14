class RenameUserInfoToSubUser < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :user_infos, :sub_users
    rename_column :current_diseases, :user_info_id, :sub_user_id
    rename_column :past_diseases, :user_info_id, :sub_user_id
    rename_column :current_drugs, :user_info_id, :sub_user_id
    rename_column :past_drugs, :user_info_id, :sub_user_id
    rename_column :current_supplements, :user_info_id, :sub_user_id
    rename_column :past_supplements, :user_info_id, :sub_user_id
    rename_column :family_med_histories, :user_info_id, :sub_user_id

  end

  def self.down
    rename_table :user_infos, :sub_users
    rename_column :current_diseases, :user_info_id, :sub_user_id
    rename_column :past_diseases, :user_info_id, :sub_user_id
    rename_column :current_drugs, :user_info_id, :sub_user_id
    rename_column :past_drugs, :user_info_id, :sub_user_id
    rename_column :current_supplements, :user_info_id, :sub_user_id
    rename_column :past_supplements, :user_info_id, :sub_user_id


  end
end
