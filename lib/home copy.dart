import 'package:flutter/material.dart';
import 'push_notification_provider.dart';
import 'registro.dart';
import 'evacuacion2.dart';
import 'contactos2.dart';
import 'nosotros.dart';
import 'main.dart';

class Home2 extends StatefulWidget {
  Home2State createState() => Home2State();
}

class Home2State extends State<Home2> {
  int _selectItem = 0;
  var _nameAppBar = Text('Registro de sismos');
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return Registro();
      case 1:
        return Evacuacion();
      case 2:
        return Contactos2();
      case 4:
        return Nosotros();
    }
  }

  _onSelect(int pos) {
    Navigator.of(context).pop();
    setState(() {
      _selectItem = pos;
    });
  }

  _getAppBar(int pos) {
    switch (pos) {
      case 0:
        _nameAppBar = Text('Registro de sismos');
        return _nameAppBar;
      case 1:
        _nameAppBar = Text('Vias de evacuación');
        return _nameAppBar;
      case 2:
        _nameAppBar = Text('Contactos de emergencia');
        return _nameAppBar;
      case 4:
        _nameAppBar = Text('Acerca de nosotros');
        return _nameAppBar;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _getAppBar(_selectItem),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            tooltip: 'Notificaciones',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Ajustes2(),
              ));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('images/sismos_3.jpg'),
                fit: BoxFit.fill,
              )),
              child: Text(
                'Seismic App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
                title: Text('Registro de sismos'),
                subtitle: Text('Para ver mas detalles del sismo solo pulselo'),
                leading: Icon(Icons.list),
                selected: (0 == _selectItem),
                onTap: () {
                  _onSelect(0);
                }),
            ListTile(
                title: Text('Vias de Evacuacion'),
                subtitle: Text(
                    'Aqui podra ver su via de evacuacion mas cercana en caso de estar en zona de tsunami'),
                leading: Icon(Icons.map),
                selected: (1 == _selectItem),
                onTap: () {
                  _onSelect(1);
                }),
            ListTile(
              title: Text('Contactos de Emergencia'),
              subtitle: Text(
                  'Para realizar una llamada de emergencia solo pulse el destinatario'),
              leading: Icon(Icons.call),
              selected: (2 == _selectItem),
              onTap: () {
                _onSelect(2);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Acerca de nosotros'),
              leading: Icon(Icons.account_circle),
              selected: (4 == _selectItem),
              onTap: () {
                _onSelect(4);
              },
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectItem),
    );
  }
}

class Ajustes2 extends StatefulWidget {
  @override
  _Ajustes2State createState() => _Ajustes2State();
}

class _Ajustes2State extends State<Ajustes2> {
  bool _val = SharedPrefs().notificaciones;
  double _currentSliderValue = SharedPrefs().magnitud;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajustes de notificaciones"),
      ),
      body: Column(children: <Widget>[
        Card(
            child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Activar/Desactivar notificaciones",
                style: TextStyle(fontSize: 20),
              ),
              Switch(
                value: _val,
                onChanged: (bool state) {
                  setState(() {
                    _val = state;
                    SharedPrefs().notif(state);
                    if (_val == true) {
                      PushNotificationProvider().fcmUnSubscribeAll();
                      PushNotificationProvider()
                          .fcmSubscribe(_currentSliderValue);
                    } else {
                      PushNotificationProvider().fcmUnSubscribeAll();
                    }
                  });
                  _showDialog2(context);
                },
              ),
            ],
          ),
          height: 100,
        )),
        Card(
            child: Container(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Magnitud minima a notificar",
                style: TextStyle(fontSize: 20),
              ),
              Column(
                children: <Widget>[
                  Slider(
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                        SharedPrefs().magni(value);
                      });
                    },
                    value: _currentSliderValue,
                    min: 0,
                    max: 10,
                    label: _currentSliderValue.toString(),
                    divisions: 20,
                  ),
                  FlatButton(
                    child: Text("Aplicar"),
                    onPressed: () {
                      PushNotificationProvider().fcmUnSubscribeAll();
                      PushNotificationProvider()
                          .fcmSubscribe(_currentSliderValue);
                      _showDialog2(context);
                    },
                  )
                ],
              ),
            ],
          ),
        ))
      ]),
    );
  }

  _showDialog2(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reiniciar la aplicacion'),
            content: Text(
                'Para aplicar los ajustes se debe reiniciar la aplicacion'),
            actions: <Widget>[
              FlatButton(
                child: Text("Aceptar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
