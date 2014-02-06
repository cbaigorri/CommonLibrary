_ = require 'underscore'
MediaController = require './MediaController.coffee'

class SoundController extends MediaController

  # Constructor
  constructor: (src="", options={})->
    _.extend @options, options
    console.log 'Sound Controller', @options
    @load(src) if src != ""
    super

  # Load
  load: (src)->
    console.log 'Sound Controller -> load'
    @media = new Audio src
    super

module.exports = SoundController
