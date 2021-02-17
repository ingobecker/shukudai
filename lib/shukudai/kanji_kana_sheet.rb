module Shukudai
  class KanjiKanaSheet < Sheet

    attr_reader :kanjis, :seed, :count

    def initialize(output: 'sheet.pdf', kanjis: , seed: nil, to: :hira)
      super()
      @output = output
      @kanjis = kanjis
      @seed = seed || Random.rand(100...999)
      @rng = Random.new(@seed)
      @count = 12
      @romaji_map = nil
      @to = to
    end

    def sample
      @kanjis.sample(@count, random: @rng)
    end

    def to_pdf()

      doc
      @doc.define_grid(columns: 4 * 4, rows: 3, gutter: 8)
      kanjis = sample

      answer = []
      max_height = 0
      3.times do |row|
        kanji_row = kanjis.pop(4).map do |k|
          ki = {}
          ki[:text] = k.text
          ki[:reading] = (k.kunyomi.first || k.onyomi.first).tr('.-', '')
          ki[:romaji] = Utils.romajinize(ki[:reading])
          ki[:meanings] = k.meanings.join(', ')
          ki[:meanings] = ki[:meanings][0...68] + '..' if ki[:meanings].length > 68
          ki
        end

        kanji_row.each_with_index do |k, column|
          answer << [k[:text], k[:reading]]

          # kanji
          @doc.grid(row, column * 4).bounding_box do
            @doc.font 'cjk', size: 24
            @doc.text k[:text], align: :right
          end

          # explanation
          @doc.grid([row, (column * 4) + 1], [row, (column * 4) + 3]).bounding_box do
            @doc.font 'sans', size: 12, style: :bold
            @doc.text k[:romaji]
            @doc.move_down 2
            @doc.font 'sans', size: 12, style: :normal
            @doc.text k[:meanings]

            current_height = @doc.bounds.height - @doc.cursor
            max_height = current_height if current_height > max_height
          end
        end

        # kanaboxes
        kanji_row.each_with_index do |k, column|
          @doc.grid([row, (column * 4) + 1], [row, (column * 4) + 3]).bounding_box do
            @doc.move_down max_height + 2
            kana_boxes(@doc, k[:reading].length)
          end
        end

        max_height = 0
      end

      # answer
      answer_str = answer.map{ |a| "#{a[0]}: #{@to == :hira ? a[1] : NKF.nkf("-h2 -w", a[1])}"}.join(' | ')
      @doc.grid([2, 0], [2, 12]).bounding_box do
        @doc.font 'cjk', size: 10
        @doc.text answer_str, valign: :bottom
      end

      # seed
      @doc.grid([2,12], [2,15]).bounding_box do
        @doc.font 'sans', size: 8
        @doc.text "seed: #{@seed}", size: 8, valign: :bottom, align: :right
      end

      @doc.render_file @output

    end
  end

  def to_stdio()
    sample.each do |kanji|
      reading = kanji.kunyomi.first || kanji.onyomi.first
      romaji = romajinize(reading)
      meanings = kanji.meanings.join(', ')
      puts "Kanji: #{kanji.text}, Romaji: #{romaji}, Meanings: #{meanings}"
    end
  end
end
