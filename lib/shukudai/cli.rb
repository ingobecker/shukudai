require 'optparse'

module Shukudai
  class CLI
    def self.start

      options = {
        seed: nil,
        output: 'sheet.pdf',
        jlpt: 4,
        kana: :hira
      }

      subcommands_usage = <<~USAGE
      Subcommands:
        kanjikana:      train kana handwriting and kanji knowledge at once
        kana:           train handwriting of single kanas
        kanjivg:        import kanjivg stroke order SVGs

        Use shukudai [subcommand] --help form more options.

      USAGE

      main = OptionParser.new do |opts|
        opts.banner = 'Usage: shukudai [subcommand]'
        opts.separator ''
        opts.separator subcommands_usage
      end

      subcommands = {
        kanjikana: OptionParser.new do |opts|
          opts.banner = 'Usage: shukudai kanjikana [options]'

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
            options[:jlpt] = j if j.between?(1, 4)
          end


          opts.on('-o [<filename>]',
                  '--output [<filename>]',
                  String,
                  '(default: sheet.pdf)') do |o|

            options[:output] = o
          end

          opts.on('-k [<hira|kata>]',
                  '--kana [<hira|kata>]',
                  String,
                  'Show answer in hiragana or katakana (default: hira)') do |k|

            options[:kana] = k.to_sym if %w(hira kata).include? k
          end
        end,

        kana: OptionParser.new do |opts|
          opts.banner = 'Usage: shukudai kana [options]'

          opts.on('-c <char>',
                  '--char <char>',
                  String,
                  'Kana to generate a sheet for') do |o|
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

    def self.kanjikana(opts)
      puts "Loading kanjis for JLPT grade #{opts[:jlpt]}..."
      k = Utils.load_kanjis(path: Config.load[:data][:kanjidic2_xml]) do |kanji|
        kanji.jlpt == opts[:jlpt] \
        && kanji.kunyomi.any? \
        && kanji.text != ""
      end
      puts "#{k.count} kanjis loaded."
      s = KanjiKanaSheet.new(kanjis: k, seed: opts[:seed], output: opts[:output], to: opts[:kana])
      puts "Generating PDF #{s.output} with seed #{s.seed}..."
      s.to_pdf
      puts "Done!"
    end

    def self.kanjivg(opts)
      puts "Generating SVG with hiragana stoke orders..."
      KanjiVGImporter.assemble_svg
    end

    def self.kana(opts)
      puts "Generating hiragana sheet..."
      s = KanaSheet.new(output: opts[:output], char: opts[:char])
      s.to_pdf
    end
  end
end
