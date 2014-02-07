
$ = require('jquery')
SoundController = require './SoundController.coffee'


s = new SoundController 'test.mp3',
  autoplay: false
  preload: true

$ ->
  $('.load').bind 'click', (e)->
    s = new SoundController 'test.mp3',
      autoplay: false
      preload: true
    @

  $('.play').bind 'click', (e)->
    s.play()
    @

  $('.pause').bind 'click', (e)->
    s.pause()
    @

  s.addListener 'timeupdate', (e, c, d)->
    $('.elapsed').text(c)
    $('.duration').text(d)
    $('.seek').attr('value', e.currentTarget.currentTime / e.currentTarget.duration)

  $('.volume').bind 'change', (e)->
    s.setVolume e.currentTarget.value

  $('.seek').bind 'change mouseup', (e)->
    s.currentTime e.currentTarget.value
    $('.seek').attr('max', e.currentTarget.duration)

  $('.fadeIn').bind 'click', (e)->
    s.fadeIn()

  $('.fadeOut').bind 'click', (e)->
    s.fadeOut()

  return
