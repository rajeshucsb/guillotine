require 'active_record'

module Guillotine
  module Adapters
    class ActiveRecordAdapter < Adapter
      class Url < ActiveRecord::Base; end

      def initialize(config)
        Url.establish_connection config
      end
      
      # Public: Stores the shortened version of a URL.
      # 
      # url  - The String URL to shorten and store.
      # code - Optional String code for the URL.
      #
      # Returns the unique String code for the URL.  If the URL is added
      # multiple times, this should return the same code.
      def add(url, code = nil)
        if row = Url.select(:code).where(:url => url).first
          row[:code]
        else
          code ||= shorten url
          Url.create :url => url, :code => code
          code
        end
      end

      def find(code)
        if row = Url.select(:url).where(:code => code).first
          row[:url]
        end
      end

      # Public: Retrieves a URL from the code.
      #
      # code - The String code to lookup the URL.
      #
      # Returns the String URL.
      def setup
        Url.connection.create_table :urls do |t|
          t.string :url, :unique => true
          t.string :code, :unique => true
        end
      end
    end
  end
end