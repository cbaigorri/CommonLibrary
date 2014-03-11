_ = require 'underscore'
moment = require 'moment'
EventEmitter = require('events').EventEmitter

class MediaController extends EventEmitter

  # Options
  options:
    autoplay: false
    preload: false
    loop: true
    volume: 1

  # Events
  events:
    LOAD_START: 'loadstart'
    PROGRESS: 'progress'
    SUSPEND: 'suspend'
    ABORT: 'abort'
    ERROR: 'error'
    EMPTIED: 'emptied'
    STALLED: 'stalled'
    LOADED_META_DATA: 'loadedmetadata'
    LOADED_DATA: 'loadeddata'
    CAN_PLAY: 'canplay'
    CAN_PLAY_THROUGH: 'canplaythrough'
    PLAYING: 'playing'
    WAITING: 'waiting'
    SEEKING: 'seeking'
    SEEKED: 'seeked'
    ENDED: 'ended'
    DURATION_CHANGE: 'durationchange'
    TIME_UPDATE: 'timeupdate'
    PLAY: 'play'
    PAUSE: 'pause'
    RATE_CHANGE: 'ratechange'
    RESIZE: 'resize'
    VOLUME_CHANGE: 'volumechange'

  constructor: ()->

  # Play
  play: ()->
    @media.play()

  # Pause
  pause: ()->
    @media.pause()

  # Set Volume
  setVolume: (value)->
    @media.volume = value

  # Mute
  mute: ()->
    @setVolume 0

  # Fade In
  fadeIn: (duration=1000, steps=10)->
    vol = @media.volume
    clearInterval @volIntervalId
    @volIntervalId = setInterval ()=>
        if vol < 1
          vol += 0.05
          @media.volume = vol.toFixed(2)
        else
          clearInterval @volIntervalId
      , duration/steps

  # Fade Out
  fadeOut: (duration=1000, steps=10)->
    vol = @media.volume
    clearInterval @volIntervalId
    @volIntervalId = setInterval ()=>
        if vol > 0
          vol -= 0.05
          @media.volume = vol.toFixed(2)
        else
          clearInterval @volIntervalId
      , duration/steps

  # Set Current Time
  currentTime: (value)->
    @media.currentTime = @media.duration * value

  # Get Playable Source
  getPlaybleSource: (t)->
    codecs =
      # audio
      mp3: !!t.canPlayType('audio/mpeg;').replace(/^no$/, '')
      opus: !!t.canPlayType('audio/ogg; codecs="opus"').replace(/^no$/, '')
      ogg: !!t.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/, '')
      wav: !!t.canPlayType('audio/wav; codecs="1"').replace(/^no$/, '')
      m4a: !!(t.canPlayType('audio/x-m4a;') || t.canPlayType('audio/aac;')).replace(/^no$/, '')
      mp4: !!(t.canPlayType('audio/x-mp4;') || t.canPlayType('audio/aac;')).replace(/^no$/, '')
      weba: !!t.canPlayType('audio/webm; codecs="vorbis"').replace(/^no$/, '')
      # video
      webm: !!t.canPlayType('video/webm; codecs="vp8, vorbis"').replace(/^no$/, '')
      mp4: !!t.canPlayType('video/mp4; codecs="avc1.42E01E, mp4a.40.2"').replace(/^no$/, '')
      ogv: !!t.canPlayType('video/ogg; codecs="theora, vorbis"').replace(/^no$/, '')

    t = null

    src = @options.src

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
    url

  # Load
  load: ()->
    # set default volume level
    @media.volume = @options.volume

    # preload if requested
    @media.setAttribute 'preload', 'auto' if @options.preload

    @media.addEventListener @events.LOAD_START, (e)=>
        @media_LoadStart e
        return
      , false

    @media.addEventListener @events.PROGRESS, (e)=>
        @media_Progress e
        return
      , false

    @media.addEventListener @events.SUSPEND, (e)=>
        @media_Suspend e
        return
      , false

    @media.addEventListener @events.ABORT, (e)=>
        @media_Abort e
        return
      , false

    @media.addEventListener @events.ERROR, (e)=>
        @media_Error e
        return
      , false

    @media.addEventListener @events.EMPTIED, (e)=>
        @media_Emptied e
        return
      , false

    @media.addEventListener @events.STALLED, (e)=>
        @media_Stalled e
        return
      , false

    @media.addEventListener @events.LOADED_META_DATA, (e)=>
        @media_LoadedMetaData e
        return
      , false

    @media.addEventListener @events.LOADED_DATA, (e)=>
        @media_LoadedData e
        return
      , false

    @media.addEventListener @events.CAN_PLAY, (e)=>
        @media_CanPlay e
        return
      , false

    @media.addEventListener @events.CAN_PLAY_THROUGH, (e)=>
        @media_CanPlayThrough e
        return
      , false

    @media.addEventListener @events.PLAYING, (e)=>
        @media_Playing e
        return
      , false

    @media.addEventListener @events.WAITING, (e)=>
        @media_Waiting e
        return
      , false

    @media.addEventListener @events.SEEKING, (e)=>
        @media_Seeking e
        return
      , false

    @media.addEventListener @events.SEEKED, (e)=>
        @media_Seeked e
        return
      , false

    @media.addEventListener @events.ENDED, (e)=>
        @media_Ended e
        return
      , false

    @media.addEventListener @events.DURATION_CHANGE, (e)=>
        @media_DurationChange e
        return
      , false

    @media.addEventListener @events.TIME_UPDATE, (e)=>
        @media_TimeUpdate e
        return
      , false

    @media.addEventListener @events.PLAY, (e)=>
        @media_Play e
        return
      , false

    @media.addEventListener @events.PAUSE, (e)=>
        @media_Pause e
        return
      , false

    @media.addEventListener @events.RATE_CHANGE, (e)=>
        @media_RateChange e
        return
      , false

    @media.addEventListener @events.RESIZE, (e)=>
        @media_Resize e
        return
      , false

    @media.addEventListener @events.VOLUME_CHANGE, (e)=>
        @media_VolumeChange e
        return
      , false

  # Destroy
  destroy: ()->
    @media.removeEventListener @events.LOAD_START, @media_LoadStart
    @media.removeEventListener @events.PROGRESS, @media_Progress
    @media.removeEventListener @events.SUSPEND, @media_Suspend
    @media.removeEventListener @events.ABORT, @media_Abort
    @media.removeEventListener @events.ERROR, @media_Error
    @media.removeEventListener @events.EMPTIED, @media_Emptied
    @media.removeEventListener @events.STALLED, @media_Stalled
    @media.removeEventListener @events.LOADED_META_DATA, @media_LoadedMetaData
    @media.removeEventListener @events.LOADED_DATA, @media_LoadedData
    @media.removeEventListener @events.CAN_PLAY, @media_CanPlay
    @media.removeEventListener @events.CAN_PLAY_THROUGH, @media_CanPlayThrough
    @media.removeEventListener @events.PLAYING, @media_Playing
    @media.removeEventListener @events.WAITING, @media_Waiting
    @media.removeEventListener @events.SEEKING, @media_Seeking
    @media.removeEventListener @events.SEEKED, @media_Seeked
    @media.removeEventListener @events.ENDED, @media_Ended
    @media.removeEventListener @events.DURATION_CHANGE, @media_DurationChange
    @media.removeEventListener @events.TIME_UPDATE, @media_TimeUpdate
    @media.removeEventListener @events.PLAY, @media_Play
    @media.removeEventListener @events.PAUSE, @media_Pause
    @media.removeEventListener @events.RATE_CHANGE, @media_RateChange
    @media.removeEventListener @events.RESIZE, @media_Resize
    @media.removeEventListener @events.VOLUME_CHANGE, @media_VolumnChange

  # Events

  # Load Start
  media_LoadStart: (e)->
    @.emit @events.LOAD_START, e

  # Progress
  media_Progress: (e)->
    @.emit @events.PROGRESS, e

  # Suspend
  media_Suspend: (e)->
    @.emit @events.SUSPEND, e

  # Abort
  media_Abort: (e)->
    @.emit @events.ABORT, e

  # Error
  media_Error: (e)->
    throw new Error('File not found')
    @.emit @events.ERROR, e

  # Emptied
  media_Emptied: (e)->
    @.emit @events.EMPTIED, e

  # Stalled
  media_Stalled: (e)->
    @.emit @events.STALLED, e

  # Loaded Meta Data
  media_LoadedMetaData: (e)->
    @.emit @events.LOADED_META_DATA, e

  # Loaded Data
  media_LoadedData: (e)->
    @.emit @events.LOADED_DATA, e

  # Can Play
  media_CanPlay: (e)->
    @.emit @events.CAN_PLAY, e
    @media.play() if @options.autoplay == true && @options.preload == false
    return

  # Can Play Through
  media_CanPlayThrough: (e)->
    @.emit @events.CAN_PLAY_THROUGH, e
    @media.play() if @options.autoplay == true && @options.preload == true
    return

  # Playing
  media_Playing: (e)->
    @.emit @events.PLAYING, e

  # Waiting
  media_Waiting: (e)->
    @.emit @events.WAITING, e

  # Seeking
  media_Seeking: (e)->
    @.emit @events.SEEKING, e

  # Seeked
  media_Seeked: (e)->
    @.emit @events.SEEKED, e

  # Ended
  media_Ended: (e)->
    @.emit @events.ENDED, e
    if typeof @media.loop == 'boolean'
      @media.loop = true
    else
      if @options.loop == true
        @media.currentTime = 0
        @media.play()

  # Duration Change
  media_DurationChange: (e)->
    @.emit @events.DURATION_CHANGE, e

  # Time Update
  media_TimeUpdate: (e)->
    currentTime = moment.duration(e.currentTarget.currentTime, 'seconds')
    duration = moment.duration(e.currentTarget.duration, 'seconds')
    currentTImeDisplay = currentTime.minutes() + ':' + ('0' + currentTime.seconds()).slice(-2)
    durationDisplay = duration.minutes() + ':' + ('0' + duration.seconds()).slice(-2)
    @.emit @events.TIME_UPDATE, e, currentTImeDisplay, durationDisplay

  # Play
  media_Play: (e)->
    @.emit @events.PLAY, e

  # Pause
  media_Pause: (e)->
    @.emit @events.PAUSE, e

  # Rate Change
  media_RateChange: (e)->
    @.emit @events.RATE_CHANGE, e

  # Resize
  media_Resize: (e)->
    @.emit @events.RESIZE, e

  # Volume Change
  media_VolumeChange: (e)->
    @.emit @events.VOLUME_CHANGE, e

module.exports = MediaController
