
import os


os.system('curl http://localhost:8080/bus/webresources/datastore/ -d "cmd=delete"')
os.system('curl  http://localhost:8080/bus/webresources/buslines -d "busLine=西线班车11号线&seatCount=40&license=京NB001&driver=陈师傅&phone=13800011234"')
