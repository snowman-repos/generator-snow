# src = require("./tasks/files.coffee")
# Karma configuration
# Generated on Thu Feb 20 2014 12:51:57 GMT-0300 (ART)
module.exports = (config) ->
	config.set
		preprocessors:
			"src/test/spec.coffee": ["coffee"]
			"src/coffee/main.coffee": ["browserify"]

		coffeePreprocessor:
			# options passed to the coffee compiler
			options:
				bare: true
				sourceMap: true

		# base path, that will be used to resolve files and exclude
		basePath: ""
		colors: true

		# frameworks to use
		frameworks: ["jasmine", "browserify"]
		
		# test results reporter to use
		# possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
		reporters: ["progress"]
		
		# web server port
		port: 9876
		
		# enable / disable colors in the output (reporters and logs)
		colors: true
		
		# level of logging
		# possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
		logLevel: config.LOG_INFO
		
		# enable / disable watching file and executing tests whenever any file changes
		files: [
			"src/lib/picturefill/picturefill.js"<% if (jquery) { %>
			"src/lib/jquery/<% if (!ie8) { %>dist/<% } %>jquery.js"<% } %>
			"src/coffee/main.coffee"
			"src/test/*.coffee"
 			{
 				pattern: "src/coffee/main.coffee"
 				watched: false
 				included: false
 				served: false
 			}
		]
		exclude: []
		autoWatch: false
		
		# Start these browsers, currently available:
		# - Chrome
		# - ChromeCanary
		# - Firefox
		# - Opera (has to be installed with `npm install karma-opera-launcher`)
		# - Safari (only Mac; has to be installed with `npm install karma-safari-launcher`)
		# - PhantomJS
		# - IE (only Windows; has to be installed with `npm install karma-ie-launcher`)
		browsers: ["PhantomJS"]
		
		# If browser does not capture in given timeout [ms], kill it
		captureTimeout: 60000
		
		# Continuous Integration mode
		# if true, it capture browsers, run tests and exit
		singleRun: true
		browserify:
			extensions: [".coffee"]
			transform: ["coffeeify"]
			debug: true