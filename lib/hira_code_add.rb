module HiraCodeAdd
    extend self


    require 'uri'
    require 'json'
    require 'net/http'

    def hira_code_add(drug)
        puts drug.name
        uri = URI("https://www.hira.or.kr/rg/dur/getDrugListJson.do")
        # http = Net::HTTP.new(uri.host, uri.port)
        res = Net::HTTP.post_form(uri, "txtArtcNm" => URI::encode(drug.name) )

        # req.body = {"txtArtcNm" => Drug.first.name }.to_json
        # res = http.request(req)
        begin
            parsed = JSON.parse(res.body)
        rescue
            res = Net::HTTP.post_form(uri, "txtArtcNm" => URI::encode(drug.name) )
            parsed = JSON.parse(res.body)
        end

        searched = parsed["data"]["rest"]["LIST"]
        if searched.nil?
            #검색 안되면 코드로 검색
            if !drug.package_insert.nil?
                if drug.package_insert.class == Hash
                    #Hash인 경우와 String인 경우 구분 => Hash로 모두 변환
                    hashed_package = drug.package_insert
                else
                    hashed_package = JSON.parse(drug.package_insert)
                end
                bar_code = hashed_package['DRB_ITEM']['BAR_CODE'] ? hashed_package['DRB_ITEM']['BAR_CODE'] : nil
                if !bar_code.nil?
                    #검색에 필요한 부분만 추출
                    @codes = []
                    bar_codes = bar_code.split(",").map(&:strip)
                    bar_codes.each { |code| 
                    @codes << code[3..11]
                    }
                    @codes.each { |code|
                        res = Net::HTTP.post_form(uri, "txtArtcNm" => code )
                        begin
                            parsed = JSON.parse(res.body)
                        rescue
                            res = Net::HTTP.post_form(uri, "txtArtcNm" => code )
                            parsed = JSON.parse(res.body)
                        end
                        searched = parsed["data"]["rest"]["LIST"]
                        if !searched.nil?
                            break
                        end
                    }
                end
            else
                puts "설명서도 없는 놈"
            end
        end
        if searched.nil?
            puts drug.name.concat(" 검색 안되는 놈")
        else
            puts searched.first

            drug.hira_medicine_code = searched.first["MEDC_CD"].to_i
            drug.hira_main_ingr_code = searched.first["GNL_NM_CD"]
            drug.save
        end
    end
end
