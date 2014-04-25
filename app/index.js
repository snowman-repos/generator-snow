"use strict";

var util = require("util");
var path = require("path");
var yeoman = require("yeoman-generator");
var chalk = require("chalk");


var SnowGenerator = yeoman.generators.Base.extend({
	init: function () {
		this.pkg = require("../package.json");

		this.argument("sitename", {type: String, required: false});
		this.sitename = this.sitename || path.basename(process.cwd());
		this.sitename = this._.camelize(this._.slugify(this._.humanize(this.sitename)));

		this.on("end", function () {
			if (!this.options["skip-install"]) {
				this.installDependencies();
			}
		});
	},

	basicOptions: function () {
		var done = this.async();

		// have Yeoman greet the user
		this.log(this.yeoman);

		// replace it with a short and sweet description of your generator
		this.log(chalk.magenta("You're using the rather splendid Snow generator."));
		this.log(chalk.magenta("It's great for setting up new projects that use Jade, Stylus, CoffeeScript, and may need localised templates"));

		var prompts = [{
			type: "confirm",
			name: "jquery",
			message: "Do you need jQuery?",
			default: true
		},
		{
			type: "confirm",
			name: "ie8",
			message: "Do you need to support IE8?",
			default: false
		},
		{
			type: "confirm",
			name: "component",
			message: "Do you want to use Component?",
			default: false
		},
		{
			type: "confirm",
			name: "localised",
			message: "Do you need multiple locales?",
			default: false
		},
		{
			type: "confirm",
			name: "svgicons",
			message: "Do you want to try SVG icons (instead of icon fonts)?",
			default: false
		}];

		this.prompt(prompts, function (props) {
			this.jquery = props.jquery;
			this.ie8 = props.ie8;
			this.component = props.component;
			this.localised = props.localised;
			this.svgicons = props.svgicons;
			done();
		}.bind(this));
	},

	app: function () {
		this.mkdir("src");
		this.mkdir("src/jade");
		this.mkdir("src/jade/includes");
		this.mkdir("src/jade/templates");
		this.mkdir("src/stylus");
		this.mkdir("src/stylus/base");
		this.mkdir("src/stylus/helpers");
		this.mkdir("src/stylus/modules");
		this.mkdir("src/coffee");
		this.mkdir("src/lib");
		this.mkdir("src/images");
		this.mkdir("src/images/favicons");
		if (this.svgicons) {
			this.mkdir("src/images/icons");
		} else {
			this.mkdir("src/fonts");
		}

		this.template("package.json", "package.json");
		this.template("bower.json", "bower.json");

		if (this.component) {
			this.template("component.json", "component.json");
		}
	},

	projectfiles: function () {
		// base files
		this.copy("bowerrc", ".bowerrc");
		this.copy("editorconfig", ".editorconfig");
		this.copy("gitignore", ".gitignore");
		this.template("gulpfile.coffee", "gulpfile.coffee");
		this.copy("gulpfile.js", "gulpfile.js");
		this.copy("coffeelintrc", ".coffeelintrc");
		this.copy("readme.md", "readme.md");
		this.copy("src/favicon.ico", "src/favicon.ico");
		this.copy("src/browserconfig.xml", "src/browserconfig.xml");
		if (this.localised) {
			this.template("src/content-localised.json", "src/content.json");
		} else {
			this.copy("src/content.json", "src/content.json");
		}

		// jade
		this.template("src/jade/index.jade", "src/jade/index.jade");
		this.template("src/jade/templates/master.jade", "src/jade/templates/master.jade");
		this.template("src/jade/includes/header.jade", "src/jade/includes/header.jade");
		this.copy("src/jade/includes/footer.jade", "src/jade/includes/footer.jade");

		// stylus
		this.copy("src/stylus/main.styl", "src/stylus/main.styl");
		this.copy("src/stylus/base/base.styl", "src/stylus/base/base.styl");
		this.copy("src/stylus/base/buttons.styl", "src/stylus/base/buttons.styl");
		this.copy("src/stylus/base/forms.styl", "src/stylus/base/forms.styl");
		this.copy("src/stylus/base/icons.styl", "src/stylus/base/icons.styl");
		this.copy("src/stylus/base/images.styl", "src/stylus/base/images.styl");
		this.copy("src/stylus/base/inputs.styl", "src/stylus/base/inputs.styl");
		this.copy("src/stylus/base/lists.styl", "src/stylus/base/lists.styl");
		this.copy("src/stylus/base/selects.styl", "src/stylus/base/selects.styl");
		this.copy("src/stylus/base/tables.styl", "src/stylus/base/tables.styl");
		this.copy("src/stylus/base/typography.styl", "src/stylus/base/typography.styl");
		this.copy("src/stylus/helpers/debug.styl", "src/stylus/helpers/debug.styl");
		this.copy("src/stylus/helpers/grid.styl", "src/stylus/helpers/grid.styl");
		this.copy("src/stylus/helpers/mixins.styl", "src/stylus/helpers/mixins.styl");
		this.copy("src/stylus/helpers/normalise.styl", "src/stylus/helpers/normalise.styl");
		this.copy("src/stylus/helpers/variables.styl", "src/stylus/helpers/variables.styl");
		this.copy("src/stylus/modules/navbar.styl", "src/stylus/modules/navbar.styl");
		this.copy("src/stylus/modules/hero.styl", "src/stylus/modules/hero.styl");

		// coffeescript
		this.copy("src/coffee/dependency.coffee", "src/coffee/dependency.coffee");
		this.template("src/coffee/main.coffee", "src/coffee/main.coffee");

		// tests
		this.template("src/test/spec.coffee", "src/test/spec.coffee");

		// images
		this.copy("src/images/logo.png", "src/images/logo.png");
		this.copy("src/images/ajax-loader.gif", "src/images/ajax-loader.gif");
		this.copy("src/images/favicons/apple-touch-icon-114x114.png", "src/images/favicons/apple-touch-icon-114x114.png");
		this.copy("src/images/favicons/apple-touch-icon-120x120.png", "src/images/favicons/apple-touch-icon-120x120.png");
		this.copy("src/images/favicons/apple-touch-icon-144x144.png", "src/images/favicons/apple-touch-icon-144x144.png");
		this.copy("src/images/favicons/apple-touch-icon-152x152.png", "src/images/favicons/apple-touch-icon-152x152.png");
		this.copy("src/images/favicons/apple-touch-icon-57x57.png", "src/images/favicons/apple-touch-icon-57x57.png");
		this.copy("src/images/favicons/apple-touch-icon-60x60.png", "src/images/favicons/apple-touch-icon-60x60.png");
		this.copy("src/images/favicons/apple-touch-icon-72x72.png", "src/images/favicons/apple-touch-icon-72x72.png");
		this.copy("src/images/favicons/apple-touch-icon-76x76.png", "src/images/favicons/apple-touch-icon-76x76.png");
		this.copy("src/images/favicons/apple-touch-icon-precomposed.png", "src/images/favicons/apple-touch-icon-precomposed.png");
		this.copy("src/images/favicons/apple-touch-icon.png", "src/images/favicons/apple-touch-icon.png");
		this.copy("src/images/favicons/favicon-160x160.png", "src/images/favicons/favicon-160x160.png");
		this.copy("src/images/favicons/favicon-16x16.png", "src/images/favicons/favicon-16x16.png");
		this.copy("src/images/favicons/favicon-196x196.png", "src/images/favicons/favicon-196x196.png");
		this.copy("src/images/favicons/favicon-32x32.png", "src/images/favicons/favicon-32x32.png");
		this.copy("src/images/favicons/favicon-96x96.png", "src/images/favicons/favicon-96x96.png");
		this.copy("src/images/favicons/mstile-144x144.png", "src/images/favicons/mstile-144x144.png");
		this.copy("src/images/favicons/mstile-150x150.png", "src/images/favicons/mstile-150x150.png");
		this.copy("src/images/favicons/mstile-310x150.png", "src/images/favicons/mstile-310x150.png");
		this.copy("src/images/favicons/mstile-310x310.png", "src/images/favicons/mstile-310x310.png");
		this.copy("src/images/favicons/mstile-70x70.png", "src/images/favicons/mstile-70x70.png");

		if (this.svgicons) {
			// Icons
			this.copy("src/images/icons/arrow-down.svg", "src/images/icons/arrow-down.svg");
			this.copy("src/images/icons/arrow-left.svg", "src/images/icons/arrow-left.svg");
			this.copy("src/images/icons/arrow-right.svg", "src/images/icons/arrow-right.svg");
			this.copy("src/images/icons/arrow-up.svg", "src/images/icons/arrow-up.svg");
			this.copy("src/images/icons/heart.svg", "src/images/icons/heart.svg");
			this.copy("src/images/icons/user-add.svg", "src/images/icons/user-add.svg");
		} else {
			// Fonts
			this.copy("src/fonts/snow.eot", "src/fonts/snow.eot");
			this.copy("src/fonts/snow.svg", "src/fonts/snow.svg");
			this.copy("src/fonts/snow.ttf", "src/fonts/snow.ttf");
			this.copy("src/fonts/snow.woff", "src/fonts/snow.woff");
		}
	}
});

module.exports = SnowGenerator;