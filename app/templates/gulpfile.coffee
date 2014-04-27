# -----------DEPENDENCIES-----------

gulp		= require "gulp"
gutil		= require "gulp-util"
$			= require("gulp-load-plugins")()
replace		= require "gulp-replace-task"
run			= require "run-sequence"
<% if (svgicons) { %>
svgsprite	= $.svgSprites.svg
<% } %>
express		= require "express"
open		= require "open"
path		= require "path"
lr			= require("tiny-lr")()

# --------------CONFIG--------------

Config =
	debug: false
	port: 8080
	livereloadport: 35729
	src: "./src"
	dist: "./public"
	content: require "./src/content.json"

# --------------TASKS---------------

# RESET
# 
# Delete everything inside the Config.dist foler

gulp.task "reset", ->
	gulp.src Config.dist + "/*", read: false
		.pipe $.clean
			force: true

# CLEANASSETS
# 
# Removes the existing cache-busting versions of
# static assets in preparation for new versions

gulp.task "cleanassets", ->
	gulp.src Config.dist + "/styles/!(main.min.css|main.css|fonts)", read: false
		.pipe $.clean
			force: true

	gulp.src Config.dist + "/scripts/!(main.min.js|main.js|lib)", read: false
		.pipe $.clean
			force: true

# INSTALL
# 
# Installs Bower <% if (component) { %>& Component <% } %>dependencies

gulp.task "install", ->
	<% if (component) { %>
	# A bit hacky but the gulp-component plugin doesn't work...
	options =
		silent: false
		dist: Config.dist
		continueOnError: true
	gulp.src "component.json"
		.pipe $.exec "component build -o public/components", options

	gutil.log gutil.colors.green "Components installed to " + Config.dist + "/components"<% } %>
	
	$.bower()
	gutil.log gutil.colors.green "Bower dependencies installed to " + Config.src + "/lib"

# JADE
# 
# Compile the Jade templates to HTML and save to the
# Config.dist folder.<% if (localised) { %> A set of 
# compiled files will be generated for each locale.<% } %>

gulp.task "jade", ->

	Config.content = require "./src/content.json"
	<% if (localised) { %>
	for locale, content of Config.content.locales

		if not Config.debug

			gulp.src Config.src + "/jade/*.jade"
				.pipe $.plumber()
				.pipe $.jade
					pretty: true
					data: content
				.pipe gulp.dest Config.dist + "/" + locale

			gulp.src Config.src + "/*.xml"
				.pipe gulp.dest Config.dist + "/" + locale

		else

			gulp.src Config.src + "/jade/*.jade"
				.pipe $.plumber()
				.pipe $.jade
					pretty: true
					data: content
				.pipe replace
					patterns: [
						match: "main.min.css"
						replacement: "main.css"
					,
						match: "main.min.js"
						replacement: "main.js"
					]
				.pipe gulp.dest Config.dist + "/" + locale

			gulp.src Config.src + "/*.xml"
				.pipe gulp.dest Config.dist + "/" + locale
	<% } else { %>
	if not Config.debug

		gulp.src Config.src + "/jade/*.jade"
			.pipe $.plumber()
			.pipe $.jade
				pretty: true
				data: Config.content
			.pipe gulp.dest Config.dist

	else

		gulp.src Config.src + "/jade/*.jade"
			.pipe $.plumber()
			.pipe $.jade
				pretty: true
				data: Config.content
			.pipe replace
				patterns: [
					match: "main.min.css"
					replacement: "main.css"
				,
					match: "main.min.js"
					replacement: "main.js"
				]
			.pipe gulp.dest Config.dist<% } %>

# STYLUS
# 
# Compile the Stylus files to a single CSS file. The 
# compiled CSS will be minified when running `gulp 
# deploy`. Vendor prefixes will be automatically
# added based on requirements indicated at caniuse.com.
# <% if (component) { %>Components' CSS will be included
# at the top of the file <% } %>

gulp.task "stylus", ->
<% if (component) { %>
	cssfilter = $.filter "!build.css"<% } %>

	if not Config.debug

		gulp.src <% if (component) { %>[Config.dist + "/components/build.css", <% } %>Config.src + "/stylus/main.styl"<% if (component) { %>]<% } %>
			.pipe $.plumber()<% if (component) { %>
			.pipe cssfilter<% } %>
			.pipe $.stylus
				set: ["compress"]
				# use: "nib" # (better to avoid nib in favour of autoprefixer and manual mixins)
			.pipe $.autoprefixer "last 1 version", "> 1%", "ie 8", "ie 7"<% if (component) { %>
			.pipe cssfilter.restore()
			.pipe $.concat "main.css"
			.pipe $.minifyCss()<% } %>
			.pipe $.rename "main.min.css"
			.pipe $.stylestats()
			.pipe $.header "/* " + new Date() + " */"
			.pipe $.size
				showFiles: true
			.pipe gulp.dest Config.dist + "/styles"

	else

		gulp.src <% if (component) { %>[Config.dist + "/components/build.css", <% } %>Config.src + "/stylus/main.styl"<% if (component) { %>]<% } %>
			.pipe $.plumber()<% if (component) { %>
			.pipe cssfilter<% } %>
			.pipe $.stylus()
			.pipe $.autoprefixer "last 1 version", "> 1%", "ie 8", "ie 7"<% if (component) { %>
			.pipe cssfilter.restore()
			.pipe $.concat "main.css"<% } %>
			.pipe $.stylestats()
			.pipe $.header "/* " + new Date() + " */"
			.pipe $.size
				showFiles: true
			.pipe gulp.dest Config.dist + "/styles"

# COFFEESCRIPT
# 
# Compile the CoffeeScript files to a single JavaScript
# file using Browserify. Shim files will be available by
# doing `require = "shim"` in your CoffeeScript. The
# compiled JavaScript will be minified when running
# `gulp deploy`. <% if (component) { %>Component's
# JavaScript will be included at the top of the file.<% } %>

gulp.task "coffeescript", ->
<% if (component) { %>
	jsfilter = $.filter "!build.js"<% } %>

	if not Config.debug

		gulp.src <% if (component) { %>[Config.dist + "/components/build.js", <% } %>Config.src + "/coffee/main.coffee"<% if (component) { %>]<% } %>, read: false
			.pipe $.plumber()<% if (component) { %>
			.pipe jsfilter<% } %>
			.pipe $.browserify
				transform: ["coffeeify"]
				shim:
					picturefill:
						path: Config.dist + "/scripts/lib/picturefill/picturefill.js"
						exports: "picturefill"<% if (jquery) { %>
					jquery:
						path: Config.src + "/lib/jquery<% if (!ie8) { %>/dist<% } %>/jquery.min.js"
						exports: "jquery"<% } %><% if (component) { %>
			.pipe jsfilter.restore()
			.pipe $.concat "main.js"<% } %>
			.pipe $.uglify
				mangle: false
			.pipe $.rename "main.min.js"
			.pipe $.header "/* " + new Date() + " */"
			.pipe $.size
				showFiles: true
			.pipe gulp.dest Config.dist + "/scripts"

	else

		gulp.src <% if (component) { %>[Config.dist + "/components/build.js", <% } %>Config.src + "/coffee/main.coffee"<% if (component) { %>]<% } %>, read: false
			.pipe $.plumber()<% if (component) { %>
			.pipe jsfilter<% } %>
			.pipe $.browserify
				transform: ["coffeeify"]
				shim:
					picturefill:
						path: Config.dist + "/scripts/lib/picturefill/picturefill.js"
						exports: "picturefill"<% if (jquery) { %>
					jquery:
						path: Config.dist + "/scripts/lib/jquery<% if (!ie8) { %>/dist<% } %>/jquery.min.js"
						exports: "jquery"<% } %><% if (component) { %>
			.pipe jsfilter.restore()
			.pipe $.concat "main.js"<% } else { %>
			.pipe $.rename "main.js"<% } %>
			.pipe $.header "/* " + new Date() + " */"
			.pipe $.size
				showFiles: true
			.pipe gulp.dest Config.dist + "/scripts"

# JAVASCRIPT
# 
# Copy the JavaScript dependencies to the Config.dist/
# scripts/lib folder. This is in case dependencies need
# to be bundled from the Config.src folder at compile
# time or referenced separately in the final HTML.

gulp.task "javascript", ->
	gulp.src Config.src + "/lib/**/*.js"
		.pipe $.plumber()
		.pipe gulp.dest Config.dist + "/scripts/lib"

# IMAGES
# 
# This task performs the following functions:
# 
# - Optimise and copy all raster images to the 
#   Config.dist/images folder
#   
# - Optimise and copy all SVG images to the
#   Config.dist/images folder<% if (svgicons) { %>
#   
# - Generate a sprite from SVG icons<% } %>

gulp.task "images", ->
	gulp.src Config.src + "/images/**/*.{jpg,png,gif}"
		.pipe $.plumber()
		.pipe $.imagemin
			cache: false
		.pipe $.size
			showFiles: true
		.pipe gulp.dest Config.dist + "/images"

	gulp.src Config.src + "/images/**/*.svg"
		.pipe $.plumber()
		.pipe $.svgmin()
		.pipe $.size
			showFiles: true
		.pipe gulp.dest Config.dist + "/images"
<% if (svgicons) { %>
	gulp.src Config.src + "/images/icons/*.svg"
		.pipe $.plumber()
		.pipe svgsprite
			className: ".icon-%f"
			defs: true
		.pipe gulp.dest Config.dist + "/images/icons"
<% } %>
# RENAMEFILES
# 
# Rename CSS and JavaScript files with cache-busting
# filenames. This task also generate manifest files
# to show which files have been renamed to what. Back-
# end scripts (e.g. PHP) could be written to read those
# manifest files and reference the correct asset files in
# the templates.

gulp.task "renamefiles", ->
	gulp.src [Config.dist + "/styles/*.css"]
	.pipe $.plumber()
	.pipe $.rev()
	.pipe gulp.dest Config.dist + "/styles"
	.pipe $.rev.manifest()
	.pipe gulp.dest Config.dist + "/styles"

	gulp.src [Config.dist + "/scripts/*.js"]
	.pipe $.plumber()
	.pipe $.rev()
	.pipe gulp.dest Config.dist + "/scripts"
	.pipe $.rev.manifest()
	.pipe gulp.dest Config.dist + "/scripts"

# UPDATEHTML
# 
# Update the references to CSS and JavaScript files in
# the HTML to use the new cache-busting filenames.
# 
# NOTE: A timeout is used here to ensure the manifest
# files can be generated before the task is run.

gulp.task "updatehtml", ->

	setTimeout ->

		css = require Config.dist + "/styles/rev-manifest.json"
		js = require Config.dist + "/scripts/rev-manifest.json"

		if not Config.debug

			gulp.src Config.dist + "/**/*.html"
				.pipe $.plumber()
				.pipe replace
					patterns:[
						match: "main.min.css",
						replacement: css["main.min.css"]
					,
						match: "main.min.js",
						replacement: js["main.min.js"]
					]
				.pipe gulp.dest Config.dist

		else

			gulp.src Config.dist + "/**/*.html"
				.pipe $.plumber()
				.pipe replace
					patterns:[
						match: "main.css",
						replacement: css["main.css"]
					,
						match: "main.js",
						replacement: js["main.js"]
					]
				.pipe gulp.dest Config.dist

	, 1000

# OTHERSTUFF
# 
# Move remaining files

gulp.task "otherstuff", ->
<% if (!svgicons) { %>
	gulp.src Config.src + "/fonts/*"
		.pipe gulp.dest Config.dist + "/styles/fonts"
<% } %>
	gulp.src Config.src + "/*.ico"
		.pipe gulp.dest Config.dist

	gulp.src Config.src + "/*.txt"
		.pipe gulp.dest Config.dist
	<% if (!localised) { %>
	gulp.src Config.src + "/*.xml"
		.pipe gulp.dest Config.dist
	<% } %>

# WATCH
#
# Watch for changes in source files and re-run 
# tasks to compile, optimise, run tests etc.. 
# Also watch for changes in result files and 
# refresh the livereload server.

gulp.task "watch", ->
<% if (component) { %>
	gulp.watch "./component.json", ["install"]
	gulp.watch Config.dist + "/components/build.css", ["stylus"]
	gulp.watch Config.dist + "/components/build.js", ["jade"]
<% } %>

	gulp.watch "./bower.json", ["install"]

	gulp.watch Config.src + "/jade/**/*.jade", ["jade"]
	gulp.watch Config.src + "/stylus/**/*.styl", ["stylus"]
	gulp.watch Config.src + "/coffee/**/*.coffee", ["coffeescript", "test"]
	gulp.watch Config.src + "/test/**/*.coffee", ["test"]
	gulp.watch Config.src + "/images/!(favicons)/*.{png,jpg,gif,svg}", ["images"]
	gulp.watch Config.src + "/lib/**/*.js", ["javascript"]
	gulp.watch Config.src + "/content.json", ["jade"]
	gulp.watch Config.src + "/*.{xml,ico,txt,php}", ["otherstuff"]<% if (!svgicons) { %>
	gulp.watch Config.src + "/fonts/*", ["otherstuff"]<% } %>

	gulp.watch Config.dist + "/**/*.{html,css,js}", notifyLivereload
	gulp.watch Config.dist + "/images/**/*", notifyLivereload

# SERVER
# 
# Start an express server during development

gulp.task "server", ->
	app = express()
	app.use require("connect-livereload")()
	app.use express.static(Config.dist)
	app.listen Config.port
	lr.listen Config.livereloadport
	gutil.log gutil.colors.yellow("Server listening on port " + Config.port)
	gutil.log gutil.colors.yellow("Livereload listening on port " + Config.livereloadport)
	open("http://localhost:8080<% if (localised) { %>/en_GB<% } %>") #change this to whatever locale you have

# TEST
# 
# Run unit tests

gulp.task "test", ->
	options =
		silent: false
		continueOnError: true
	gulp.src "karma.conf.coffee"
		.pipe $.exec "./node_modules/karma/bin/karma start", options

notifyLivereload = (event) ->

	fileName = "/" + path.relative Config.dist, event.path
	gulp.src event.path, read: false
		.pipe require("gulp-livereload")(lr)
	gutil.log gutil.colors.yellow("Reloading " + fileName)

# DEFAULT
# 
# The task that runs when you type `gulp`. It runs
# the tasks in sequence, meaning that the first time may
# take a little while to generate everything.

gulp.task "default", ->
	Config.debug = true
	run "reset", ["install", "images", "javascript", "otherstuff"], "jade", ->
		setTimeout ->
			run ["stylus", "coffeescript"], ->
				run "server", "watch", ->
					gutil.log gutil.colors.green("Finished setup")
		, 4000

# DEPLOY
# 
# This copies all compiled and minified assets to the
# Config.dist directory, ready for deployment

gulp.task "deploy", ->
	Config.debug = false
	run "reset", ["install", "images", "javascript", "otherstuff"], ->
		# Wait for components to install
		setTimeout ->
			run "cache", ->
				gutil.log gutil.colors.green("Your deployment files are going to the " + Config.dist + " folder")
		, 8000

# CACHE
# 
# Apply cache-busting filenames to static assets and update
# references to those files in the compiled HTML.

gulp.task "cache", ->
	run "cleanassets", ["stylus", "coffeescript"], "renamefiles", "jade", "updatehtml"