import csv
import pycurl



for line in csv.DictReader(open("busLines1.csv",'rb')):
    print line.decode('gb18030')
