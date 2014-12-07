import csv
import pycurl
import urllib
import urllib2
import StringIO
import chardet
import sys

def readCSVasDict (csvfile):

    dicArray=csv.DictReader(open(csvfile,'rU'),delimiter=';')

    return dicArray


def urllibPost(url,dic):
    newDic={}
    for fid in dic:
#        print fid
#        coding=chardet.detect(dic[fid])
#        print coding
         newDic[fid]=dic[fid].decode('gb18030').encode('utf-8')
    
    data=urllib.urlencode(newDic)
    req=urllib2.Request(url,data)
    response=urllib2.urlopen(req)
    return

#main entry

lineCSV='busLines.csv'
stopCSV='busstops.csv'

if len(sys.argv)<2:
    print "Please assign host IP."
    sys.exit(0)

host=sys.argv[1]
url="http://"+host+":8080/bus/webresources/stops"



#url="http://192.168.0.12:8080/bus/webresources/stops"
#url="http://192.168.0.12:8080/bus/webresources/stops"

dicArray=readCSVasDict(stopCSV)

for text in dicArray:
    line=text['line']
    #del newLine['line']
    urllibPost(url,text)

    #req = urllib2.Request(url+'?line='+line)
    #print req
