require 'optparse'

module Shukudai
  class CLI
    def self.start

      options = {
        seed: nil,
        output: 'sheet.pdf',
        jtlp: 4
      }

      subcommands_usage = <<~USAGE
      Subcommands:
        kanjigana:      train hiragana handwriting and kanji knowledge at once

        Use shukudai [subcommand] --help form more options.

      USAGE

      main = OptionParser.new do |opts|
        opts.banner = 'Usage: shukudai [subcommand]'
        opts.separator ''
        opts.separator subcommands_usage
      end

      subcommands = {
        kanjigana: OptionParser.new do |opts|
          opts.banner = 'Usage: shukudai kanjigana [options]'

          opts.on('-s [<number>]',
                  '--seed [<number>]',
                  Integer,
                  'Reprodruce worksheet with <seed> from page (default: random)') do |s|

            options[:seed] = s
          end

          opts.on('-j [<grade>]',
                 '--jlpt [<grade>]',
                 Integer,
                 'Use kanjis of the given JLPT grade. (default: 4)') do |j|
            options[:jltp] = j
          end


          opts.on('-o [<filename>]',
                  '--output [<filename>]',
                  String,
                  '(default: sheet.pdf)') do |o|

            options[:output] = o
          end
        end
      }

      main.order!

      subcommand = ARGV.shift.to_sym
      if subcommands.include? subcommand
        subcommands[subcommand].order!
        send subcommand, options
      else
        abort("#{main.help} Subcommand \"#{subcommand}\" not found. \n\n")
      end

    end

    def self.kanjigana(opts)
      puts "Loading kanjis..."
      k = Utils.load_kanji_by_jlpt_grade(path: Config.load[:data][:kanjidic2_xml],
                                         jlpt_grade: opts[:jltp])
      s = KanjiHiraganaSheet.new(kanjis: k, seed: opts[:seed], output: opts[:output])
      puts "Generating PDF #{s.output} with seed #{s.seed}..."
      s.to_pdf
      puts "Done!"
    end
  end
end
