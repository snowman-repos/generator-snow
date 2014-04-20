dependencyloaded = true

module.exports.log = ->
	console.info "Dependency successfully loaded: " + dependencyloaded

module.exports.variable = dependencyloaded