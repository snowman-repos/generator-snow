describe "<%= _.slugify(sitename) %>", ->

	delay = (ms, func) -> setTimeout func, ms

	it "should load dependecy", ->
		expect(dependency.variable).toBe true