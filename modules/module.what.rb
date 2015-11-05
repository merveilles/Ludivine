#!/bin/env ruby
# encoding: utf-8

#: Ask me anything.

class Answer

    def is

        @memory.connect()
        @message = _matchPronouns(@message)

        topic = @message.sub("what is","").strip

        # Find answers
        $answer = _answer(topic)
        $parent = _answer($answer)
        $similar = _similar($parent)

        if !$answer
            return "I don't know what #{topic} is."
        else
            if $parent && $similar then return "#{topic.capitalize} is *#{$answer}*, #{$parent}, like _#{$similar}_." end
            if $parent then return "*#{topic.capitalize}* is #{$answer}, #{$parent}." end
            return "*#{topic.capitalize}* is #{$answer}."
        end

        return ""

    end

    def time

        return Time.now.inspect

    end

	def _answer topic

		thoughts = @memory.load(topic)
        answers = []
        thoughts.shuffle.each do |thought|
            if thought[2] == topic then next end
        	return thought[2]
        end
        return

	end

	def _similar topic

		thoughts = @memory.load(topic)
        similars = []
        thoughts.each do |thought|
            if thought[2] != topic then next end
            if thought[1] == $answer then next end
            return thought[1]
        end
		return

	end

end