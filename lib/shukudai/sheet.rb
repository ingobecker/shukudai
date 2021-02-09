require 'prawn'

module Shukudai
  class Sheet

    attr_accessor :output, :page_size, :config

    def initialize
      @config = Config.load
      @page_size = 'A4'
      @output = 'sheet.pdf'
    end

    def doc
      @doc ||= begin
        d = Prawn::Document.new(page_size: @page_size)
        d.font_families.update(font_dict)
        d
      end
    end

    def font_dict()
      {
        'cjk' => {
          normal: @config[:fonts][:cjk]
        },
        'sans' => {
          normal: @config[:fonts][:sans],
          bold: @config[:fonts][:sans_bold]
        }
      }
    end

    def kana_boxes(d, count)
      size = 40
      d.bounding_box([d.bounds.left, d.cursor], width: size, height: size * count) do
        count.times do |i|
          y = i + 1
          d.stroke_rectangle [0, y * size], size, size

          d.dash(2)
          d.stroke do
            d.horizontal_line 0, size, at: (i + 0.5) * size
            d.vertical_line i * size, y * size, at: size * 0.5
          end
          d.undash
        end
      end
    end
  end
end
