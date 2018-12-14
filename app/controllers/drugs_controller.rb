class DrugsController < ApplicationController
  # before_action :set_drug, only: [:show, :update, :destroy]

  # GET /drugs
  def index
    @drugs = Drug.all

    render json: @drugs
  end

  # GET /drugs/1
  def show
    render json: @drug
  end

  # POST /drugs
  def create
    @drug = Drug.new(drug_params)

    if @drug.save
      render json: @drug, status: :created, location: @drug
    else
      render json: @drug.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /drugs/1
  def update
    if @drug.update(drug_params)
      render json: @drug
    else
      render json: @drug.errors, status: :unprocessable_entity
    end
  end

  # DELETE /drugs/1
  def destroy
    @drug.destroy
  end

  def find_each_drug

    search= params[:search_term]
    # query = "SELECT * FROM drugs WHERE item_name = " + "'" + search + "'"
    # @rep = Drug.find_by_sql(query) //이전 searchkick 쓰고나서 다음과 같다.
    # Searchkick.search(search, where: {name: /.*#{search}.*/, ingredients: /.*#{search}.*/})
    searched = if search
      Searchkick.search(search, index_name: [Drug, Supplement])
    end

    # 뭐 검색됐는지 확인용
    # searched.each { |item|
    #   if item.class == Drug
    #     puts item.item_name
    #   elsif item.class == Supplement
    #     puts item.product_name
    #   end
    # }
  
    @data = []
  
    searched.each { |item|
      if item.class == Drug && search == item.item_name
        if(!item.drug_imprint.nil?)
          @data << item.drug_imprint
        end
        @rep = item
        @infomation = if @rep.nil? next : @rep['package_insert']['DRB_ITEM']
        @ITEM_NAME = @rep.item_name
        # CLASS_NO string
        @CLASS_NO = @infomation['CLASS_NO']
        # ETC_OTC_CODE
        @ETC_OTC_CODE = @infomation['ETC_OTC_CODE']
        # ENTP_NAME
        @ENTP_NAME = @infomation['ENTP_NAME']
        # STORAGE METHOD
        @STORAGE_METHOD = @infomation['STORAGE_METHOD']
        # VALID_TERM
        @VALID_TERM = @infomation['VALID_TERM']
        # 효능효과 array
        @Benefit = @infomation['EE_DOC_DATA']['DOC']['SECTION'] if !@infomation['EE_DOC_DATA'].nil?
        @Benefit_ARTICLE_TITLE = []
        @Benefit_ARTICLE_PARAGRAPH = []
        begin
          for i in 0...@Benefit.length
              @Benefit_TITLE = @Benefit[i]['title']
              begin
                  for j in 0...@Benefit[i]['ARTICLE'].length
                      @Benefit_ARTICLE_TITLE << @Benefit[i]['ARTICLE'][j]['title']
                      @Benefit_ARTICLE_PARAGRAPH << @Benefit[i]['ARTICLE'][j]['PARAGRAPH']
                  end
              rescue NoMethodError
                @Benefit_ARTICLE_TITLE = []
                @Benefit_ARTICLE_PARAGRAPH = []
                @Benefit_ARTICLE_TITLE << @Benefit[i]['ARTICLE']['title']
                @Benefit_ARTICLE_TITLE << @Benefit[i]['ARTICLE']['PARAGRAPH']
              end
          end
        rescue NoMethodError
          begin
            @Benefit_ARTICLE_TITLE = []
            @Benefit_ARTICLE_PARAGRAPH = []
              for i in 0...@Benefit['ARTICLE'].length
                @Benefit_ARTICLE_TITLE << @Benefit['ARTICLE'][i]['title']
                @Benefit_ARTICLE_PARAGRAPH << @Benefit['ARTICLE'][i]['PARAGRAPH']
              end
          rescue NoMethodError
            @Benefit_ARTICLE_TITLE = []
            @Benefit_ARTICLE_PARAGRAPH = []
            @Benefit_ARTICLE_TITLE << @Benefit['ARTICLE']['title']
            @Benefit_ARTICLE_PARAGRAPH << @Benefit['ARTICLE']['PARAGRAPH']
          end
        end

        @EE_DOC_DATA = []
        for i in 0...@Benefit_ARTICLE_TITLE.length
          @EE_DOC_DATA << @Benefit_ARTICLE_TITLE[i]
          if @Benefit_ARTICLE_PARAGRAPH[i].nil?
          elsif @Benefit_ARTICLE_PARAGRAPH[i].kind_of?(String)
            @EE_DOC_DATA << @Benefit_ARTICLE_PARAGRAPH[i]
          else
            for j in 0...@Benefit_ARTICLE_PARAGRAPH[i].length
              @EE_DOC_DATA << @Benefit_ARTICLE_PARAGRAPH[i][j]
            end
          end
        end
        
        @DOSAGE = @infomation['UD_DOC_DATA']['DOC']['SECTION']
        @DOSAGE_ARTICLE_TITLE = []
        @DOSAGE_ARTICLE_PARAGRAPH = []
        begin
            for i in 0...@DOSAGE.length
                @DOSAGE_TITLE = @DOSAGE[i]['title']
                begin
                    for j in 0...@DOSAGE[i]['ARTICLE'].length
                        @DOSAGE_ARTICLE_TITLE << @DOSAGE[i]['ARTICLE'][j]['title']
                        @DOSAGE_ARTICLE_PARAGRAPH << @DOSAGE[i]['ARTICLE'][j]['PARAGRAPH']
                    end
                rescue NoMethodError
                  @DOSAGE_ARTICLE_TITLE = []
                  @DOSAGE_ARTICLE_PARAGRAPH = []
                  @DOSAGE_ARTICLE_TITLE << @DOSAGE[i]['ARTICLE']['title']
                  @DOSAGE_ARTICLE_PARAGRAPH << @DOSAGE[i]['ARTICLE']['PARAGRAPH']
                end
            end
        rescue NoMethodError
          @DOSAGE_ARTICLE_TITLE = []
          @DOSAGE_ARTICLE_PARAGRAPH = []
            begin
                for i in 0...@DOSAGE['ARTICLE'].length
                  @DOSAGE_ARTICLE_TITLE << @DOSAGE['ARTICLE'][i]['title']
                  @DOSAGE_ARTICLE_PARAGRAPH << @DOSAGE['ARTICLE'][i]['PARAGRAPH']
                end
            rescue NoMethodError
              @DOSAGE_ARTICLE_TITLE = []
              @DOSAGE_ARTICLE_PARAGRAPH = []
              @DOSAGE_ARTICLE_TITLE << @DOSAGE['ARTICLE']['title']
              @DOSAGE_ARTICLE_PARAGRAPH << @DOSAGE['ARTICLE']['PARAGRAPH']
            end
        end
        @UD_DOC_DATA = []
        for i in 0...@DOSAGE_ARTICLE_TITLE.length
          @UD_DOC_DATA << @DOSAGE_ARTICLE_TITLE[i]
          if @DOSAGE_ARTICLE_PARAGRAPH[i].nil?
          elsif @DOSAGE_ARTICLE_PARAGRAPH[i].kind_of?(String)
            @UD_DOC_DATA << @DOSAGE_ARTICLE_PARAGRAPH[i]
          else
            for j in 0...@DOSAGE_ARTICLE_PARAGRAPH[i].length
              @UD_DOC_DATA << @DOSAGE_ARTICLE_PARAGRAPH[i][j]
            end
          end
        end

        # 사용상 주의사항
        @CAUTION = @infomation['NB_DOC_DATA']['DOC']['SECTION']
        @CAUTION_ARTICLE_TITLE = []
        @CAUTION_ARTICLE_PARAGRAPH = []
        begin
            for i in 0...@CAUTION.length
                @CAUTION_TITLE = @CAUTION[i]['title']
                begin
                    for j in 0...@CAUTION[i]['ARTICLE'].length
                        @CAUTION_ARTICLE_TITLE << @CAUTION[i]['ARTICLE'][j]['title']
                        @CAUTION_ARTICLE_PARAGRAPH << @CAUTION[i]['ARTICLE'][j]['PARAGRAPH']
                    end
                rescue NoMethodError
                  @CAUTION_ARTICLE_TITLE = []
                  @CAUTION_ARTICLE_PARAGRAPH = []
                  @CAUTION_ARTICLE_TITLE << @CAUTION[i]['ARTICLE']['title']
                  @CAUTION_ARTICLE_PARAGRAPH << @CAUTION[i]['ARTICLE']['PARAGRAPH']
                end
            end
        rescue NoMethodError
          @CAUTION_ARTICLE_TITLE = []
          @CAUTION_ARTICLE_PARAGRAPH = []
            begin
                for i in 0...@CAUTION['ARTICLE'].length
                  @CAUTION_ARTICLE_TITLE << @CAUTION['ARTICLE'][i]['title']
                  @CAUTION_ARTICLE_PARAGRAPH << @CAUTION['ARTICLE'][i]['PARAGRAPH']
                end
            rescue NoMethodError
              @CAUTION_ARTICLE_TITLE = []
              @CAUTION_ARTICLE_PARAGRAPH = [] 
              @CAUTION_ARTICLE_TITLE << @CAUTION['ARTICLE']['title']
              @CAUTION_ARTICLE_PARAGRAPH << @CAUTION['ARTICLE']['PARAGRAPH']
            end
          end
        @NB_DOC_DATA = []
        for i in 0...@CAUTION_ARTICLE_TITLE.length
          @NB_DOC_DATA << @CAUTION_ARTICLE_TITLE[i]
          if @CAUTION_ARTICLE_PARAGRAPH[i].nil?
          elsif @CAUTION_ARTICLE_PARAGRAPH[i].kind_of?(String)
            @NB_DOC_DATA << @CAUTION_ARTICLE_PARAGRAPH[i]
          else
            for j in 0...@CAUTION_ARTICLE_PARAGRAPH[i].length
              @NB_DOC_DATA << @CAUTION_ARTICLE_PARAGRAPH[i][j]
            end
          end
        end

        @data << @ITEM_NAME
        @data << @CLASS_NO
        @data << @ETC_OTC_CODE
        @data << @ENTP_NAME
        @data << @STORAGE_METHOD
        @data << @VALID_TERM
        @data << @EE_DOC_DATA
        @data << @UD_DOC_DATA
        @data << @NB_DOC_DATA
        @data << item.ingr_kor_name
        @data << item.ingr_eng_name
        @data << item.atc_code
        break
      elsif item.class == Supplement && search == item.product_name
        @sup = item
        break
      end
    }

    if(!@sup.nil?)
      @data = @sup
    else
      searched.each { |item|
        if item.class == Drug
          @data << item.item_name
        elsif item.class == Supplement
          @data << item.product_name
        end
      }
    end

    render json: @data
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_drug
      @drug = Drug.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def drug_params
      params.require(:drug).permit(:item_seq, :item_name, :ingr_kor_name, :package_insert, :ingr_eng_name, :atc_code)
    end
end
