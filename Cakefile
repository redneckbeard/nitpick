fs     = require 'fs'
{exec} = require 'child_process'

appFiles  = [
  # omit src/ and .coffee to make the below lines a little shorter
  'colormath'
  'template'
  'colorpicker'
]

task 'build', 'Build single application file from source files', ->
  appContents = new Array remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    fs.readFile "coffee/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'js/nitpick.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee -o js --compile js/nitpick.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        exec 'uglifyjs js/nitpick.js', (err, stdout, stderr) ->
          throw err if err
          fs.writeFile 'js/nitpick.min.js', stdout, 'utf8', (err) ->
            throw err if err
        fs.unlink 'js/nitpick.coffee', (err) ->
          throw err if err
