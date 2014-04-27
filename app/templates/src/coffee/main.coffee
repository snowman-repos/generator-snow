console.log "Hello World!"

require "picturefill"
picturefill()

dependency = require "./dependency.coffee"
dependency.log()

# export stuff for testing
module.exports.dependencyloaded = dependency.variable