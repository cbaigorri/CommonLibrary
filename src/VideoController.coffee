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
    container.appendChild @media

    # set the source
    @media.setAttribute 'src', @getPlaybleSource()

    # poster if requested
    @media.setAttribute 'poster', @options.poster if @options.poster && @options.poster != ''

    # width
    @media.setAttribute 'width', @options.width if @options.width && @options.width != ''

    # height
    @media.setAttribute 'height', @options.height if @options.height && @options.height != ''

    # Fullscreen listeners
    @media.addEventListener @events.WEBKIT_FULLSCREEN_CHANGE, (e)=>
        @media_FullScreenChange e
        return
      , false

    @media.addEventListener @events.MOZ_FULLSCREEN_CHANGE, (e)=>
        @media_FullScreenChange e
        return
      , false

    @media.addEventListener @events.WEBKIT_BEGIN_FULLSCREEN, (e)=>
        @media_BeginFullScreen e
        return
      , false

    @media.addEventListener @events.WEBKIT_END_FULLSCREEN, (e)=>
        @media_EndFullScreen e
        return
      , false

    super

  # Get Playable Source
  getPlaybleSource: ()->
    videoElement = document.createElement 'video'
    super videoElement

  # FUllscreen
  fullscreen: ()->
    @media.requestFullScreen() if @media.requestFullScreen
    @media.mozRequestFullScreen() if @media.mozRequestFullScreen
    @media.webkitRequestFullScreen() if @media.webkitRequestFullScreen

  # Destroy
  destroy: ()->
    @media.removeEventListener @events.WEBKIT_FULLSCREEN_CHANGE, @media_FullScreenChange
    @media.removeEventListener @events.MOZ_FULLSCREEN_CHANGE, @media_FullScreenChange
    @media.removeEventListener @events.WEBKIT_BEGIN_FULLSCREEN, @media_BeginFullScreen
    @media.removeEventListener @events.WEBKIT_END_FULLSCREEN, @media_EndFullScreen
    super

  # Events

  # Fullscreen Change
  media_FullScreenChange: (e)->
    @.emit @events.FULLSCREEN_CHANGE, e

  # Fullscreen Begin
  media_BeginFullScreen: (e)->
    @.emit @events.BEGIN_FULLSCREEN, e

  # Fullscreen End
  media_EndFullScreen: (e)->
    @.emit @events.END_FULLSCREEN, e

module.exports = VideoController
