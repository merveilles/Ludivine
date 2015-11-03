#!/bin/env ruby
# encoding: utf-8

class Answer

    def initialize(module_name, method_name, username, message, channel, memory = nil)

        @module_name = module_name
        @method_name = method_name
        @username    = username
        @message     = message
        @channel     = channel
        @memory      = if memory == nil then Memory.new() else memory end

    end

    def debug

        return "#{@module_name} - #{@username} - #{@message} - #{@channel}"

    end

    def includeModule name

        require_relative "modules/module."+name+".rb"

    end

    def output

        includeModule(@module_name)
        if self.respond_to?(@method_name)
            return self.send(@method_name)
        end
        return self.send(@module_name)

    end

    def hey

        return "hey #{@username}."

    end

end