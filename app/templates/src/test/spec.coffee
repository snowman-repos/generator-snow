# main = require "../coffee/main.coffee"
dependency = require "../coffee/dependency.coffee"

describe "<%= _.slugify(sitename) %>", ->

	delay = (ms, func) -> setTimeout func, ms

	it "should load dependecy", ->
		# expect(main.dependencyloaded).toBe true
		expect(dependency.variable).toBe true