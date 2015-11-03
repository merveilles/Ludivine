#!/bin/env ruby
# encoding: utf-8

#: General documentation.

class Answer

    def help

        return "What do you need help with?\nYou can see my list of modules with `help modules` or improve my responses by creating pull requests on Github: https://github.com/merveilles/Bot-Ludivine"

    end

    def rules

        return "_You must have a black and white avatar. I am exempt from this rule._"

    end

    def modules

        visible_modules = ""

        Dir.entries("#{$root}/modules/").each do |name,v|
            if !name.include?("module.") then next end

            nameFormatted = name.sub("module.", "").sub(".rb", "")
            documentation = ""
            methods = []
            filePath = "#{$root}/modules/"+name
            File.open(filePath, 'r') do |f1|  
                while line = f1.gets  
                    if line.include?("#: ") && documentation == "" then documentation = line.gsub("#:","").strip end
                    if line.include?("def ") && !line.include?("if line") then methods.push(line.sub("def","").strip) end
                end  
            end

            visible_modules += "*#{nameFormatted.capitalize}* "
            if documentation != "" 
                visible_modules += "_#{documentation}_"
            else
                visible_modules += "[Missing documentation]"
            end
            visible_modules += "\n"
            methods.each do |method|
                if method[0,1] == "_" then next end
                if method == nameFormatted.downcase then next end
                visible_modules += "`#{method}` "
            end
            visible_modules += "\n\n"
        end

        return visible_modules.rstrip

    end

    def query

        topic = @message.sub("help query","").strip

        if topic == "" then
            return "Query takes a parameter:\n`help query single malt`\nYou may also query which topics can be listed with `list all`."
        end

        @memory.connect()
        thoughts = @memory.load(topic)

        matches = thoughts.select {|x| x[2].include?(topic) }.map { |x| x[1] }.uniq

        if matches.size() == 1 then
            return "The only *#{topic}* I know is _#{matches[0]}_."
        elsif matches.size() > 1 then
            return "I know #{matches.size()} kinds of *#{topic}* : _#{matches.join("_, _")}_."
        end

        return "I don't know any *#{topic}*."

    end

    def topics

        @memory.connect()
        thoughts = @memory.load("")

        matches = thoughts.select.with_index { |x,i| thoughts.index.with_index { |y,j| y[2] == x[2] && j != i } != nil }.map { |x| x[2] }.uniq

        if matches.size() > 0 then
            return "There are #{matches.size()} listable topics : _#{matches.join("_, _")}_."
        end

        return "There are no listable topics."

    end

    def compile

        @memory.connect()
        query = @message.sub("compile", "").strip

        if query == ""
            return "You must give me something to compile.\n`compile something`"
        end

        thoughts = @memory.load(query).shuffle

        votes = {}
        votesSum = 0

        thoughts.each do |known|
            if known[1] != query then next end
            votes[known[2]] = votes[known[2]].to_i + 1
            votesSum += 1
        end

        if votesSum < 1
            return "I don't know what *"+query+"* is."
        end

        totalPercents = 0
        otherVotes = 0
        graph = ""
        votes.sort_by {|_key, value| value}.reverse.each do |value,count|
            percent = ((count.to_f/votesSum.to_f)*100).to_i
            if percent < 10
                otherVotes += 1
                next
            end
            totalPercents += percent
            graph += _progressBar(percent)+" *"+value+"* has "+count.to_s+" votes, for "+percent.to_s+"%\n"
        end

        if totalPercents > 3 && otherVotes > 0
           graph += "And *"+otherVotes.to_s+" misc votes*, for "+(100-totalPercents).to_s+"%..\n" 
        end

        return "The result for "+query+" is: \n"+graph

    end

    def _progressBar percent

        graph = ""

        i = 0
        while i < percent/10
            graph += "="
            i += 1
        end 

        space = 0
        while space < (10-i)
            graph += " "
            space += 1
        end

        if graph.strip == ""
            graph += "__________"
        end

        return "`"+graph+"`"

    end

end