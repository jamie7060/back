#20190917 기준

require 'json'
require 'net/http'
require 'active_support/core_ext/hash'

Searchkick.disable_callbacks

for i in 1..497
    puts "i = #{i}"
    response = Net::HTTP.get_response(URI.parse("http://apis.data.go.kr/1471057/MdcinPrductPrmisnInfoService/getMdcinPrductItem?serviceKey=#{ENV['PUBLIC_API_KEY']}&pageNo=#{i}&numOfRows=100")).body
    begin
        hashed_response = Hash.from_xml(response)
    rescue
        response.gsub!(/&(?!(?:amp|lt|gt|quot|apos);)/, '&amp;')
        hashed_response = Hash.from_xml(response)
    end
    #각각 찾아서 입력
    hashed_response['response']['body']['items']['item'].each do |item|
        drug_to_change = Drug.find_by(item_seq: item['ITEM_SEQ'])
        puts drug_to_change.class
        if !drug_to_change.nil? && drug_to_change.id < 56932
            package = (drug_to_change.package_insert.class == String) ? JSON.parse(drug_to_change.package_insert) : drug_to_change.package_insert
            # package['DRB_ITEM']['BAR_CODE'] = item['BAR_CODE']
            # if !item['EDI_CODE'].nil?
            #     package['DRB_ITEM']['EDI_CODE'] = item['EDI_CODE']
            # end
            puts drug_to_change.id
            drug_to_change.update(package_insert: package.as_json)
            puts drug_to_change.name
        #2019년 09월 17일 기준
        elsif item['ITEM_SEQ'].to_i > 201903558
            new_item = Drug.new
            new_item.item_seq = item['ITEM_SEQ']
            new_item.name = item['ITEM_NAME']
            puts new_item.name
            #성분 추가
            if !item['MATERIAL_NAME'].nil?
                main_ingrs = item['MATERIAL_NAME'].split(";") 
                ingrs = []
                main_ingrs.each { |ingr|
                    
                    ingrs << ingr.split("|")[1]
                }
                new_item.ingr_kor_name = ingrs.to_json
            end
            #설명서 추가
            a = Hash.new
            a["DRB_ITEM"] = item
            new_item.package_insert = a.as_json
            puts new_item.save
        end
    end
end
    