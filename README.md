# generator-snow [![Build Status](https://secure.travis-ci.org/darryl-snow/generator-snow.png?branch=master)](https://travis-ci.org/darryl-snow/generator-snow)

## Features:
* Jade/Stylus/CoffeeScript stack
* Localisation based on content from a single config file
* Minimal CSS boilerplate framework
* CoffeeScript with browserify (require "dependency")
* Remove unused CSS
* Unit tests with Jasmine/Karma/PhantomJS
* Automatically includes jQuery (latest, or otherwise 1.10.* if IE8 support is * required) and HTML5 shim if required
* Component integration
* Other front-end dependencies managed with Bower
* All the config files you need
* Support for icon fonts and SVG icon sprites
* Responsive images using picturefill
* Image optimisation
* Full set of fav/app/touch icons
* Automating cache-busting for CSS and JS
* Fully automated watch & build system using GulpJS
* A handsome logo


## Getting Started

Yeoman is a scaffolding application that helps you set up projects so you can get straight into the coding. **Snow** is a generator that scaffolds out a starter template with:

* Jade, Stylus, and CoffeeScript front-end stack
* Gulp configuration to compile and optimise templates, styles, scripts, and images, as well as run a development server with livereload (won't work with a VPN on)
* Localised content generated from a single JSON file

### Prerequisites

* [NodeJS](https://nodejs.org)
* [NPM](https://npmjs.org)
* [GulpJS](http://gulpjs.com)
* [Yeoman](http://yeoman.io/):

```
$ sudo npm install -g yo
```

### Get Started

To install generator-snow from npm, run:

```
$ sudo npm install -g generator-snow
```

Then create a new project directory and then initiate the generator:

```
$ mkdir <project> && cd $_
$ yo snow <project>
```

### Sub-generators

To create a new page:

```
yo snow:page [pagename]
```

### Using the generated project

To install Bower and Component dependencies:

```
gulp install
```

During development (compile, watch for changes, run a server):

```
gulp
```

For deployment (will package and optimise everything):

```
gulp deploy
```

## License

MIT