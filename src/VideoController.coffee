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
    @media = document.createElement 'video'
    container = document.getElementById @options.el
    playableSource = @getPlaybleSource()

    container.appendChild @media

    @media.setAttribute 'src', playableSource

    console.log 'load', container, @media

    # poster if requested
    @media.setAttribute 'poster', @options.poster if @options.poster && @options.poster != ''

    super

  # Get Playable Source
  getPlaybleSource: ()->
    videoElement = document.createElement 'video'
    super videoElement

module.exports = VideoController
