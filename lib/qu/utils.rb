require 'bio'
require "qu/utils/version"

module Qu
  module Utils
    # Your code goes here...
  end
end

module Bio
  # A patch for BioRuby FastaFormat class
  class FastaFormat
    def entry_name
      @definition.split.first.chomp(',').gsub(/,/, '.')
    end

    def description
      @definition.split[1..-1].join(' ')
    end

    alias desc description
  end
end