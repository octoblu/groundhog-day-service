#!/usr/bin/env node

require('coffee-script/register');
var Command = require('./command.coffee');
var command = new Command({argv: process.argv});
command.run();
