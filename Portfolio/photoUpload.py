import json,httplib, os
from collections import deque
connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()

objectIds = deque([])


## going throgh tumbnail file path
abtolutepath = '/Users/MBA2/Desktop/Portfolio/tumbnail'
abtolutepaths = []

for root, dirs, files in os.walk(abtolutepath):
    for f in files:
        abtolutepaths.append(abtolutepath + '/' + f)

## going throgh fullSize file path      
abtolutepathFullSize = '/Users/MBA2/Desktop/Portfolio/fullSize'
abtolutepathFullSizes = []

for root, dirs, files in os.walk(abtolutepathFullSize):
    for f in files:
        abtolutepathFullSizes.append(abtolutepathFullSize + '/' + f)
#print abtolutepaths
##print abtolutepathFullSizes

## uploading tumbnail files
i = 0
raw = False

for photo in abtolutepaths:
    url = '/1/files/pic' + str(i) +'.jpg'
    connection.request('POST', url, open(photo, 'r'), {
       "X-Parse-Application-Id": "bUzh4WAVsJVI2tlaoAbgukS5WjnJe4vbiTd0Z95x",
       "X-Parse-REST-API-Key": "OwlrfzaY3wWbQvgs6ABQw54tai5KghwwGXWop5hN",
       "Content-Type": "image/jpeg"
         })
    result = json.loads(connection.getresponse().read())

    ##print result
    file = result.pop(u'name')

    if i < 20:
        raw = True
        
        
    else: raw = False

## creating photo object with tumbnail file    
    connection.request('POST', '/1/classes/photos', json.dumps({
           "raw": raw,
           "tumbnail": {
             "name": file,
             "__type": "File"
           }
         }), {
           "X-Parse-Application-Id": "bUzh4WAVsJVI2tlaoAbgukS5WjnJe4vbiTd0Z95x",
           "X-Parse-REST-API-Key": "OwlrfzaY3wWbQvgs6ABQw54tai5KghwwGXWop5hN",
           "Content-Type": "application/json"
         })
    result = json.loads(connection.getresponse().read())
    objectIds.append(result.pop(u'objectId'))
                     
    print result

    i+= 1

##uploading fullSize file
i = 0
for fullphoto in abtolutepathFullSizes:
    url = '/1/files/pic' + str(i) +'.jpg'
    connection.request('POST', url, open(fullphoto, 'r'), {
       "X-Parse-Application-Id": "bUzh4WAVsJVI2tlaoAbgukS5WjnJe4vbiTd0Z95x",
       "X-Parse-REST-API-Key": "OwlrfzaY3wWbQvgs6ABQw54tai5KghwwGXWop5hN",
       "Content-Type": "image/jpeg"
         })
    result = json.loads(connection.getresponse().read())

    file = result.pop(u'name')

## adding fullSize file to the already created object 
    url = "/1/classes/photos" + "/" + objectIds.popleft()


    connection.request('PUT', url, json.dumps({
           "fullSize": {
             "name": file,
             "__type": "File"
           }
         }), {
           "X-Parse-Application-Id": "bUzh4WAVsJVI2tlaoAbgukS5WjnJe4vbiTd0Z95x",
           "X-Parse-REST-API-Key": "OwlrfzaY3wWbQvgs6ABQw54tai5KghwwGXWop5hN",
           "Content-Type": "application/json"
         })
    result = json.loads(connection.getresponse().read())

    print result

    i+= 1
