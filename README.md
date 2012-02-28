SiriProxy-Sabnzbd
==

About
--

Allows you to control [Sabnzbd](http://sabnzbdd.org) with Siri!

Installation
--

1. Add the following to ~./siriproxy/config.yml

  - name: 'Sabnzbd'
      git: 'git://github.com/mongo527/siriproxy-sabnzbd.git'
      sab_host: '127.0.0.1' # IP of Sabnzbd
      sab_port: '8080' # Port Sabnzbd runs on
      sab_api: '' # Sabnzbd API Key, found at Config > General

2. Change options that need to be changed in config.yml.

3. Run the bundler
	- $ siriproxy bundle

4. Start SiriProxy using 
	- $ rvmsudo siriproxy server

5. To update:
	- $ siriproxy update

Voice Commands
--

+ pause my downloads
+ pause my downloads for *min* minutes
+ resume my downloads
+ what is downloading OR whats downloading

Notes
--

This is the first time I used Ruby. I figured it would be a decent way to learn the language. So help me where you can! 

Thanks!

Credits
--

Thanks to [Plamoni](https://github.com/plamoni/SiriProxy) and [Westbaer](https://github.com/westbaer/SiriProxy) for SiriProxy.

Thanks to the Sabnzbd team for Sabnzbd.

You are free to use, modify, and redistribute the SiriProxy-Sabnzbd gem as long as proper credit is given to.