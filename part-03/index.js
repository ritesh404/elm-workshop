require('ace-css/css/ace.css');
require('font-awesome/css/font-awesome.css');
require('../index.html');
const Elm = require('./Main.elm');

var mountNode = document.getElementById('main');

Elm.Main.embed(mountNode);

// .embed() can take an optional second argument. This would be an object describing the data we need to start a program, i.e. a userID or some token
// var app = .Main.embed(mountNode);

