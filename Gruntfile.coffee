# Grunt Wrapper
module.exports = (grunt) ->

  grunt.initConfig

    # Watch
    watch:
      src:
        options:
          livereload: false
        files: ['src/**/*.{js,coffee}']
        tasks: ['compile']
      # Live reload
      livereload:
        options:
          dateFormat: (time) ->
            grunt.log.writeln 'Watch finished in ' + time + 'ms at ' + (new Date()).toString()
            grunt.log.writeln 'Waiting for changes...'
          livereload: true
        files: ['build/**/*']

    # Coffee Lint
    coffeelint:
      options:
        'no_trailing_whitespace':
          'level': 'error'
        'max_line_length':
          'level': 'ignore'
      app: [
        'Gruntfile.coffee'
        'src/index.coffee'
      ]

    # Build number

  # Dependencies
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  # Test
  grunt.registerTask 'test', [
    'compile'
  ]

  # Compile
  grunt.registerTask 'compile', [
    'coffeelint'
  ]

  # Development
  grunt.registerTask 'dev', [
    'compile'
    'watch'
  ]
