# Grunt Wrapper
module.exports = (grunt) ->

  grunt.initConfig

    # Watch
    watch:
      src:
        options:
          livereload: 35728
        files: ['src/**/*.{js,coffee}']
        tasks: ['compile']

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
