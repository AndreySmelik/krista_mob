import 'package:flutter/material.dart';
import 'FirstScreen.dart';
import 'models/StructureModel.dart';
import 'DocTitle.dart';

class Document extends StatefulWidget {
  StructureModel structure;
  int section;
  int subSection;
  String token;
  String url;
  bool subSectionFlag;
  String server;
  Document({
    Key key,
    @required this.structure,
    @required this.section,
    @required this.subSection,
    @required this.token,
    @required this.url,
    @required this.subSectionFlag,
    @required this.server,
  });

  @override
  State<StatefulWidget> createState() => DocumentState();
}

class DataDoc {
  String name;
  String docCfgID;

  DataDoc({this.name, this.docCfgID});
}

class DocumentState extends State<Document> {
  bool _isButtonDisabled = false;
  bool reportsFlag = false;
  List<DataDoc> doc = [];
  List<DataDoc> reports = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {

    if (widget.subSectionFlag) {
      if (widget.structure.sections[widget.section].subSections[widget.subSection].documents != null) {
        for (int i = 0; i < widget.structure.sections[widget.section].subSections[widget.subSection].documents.length; i++) {
          DataDoc el = new DataDoc(
              name: widget.structure.sections[widget.section].subSections[widget.subSection].documents[i].name,
              docCfgID: widget.structure.sections[widget.section].subSections[widget.subSection].documents[i].docCfgID);
          print('elem' + el.name + el.docCfgID);
          doc.add(el);
        }
      }
      if (widget.structure.sections[widget.section].subSections[widget.subSection].reports != null) {
        for (int i = 0; i < widget.structure.sections[widget.section].subSections[widget.subSection].reports.length; i++) {
          DataDoc el = new DataDoc(
              name: widget.structure.sections[widget.section].subSections[widget.subSection].reports[i].name,
              docCfgID: widget.structure.sections[widget.section].subSections[widget.subSection].reports[i].iD);
          print('elem' + el.name + el.docCfgID);
          reports.add(el);
        }
        if  (widget.structure.sections[widget.section].subSections[widget.subSection].reports.length !=0) reportsFlag=true;
      }
    } else {
      if (widget.structure.sections[widget.section].documents != null) {
        for (int i = 0; i < widget.structure.sections[widget.section].documents.length; i++) {
          DataDoc el = new DataDoc(name: widget.structure.sections[widget.section].documents[i].name, docCfgID: widget.structure.sections[widget.section].documents[i].docCfgID);
          print('elem' + el.name + el.docCfgID);
          doc.add(el);
        }
      }

      if (widget.structure.sections[widget.section].reports != null) {
        for (int i = 0; i < widget.structure.sections[widget.section].reports.length; i++) {
          DataDoc el = new DataDoc(name: widget.structure.sections[widget.section].reports[i].name, docCfgID: widget.structure.sections[widget.section].reports[i].iD);
          print('elem' + el.name + el.docCfgID);
          reports.add(el);
        }
        if  (widget.structure.sections[widget.section].reports.length !=0) reportsFlag=true;
      }
    }
  }

  _sendToNextSection(int i) {
    print(widget.section);
    print(widget.structure.sections[widget.section].documents.length);
    print('section' + widget.structure.sections[widget.section].documents[i].docCfgID);
    print(widget.url);
    if (widget.structure.sections[i] != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DocTitle(
                    url: widget.url,
                    structure: widget.structure,
                    docCfgID: widget.structure.sections[widget.section].documents[i].docCfgID,
                    sectionId: widget.structure.sections[widget.section].iD,
                    token: widget.token,
                    sectionFlag: false,
                    sectionIndex: widget.section,
                    docIndex: i,
                    server:widget.server,
                  )));
    }
  } //_sendReques

  _sendToNextSubSection(int i) {
    if (widget.structure.sections[widget.section].subSections[i] != null) {
      print(widget.section);
      print(widget.structure.sections[widget.section].documents.length);
      print("docCfg" + widget.structure.sections[widget.section].subSections[widget.subSection].documents[i].docCfgID);
      print(widget.structure.sections[widget.section].subSections[widget.subSection].iD);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DocTitle(
                    url: widget.url,
                    structure: widget.structure,
                    docCfgID: widget.structure.sections[widget.section].subSections[widget.subSection].documents[i].docCfgID,
                    sectionId: widget.structure.sections[widget.section].subSections[widget.subSection].iD,
                    token: widget.token,
                    sectionFlag: true,
                    sectionIndex: widget.section,
                    subSectionIndex: widget.subSection,
                    docIndex: i,
                    server:widget.server,
                  )));
    }
  }

  _buildList() {
    return Container(
      child: Scrollbar(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if(reportsFlag)
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    onPressed: !_isButtonDisabled
                        ? null
                        : () {
                            setState(() => _isButtonDisabled = !_isButtonDisabled);
                          },
                    textColor: Colors.black,
                    color: Color.fromRGBO(0, 134, 169, 1),
                    disabledColor: Colors.white,
                    disabledTextColor: Colors.black,
                    highlightColor: Color.fromRGBO(0, 134, 169, 1),
                    child: Text('Документы'),
                    padding: EdgeInsets.all(17.0),
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    onPressed: _isButtonDisabled
                        ? null
                        : () {
                            setState(() => _isButtonDisabled = !_isButtonDisabled);
                          },
                    textColor: Colors.black,
                    color: Color.fromRGBO(0, 134, 169, 1),
                    disabledColor: Colors.white,
                    disabledTextColor: Colors.black,
                    highlightColor: Color.fromRGBO(0, 134, 169, 1),
                    child: Text('Отчеты'),
                    padding: EdgeInsets.all(17.0),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _isButtonDisabled ? reports.length : doc.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          _isButtonDisabled ? reports[index].name : doc[index].name,
                          style: TextStyle(fontSize: 16),
                        ),
                        //subtitle: Text(_isButtonDisabled ? reports[index].docCfgID : doc[index].docCfgID),
                        onTap: () {
                          widget.subSectionFlag ? _sendToNextSubSection(index) : _sendToNextSection(index);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.structure.sections[widget.section].name)), body: Container(child: _buildList()));
  }
}
