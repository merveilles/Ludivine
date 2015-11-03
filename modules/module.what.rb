#!/bin/env ruby
# encoding: utf-8

class Answer

	def what

		if !@message.include?("what is") then return end

		@memory.connect()

		topic = @message.sub("what is ","")

        # Find answers
        $answer = _answer(topic)
        $similar = _similar(topic)
        $parent = _parent($answer[2])
        $related = _related($answer[2])

        if $similar then also = "\n#{$similar[1].to_s.capitalize} is also #{topic}." end

        if !$answer
        	return "I don't know what #{topic} is."
    	else
    		if $parent && $related then return "#{topic.capitalize} is *#{$answer[2]}*, #{$parent[2]}, like _#{$related[1]}_. #{also}" end
    		if $parent then return "*#{topic.capitalize}* is #{$answer[2]}, #{$parent[2]}. #{also}" end
    		if $related then return "*#{topic.capitalize}* is #{$answer[2]}, like #{$related[1]}. #{also}" end
    		return "*#{topic.capitalize}* is #{$answer[2]}. #{also}"
        end

        return ""

	end

	def _answer topic

		thoughts = @memory.load(topic)
        answers = []
        thoughts.each do |thought|
        	if thought[1] == topic then answers.push(thought) end
        end
        return answers.sample

	end

	def _parent topic

		thoughts = @memory.load(topic)
        parents = []
        thoughts.each do |thought|
        	if thought[1] == $answer[1] then next end
        	if thought[1] == $answer[2] then parents.push(thought) end
        end
        return parents.sample

	end

	def _related topic

		thoughts = @mem