/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// To install Webpacker after bundling, do:
// rails webpack:install

// To add support for js.erb files, do:
// rails webpack:install:erb

// To add support fo react with webpacker, do:
// rails webpack:install:react

// After installing react-rails gem, do:
// rails g react:install

// With Webpack working for us, it takes some time to compile JavaScript files. To do this in the background, run the following in another tab: 
// bin/webpack-dev-server

console.log('Hello World from Webpacker')
// Support component names relative to this directory:
var componentRequireContext = require.context("components", true)
var ReactRailsUJS = require("react_ujs")
ReactRailsUJS.useContext(componentRequireContext)
