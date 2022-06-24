# frozen_string_literal: true

require_relative '../spec_helper'
require './lib/log_parser'

RSpec.describe LogParser do
  let(:file_path) { 'spec/fixtures/files/webserver_sample.log' }

  subject { described_class.new(file_path) }

  describe 'initialized without valid arguments' do
    describe 'invalid file path' do
      let(:file_path) { 'fake_path/file.log' }

      it 'raises an expection for the invalid file' do
        expect { subject }.to raise_error(RuntimeError, "No such file or directory @ #{file_path}")
      end
    end

    describe 'without any file' do
      let(:file_path) { '' }

      it 'raises an expection for the invalid file' do
        expect { subject }.to raise_error(RuntimeError, "No such file or directory @ #{file_path}")
      end
    end
  end

  describe 'initialized with valid arguments' do
    describe '#parse_logs' do
      describe 'checking total and unique views' do
        it 'returns the full report of visits ordered by count and name' do
          output = "\"List of webpages with all page views ordered by views count\"\n\"/b 4 views\"\n\"/c 3 views\"\n\"/a 1 views\"\n\"/d 1 views\"\n\"List of webpages with unique page views ordered by views count\"\n\"/b 2 views\"\n\"/c 2 views\"\n\"/a 1 views\"\n\"/d 1 views\"\n"

          expect { subject.parse_logs }.to output(output).to_stdout
        end
      end
      describe 'checking only total views' do
        subject { described_class.new(file_path, '--all') }
        it 'returns the total visits report ordered by count and name' do
          output = "\"List of webpages with all page views ordered by views count\"\n\"/b 4 views\"\n\"/c 3 views\"\n\"/a 1 views\"\n\"/d 1 views\"\n"

          expect { subject.parse_logs }.to output(output).to_stdout
          expect(subject.result).to eq([['/b', 4], ['/c', 3], ['/a', 1], ['/d', 1]])
        end
      end
      describe 'checking only unique views' do
        subject { described_class.new(file_path, '--unique') }
        it 'returns the unique visits report ordered by count and name' do
          output = "\"List of webpages with unique page views ordered by views count\"\n\"/b 2 views\"\n\"/c 2 views\"\n\"/a 1 views\"\n\"/d 1 views\"\n"

          expect { subject.parse_logs }.to output(output).to_stdout
          expect(subject.result).to eq([['/b', 2], ['/c', 2], ['/a', 1], ['/d', 1]])
        end
      end
    end
  end
end
