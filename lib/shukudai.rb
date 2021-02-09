# frozen_string_literal: true

require_relative "shukudai/version"

require 'shukudai/cli'
require 'shukudai/config'
require 'shukudai/sheet'
require 'shukudai/utils'
require 'shukudai/kanji_hiragana_sheet'

module Shukudai
  class Error < StandardError; end
  # Your code goes here...
end
