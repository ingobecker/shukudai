require 'json'
require 'eiwa'

module Shukudai
  module Utils
    def self.load_kanjis(path: , &filter)
      kanjis = Eiwa.parse_file(path, type: :kanjidic2)
      if filter
        kanjis.select(&filter)
      else
        kanjis
      end
    end

    def self.char_to_romaji(char)
      @@romaji_map ||= begin
                         f = File.read(Config.load[:data][:romaji_map])
                         @@romaji_map = JSON.parse(f)
                       end
      @@romaji_map[char]
    end

    def self.romajinize(word)
      word.each_char.map{|c| self.char_to_romaji(c)}.join
    end
  end
end
