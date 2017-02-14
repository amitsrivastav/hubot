Steps to generate Hubot and run it
______________________________________
1.  Install expat library in system
For CentOS
yum install libexpat1-devel 

2.  Install redis to use as Hubot brain
Yum install redis
service redis start
3.  Install NodeJs
wget https://nodejs.org/dist/v7.5.0/node-v7.5.0-linux-x64.tar.xz
tar --strip-components 1 -xvf node-v7.5.0-linux-x64.tar.xz -C /usr/local

4.  Install Coffeescript, yo generator-hubot
npm install -g coffeescript
npm install -g yo generator-hubot

5.  Create user to run Hubot 
adduser amit
6.  Switch to new user 
su – amit
7.  Create a directory to generate hubot 
Mkdir myhubot
8.  Create hubot with Hipchat plugin
yo hubot 
9.  Install hubot-hipchat and hubot-elasticsearch 
Npm install hubot-hipchat –save
Npm install hubot-elasticsearch –save
____________________________________________________________
Once the installation is complete create a script to export the valiable
required to start with its adoptor

#!/bin/bash
#Hipchat user information from account settings
export HUBOT_HIPCHAT_JID="***********"
export HUBOT_HIPCHAT_PASSWORD="**********"
#it will work for all room as of now, we can put a single room name as well
export HUBOT_HIPCHAT_ROOMS="$ROOMENAME OR 'All'"
#integration hangout as well here
# https://github.com/hubot-scripts/hubot-google-hangouts
export HUBOT_GOOGLE_HANGOUTS_DOMAIN='PUT YOUR DOMAIN HANGOUT URL HERE'
to export port for http listener
export PORT=8585
now start the hhubot with hipchat adapter
bin/hubot --adapter hipchat -n "RobOt"
__________________________________________________________

