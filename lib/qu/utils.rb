require 'bio'
require "qu/utils/version"

module Qu
  module Utils
    # File actionpack/lib/action_view/helpers/text_helper.rb, line 215
    def word_wrap(text, line_width = 80)
      text.split("\n").collect do |line|
        line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
      end * "\n"
    end

    def seconds_to_units(seconds)
      return "#{seconds.round(2)} second" if seconds < 1
      return "#{seconds.round(2)} seconds" if seconds < 60
      '%d minutes, %d seconds' %
      #'%d days, %d hours, %d minutes, %d seconds' %
      # the .reverse lets us put the larger units first for readability

      #[24,60,60].reverse.inject([seconds]) {|result, unitsize|

      [60].reverse.inject([seconds]) {|result, unitsize|
        result[0,0] = result.shift.divmod(unitsize)
        result
      }
    end

    def plural_word(word, count)
      count > 1 ? word + 's' : word
    end

    def os
      case RUBY_PLATFORM
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        return 'windows'
      when /darwin|mac/
        return 'mac'
      when /linux/
        return 'linux'
      when /solaris|bsd/
        return 'unix'
      else
        raise Error::WebDriverError, "Unknown os: #{RUBY_PLATFORM.inspect}"
      end
    end

    def bit
      case RUBY_PLATFORM
      when /64/
        return 64
      when /32/
        return 32
      else
        raise Error::WebDriverError, "Unknown os bit: #{RUBY_PLATFORM.inspect}"
      end

    end
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