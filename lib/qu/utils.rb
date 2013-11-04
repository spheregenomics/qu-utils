require 'bio'
require "qu/utils/version"

module Qu
  module Utils
    IUPAC = {
      A: ['A'],
      T: ['T'],
      C: ['C'],
      G: ['G'],
      R: ['G', 'A'],
      Y: ['T', 'C'],
      S: ['G', 'C'],
      W: ['T', 'A'],
      K: ['G', 'T'],
      M: ['A', 'C'],
      D: ['G', 'T', 'A'],
      H: ['T', 'A', 'C'],
      B: ['G', 'T', 'C'],
      V: ['G', 'A', 'C'],
      N: ['G', 'A', 'T', 'C'],
      I: ['G', 'A', 'T', 'C'],
    }
    module_function

    def iupac2normal(seq, prefixes = [''])
      return prefixes if seq.size == 0

      first = seq[0].to_sym
      last_seq = seq[1..-1]
      new_prefixes = []
      prefixes.each do |prefix|
        if IUPAC.include?(first)
          IUPAC[first].each {|base| new_prefixes << "#{prefix}#{base}"}
        else
          $stderr.puts "Error: unrecognized base: #{first}"
          exit
        end
      end
      return iupac2normal(last_seq, prefixes = new_prefixes)
    end

    def convert_degenerate_primer(primer_file)
      primer_records = Bio::FlatFile.new(Bio::FastaFormat, File.open(primer_file))

      primer_list = []
      primer_records.each do |primer|
        if primer.naseq.to_s =~ /[^atcgATCG]+/
          normal_seq_list = iupac2normal(primer.naseq.upcase)
          fasta_io = StringIO.new
          normal_seq_list.each_with_index do |normal_seq, index|
            fasta_io << ">#{primer.entry_name}_#{index+1} #{primer.description}\n#{normal_seq}\n"
          end
          fasta_io.rewind
          primer_list += Bio::FlatFile.new(Bio::FastaFormat, fasta_io).to_a
          fasta_io.close
        else
          primer_list << primer
        end
      end

      return primer_list
    end

    # File actionpack/lib/action_view/helpers/text_helper.rb, line 215
    def word_wrap(text, line_width = 80)
      text.split("\n").collect do |line|
        line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
      end * "\n"
    end

    def long_seq_wrap(word, length=80, separator="\n")
      # Wrap a long sentence with may words into multiple lines
      (word.length < length) ?
        word :
        word.scan(/.{1,#{length}}/).join(separator)
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

    def platform_os
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

    def platform_bit
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