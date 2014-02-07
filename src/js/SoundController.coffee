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
    t = new Audio()
    codecs =
      mp3: !!t.canPlayType('audio/mpeg;').replace(/^no$/, '')
      opus: !!t.canPlayType('audio/ogg; codecs="opus"').replace(/^no$/, '')
      ogg: !!t.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/, '')
      wav: !!t.canPlayType('audio/wav; codecs="1"').replace(/^no$/, '')
      m4a: !!(t.canPlayType('audio/x-m4a;') || t.canPlayType('audio/aac;')).replace(/^no$/, '')
      mp4: !!(t.canPlayType('audio/x-mp4;') || t.canPlayType('audio/aac;')).replace(/^no$/, '')
      weba: !!t.canPlayType('audio/webm; codecs="vorbis"').replace(/^no$/, '')
    t = null

    if _.isArray(src)
      i = 0
      while i < src.length
        ext = src[i].split('.').pop()
        if codecs[ext]
          url = src[i]
          break
        i++
    else
      url = src

    @media = new Audio url

    super

module.exports = SoundController
