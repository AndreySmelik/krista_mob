import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  String pssw;

  MyForm({@required this.pssw});

  @override
  State<StatefulWidget> createState() => MyFormState();
}

class MyFormState extends State<MyForm> {

  TextEditingController textController = TextEditingController();
  String password='';
  @override
  void initState() {
    textController.text=widget.pssw;
    password=widget.pssw;
  }
    Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: new Form(
            child: new Column(
              children: <Widget>[
                new Text(
                  'Пароль',
                  style: TextStyle(fontSize: 20.0),
                ),
                new TextFormField(
                    obscureText: true,
                    controller: textController,
                   onChanged: (value){
                     password=value;
                   },
                ),
                new SizedBox(height: 20.0),
                new RaisedButton(
                  onPressed: () {
                    _sendDataBack(context,password);
                  },
                  child: Text('Подтвердить'),
                  color: Color.fromRGBO(0, 134, 169, 1),
                  textColor: Colors.white,
                ),
              ],
            )));
  }
}

class Password extends StatelessWidget {
  String pssw;

  Password({@required this.pssw});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Пароли'),
      ),
      body: MyForm(pssw: pssw),
    );
  }
}

void _sendDataBack(BuildContext context, text) {
  Navigator.pop(context, text);
}
