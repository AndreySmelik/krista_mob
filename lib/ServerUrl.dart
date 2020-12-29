import 'package:flutter/material.dart';

class ServerLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return _myListView1(context);
  }

}

Widget _myListView1(BuildContext context) {

  return ListView(
    children: <Widget>[
      Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(labelText: "Введите имя сервера"),
                onSubmitted: (text) {
                  _sendDataBack(context, text) ;
                },
              ),
            ],
          )),
      ListTile(
        title: Text('buch.mosreg.ru:8080',style: TextStyle(fontSize:16),),
         onTap: () {
           _sendDataBack(context,'buch.mosreg.ru:8080');
         }
      ),
      ListTile(
        title: Text('stimate.krista.ru:8080'),
          onTap: () {
            _sendDataBack(context,'stimate.krista.ru:8080');
          }
      ),
      ListTile(
        title: Text('win-stim.krista.ru:8080'),
          onTap: () {
            _sendDataBack(context,'win-stim.krista.ru:8080');
          }
      ),
    ],
  );
}

class ServerUrl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Адреса"),
      ),
      body: ServerLayout(),
    );
  }
}

void _sendDataBack(BuildContext context, text ) {

  Navigator.pop(context, text);
}