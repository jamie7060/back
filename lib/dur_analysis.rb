module DurAnalysis
  extend self
  require 'json'
  require 'http'

    def drug_controller(codes)

      response = HTTP.get("https://www.hira.or.kr/rg/dur/getRestListJson.do?medcCd=#{codes}")
      begin
          rest = JSON.parse(response)["data"]["rest"]
      rescue
          response = HTTP.get("https://www.hira.or.kr/rg/dur/getRestListJson.do?medcCd=#{codes}")
          rest = JSON.parse(response)["data"]["rest"]
      end

      @result = Hash.new
      #병용금기
      parent = rest["A"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = [yak["durNmA"], yak["durNmB"]]
          dur["description"] = yak["durSdEft"]
          put << dur
        }
        put.uniq!
        @result["interactions"] = put
      end
      
      #동일성분중복
      parent = rest["G"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = [yak["durNmA"], yak["durNmB"]]
          put << dur
        }
        put.uniq!
        @result["same_ingr"] = put
      end
  
      #효능군중복
      parent = rest["F"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = [yak["durNmA"], yak["durNmB"]]
          put << dur
        }
        put.uniq!
        @result["duplicate"] = put
      end
  
      return @result
    
    end
    


    def get_by_drug(codes)
        response = HTTP.get("https://www.hira.or.kr/rg/dur/getRestListJson.do?medcCd=#{codes}")
        begin
            rest = JSON.parse(response)["data"]["rest"]
        rescue
            response = HTTP.get("https://www.hira.or.kr/rg/dur/getRestListJson.do?medcCd=#{codes}")
            rest = JSON.parse(response)["data"]["rest"]
        end

      @result = Hash.new
      #병용금기
      parent = rest["A"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = "#{yak["durNmA"]} + #{yak["durNmB"]}"
          dur["description"] = yak["durSdEft"]
          put << dur
        }
        put.uniq!
        @result["interactions"] = put
      end
      
      #연령금기
      parent = rest["B"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = yak["artcnm"]
          dur["description"] = "#{yak["spcAge"]} #{yak["spcAgeUnit"]}"
          put << dur
        }
        put.uniq!
        @result["age"] = put
      end
  
      #임부금기
      parent = rest["C"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = yak["artcnm"]
          dur["description"] = yak["imcompReason"]
          put << dur
        }
        put.uniq!
        @result["pregnancy"] = put
      end
  
      #사용(급여)중지
      parent = rest["D"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = yak["artcnm"]
          dur["description"] = yak["suspDt"]
          put << dur
        }
        put.uniq!
        @result["stop_usage"] = put
      end
  
      #동일성분중복
      parent = rest["G"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = "#{yak["durNmA"]} + #{yak["durNmB"]}"
          dur["description"] = "약의 효능효과·성분이 동일한 약물이 2가지 이상 있는 경우로 결과는 단순 참고용입니다"
          put << dur
        }
        put.uniq!
        @result["same_ingr"] = put
      end
  
      #효능군중복
      parent = rest["F"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = "#{yak["durNmA"]} + #{yak["durNmB"]}"
          dur["description"] = "약의 성분은 다르나 효능이 동일한 약물이 2가지 이상 있는 경우"
          put << dur
        }
        put.uniq!
        @result["duplicate"] = put
      end
      #용량주의
      parent = rest["I"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = yak["artcnm"]
          dur["description"] = "이 약은 1일 최대 #{yak["suspDt"]} 이내로 복용해야 하는 용량주의 의약품입니다."
          put << dur
        }
        put.uniq!
        @result["dosage"] = put
      end
  
      #투여기간주의
      parent = rest["J"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = yak["artcnm"]
          dur["description"] = "#{yak["suspDt"]} 일을 초과하여 복용하면 부작용이 우려되는 투여기간주의 의약품입니다."
          put << dur
        }
        put.uniq!
        @result["period"] = put
      end
  
      #노인주의
      parent = rest["L"]
      if !parent.nil?
        put = []
        parent.each { |yak|
          dur = Hash.new
          dur["name"] = yak["artcnm"]
          dur["description"] = "이 약은 #{yak["suspDt"]} 세 이상 고령자가 복용 시 주의해야하는 노인주의 의약품입니다."
          put << dur
        }
        put.uniq!
        @result["elder"] = put
      end
  
      return @result
  
    end

  def drug_code(drug_ids_array)
      require 'json'
      @codes = ""
      @excluded = []

      drug_ids_array.each { |drug_id|
          select_drug =  Drug.find(drug_id)
          select_code = select_drug.hira_medicine_code
          #hira_med_code 있는 경우 
          if !select_code.nil?
            if select_code.to_s.length == 8
              select_code = "0".concat(select_code.to_s)
            end
            @codes << select_code.to_s.concat(";")
          else
              if select_drug.package_insert.nil?
                  @excluded << select_drug.name
              else
                  if select_drug.package_insert.class == Hash
                  #Hash인 경우와 String인 경우 구분 => Hash로 모두 변환
                  hashed_package = select_drug.package_insert
                  else
                  hashed_package = JSON.parse(select_drug.package_insert)
                  end
                  select_code = hashed_package['DRB_ITEM']['EDI_CODE'] ? hashed_package['DRB_ITEM']['EDI_CODE'] : nil
                  if select_code.nil?
                  bar_code = hashed_package['DRB_ITEM']['BAR_CODE'] ? hashed_package['DRB_ITEM']['BAR_CODE'] : nil
                  if !bar_code.nil?
                      bar_codes = bar_code.split(",").map(&:strip)
                      bar_codes.each { |code| 
                      @codes << code[3..11] + ";"
                      }
                  end
                  else
                  edi_code = select_code
                  if edi_code.length != 9
                      edi_code.concat("0")
                  end
                  @codes << edi_code.concat(";")
                  end
              end
          end
      }
      return @codes.empty? ? @exclued : @codes
  end

end