ga = require "ga-browserify"
tracker = ga "UA-0000000-X" #replace with your GA tracking code
tracker._trackPageview()
# tracker.trackEvent(...)
<% if(jquery) { %>require "jquery"<% } %>

console.log "Hello World!"

require "picturefill"
picturefill()

dependency = require "./dependency.coffee"
dependency.log()

# export stuff for testing
module.exports.dependencyloaded = dependency.variable