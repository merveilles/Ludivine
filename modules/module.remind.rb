#!/bin/env ruby
# encoding: utf-8

#: Add to the hourly reminders with _remember us to_

class Answer

    def remind

        @memory.connect()
        @message = @message.sub("remind us to ", "").strip
        @memory.save(@username, "#{@username}'s reminder", @message)
        return "I will remind you to *#{@message}*."

    end

end