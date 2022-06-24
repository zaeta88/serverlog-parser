# frozen_string_literal: true

# LogParser class is used to parse the log server visits and get the number of unique and total visits
# in each page of the application, the format of the log we are currently supporting is the following:
# Ex: /path-to-site 127.0.0.1
class LogParser
  attr_reader :entries, :result, :mode

  def initialize(file_path, mode = '')
    @mode = mode
    file_exists?(file_path)
    read_file(file_path)
  end

  def file_exists?(file_path)
    raise "No such file or directory @ #{file_path}" unless File.exist? file_path
  end

  def read_file(file_path)
    @entries = File.open(file_path).each_with_object(Hash.new { |h, k| h[k] = [] }) do |file_line, entries|
      page, ip = file_line.split(/\s+/)
      entries[page] << ip
    end
  end

  def parse_logs
    line_results('all') unless @mode.include?('unique')
    line_results('unique') unless @mode.include?('all')
  end

  def line_results(method)
    @result = @entries.each_with_object({}) do |(page, visits), result|
      send("#{method}_visits", page, visits, result)
    end
                      .sort_by { |path, count| [-count, path] }

    formatted_output(method)
  end

  def all_visits(page, visits, result)
    result[page] = visits.count
  end

  def unique_visits(page, visits, result)
    result[page] = visits.uniq.count
  end

  def formatted_output(method)
    p "List of webpages with #{method} page views ordered by views count"
    @result.each do |page, visits|
      p "#{page} #{visits} views"
    end
  end
end
