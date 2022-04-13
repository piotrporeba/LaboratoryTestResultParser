class LaboratoryTestResult 
    def initialize(data)
        @code=data[:code]
        @result = data[:result]
        @format = data[:format]
        @comment = ""
        data[:comment].each do |c|
            @comment << c << "\n"
        end

        
        # columns 
        #   :code :string
        #   :result :float
        #   :format :string
        #   :comment :strint
    end

    def print_it_all
        puts "#{@code}, #{@result}, #{@format}, #{@comment}"
    end


  end