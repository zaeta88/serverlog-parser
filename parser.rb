# frozen_string_literal: true

require_relative 'lib/log_parser'

parser = LogParser.new(ARGV[0])
parser.parse_logs
