_ = require 'underscore'
MediaController = require './MediaController.coffee'

class SoundController extends MediaController

  # Constructor
  constructor: (options={})->
    _.extend @options, options
    console.log 'Sound Controller', @options
    @load(@options.src) if @options.src != ""
    super

  # Load
  load: (src)->
    @media = new Audio @getPlaybleSource()
    super

  # Get Playable Source
  getPlaybleSource: ()->
    super new Audio()

module.exports = SoundController

