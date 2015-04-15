module.exports = (grunt) ->

  # configure the tasks
  grunt.initConfig
    browserify:
      options:
        debug: true
        transform: ['coffee-reactify']
        extensions: ['.jsx', '.cjsx', '.coffee']
      dev:
        options:
          alias: ['react:']  # Make React available externally for dev tools
          browserifyOptions:
            debug: true
        src: ['client/scripts/app.cjsx']
        dest: 'build/static/js/app.js'
      production:
        options:
          debug: false
        src: '<%= browserify.dev.src %>'
        dest: '<%= browserify.dev.dest %>'
    coffee:
      server:
        options:
          bare: true
        files: [
          {
            expand: true
            cwd: 'server/'
            src: ['*.coffee']
            dest: 'build/'
            ext: '.js'
          }
        ]
    sass:
      dev:
        options:
          sourcemap: 'inline'
        files:
          'build/static/css/app.css': 'client/styles/app.sass'
    concat:
      options:
        separator: ';'
      otr:
        src: [
          'client/scripts/vendor/otr/dep/salsa20.js',
          'client/scripts/vendor/otr/dep/bigint.js',
          'client/scripts/vendor/otr/dep/crypto.js',
          'client/scripts/vendor/otr/dep/eventemitter.js',
          'client/scripts/vendor/otr/otr.js'
        ]
        dest: 'build/static/js/otr.js'
    copy:
      server:
        cwd: 'server/'
        src: [ 'views/**/*' ]
        dest: 'build/'
        expand: true
      deployment:
        cwd: 'deployment/'
        src: [ 'manifest.yml', 'package.json' ]
        dest: 'build/'
        expand: true
    watch:
      styles:
        files: 'client/styles/**/*'
        tasks: [ 'sass:dev' ]
      scripts:
        files: 'client/scripts/**/*'
        tasks: [ 'browserify:dev' ]
      otr:
        files: 'client/scripts/vendor/**/*'
        tasks: [ 'concat:otr' ]
      server:
        files: 'server/**/*'
        tasks: [ 'express:node_server:stop', 'coffee:server', 'copy:server', 'express:node_server' ]
        options:
          spawn: false
          debounceDelay: 2000
    browserSync:
      dev:
        bsFiles:
          src : [
            'build/*.html'
            'build/*.js'
            'build/static/**/*'
          ]
        options:
          watchTask: true
          proxy: 'localhost:9000'
          ghostMode: false
          watchOptions:
            debounceDelay: 3000
          open: false
          reloadOnRestart: false
    env:
      dev:
        NODE_ENV : 'development'
      build:
        NODE_ENV : 'production'
    clean:
      build: src: 'build'
    express:
      node_server:
        options:
          port: 9000
          node_env: 'development'
          script: 'build/index.js'
    nodeunit:
      server: ['server/test/*_test.coffee']
      options:
        reporter: 'default'


  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-browser-sync'
  grunt.loadNpmTasks 'grunt-env'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-contrib-concat'

  grunt.registerTask 'dev', ['browserify:dev', 'sass:dev', 'copy:server', 'concat:otr']
  grunt.registerTask 'server', ['clean:build', 'coffee:server', 'copy:server', 'copy:deployment']
  grunt.registerTask 'build', ['server', 'dev']
  grunt.registerTask 'reloading', ['server', 'dev', 'express:node_server', 'browserSync', 'watch']

