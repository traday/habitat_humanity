require 'active_support/concern'
require 'csv'

module WeeklyReportable
  extend ActiveSupport::Concern

  included do
    attr_reader :begin, :end
  end

  class_methods do
    ##
    # @param ending [String,Date]
    #   Date or String parseable as a Date
    #
    # @return [SignaturesReport]
    def for_week(ending:)
      end_date = Date.parse(ending.to_s)
      begin_date = end_date - 6
      new(begin_date, end_date)
    end
  end

  ##
  # @param begin_date [String,Date]
  #   Date or String parseable as a Date
  # @param end_date [String,Date]
  #   Date or String parseable as a Date
  def initialize(begin_date, end_date)
    @begin = Date.parse(begin_date.to_s)
    @end = Date.parse(end_date.to_s)
  end

  def to_csv
    CSV.generate(write_headers: false, headers: self.class::JOINED_HEADERS) do |csv|
      # Don't want to rely on `write_headers: true` since we want still
      # header row in the CSV file even when there is no data.
      csv << self.class::JOINED_HEADERS
      pull_join.each { |record| csv << record.attributes }
    end
  end
end
