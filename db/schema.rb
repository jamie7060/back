# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_30_062910) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "adverse_effects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "symptom_code"
    t.string "symptom_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "adverse_effects_drug_reviews", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "drug_review_id", null: false
    t.bigint "adverse_effect_id", null: false
    t.index ["drug_review_id", "adverse_effect_id"], name: "drug_reviews_and_adverse_effects"
  end

  create_table "classifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "code"
    t.string "class_name"
    t.json "sub_classes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "thumbnail_url"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "current_diseases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "sub_user_id"
    t.integer "current_disease_id"
    t.date "to"
    t.date "from"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "current_drugs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "sub_user_id"
    t.integer "current_drug_id"
    t.string "when"
    t.string "how"
    t.date "to"
    t.date "from"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "current_supplements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "sub_user_id"
    t.integer "current_supplement_id"
    t.date "to"
    t.date "from"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diseases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug_associations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "drug_id"
    t.bigint "drug_ingr_id"
    t.bigint "dur_ingr_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_id"], name: "index_drug_associations_on_drug_id"
    t.index ["drug_ingr_id"], name: "index_drug_associations_on_drug_ingr_id"
    t.index ["dur_ingr_id"], name: "index_drug_associations_on_dur_ingr_id"
  end

  create_table "drug_imprints", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "drug_id"
    t.string "item_name"
    t.text "description"
    t.string "dosage_form"
    t.string "drug_image"
    t.string "print_front"
    t.string "print_back"
    t.string "drug_shape"
    t.string "color_front"
    t.string "color_back"
    t.string "line_front"
    t.string "line_back"
    t.decimal "length_long", precision: 10, scale: 3
    t.decimal "length_short", precision: 10, scale: 3
    t.decimal "thickness", precision: 10, scale: 3
    t.string "mark_content_front"
    t.string "mark_content_back"
    t.string "mark_img_front"
    t.string "mark_img_back"
    t.string "mark_code_front"
    t.string "mark_code_back"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_id"], name: "index_drug_imprints_on_drug_id"
  end

  create_table "drug_ingrs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "name_eng"
    t.json "description"
    t.json "atc_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug_interactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "drug_ingr_id"
    t.bigint "interaction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_ingr_id"], name: "index_drug_interactions_on_drug_ingr_id"
    t.index ["interaction_id"], name: "index_drug_interactions_on_interaction_id"
  end

  create_table "drug_review_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "drug_review_id"
    t.text "body"
    t.integer "likes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drug_review_id"], name: "index_drug_review_comments_on_drug_review_id"
    t.index ["user_id"], name: "index_drug_review_comments_on_user_id"
  end

  create_table "drug_review_likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "drug_review_id"
    t.index ["drug_review_id"], name: "index_drug_review_likes_on_drug_review_id"
    t.index ["user_id"], name: "index_drug_review_likes_on_user_id"
  end

  create_table "drug_reviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "drug_id"
    t.float "efficacy"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "drug_review_likes_count", default: 0
    t.index ["drug_id"], name: "index_drug_reviews_on_drug_id"
    t.index ["user_id"], name: "index_drug_reviews_on_user_id"
  end

  create_table "drug_taking_reasons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "disease_id"
    t.string "reasonable_type"
    t.bigint "reasonable_id"
    t.index ["disease_id"], name: "index_drug_taking_reasons_on_disease_id"
    t.index ["reasonable_type", "reasonable_id"], name: "index_drug_taking_reasons_on_reasonable_type_and_reasonable_id"
  end

  create_table "drugs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "item_seq"
    t.string "name"
    t.json "ingr_kor_name"
    t.string "short_description"
    t.string "short_notice"
    t.json "package_insert"
    t.json "dur_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "ingr_eng_name"
    t.string "atc_code"
    t.integer "hira_medicine_code"
    t.string "hira_main_ingr_code"
    t.float "drug_rating"
    t.index ["item_seq"], name: "drugs_item_seq_IDX"
    t.index ["name"], name: "index_drugs_on_name"
  end

  create_table "drugs_dur_ingrs", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "drug_id", null: false
    t.bigint "dur_ingr_id", null: false
  end

  create_table "dur_ingrs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "dur_code"
    t.string "ingr_eng_name"
    t.string "ingr_kor_name"
    t.string "related_ingr_code"
    t.string "related_ingr_kor_name"
    t.string "related_ingr_eng_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingr_eng_name"], name: "index_dur_ingrs_on_ingr_eng_name"
    t.index ["ingr_kor_name"], name: "index_dur_ingrs_on_ingr_kor_name"
    t.index ["related_ingr_kor_name"], name: "index_dur_ingrs_on_related_ingr_kor_name"
  end

  create_table "family_med_histories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "sub_user_id"
    t.integer "med_his_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "health_news", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "url"
    t.string "press"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hospitals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "province"
    t.string "city"
    t.json "more"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "interactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "is_recommendation"
    t.string "interactable_type"
    t.bigint "interactable_id"
    t.string "title"
    t.json "info"
    t.json "references"
    t.index ["interactable_type", "interactable_id"], name: "index_interactions_on_interactable_type_and_interactable_id"
  end

  create_table "notices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "url"
  end

  create_table "past_diseases", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "sub_user_id"
    t.integer "past_disease_id"
    t.date "to"
    t.date "from"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "past_drugs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "sub_user_id"
    t.integer "past_drug_id"
    t.string "when"
    t.string "how"
    t.date "to"
    t.date "from"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "past_supplements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "sub_user_id"
    t.integer "past_supplement_id"
    t.date "to"
    t.date "from"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prescription_photos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "sub_user_id"
    t.string "url"
    t.string "check"
    t.index ["sub_user_id"], name: "index_prescription_photos_on_user_id"
  end

  create_table "search_terms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.json "terms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "diseases"
    t.json "drugs"
    t.json "supplements"
  end

  create_table "sub_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "user_name", null: false
    t.string "profile_image"
    t.date "birth_date"
    t.boolean "drink"
    t.boolean "smoke"
    t.boolean "caffeine"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sex"
    t.index ["user_id"], name: "index_sub_users_on_user_id"
  end

  create_table "suggestions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "body"
    t.string "contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_suggestions_on_user_id"
  end

  create_table "sup_review_comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "sup_review_id"
    t.text "body"
    t.integer "likes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sup_review_id"], name: "index_sup_review_comments_on_sup_review_id"
    t.index ["user_id"], name: "index_sup_review_comments_on_user_id"
  end

  create_table "sup_reviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "supplement_id"
    t.integer "efficacy"
    t.integer "side_effect"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["supplement_id"], name: "index_sup_reviews_on_supplement_id"
    t.index ["user_id"], name: "index_sup_reviews_on_user_id"
  end

  create_table "supplement_ingrs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "approval_no"
    t.string "ingr_name"
    t.string "enterprise_name"
    t.json "benefits"
    t.json "warnings"
    t.string "daily_intake"
    t.string "daily_intake_max"
    t.string "daily_intake_min"
    t.json "rich_foods"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "active_ingr"
    t.index ["ingr_name"], name: "index_supplement_ingrs_on_ingr_name"
  end

  create_table "supplement_ingrs_supplements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "supplement_id", null: false
    t.bigint "supplement_ingr_id", null: false
    t.integer "ranking"
  end

  create_table "supplements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "shopping_site"
    t.string "name"
    t.string "enterprise_name"
    t.integer "price"
    t.string "product_url"
    t.string "photo_url"
    t.float "rating"
    t.integer "shoppingmall_reviews"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_user_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_user_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_user_roles_on_resource_type_and_resource_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "push_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_user_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "user_role_id"
    t.index ["user_id", "user_role_id"], name: "index_users_user_roles_on_user_id_and_user_role_id"
    t.index ["user_id"], name: "index_users_user_roles_on_user_id"
    t.index ["user_role_id"], name: "index_users_user_roles_on_user_role_id"
  end

  create_table "watch_drugs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "watch_drug_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "watch_supplements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "watch_supplement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "drug_disease_interactions", "diseases"
  add_foreign_key "drug_disease_interactions", "drugs"
  add_foreign_key "drug_interactions", "drug_ingrs"
  add_foreign_key "drug_interactions", "interactions"
  add_foreign_key "drug_review_comments", "drug_reviews"
  add_foreign_key "drug_review_comments", "users"
  add_foreign_key "drug_review_likes", "drug_reviews"
  add_foreign_key "drug_review_likes", "users"
  add_foreign_key "drug_taking_reasons", "diseases"
  add_foreign_key "identities", "users"
  add_foreign_key "suggestions", "users"
  add_foreign_key "sup_review_comments", "sup_reviews"
  add_foreign_key "sup_review_comments", "users"
end
