require 'optparse'

module Shukudai
  class CLI
    def self.start

      options = {
        seed: nil,
        output: 'sheet.pdf',
        jlpt: 4
      }

      subcommands_usage = <<~USAGE
      Subcommands:
        kanjigana:      train hiragana handwriting and kanji knowledge at once
        hiragana:       train handwriting of single hiraganas
        kanjivg:        import kanjivg stroke order SVGs

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
        end,

        hiragana: OptionParser.new do |opts|
          opts.banner = 'Usage: shukudai hiragana [options]'

          opts.on('-c <char>',
                  '--char <char>',
                  String,
                  'Hiragana to generate a sheet for') do |o|
            options[:char] = o
          end

          opts.on('-o [<filename>]',
                  '--output [<filename>]',
                  String,
                  '(default: sheet.pdf)') do |o|

            options[:output] = o
          end
        end,

        kanjivg: OptionParser.new do |opts|
          opts.banner = 'Usage: shukudai kanjivg [options]'

          opts.on('-i [<dir>]',
                  '--import [<dir>]',
                  String,
                  'Directory containing kanjivg SVGs (default: $XDG_DATA_HOME/shukudai/kanji)') do |d|
            options[:import_dir] = d
          end

          opts.on('-o [<filename>]',
                  '--output [<filename>]',
                  String,
                  'Assembled SVGs output location (default: $XDG_DATA_HOME/shukudai/hiragana.svg)') do |d|
            options[:hiragana_svg] = d
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
      puts "Loading kanjis for JLPT grade #{opts[:jlpt]}..."
      k = Utils.load_kanjis(path: Config.load[:data][:kanjidic2_xml]) do |kanji|
        kanji.jlpt == opts[:jlpt] \
        && kanji.kunyomi \
        && kanji.text \
        && kanji.text != ""
      end
      puts "#{k.count} kanjis loaded."
      s = KanjiHiraganaSheet.new(kanjis: k, seed: opts[:seed], output: opts[:output])
      puts "Generating PDF #{s.output} with seed #{s.seed}..."
      s.to_pdf
      puts "Done!"
    end

    def self.kanjivg(opts)
      puts "Generating SVG with hiragana stoke orders..."
      KanjiVGImporter.assemble_svg
    end

    def self.hiragana(opts)
      puts "Generating hiragana sheet..."
      s = HiraganaSheet.new(output: opts[:output], char: opts[:char])
      s.to_pdf
    end
  end
end
