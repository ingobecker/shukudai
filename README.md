# Shukudai

Shukudai it a tool for practicing japanese hiragana handwriting. It can generate an unlimitednumber of randomized PDF worksheets. Using the seed found on each worksheet it can be regenerated.

## Kanji-Hiragana-Sheets

This type of sheet is currently the only supported one. It generates 12 kanjis, each with it's corresponding romaji-style pronounciation and meaning. Below each pronounciation are vertical boxes which can be filled with the corresponding hiragana. The sheets look like this:

![Kanji-Hiragana-Sheet PDF](misc/kanji_hira_sheet_poster.jpg?raw=true)

Download the [sample PDF](misc/sheet_123.pdf?raw=true) from the picture above.

## Installation

The easiest way to run `shukudai` is using the container inside this repo. The container contains a propper CKJ-font to render japanese characters as well as the dictionaries required to determine each kanjis meaning and pronounciation.

Build and run the container as shown below:

```
$ git clone https://github.com/ingobecker/shukudai.git
$ cd shukudai
$ podman build -t shukudai .
$ podman container runlabel exec shukudai -- -s 123 -o sheet_123.pdf
```

This will create a file called `sheet_123.pdf` in the current working directory using the seed `123`.
