# frozen_string_literal: true

# Class LaboratoryTestResult
class LaboratoryTestResult
  def initialize(code, result, format, comments)
    @code = code
    @result = result
    @format = format
    @comment = ''
    comments.each do |c|
      @comment << c << "\n"
    end
  end

  def print_it_all
    puts "#{@code}, #{@result}, #{@format}, #{@comment}"
  end
end
