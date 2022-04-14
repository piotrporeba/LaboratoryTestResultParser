# frozen_string_literal: false

require_relative 'laboratory_test_result'

# Parser Class
class Parser
  # rubocop:disable Metrics/MethodLength
  # Public: Initializes Parser
  def initialize(file_path)
    @data = []
    file = File.open(file_path)
    file_data = file.read.split('OBX').reject(&:empty?)
    file_data.map do |f|
      @data.push('OBX' << f)
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

      code = split_data[2]
      result = parse_result(split_data[3])
      format = parse_format(split_data[2])
      comments = parse_comments(d)

      laboratory_test_result = LaboratoryTestResult.new(code, result, format, comments)
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
    elsif %w[NEGATIVE NIL].include?(val)
      -1.0
    elsif ['POSITIVE', '+', '++'].include?(val)
      -2.0
    elsif val == '+++'
      -3.0
    end
  end

  # Private: helper method to check if value passed is numeric
  # returns boolean
  def numeric?(val)
    true if Float(val)
  rescue StandardError
    false
  end

  def parse_format(code)
    if %w[C100 C200].include?(code)
      'float'
    elsif code == 'A250'
      'boolean'
    elsif code == 'B250'
      'nil_3plus'
    end
  end

  # Private: helper method to parse coments
  # returns array or comments for result
  def parse_comments(data)
    comments = []
    # splitting result section into seperate lines
    lines = data.split(/\n+/).reject(&:empty?)
    # filtering out non coment lines
    lines.select! { |s| s.include?('NTE') }
    # adding comments to comments array
    lines.map do |cl|
      cl_split = cl.split('|')
      comments.push(cl_split[2])
    end

    comments
  end
  # rubocop:enable Metrics/MethodLength
end
