module Shukudai
  module Config
    def self.load
      data_dir = File.expand_path(File.dirname(__FILE__) + '/../../data')
      @@config ||= begin
                     {
                       fonts: {
                         cjk: '/usr/share/fonts/truetype/vlgothic/VL-Gothic-Regular.ttf',
                         sans: '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
                         sans_bold: '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
                       },
                       data: {
                         romaji_map: "#{data_dir}/romaji_map.json",
                         kanjidic2_xml: "#{Dir.home}/.local/share/shukudai/kanjidic2.xml",
                         jmdict_xml: "#{data_dir}/jmdict.xml"
                       }
                     }
                   end
    end
  end
end
