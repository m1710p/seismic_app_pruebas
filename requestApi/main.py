import requests
import json
import pyrebase

import firebase_admin
from firebase_admin import credentials, messaging
# SDK ADMIN
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)

# PUSH MESSAGES
def sendPush(title, msg, dataObject=None):
    # See documentation on defining a message payload.
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=msg
        ),
        topic='Temblores'
    )

    # Send a message to the device corresponding to the provided
    # registration token.
    response = messaging.send(message)
    # Response is a message ID string.
    print('Successfully sent message:', response)

def PushPorTopic(Magnitud,title,msg):
    valor = Magnitud.split()[0]
    magnitud = float(valor)
    Topics = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0]
    for numero in Topics:
        if magnitud >= numero:
            sendPush(title,msg,str(numero))
            print('Mensaje enviado a '+str(numero))
    print('Mensajes enviado(s) Correctamente')



# Configuracion Firebase
#######################################################
config = {
  "apiKey": "apiKey",
  "authDomain": "seismicapp-ab75b.firebaseapp.com",
  "databaseURL": "https://seismicapp-ab75b.firebaseio.com/",
  "storageBucket": "seismicapp-ab75b",
  "serviceAccount": "serviceAccountKey.json"
}

firebase = pyrebase.initialize_app(config)
db = firebase.database()
#######################################################


def jprint(obj):
    text = json.dumps(obj, sort_keys=True, indent=4)
    print(text)


# API usada.
response = requests.get('https://api.gael.cl/general/public/sismos')
#######################################################
databaseTemblor = db.child("temblores").get().val()
apiTemblor = response.json()


compararApi = []
for respuesta in apiTemblor:
    respuesta = dict(sorted(respuesta.items()))
    compararApi.append(respuesta)


compararBase = []
for temblor in databaseTemblor:
    entrada = databaseTemblor[temblor]
    compararBase.append(entrada)


posACambiar = []
pos = 0
for dato1 in compararApi:
    i = 0
    for dato2 in compararBase:
        if dato1['Fecha'] != dato2['Fecha']:
            i += 1
            pass
        else:
            break
    if i != len(compararBase):
        print('Ningun cambio')
    else:
        posACambiar.append(pos)
        print('Entrada nueva encontrada')
        PushPorTopic(dato1['Magnitud'],'Temblor: '+dato1['Magnitud'],'A '+dato1['RefGeografica'])
    pos += 1

if posACambiar != []:
    for x in posACambiar:
        db.child("temblores").push(compararApi[x])
        print('Entradas añadidas con exito')

