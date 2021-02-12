require 'prawn-svg'
require 'nokogiri'

module Shukudai
  class HiraganaSheet < Sheet

    attr_reader :char

    def initialize(output: 'sheet.pdf', char: )
      super()
      @char = char
      @svg_id = "0#{@char.ord.to_s(16)}"
      @romaji = Utils.char_to_romaji(@char)
      @number_g_selector = "[id=kvg\\:StrokeNumbers_#{@svg_id}]"
      @stroke_g_selector = "[id=kvg\\:StrokePaths_#{@svg_id}]"
    end

    def to_pdf
      doc
      @doc.define_grid(columns: 4 * 3, rows: 5, gutter: 8)

      render_hiragana_header
      render_stroke_order
      render_kana_boxes

      @doc.render_file @output
    end

    private

    def render_hiragana_header
      @doc.grid([0, 0], [0, 3]).bounding_box do
        @doc.font 'cjk', size: 120
        @doc.text @char, align: :center
        @doc.move_down 2
        @doc.font 'sans', size: 24
        @doc.text @romaji, align: :center

        @doc.stroke_vertical_line @doc.bounds.top - 8,
          @doc.bounds.bottom + 8,
          at: @doc.bounds.right
      end
    end

    def render_stroke_order
      svg_path = Config.load[:data][:hiragana_svg]
      svg_doc = File.open(svg_path){|s| Nokogiri::XML(s)}

      stroke_g = svg_doc.css(@stroke_g_selector).first.clone
      stroke_paths = stroke_g.css("path")

      svg_doc.root.content = " "
      stroke_g.content = ""
      svg_doc.root << stroke_g

      w = @doc.bounds.right / stroke_paths.count

      @doc.grid([0, 4], [0, 11]).bounding_box do
        width = 80
        space = (@doc.bounds.width - (stroke_paths.count * width)) / (stroke_paths.count + 1)
        y_at = @doc.bounds.top - ((@doc.bounds.height - width) / 2)

        stroke_paths.each_with_index do |s, i|
          stroke_g << s
          x_at = (i * (width + space)) + space
          @doc.svg svg_doc.to_xml, at: [x_at , y_at], with: width, height: width
        end
      end
    end

    def render_kana_boxes
      @doc.grid([1, 0], [4, 11]).bounding_box do
        top_space = 32
        @doc.move_down top_space
        kanabox_count = ((@doc.bounds.height - top_space) / 40).floor
        y = @doc.cursor
        ((@doc.bounds.width / 40).floor).times do |i|
          kana_boxes(@doc, kanabox_count, i * 40, y)
        end
      end
    end

  end
end
