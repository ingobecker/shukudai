# Shukudai

Shukudai it a tool for practicing japanese hiragana handwriting. It can generate two different types of PDF worksheets at the moment.

## Kanji-Kana-Sheets

This type of sheet consists of 12 kanjis, each with it's corresponding romaji-style pronounciation and meaning. Below each pronounciation there are vertical boxes which can be filled with the corresponding kanas. There is the option to write the word in hiragana or katakana. The sheets look like this:

<img srcset="https://github.com/ingobecker/shukudai/raw/main/misc/kanji_kana_sheet_poster_797w.png, https://github.com/ingobecker/shukudai/raw/main/misc/kanji_kana_sheet_poster_1991w.png 2x" src="https://github.com/ingobecker/shukudai/raw/main/misc/kanji_kana_sheet_poster_797w.png" alt="Kanji-Kana-Sheet PDF">

Download the [sample PDF](misc/sheet_123.pdf?raw=true) from the picture above.

To generate those sheets use the `kanjikana` subcommand:

```
$ shukudai kanjikana --seed 123 --jlpt 2 --kana hira --output sheet_123.pdf
# or
$ shukudai kanjikana -s 123 -j 2 -k hira -o sheet_123.pdf

# to generate a sheet with the answer in katakana use the following option
$ shukudai kanjikana -k kana -o kanji_katakan_sheet.pdf

# don't specify a seed and kana option to generate a random sheet
# with answer in hiragana
$ shukudai kanjikana -o random.pdf
```

## Kana-Sheets

If you have just started learning hiragana and katakana, this type of worksheet helps you practice handwriting of individual kanas:

<img srcset="https://github.com/ingobecker/shukudai/raw/main/misc/kana_sheet_poster_664w.png, https://github.com/ingobecker/shukudai/raw/main/misc/kana_sheet_poster_1669w.png 2x" src="https://github.com/ingobecker/shukudai/raw/main/misc/kana_sheet_poster_664w.png" alt="Kana-Sheet PDF">

Download the [sample PDF](misc/sheet_se.pdf?raw=true) from the picture above.

To generate one use the `kana` subcommand:

```
$ shukudai kana --char せ --output sheet_se.pdf
# or just
$ shukudai kana -c せ -o sheet_se.pdf
# or for katakana
$ shukudai kana -c セ -o sheet_se.pdf
```


## Installation

The easiest way to run `shukudai` is using the container inside this repo. The container contains a propper CKJ-font to render japanese characters as well as the dictionaries required to determine each kanjis meaning and pronounciation.

Build and run the container as shown below:

```
$ git clone https://github.com/ingobecker/shukudai.git
$ cd shukudai
$ podman build -t shukudai .
$ podman container runlabel exec shukudai -- kanjikana -s 123 -o sheet_123.pdf
```

This will create a file called `sheet_123.pdf` in the current working directory using the seed `123`.
