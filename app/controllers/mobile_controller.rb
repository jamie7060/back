class MobileController < ApplicationController
    def version
        @result = Hash.new
        @result['data'] = '1.0.3'
        render json: @result
    end
end
