class String
    def numeric?
      Float(self) != nil rescue false
    end
end

ids = [475, 476, 9, 10, 12, 41, 49, 50, 51, 55, 56, 57, 59, 60, 61, 65, 69, 93, 330]
search_terms = ["310633", "310635", "310634", "310638", "310656", "베타카로틴", "310639", "310640", "비타민 B1", "비타민 B6", "310646" ,"비타민 B12", "310641", "310642", "310644", "프락토올리고당", "310643", "310661", "XOS"]

require 'nokogiri'
require 'open-uri'
require 'net/http'


count_all = 0
count_terms = 0
search_terms.each_with_index do |search_term, index|
    count_terms += 1
    puts count_all
    puts count_terms
    puts search_term
    if search_term.numeric?
        begin
            doc = Nokogiri::HTML(open("http://www.coupang.com/np/categories/#{search_term}?listSize=120&brand=&offerCondition=&filterType=&isPriceRange=false&minPrice=&maxPrice=&page=1&channel=user&fromComponent=N&selectedPlpKeepFilter=&sorter=saleCountDesc&filter=&component=310534&rating=0"))
        rescue SystemCallError
            puts "시간이 너무 오래 걸리네"
        end
    else
        begin
            doc = Nokogiri::HTML(open("http://www.coupang.com/np/search?q=#{URI::encode(search_term)}&brand=&offerCondition=&filter=&availableDeliveryFilter=&filterType=&isPriceRange=false&priceRange=&minPrice=&maxPrice=&page=1&trcid=&traid=&filterSetByUser=true&channel=user&backgroundColor=&component=305698&rating=0&sorter=saleCountDesc&listSize=72"))
        rescue SystemCallError
            puts "시간이 너무 오래 걸리네"
        end
    end
    doc.css("a.baby-product-link").each_with_index { |data, index2|
        product_name = data.css("dl > dd > div:nth-child(2)")[0].text.strip()
        url = "https://www.coupang.com" + data["href"]
        photo = "https:" + data.css("dl > dt > img")[0]["src"]
        #rating 없을 경우 처리
        if !data.css(".rating-star").blank?
            rating = data.css(".rating").text
            rating = data.css(".rating-total-count").text
        end
        producer = Nokogiri::HTML(open(url)).css('#brand > a > span > bdi').children.first.text


        #품절 처리
        price = data.css("dl > dd > div.price-area > div.price-wrap > div.price > em.sale > strong.price-value")[0].text.delete(',').to_i
        ranking = index2 + 1
        byebug
        # to_be_created = Supplement.where(name: product_name, shopping_site: "iherb").first_or_initialize

        # if to_be_created.new_record?
        #     # to_be_created.supplement_ingr_id = ids[index]
        #     # to_be_created.shopping_site = "iherb"
        #     # to_be_created.name = product_name
        #     to_be_created.enterprise_name = producer
        #     to_be_created.price = price
        #     to_be_created.product_url = url
        #     to_be_created.photo_url = photo
        #     to_be_created.rating = stars unless stars.blank?
        #     to_be_created.shoppingmall_reviews = num_of_reviews unless num_of_reviews.blank?
        #     puts to_be_created.save!
        #     SupplementIngrsSupplement.create(supplement_id: to_be_created.id, supplement_ingr_id: ids[index], ranking: ranking)
        #     puts "#{product_name} success"
        # else
        #     SupplementIngrsSupplement.create(supplement_id: to_be_created.id, supplement_ingr_id: ids[index], ranking: ranking)
        #     puts "#{product_name} success2"
        # end

        puts "#{product_name}, #{url}, #{photo}"
        # puts "price: #{price}, rank #{ranking}, url: #{url}, name: #{product_name}, photo: #{photo}"
        count_all += 1
    }
end
