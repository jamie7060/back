module ReviewView
    extend self

    def view(review)
        temp = Hash.new
        temp["id"] = review.id
        temp["drug_id"] = review.drug_id
        temp["efficacy"] = review.efficacy
        temp["adverse_effects"] = review.adverse_effects.select(:id, :symptom_name)
        temp["body"] =review.body
        temp["liked_users"] = review.l_users.count

        return temp
    end

end