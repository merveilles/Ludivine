#!/bin/env ruby
# encoding: utf-8

#: Add things to my memory

class Answer

    def that

        @memory.connect()
        @message = @message.sub("remember that ", "").strip
    
        termSplit = _termToSplit(@message)
        name = termSplit[0]
        value = termSplit[1]
        term = termSplit[2]
        
        if value.include?("http")
            return "I cannot remember URLs."
        end
        
        if name != "" && value != "" && term != ""
            @memory.save(@username, name, value)
            return "I will remember that *"+_nlpResponse(name)+"*" + term + "*#{value}*."
        end
        
        return "What do you want me to remember #{@username}?"

    end

    def _nlpResponse words

        words = " "+words+" "
        words = words.sub(" my "," _your_ ")
        words = words.sub(" me "," _you_ ")
        words = words.sub(" your "," _my_ ")
        words = words.sub(" you "," _me_ ")
        words = words.gsub("_","")

        return words.strip

    end
    
    def _termToSplit(msg)
        terms = ["is", "are", "have", "has"]
        if msg.split(" ").length > 2
            for term in terms
                name = msg.split(" " + term + " ")[0].to_s.strip
                value = msg.split(" " + term + " ")[1].to_s.strip
                if name != "" && value != ""
                    return [name, value, " " + term + " "]
                end
            end
        end
        return ["", "", ""]
    end

end