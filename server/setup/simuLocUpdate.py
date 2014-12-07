# -*- coding: utf-8 -*-
import urllib
import urllib2
import sys
import time

def postPostion(url,postion):
    data=urllib.urlencode(postion)
    req=urllib2.Request(url,data)
    response=urllib2.urlopen(req)
    return


#main
if len(sys.argv)<2:
    print 'Format: '+sys.argv[0]+' 10 -- do simulation for 10 minutes'
    sys.exit(0)

duration=float(sys.argv[1])
steps=duration*60*2

startLong=116.192431
startLat=39.914004

endLong=116.302869
endLat=40.054841
url='http://trserver1:8080/bus/webresources/locations'

i=0
while(i<steps):
    time.sleep(0.5)
    curTime=time.strftime('%Y-%m-%d %H:%M:%s',time.localtime(time.time()))
    i=i+1
    stepLong=(endLong-startLong)/steps
    stepLat=(endLat-startLat)/steps
    lat=startLat+i*stepLat
    lon=startLong+i*stepLong
    position={'latitude':lat,'longitude':lon,'altitude':0.0,'userID':'user1','line':"西线4号线",'time':curTime}
    print('update location('+str(i)+'/'+str(steps)+')')
    print(position)
    postPostion(url,position)
    
