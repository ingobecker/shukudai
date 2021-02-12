require 'json'
require 'nokogiri'

module Shukudai
  module KanjiVGImporter
    def self.assemble_svg(kanjivg_svg_dir: nil, output: nil)
      config = Config.load
      kanjivg_dir ||= config[:data][:kanjivg_dir]
      output ||= config[:data][:hiragana_svg]

      f = File.read(config[:data][:romaji_map])
      m = JSON.parse(f)

      m.delete('ゟ')
      filenames = m.map do |k, v|
        next if k.size > 1
        {
          file: "#{kanjivg_dir}/0#{k.ord.to_s(16)}.svg",
          char: k
        }
      end.compact

      svg_collect = nil

      filenames.each do |f|
        d = File.open(f[:file]){|s| Nokogiri::XML(s)}

        unless svg_collect
          svg_collect = { doc: d, svg: d.css('svg').first }
        else
          svg_collect[:svg] << d.css('svg').children
        end
      end

      File.open("#{output}", "w+") do |f|
        f.write(svg_collect[:doc].to_xml)
      end
    end
  end
end
