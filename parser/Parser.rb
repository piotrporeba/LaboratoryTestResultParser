require_relative 'LaboratoryTestResult.rb'

class Parser

    # Public: Initializes Parser
    def initialize(file_path)
        @data = []
        file = File.open(file_path)
        file_data = file.read.split("OBX").reject(&:empty?)
        file_data.map do |f|
            @data.push("OBX" << f)
        end
        # puts @data
        # puts @data.size
    end
      
    # Public: maps results
    def mapped_results
        laboratory_test_results = []
        split_data = []

        @data.each do |d|
            split_data = d.split('|')
            mapped_result = {}
            mapped_result[:code] = split_data[2]
            mapped_result[:result] = parse_result(split_data[3])
            mapped_result[:format] = parse_format(split_data[2])
            mapped_result[:comment] = parse_comments(split_data)

            laboratory_test_result = LaboratoryTestResult.new(mapped_result)
            laboratory_test_results.push(laboratory_test_result)
            puts laboratory_test_result.print_it_all
        end

        laboratory_test_results

    end   

    private

    # Private: helper method to parse results
    # returns float value
    def parse_result(val)
        
        if numeric?(val)
            Float(val)
        elsif val == 'NEGATIVE' || val == 'NIL'
            -1.0
        elsif val == 'POSITIVE' || val == '+' || val == '++'
            -2.0
        elsif val == '+++'
            -3.0
        end
    end

    # Private: helper method to check if value passed is numeric
    # returns boolean
    def numeric?(val)
        true if Float(val) rescue false
    end

    def parse_format(code)
        if code == 'C100' || code == 'C200'
            'float'
        elsif code == 'A250'
            'boolean'
        elsif code == 'B250'
            'nil_3plus'
        end
    end

    # Private: helper method to parse coments
    # returns array or comments for result
    def parse_comments(val)

        val.keep_if{|x| x=~/Comment*?/}

    end
end