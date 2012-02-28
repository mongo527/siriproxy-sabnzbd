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
    
    listen_for /pause (my downloads|saab|sab)/i do
    	begin
    		sab = sabParser("pause")
    		if sab["status"]
    			say "Sabnzbd has paused all downloads"
    		elsif not sab["status"]
    			if sab["error"].downcase == "api key incorrect"
    				say "Sorry, the API Key is incorrect"
    			elsif sab["error"].downcase == "api key required"
    				say "Sorry, API Key was not given in the config file"
    			else
    				say "Sorry, I could not pause Sab"
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
    
    listen_for /resume (my downloads|saab|sab)/i do
    	begin
    		sab = sabParser("resume")
    		if sab["status"]
    			say "Sabnzbd has resumed all downloads"
    		elsif not sab["status"]
    			if sab["error"].downcase == "api key incorrect"
    				say "Sorry, the API Key is incorrect"
    			elsif sab["error"].downcase == "api key required"
    				say "Sorry, API Key was not given in the config file"
    			else
    				say "Sorry, I could not resume Sab"
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
    
    def sabParser(cmd)
        
        url = "http://#{@host}:#{@port}/sabnzbd/api?mode=#{cmd}&output=json&apikey=#{@api_key}"
        resp = Net::HTTP.get_response(URI.parse(url))
        data = resp.body
        
        result = JSON.parse(data)
        
        return result
    end
end