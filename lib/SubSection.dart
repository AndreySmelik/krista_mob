import 'package:flutter/material.dart';
import 'models/StructureModel.dart';
import 'Document.dart';

class SubSection extends StatefulWidget {
  StructureModel structure;
  int j;
  String token;
  String url;
  String server;
  SubSection(
      {Key key,
        @required this.structure,
        @required this.j,
        @required this.token,
        @required this.url,
        @required this.server});

  @override
  State<StatefulWidget> createState() => SubSectionState(structure: structure, j: j,token:token);
}

class SubSectionState extends State<SubSection> {
  StructureModel structure;
  int j;
  String token;

  SubSectionState(
      {Key key, @required this.structure, @required this.j, @required this.token});

  _sendToNextSection(int i, j,bool subSectionFlag) {
    print( token);
    if (structure.sections[j].subSections != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Document(
                  structure: structure,
                  section: j,
                  subSectionFlag: subSectionFlag,
                  subSection: i,
                  url:widget.url,
                  token: token,
                  server:widget.server)));
    }
  } //_sendReques

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(structure.sections[j].name),
      ),
      body: Container(
        child: Scrollbar(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(structure.sections[j].name),
                onTap: () {
                  _sendToNextSection(j, j,false);  //1111-номер для загрузки только секции
                },
                leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 25,
                    minHeight: 25,
                    maxWidth: 25,
                    maxHeight: 25,
                  ),
                  //child: Image.memory(Base64Decoder().convert(_konfig.sections[i].RCDATA== null ? '': _konfig.sections[i].RCDATA)),
                  child:
                  Image.network(
                    'http://'+widget.url+'server~' +
                       structure.sections[j].image,
                  ),
                ),
              ),
              for (int i = 0; i < structure.sections[j].subSections.length; i++)
                ListTile(
                  title: Text(structure.sections[j].subSections[i].name),
                  onTap: () {
                    _sendToNextSection(i, j,true);
                  },
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 25,
                      minHeight: 25,
                      maxWidth: 25,
                      maxHeight: 25,
                    ),
                   // child: Image.memory(Base64Decoder().convert(_konfig.sections[i].RCDATA== null ? '': _konfig.sections[i].RCDATA)),


                    child: Image.network(
                      'http://'+widget.url+'server~' +
                          structure.sections[j].subSections[i].image,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
