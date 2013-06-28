import json,httplib, os
connection = httplib.HTTPSConnection('api.parse.com', 443)
connection.connect()

abtolutepath = '/Users/MBA2/Desktop/Portfolio/con3'
abtolutepaths = []

for root, dirs, files in os.walk(abtolutepath):
    for f in files:
        abtolutepaths.append(abtolutepath + '/' + f)
       

#print abtolutepaths

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
    file = result.pop(u'name')

    if i < 20:
        raw = True
        
        
    else: raw = False
    
    connection.request('POST', '/1/classes/photos', json.dumps({
           "raw": raw,
           "picture": {
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
