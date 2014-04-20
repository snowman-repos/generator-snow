"use strict";
var util = require("util");
var yeoman = require("yeoman-generator");


var PageGenerator = yeoman.generators.NamedBase.extend({

	init: function () {
		// content = require("./src/content.json");
		console.log("Creating page: " + this.name.toLowerCase() + ".");
	},

	files: function () {
		this.copy("newpage.jade", "src/jade/" + this.name.toLowerCase() + ".jade");
	}
});

module.exports = PageGenerator;