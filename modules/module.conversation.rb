#!/bin/env ruby
# encoding: utf-8

#Very simple Eliza Implementation




class Answer




	def answer
        @reflections = {
            "am"=> "are",
            "was"=> "were",
            "i"=> "you",
            "i'd"=> "you would",
            "i've"=> "you have",
            "i'll"=> "you will",
            "my"=> "your",
            "are"=> "am",
            "you've"=> "I have",
            "you'll"=> "I will",
            "your"=> "my",
            "yours"=> "mine",
            "you"=> "me",
            "me"=> "you"
        }
        
        @psychobabble = {
                /you need (.*)/ => ["Why do you need ${0} ?","are you sure you need ${0} ?"],
                /(.*)/ => ["Tell me more"]
            }
        
		ref = reflect(@message)
        
        
        return analyze(ref)
	end
    
    def analyze(msg)

        @psychobabble.each do |key,val|
            m = msg.scan(key)
            if ! m.empty?
                #found answer
                ans = val.sample
                m = m.flatten
                nbOfInterp = 0

                while ans.include?("${#{nbOfInterp}}") do
                   ans = ans.gsub("${#{nbOfInterp}}", m[nbOfInterp])
                   nbOfInterp += 1
                end   
                
                return ans
            end
            
        end
        
        puts "not found"
    end

	def reflect(msg)
    
        parts = msg.downcase.split(" ")
		parts.each_with_index do |val,i|
		  if @reflections.has_key? val
            parts[i] = @reflections[val] 
          end
		end
        
        return parts.join " "
		
	end

end