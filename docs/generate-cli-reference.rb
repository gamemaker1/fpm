#!/usr/bin/env ruby

require_relative "../lib/fpm/command"
    

puts "Command-line Reference"
puts "=========================="
puts

puts "This page documents the command-line flags available in FPM. You can also see this content in your terminal by running ``fpm --help``"
puts

puts "General Options"
puts "---------------"
puts

FPM::Command.instance_variable_get(:@declared_options).each do |option|
    text = option.description.gsub("\n", " ")

    # Don't show output-format-specific options, they get their own section
    if !text.include? "only)"
        if option.type == :flag
            # it's a flag which means there are no parameters to the option
            puts "* ``#{option.switches.first.strip}``"
        else
            puts "* ``#{option.switches.first} #{option.type.strip}``"
        end

        if option.switches.length > 1
            puts "    - Alternate option spellings: ``#{option.switches[1..].join(", ").strip}``"
        end
        puts "    - #{text}"
        puts
    end
end

FPM::Package.types.sort_by { |k,v| k }.each do |name, type|
    options = type.instance_variable_get(:@options)
    puts "#{name}"
    puts "-" * name.size
    puts

    if options.empty?
        puts "This package type has no additional options"
    end

    options.sort_by { |flag, _| flag }.each do |flag, param, help, options, block|
        if param == :flag 
            puts "* ``#{flag.first.strip}``"
        else
            puts "* ``#{flag.first} #{param.strip}``"
        end

        text = help.sub(/^\([^)]+\) /, "")
        puts "    - #{text}"
    end

    puts
end