/*global describe, beforeEach, it */
"use strict";
var path = require("path");
var helpers = require("yeoman-generator").test;

describe("snow generator", function () {

	this.timeout(5000);

	beforeEach(function (done) {
		helpers.testDirectory(path.join(__dirname, "temp"), function (err) {
			if (err) {
				return done(err);
			}

			this.app = helpers.createGenerator("snow:app", [
				"../../app"
			]);
			done();
		}.bind(this));
	});

	it("creates expected files (default)", function (done) {
		var expected = [
			"bower.json",
			".bowerrc",
			".editorconfig",
			"fabfile.py",
			".gitignore",
			"gulpfile.coffee",
			"gulpfile.js",
			".coffeelintrc",
			"package.json",
			"readme.md",
			"src/content.json",
			"src/jade/index.jade",
			"src/jade/templates/master.jade",
			"src/jade/includes/header.jade",
			"src/jade/includes/footer.jade",
			"src/stylus/main.styl",
			"src/stylus/base/base.styl",
			"src/stylus/base/buttons.styl",
			"src/stylus/base/forms.styl",
			"src/stylus/base/icons.styl",
			"src/stylus/base/images.styl",
			"src/stylus/base/inputs.styl",
			"src/stylus/base/lists.styl",
			"src/stylus/base/selects.styl",
			"src/stylus/base/tables.styl",
			"src/stylus/base/typography.styl",
			"src/stylus/helpers/debug.styl",
			"src/stylus/helpers/grid.styl",
			"src/stylus/helpers/mixins.styl",
			"src/stylus/helpers/normalise.styl",
			"src/stylus/helpers/variables.styl",
			"src/stylus/modules/navbar.styl",
			"src/stylus/modules/hero.styl",
			"src/coffee/dependency.coffee",
			"src/coffee/main.coffee",
			"src/test/spec.coffee",
			"src/images/logo.png",
			"src/images/favicons/apple-touch-icon-114x114.png",
			"src/images/favicons/apple-touch-icon-120x120.png",
			"src/images/favicons/apple-touch-icon-144x144.png",
			"src/images/favicons/apple-touch-icon-152x152.png",
			"src/images/favicons/apple-touch-icon-57x57.png",
			"src/images/favicons/apple-touch-icon-60x60.png",
			"src/images/favicons/apple-touch-icon-72x72.png",
			"src/images/favicons/apple-touch-icon-76x76.png",
			"src/images/favicons/apple-touch-icon-precomposed.png",
			"src/images/favicons/apple-touch-icon.png",
			"src/images/favicons/favicon-160x160.png",
			"src/images/favicons/favicon-16x16.png",
			"src/images/favicons/favicon-196x196.png",
			"src/images/favicons/favicon-32x32.png",
			"src/images/favicons/favicon-96x96.png",
			"src/images/favicons/mstile-144x144.png",
			"src/images/favicons/mstile-150x150.png",
			"src/images/favicons/mstile-310x150.png",
			"src/images/favicons/mstile-310x310.png",
			"src/images/favicons/mstile-70x70.png"
		];

		helpers.mockPrompt(this.app, {
			"jquery": true,
			"ie8": true,
			"component": true,
			"localised": true,
			"svgicons": true
		});
		this.app.options["skip-install"] = true;
		this.app.run({}, function () {
			helpers.assertFile(expected);
			done();
		});
	});

	it("creates expected files (icon fonts)", function (done) {
		var expected = [
			"src/fonts/snow.eot",
			"src/fonts/snow.svg",
			"src/fonts/snow.ttf",
			"src/fonts/snow.woff"
		];

		helpers.mockPrompt(this.app, {
			"svgicons": false
		});
		this.app.options["skip-install"] = true;
		this.app.run({}, function () {
			helpers.assertFile(expected);
			done();
		});
	});

	it("creates expected files (component)", function (done) {
		var expected = [
			"component.json"
		];

		helpers.mockPrompt(this.app, {
			"component": true
		});
		this.app.options["skip-install"] = true;
		this.app.run({}, function () {
			helpers.assertFile(expected);
			done();
		});
	});

	it("creates expected files (svgicons)", function (done) {
		var expected = [
			"src/images/icons/arrow-down.svg",
			"src/images/icons/arrow-left.svg",
			"src/images/icons/arrow-right.svg",
			"src/images/icons/arrow-up.svg",
			"src/images/icons/heart.svg",
			"src/images/icons/user-add.svg"
		];

		helpers.mockPrompt(this.app, {
			"svgicons": true
		});
		this.app.options["skip-install"] = true;
		this.app.run({}, function () {
			helpers.assertFile(expected);
			done();
		});
	});

});

describe("Page", function () {

	this.timeout(5000);

	it("should generate a new page", function (done) {
		this.sitesubgenerator = helpers.createGenerator("snow:page", [
				"../../page"
			], ["foo"]);

		var expected = [
			"src/jade/foo.jade"
		];

		this.sitesubgenerator.options["skip-install"] = true;
		this.sitesubgenerator.run({}, function () {
			helpers.assertFile(expected);
			done();
		});
	});
});