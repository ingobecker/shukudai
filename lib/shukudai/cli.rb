require 'optparse'

module Shukudai
  class CLI
    def self.start

      options = {
        seed: nil,
        output: 'sheet.pdf'
      }

      OptionParser.new do |opts|
        opts.banner = "Usage: shukudai [options] output.pdf"

        opts.on('-s [SEED]', '--seed [SEED]', Integer, 'Reprodruce worksheet with SEED from page (default: random)') do |s|
          if s < 100 || s > 999
            abort('make sure seed is between 100 and 999')
          end
          options[:seed] = s
        end

        opts.on('-o [OUTPUT]', '--output [OUTPUT]', String, 'Filename of created worksheet (default: sheet.pdf)') do |o|
          options[:output] = o
        end
      end.parse(ARGV)

      puts "Loading kanjis..."
      k = Utils.load_kanji_by_jlpt_grade(path: Config.load[:data][:kanjidic2_xml])
      s = KanjiHiraganaSheet.new(kanjis: k, seed: options[:seed], output: options[:output])
      puts "Generating PDF #{s.output} with seed #{s.seed}..."
      s.to_pdf
      puts "Done!"
    end
  end
end
