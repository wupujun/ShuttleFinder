import csv
import pycurl
import urllib
import urllib2
import StringIO
import sys

def readCSVasDict (csvfile):

    dicArray=csv.DictReader(open(csvfile,'rU'),delimiter=';')

    return dicArray


def curlPost(url,dic):
   
    crl = pycurl.Curl()
    crl.setopt(pycurl.URL,url)
    crl.setopt(pycurl.VERBOSE,1)
    crl.setopt(pycurl.FOLLOWLOCATION, 1)
    crl.setopt(pycurl.MAXREDIRS, 5)
    #crl.setopt(pycurl.AUTOREFERER,1)
  
    crl.setopt(pycurl.CONNECTTIMEOUT, 60)
    crl.setopt(pycurl.TIMEOUT, 300)
    #crl.setopt(pycurl.PROXY,proxy)
    crl.setopt(pycurl.HTTPPROXYTUNNEL,1)
    #crl.setopt(pycurl.NOSIGNAL, 1)
    crl.fp = StringIO.StringIO()
    #crl.setopt(pycurl.USERAGENT, "dhgu hoho")
  
    # Option -d/--data <data>   HTTP POST data
    crl.setopt(crl.POSTFIELDS,  urllib.urlencode(dic))
    crl.perform()
    return

def urllibPost(url,dic):
    newDic={}
    for fid in dic:
        newDic[fid]=dic[fid].decode('gb18030').encode('utf-8')
                            
    data=urllib.urlencode(newDic)
    req=urllib2.Request(url,data)
    response=urllib2.urlopen(req)
    return

#main entry...

lineCSV='busLines.csv'
stopCSV='busstops.csv'

if len(sys.argv)<2:
    print "Please assign host IP."
    sys.exit(0)

host=sys.argv[1]
url="http://"+host+":8080/bus/webresources/buslines"
#url="http://192.168.0.12:8080/bus/webresources/buslines"

dicArray=readCSVasDict(lineCSV)

for line in dicArray:
    #print line.decode('gb18030')
    urllibPost(url,line)
    req = urllib2.Request(url+'?line='+line['busLine'])
    print req
