
$ = require('jquery')
VideoController = require './libs/VideoController.coffee'


s = new VideoController
  src: [
    'http://cdn-1.metacdn.net/jumipqxo/50OUEm/20120318032304_trailer1080p_ogg-MEDIUM.webm'
    'http://cdn-1.metacdn.net/jumipqxo/5I9Wdx/20120318032304_trailer1080p_ogg-MEDIUM.ogv'
    'http://cdn-1.metacdn.net/jumipqxo/5UP73g/20120318032304_trailer1080p_ogg-MEDIUM.mp4'
  ]
  autoplay: false
  preload: true

$ ->
  $('.load').bind 'click', (e)->
    s = new VideoController
      src: 'media/test.mp3'
      autoplay: false
      preload: true
    @

  # Play
  $('.play').bind 'click', (e)->
    s.play()
    return

  # Pause
  $('.pause').bind 'click', (e)->
    s.pause()
    return

  # Time Update Event
  s.addListener 'timeupdate', (e, c, d)->
    $('.elapsed').text(c)
    $('.duration').text(d)
    $('.seek').attr('value', e.currentTarget.currentTime / e.currentTarget.duration)
    return

  # Scrubber Change Handler
  $('.seek').bind 'change mouseup', (e)->
    s.currentTime e.currentTarget.value
    $('.seek').attr('max', e.currentTarget.duration)
    return

  # Volume Change Event
  s.addListener 'volumechange', (e)->
    $('.volume').val e.currentTarget.volume
    $('.volume-label').text e.currentTarget.volume

  # Volume Change Handler
  $('.volume').bind 'change', (e)->
    s.setVolume e.currentTarget.value
    return

  # Fade In Volume
  $('.fadeIn').bind 'click', (e)->
    s.fadeIn()
    return

  # Fade Out Volume with duration and steps
  $('.fadeOut').bind 'click', (e)->
    s.fadeOut(10000, 50)
    return

  # Mute
  $('.mute').bind 'click', (e)->
    s.mute()
    return

  return
