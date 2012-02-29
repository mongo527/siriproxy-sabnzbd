require 'cora'
require 'siri_objects'
require 'open-uri'
require 'json'
require 'net/http'

#############
# This is a plugin for SiriProxy that will allow you to control Sabnzbd.
# Example usage: "pause my downloads"
#############

class SiriProxy::Plugin::Sabnzbd < SiriProxy::Plugin

    def initialize(config)
        @host = config["sab_host"]
        @port = config["sab_port"]
        @api_key = config["sab_api"]
    end
    
    listen_for /pause ((all|my) downloads|saab|sab)/i do
    	begin
    		sab = sabParser("pause")
    		if sab["status"]
    			say "Sabnzbd has paused all downloads", 
    			spoken: "Sab NZBD has paused all downloads"
    		elsif not sab["status"]
    			if sab["error"].downcase == "api key incorrect"
    				say "Sorry, the API Key is incorrect"
    			elsif sab["error"].downcase == "api key required"
    				say "Sorry, API Key was not given in the config file"
    			else
    				say "Sorry, I could not pause Sabnzbd", 
    				spoken: "Sorry, I could not pause Sab NZBD"
    			end
    		end
    	rescue Errno::EHOSTUNREACH
    		say "Sorry, I could not connect to Sabnzbd"
    	rescue Errno::ECONNREFUSED
    		say "Sorry, Sabnzbd is not currently running"
    	rescue Errno::ENETUNREACH
            say "Sorry, Could not connect to the network"
        rescue Errno::ETIMEDOUT
            say "Sorry, The operation timed out"
        end
        request_completed
    end
    
    listen_for /pause downloads for (.+) minutes/i do |time|
    	begin
    		sab = sabParser("config&name=set_pause&value=#{time}")
    		if sab["status"]
    			say "Sabnzbd has paused all downloads for #{time} minutes", 
    			spoken: "Sab NZBD has paused all downloads for #{time} minutes"
    		elsif not sab["status"]
    			if sab["error"].downcase == "api key incorrect"
    				say "Sorry, the API Key is incorrect"
    			elsif sab["error"].downcase == "api key required"
    				say "Sorry, API Key was not given in the config file"
    			else
    				say "Sorry, I could not pause Sabnzbd", 
    				spoken: "Sorry, I could not pause Sab NZBD"
    			end
    		end
    	rescue Errno::EHOSTUNREACH
    		say "Sorry, I could not connect to Sabnzbd"
    	rescue Errno::ECONNREFUSED
    		say "Sorry, Sabnzbd is not currently running"
    	rescue Errno::ENETUNREACH
            say "Sorry, Could not connect to the network"
        rescue Errno::ETIMEDOUT
            say "Sorry, The operation timed out"
        end
        request_completed
    end
    
    listen_for /pause (.+)/i do |response|
    	begin
			queue = sabParser("queue")
			nzb = queue["queue"]["slots"]
			if not nzb.empty?
				for i in nzb
					if /(.*)(#{response})(.*)/.match(i["filename"].downcase)
						nzbName = i["filename"]
						nzbValue = i["nzo_id"]
						success = true;
						break;
					else
						success = false;
					end
				end
			elsif nzb.empty?
				say "There is nothing to pause"
			else
				if queue["error"].downcase == "api key incorrect"
					say "Sorry, the API Key is incorrect"
				elsif queue["error"].downcase == "api key required"
					say "Sorry, API Key was not given in the config file"
				end
			end
					
			if success
				sab = sabParser("queue&name=pause&value=#{nzbValue}")
				if sab["status"]
					say "#{nzbName} has been paused",
					spoken: "#{response} has been paused"
				else
					say "Sorry, #{nzbName} could not be paused",
					spoken: "Sorry, #{response} could not be paused"
				end
			else
				say "Sorry, I could not find #{response} in the queue"
			end
    	rescue Errno::EHOSTUNREACH
    		say "Sorry, I could not connect to Sabnzbd",
    		spoken: "Sorry, I could not connect to Sab NZBD"
    	rescue Errno::ECONNREFUSED
    		say "Sorry, Sabnzbd is not currently running",
    		spoken: "Sorry, Sab NZBD is not currently running"
    	rescue Errno::ENETUNREACH
            say "Sorry, Could not connect to the network"
        rescue Errno::ETIMEDOUT
            say "Sorry, The operation timed out"
		end
	end
    
    listen_for /resume (my downloads|saab|sab)/i do
    	begin
    		sab = sabParser("resume")
    		if sab["status"]
    			say "Sabnzbd has resumed all downloads", 
    			spoken: "Sab NZBD has resumed all downloads"
    		elsif not sab["status"]
    			if sab["error"].downcase == "api key incorrect"
    				say "Sorry, the API Key is incorrect"
    			elsif sab["error"].downcase == "api key required"
    				say "Sorry, API Key was not given in the config file"
    			else
    				say "Sorry, I could not resume Sabnzbd",
    				spoken: "Sorry, I could not resume Sab NZBD"
    			end
    		end
    	rescue Errno::EHOSTUNREACH
    		say "Sorry, I could not connect to Sabnzbd",
    		spoken: "Sorry, I could not connect to Sab NZBD"
    	rescue Errno::ECONNREFUSED
    		say "Sorry, Sabnzbd is not currently running",
    		spoken: "Sorry, Sab NZBD is not currently running"
    	rescue Errno::ENETUNREACH
            say "Sorry, Could not connect to the network"
        rescue Errno::ETIMEDOUT
            say "Sorry, The operation timed out"
        end
        request_completed
    end
    
    listen_for /resume (.+)/i do |response|
    	begin
			queue = sabParser("queue")
			nzb = queue["queue"]["slots"]
			if not nzb.empty?
				for i in nzb
					if /(.*)(#{response})(.*)/.match(i["filename"].downcase) AND i["status"].downcase == "paused"
						nzb = i["filename"]
						nzbValue = i["nzo_id"]
						success = true;
						break;
					else
						success = false;
					end
				end
			elsif nzb.empty?
				say "There is nothing to resume"
			else
				if queue["error"].downcase == "api key incorrect"
					say "Sorry, the API Key is incorrect"
				elsif queue["error"].downcase == "api key required"
					say "Sorry, API Key was not given in the config file"
				end
			end
					
			if success
				sab = sabParser("queue&name=resume&value=#{nzbValue}")
				if sab["status"]
					say "#{nzb} has been resumed",
					spoken: "#{response} has been resumed"
				else
					say "Sorry, #{nzb} could not be resumed",
					spoken: "Sorry, #{response} could not be resumed"
				end
			else
				say "Sorry, I could not find #{response} in the queue"
			end
    	rescue Errno::EHOSTUNREACH
    		say "Sorry, I could not connect to Sabnzbd",
    		spoken: "Sorry, I could not connect to Sab NZBD"
    	rescue Errno::ECONNREFUSED
    		say "Sorry, Sabnzbd is not currently running",
    		spoken: "Sorry, Sab NZBD is not currently running"
    	rescue Errno::ENETUNREACH
            say "Sorry, Could not connect to the network"
        rescue Errno::ETIMEDOUT
            say "Sorry, The operation timed out"
		end
	end
    
    listen_for /(what is|whats) downloading/i do
    	
    	begin
    		sab = sabParser("queue")
			nzb = sab["queue"]["slots"]
    		if not nzb.empty?
				for i in nzb
					say "#{i['filename']} is #{i['percentage']}% done", 
					spoken: ""
				end
				say "The queue will be complete in #{sab['queue']['timeleft']}"
			elsif nzb.empty?
				say "Nothing is currently downloading"
			else
				if sab["error"].downcase == "api key incorrect"
    				say "Sorry, the API Key is incorrect"
    			elsif sab["error"].downcase == "api key required"
    				say "Sorry, API Key was not given in the config file"
    			else
    				say "Sorry, I could not resume Sabnzbd",
    				spoken: "Sorry, I could not resume Sab NZBD"
    			end
			end
		rescue Errno::EHOSTUNREACH
    		say "Sorry, I could not connect to Sabnzbd",
    		spoken: "Sorry, I could not connect to Sab NZBD"
    	rescue Errno::ECONNREFUSED
    		say "Sorry, Sabnzbd is not currently running",
    		spoken: "Sorry, Sab NZBD is not currently running"
    	rescue Errno::ENETUNREACH
            say "Sorry, Could not connect to the network"
        rescue Errno::ETIMEDOUT
            say "Sorry, The operation timed out"
        end
        request_completed
    end
    
    def sabParser(cmd)
        
        url = "http://#{@host}:#{@port}/sabnzbd/api?mode=#{cmd}&output=json&apikey=#{@api_key}"
        resp = Net::HTTP.get_response(URI.parse(url))
        data = resp.body
        
        result = JSON.parse(data)
        
        return result
    end
end