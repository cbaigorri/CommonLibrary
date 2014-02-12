_ = require 'underscore'
MediaController = require './MediaController.coffee'

class VideoController extends MediaController

  # Constructor
  constructor: (options={})->
    _.extend @options, options
    console.log 'Video Controller', @options
    @load(@options.src) if @options.src != ""
    super

  # Load
  load: (src)->
    @media = new Video @getPlaybleSource(new Video())
    super

module.exports = VideoController
