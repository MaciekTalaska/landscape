require('coffee-script/register')

gulp = require('gulp')
del = require('del')
coffee = require('gulp-coffee')
bump = require('gulp-bump')
bowerDownload = require('gulp-bower')
bowerFiles = require('main-bower-files')

paths =
  source:
    manifest: ['package.json', 'bower.json']
    source:
      coffee: ['_source/*.coffee', '_source/**/*.coffee']
      static:  ['_source/**', '!*.coffee']
    scripts:
      coffee: ['_scripts/*.coffee']
      js: ['_scripts/*.js']
  cache:
    root: '.build'
    bower: '.build/bower_components'
  dest:
    root: '.'
    scripts: 'scripts'
    source: 'source'
    scrollspy: 'source/scrollspy'
    fancybox: 'source/fancybox'
    js: 'source/js'

gulp.task 'bump', ['build'], ->
  argv = require('yargs')
    .alias('b', 'bump')
    .default('bump', 'patch')
    .describe('bump', 'bump [major|minor|patch|prerelease] version')
    .argv

  gulp.src paths.source.manifest
    .pipe bump { type: argv.bump }
    .pipe gulp.dest(paths.dest.root)

gulp.task 'build:bower:download', ->
  bowerDownload(paths.cache.bower)

gulp.task 'build:bower', ['build:bower:download'], ->
  gulp.src bowerFiles(), base: paths.cache.bower
      .pipe gulp.dest paths.dest.source

gulp.task 'build:scripts:coffee', ->
  gulp.src paths.source.scripts.coffee
    .pipe coffee()
    .pipe gulp.dest paths.dest.scripts

gulp.task 'build:scripts:js', ->
  gulp.src paths.source.scripts.js
    .pipe gulp.dest paths.dest.scripts

gulp.task 'build:scripts', ['build:scripts:coffee', 'build:scripts:js']

gulp.task 'build:source:coffee', ->
  gulp.src paths.source.source.coffee
      .pipe coffee()
      .pipe gulp.dest paths.dest.source

gulp.task 'build:source:coffee', ->
  gulp.src paths.source.source.static
      .pipe gulp.dest paths.dest.source

gulp.task 'build:source', ['build:source:coffee', 'build:source:coffee']

gulp.task 'build', [ 'clean', 'build:bower', 'build:source', 'build:scripts']

gulp.task 'default', ['build']

gulp.task 'clean:cache', ->
  del.sync [paths.cache.root]

gulp.task 'clean', (done) ->
  del.sync [paths.dest.scripts, paths.dest.source]
