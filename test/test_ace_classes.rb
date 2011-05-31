#!/usr/bin/env ruby

# 31-05-2011
# Noe Fdez Pozo
# Script to test ace classes

# the path for the classes
ROOT_PATH=File.dirname(__FILE__)
$: << File.expand_path(File.join(ROOT_PATH, "classes"))

# classes
require 'ace_parser'

if ARGV.size != 1
	puts "incorrect number of arguments, you need an ace files:\n\n\t ruby test_ace_classes.rb file.ace"
  Process.exit(-1);
end

# get file name
ace_file = ARGV[0]

# --------------------------------- ejemplo para imprimir un ace
my_ace = Ace.new(ace_file)

ace_to_print = my_ace.write_ace
puts ace_to_print
