import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/StructureModel.dart';
import 'models/DocumentTitleModel.dart';
import 'dart:convert';
import 'models/SearchTitleListModel.dart';
import 'package:http/http.dart' as http;
import 'models/FieldModel.dart';

class FullCardDocument extends StatefulWidget {
  StructureModel structure;
  Records records;
  List<String> attrArray;
  Details details;
  String docCfgID;
  String token;
  String sectionId;
  String url;
  int  sectionIndex;
  SearchTitleListModel atributs;
  var columnToAttr = Map();
  int subSectionIndex;
  bool sectionFlag;
  int docIndex;
  String titleBar='';
  String server;

  FullCardDocument({
    @required this.structure,
    @required this.records,
    @required this.attrArray,
    @required this.details,
    @required this.docCfgID,
    @required this.token,
    @required this.sectionId,
    @required this.url,
    @required this.columnToAttr,
    @required this.atributs,
    @required this.sectionIndex,
    @required this.sectionFlag,
    @required this.subSectionIndex,
    @required this.docIndex,
    @required this.server,
  });

  @override
  State<StatefulWidget> createState() => FullCardDocumentState();
}

class ItemDocument{
  String docCfgID;
  String caption;
  String name;
  String textField;
  String imageFields;
  int deep;
  ItemDocument(this.docCfgID, this.caption,this.name, this.textField, this.imageFields,this.deep);

}

class FullCardDocumentState extends State<FullCardDocument> {
  String result = '';
  String recordMax;
  String recordNum;
  double textSize = 16;
  double textWidth = 150;
  double textHeight = 40;
  var textCardFlag = Map();
  List<List<int>> notesNumber= List.generate(50, (i) => List.generate (200 ,(i)=>0) );
  List<int> zeroOneArray= List.generate(500, (i)=>0 );
  List<List<String>> timeArray= List.generate(500, (i) =>  List.generate(500, (i)=>'▼ ' ));
  List<List<String>> dataArray= List.generate(50, (i) =>  List.generate(500, (i)=>'' ));
  List<List<SearchTitleListModel>> searchTitleList= List.generate(50, (i) =>new List<SearchTitleListModel>(500));
  List<List<DocumentTitleModel>> documentTitle=  List.generate(50, (i) =>new List<DocumentTitleModel>(500));
  List<int> loadFlag = List.generate(1000, (i) =>0);
  List<ItemDocument> detItems =[];
  List<List<int>> columnToAttr= List.generate(50, (i) => List.generate (200 ,(i)=>0) );
  List<String> attrArrayTable = [];
  List<String> notesArray=[];
  List<List<bool>> hide =List.generate(50, (i) => List.generate(1000, (i) =>false));
  List<List<bool>> hideNotes =List.generate(50, (i) => List.generate(1000, (i) =>true));
  List<List<bool>> hideNotesTable =List.generate(50, (i) => List.generate(1000, (i) =>false));
  DateTime formatDate = DateTime.now();
  List<String> textData =  List.generate(500, (i) =>'');
  List<int> docLength= List.generate(1000, (i) =>1);
  List<int> parentIndex= List.generate(500, (i) =>0);
  List<String> cardData = new List<String>();
  var cardImg = List.generate(50, (i) => List.generate(1, (j) => ''));
  String img = '';
  int tableLength = 0;


  @override
  void initState() {
    super.initState();
    for(int j=0;j<50;j++) {
      for (int i = 1; i < 500; i += 2) {
        hideNotes[j][i] = false;
      }
    }
    appBarInit();
    dataLoad();
  }

  @override
  void dispose() {
    documentTitle.clear();
    searchTitleList.clear();
    loadFlag.clear();
    super.dispose();
  }

  void appBarInit(){
    if(widget.docIndex!=null)
      widget.titleBar= widget.sectionFlag ? widget.structure.sections[widget.sectionIndex].subSections[widget.subSectionIndex].documents[widget.docIndex].name :
      widget.structure.sections[widget.sectionIndex].documents[widget.docIndex].name;
    else widget.titleBar= widget.sectionFlag ? widget.structure.sections[widget.sectionIndex].subSections[widget.subSectionIndex].name :
    widget.structure.sections[widget.sectionIndex].name;
  }

  getDocumentLayout(int tabNumber,int deepIndex, String parentID) async {
    Map<String, String> header1 = {
      "LicGUID": widget.token,
      "Content-Type": "application/json",
      "DocCfgID": detItems[tabNumber].docCfgID,
      "SectionID": widget.sectionId,
      "MasterID": parentID,
      "GridState": "1",
    };

    if (widget.server!=''){
      header1.addAll({ "StimWebSrv": widget.server });
    }
    var response = await http.get('http://' + widget.url + '/mobile~documents/GetDocumentLayout', headers: header1);
    print('http://' + widget.url + '/mobile~documents/GetDocumentLayout');
    print(header1);
    print(response.body);

    searchTitleList[tabNumber][deepIndex] = SearchTitleListModel.fromJson(json.decode(response.body));

    for (int i = 1; i < searchTitleList[tabNumber][deepIndex].columns.length; i++) {
      if (searchTitleList[tabNumber][deepIndex].columns[i].deep == null) searchTitleList[tabNumber][deepIndex].columns[i].deep = '0';
      if (searchTitleList[tabNumber][deepIndex].columns[i].deep == '0') hide[tabNumber][i] = true;
    }

    // if (this.mounted) {
    // setState(() {});
    // }
  }

  handleDocument(int tabNumber,int deepIndex, String parentID) async {
    FieldModel field;

    print(widget.token);

    Map<String, String> header = {
      "LicGUID": widget.token,
      "Content-Type": "application/json",
      "DocCfgID": detItems[tabNumber].docCfgID,
      "SectionID": widget.sectionId,
      "ParentID": parentID
    };

    if (widget.server!=''){
      header.addAll({ "StimWebSrv": widget.server });
    }
    var msg = jsonEncode({"Command": "GetFields"});
    var msgRef = jsonEncode({"Command": "Refresh"});
    print('http://' + widget.url + '/mobile~documents/HandleDocument');
    print(header);
    print(msg);
    var responseRef = await http.post('http://' + widget.url + '/mobile~documents/HandleDocument', headers: header, body: msgRef);
    var response = await http.post('http://' + widget.url + '/mobile~documents/HandleDocument', headers: header, body: msg);
    field = FieldModel.fromJson(json.decode(response.body));
    print(response.body);
    if (field.recordCount != null) {
      recordMax = field.recordCount;
      recordNum = field.recordCount;

      print('max' + recordMax);
      var msg1 = jsonEncode({"Command": "GetRecords", "Count": recordNum});
      var response1 = await http.post('http://' + widget.url + '/mobile~documents/HandleDocument', headers: header, body: msg1);
      print("handle RESPONSE  "+response1.body);

      documentTitle[tabNumber][deepIndex] = DocumentTitleModel.fromJson(json.decode(response1.body));


      for (int i = 0; i < documentTitle[tabNumber][deepIndex].recordSet.attributes.length; i++) {
        attrArrayTable.add(documentTitle[tabNumber][deepIndex].recordSet.attributes[i]);
      }
      for (int i = 1; i < searchTitleList[tabNumber][deepIndex].columns.length; i++) {
        columnToAttr[tabNumber][i] = attrArrayTable.indexOf(searchTitleList[tabNumber][deepIndex].columns[i].fieldName);
      }
      for (int i = 0; i < documentTitle[tabNumber][deepIndex].recordSet.records.length;i++) {
        if(attrArrayTable.indexOf('UsedDate')!=-1&&attrArrayTable.indexOf('Notes')!=-1) {
          if(timeArray[tabNumber][i]=='▼ ')
            timeArray[tabNumber][i] = timeArray[tabNumber][i] + documentTitle[tabNumber][deepIndex].recordSet.records[i].data[attrArrayTable.indexOf('UsedDate')].text;
          dataArray[tabNumber][i] = documentTitle[tabNumber][deepIndex].recordSet.records[i].data[attrArrayTable.indexOf('Notes')].text;
        } else if(attrArrayTable.indexOf('UsedDate')!=-1&&attrArrayTable.indexOf('Opisanie')!=-1) {
          if(timeArray[tabNumber][i]=='▼ ')
            timeArray[tabNumber][i] = timeArray[tabNumber][i] + documentTitle[tabNumber][deepIndex].recordSet.records[i].data[attrArrayTable.indexOf('UsedDate')].text;
          dataArray[tabNumber][i] = documentTitle[tabNumber][deepIndex].recordSet.records[i].data[attrArrayTable.indexOf('Opisanie')].text;
        }

      }
      attrArrayTable.clear();
    } else {
      print('00000000000000000000');
    }
    // if (this.mounted) {
    //  setState(() {});
    // }
  }


  loadTable(int tabNumber) async {
    int parentIn=tabNumber;
    if(detItems[parentIn].deep==1) {
      while(parentIn!=0&&detItems[parentIn].deep==1)
        parentIn--;

      parentIndex[tabNumber]=parentIn;

      for (int i=0;i<documentTitle[parentIn][0].recordSet.records.length;i++){
        await getDocumentLayout(tabNumber, i,documentTitle[parentIn][0].recordSet.records[i].data[0].text);
        await handleDocument(tabNumber, i,documentTitle[parentIn][0].recordSet.records[i].data[0].text);


      }
      for (int i=0;i<documentTitle[parentIn][0].recordSet.records.length;i++)
        timeArray[tabNumber][i]=timeArray[parentIn][i];
      docLength[tabNumber] = 1;
      loadFlag[tabNumber] = 5;
    }
    else{
      await getDocumentLayout(tabNumber,0,widget.records.data[0].text);
      await handleDocument(tabNumber,0,widget.records.data[0].text);
      if (documentTitle[tabNumber][0]!=null)
        docLength[tabNumber]=documentTitle[tabNumber][0].recordSet.records.length;
      else docLength[tabNumber]=0;
      loadFlag[tabNumber] = 2;
    }
  }

  htmlConvert(int tabNumber) {
    String buf='';
    textData[tabNumber] = widget.records.data[widget.attrArray.indexOf(textCardFlag[tabNumber].toString())].text;
    if (widget.attrArray.indexOf(textCardFlag[tabNumber].toString()+'_HTML')!=-1) {
      try {
        buf = widget.records.data[widget.attrArray.indexOf(textCardFlag[tabNumber].toString() + '_HTML')].text;
        if ((buf != '') && (buf.indexOf('Content-Transfer-Encoding: base64') != -1)) {
          img = buf;
          img = img.replaceAll(new RegExp('\r\n'), '');
          img += 'Content-Transfer-Encoding: base64';
          img = img.substring(img.indexOf('Content-Transfer-Encoding: base64') + 33, img.length);
          img = img.substring(img.indexOf('Content-Transfer-Encoding: base64') + 33, img.length);
          while (img.length > 42) {
            cardImg[tabNumber].add(img.substring(0, img.indexOf('------=_BOUNDARY_LINE_')));
            img = img.substring(img.indexOf('Content-Transfer-Encoding: base64') + 33, img.length);
          }
        }
        loadFlag[tabNumber] = 3;
      }
      catch(_){
        loadFlag[tabNumber] = 1;
        docLength[tabNumber] = 1;
      }
    }
    else  loadFlag[tabNumber] = 1;
    docLength[tabNumber] = 1;
  }

  void dataLoad() async {
    for (int i = 0; i < widget.details.items.length; i++){
      detItems.add(new ItemDocument(
        widget.details.items[i].docCfgID,
        widget.details.items[i].caption,
        widget.details.items[i].name,
        widget.details.items[i].textField,
        widget.details.items[i].imageFields,
        0,
      ));
      if(widget.details.items[i].itemsNext!=null){
        for (int j = 0; j < widget.details.items[i].itemsNext.length; j++){
          detItems.add(new ItemDocument(
              widget.details.items[i].itemsNext[j].docCfgID,
              widget.details.items[i].itemsNext[j].caption,
              widget.details.items[i].itemsNext[j].name,
              widget.details.items[i].itemsNext[j].textField,
              widget.details.items[i].itemsNext[j].imageFields,
              1
          ));
        }
      }
    }
    for (int i = 0; i < detItems.length; i++) {
      if ((detItems[i].textField != null) && (detItems[i].textField[0] != '{'))
        textCardFlag[i] = detItems[i].textField;
      else
        textCardFlag[i] = '';
    }


    for (int i = 0; i <  detItems.length; i++){
      if (textCardFlag[i]==''){
        await loadTable(i);
        if( documentTitle[i][0]==null)
          loadFlag[i] = 6;
      }
      else  if (detItems[i].deep==0){
        htmlConvert(i);
      }
      else{
        int parentIn=i;
        while(parentIn!=0&&detItems[parentIn].deep==1)
          parentIn--;
        parentIndex[i]=parentIn;
        if( documentTitle[parentIn][0]!=null)
          loadFlag[i] = 4;
        else
          loadFlag[i] = 6;
      }
    }



    /*if (detItems[i].deep==0){
        if (textCardFlag[i]==''){
          await loadTable(i);
          if( documentTitle[i][0]==null)
            loadFlag[i] = 6;
        }
        else{
          htmlConvert(i);
        }
      } else{
        if (textCardFlag[i]==''){
          await loadTable(i);
          if( documentTitle[i][0]==null)
            loadFlag[i] = 6;
        }
        else{
          int parentIn=i;
          while(parentIn!=0&&detItems[parentIn].deep==1)
            parentIn--;
          parentIndex[i]=parentIn;
         if( documentTitle[parentIn][0]!=null)
          loadFlag[i] = 4;
         else
           loadFlag[i] = 6;
        }
      }*/

    if (this.mounted) {
      setState(() {});
    }
    int a=576;
  }

  rollUpList(int tabNumber,int parentIndex, int number) {
    if (number%2==0) {
      if(hideNotes[tabNumber][(number + 1)]) {
        hideNotes[tabNumber][(number + 1)] = false;
        timeArray[parentIndex][number~/2]= '▼'+ timeArray[parentIndex][number~/2].substring(1);
      }
      else  {
        hideNotes[tabNumber][(number + 1)] = true;
        timeArray[parentIndex][number ~/ 2] = '▶' + timeArray[parentIndex][number ~/ 2].substring(1);
      }
    }
  }

  rollUpListTable(int tabNumber,int parentIndex, int number) {
    if (true) {
      if(hideNotesTable[tabNumber][(number )]) {
        hideNotesTable[tabNumber][(number )] = false;
        timeArray[tabNumber][number]= '▼'+ timeArray[tabNumber][number].substring(1);
      }
      else  {
        hideNotesTable[tabNumber][(number )] = true;
        timeArray[tabNumber][number ] = '▶' + timeArray[tabNumber][number ].substring(1);
      }
    }
  }


  _buildList() {
    return Container(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        bottom: 15,
      ),
      child: Column(
        children: [
          DefaultTabController(
            length:  detItems.length,
            child: Expanded(
              child: Column(children: <Widget>[
                Container(
                  constraints: BoxConstraints.expand(height: 50),
                  child: TabBar(indicatorColor: Colors.grey,
                      labelColor: Colors.black,
                      isScrollable: true,
                      tabs: [
                        for (int i = 0; i <  detItems.length; i++)
                          Tab(text:  detItems[i].name),
                      ]),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(children: [
                      for (int tabNumber = 0; tabNumber < detItems.length; tabNumber++)
                        Scrollbar(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: docLength[tabNumber],
                            itemBuilder: (context, recNumber) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  if(loadFlag[tabNumber]==0)  //load data
                                    Column(
                                        children: <Widget>[
                                          SizedBox(height:250),
                                          Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ]
                                    ),
                                  if (loadFlag[tabNumber]==1)  //only text data
                                    Container(
                                      child: Text(textData[tabNumber]),
                                    ),
                                  if (loadFlag[tabNumber]==2)  //list of table
                                    Container(
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          for(int lineNumber=0;lineNumber<searchTitleList[tabNumber][0].columns.length;lineNumber++)
                                            if (hide[tabNumber][lineNumber])
                                              Container(
                                                padding: EdgeInsets.only(left: 0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Text(
                                                          searchTitleList[tabNumber][0].columns[lineNumber].title,
                                                          style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w500),
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            //  rollUpList(index, searchTitleList[index].columns[j].deep);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Text(documentTitle[tabNumber][0].recordSet.records[recNumber].data[columnToAttr[tabNumber][lineNumber]].text,
                                                            style: TextStyle(fontSize: textSize, color: Colors.black54),
                                                            overflow: TextOverflow.ellipsis,
                                                            textAlign: TextAlign.right,
                                                            maxLines: 2),
                                                        onTap: () {},
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          //SizedBox( height: 30),
                                          if(recNumber!=docLength[tabNumber] && loadFlag[tabNumber]!=0)
                                            Divider(
                                                thickness:3,
                                                color: Color.fromRGBO(0,134,169,1)
                                            )
                                        ],
                                      ),
                                    ),
                                  if (loadFlag[tabNumber]==3) //HTML data
                                    Container(
                                      child:  Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Container(
                                              child: Text(textData[tabNumber]),
                                            ),
                                            for (int imgNumber=1;imgNumber<cardImg[tabNumber].length;imgNumber++)
                                              Container(
                                                  child:Column(children: <Widget>[
                                                    Image.memory(base64Decode(cardImg[tabNumber][imgNumber])),
                                                    SizedBox(height: 20),
                                                  ])
                                              ),
                                          ]
                                      ),
                                    ), //for (int i=0;i<documentTitle.recordSet.records.length;i++)
                                  if (loadFlag[tabNumber]==4)  //List of Notes
                                    Container(
                                      padding: EdgeInsets.only(left:0 , right: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          for(int stringNumber=0;stringNumber<documentTitle[parentIndex[tabNumber]][0].recordSet.records.length*2;stringNumber++)
                                            if (hideNotes[tabNumber][stringNumber])
                                              Container(
                                                padding: EdgeInsets.only(left:  stringNumber%2==1 ? 20.0 : 0.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(child:
                                                    ListTile(
                                                      title: Text(
                                                        stringNumber%2==1 ? dataArray[parentIndex[tabNumber]][stringNumber~/2] : timeArray[parentIndex[tabNumber]][stringNumber~/2],
                                                        style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w400),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          rollUpList(tabNumber,parentIndex[tabNumber], stringNumber);
                                                        });
                                                      },
                                                    ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  if (loadFlag[tabNumber]==5)  //List of Notes
                                    Container(
                                      padding: EdgeInsets.only(left:0 , right: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          for(int blockNumber=0;blockNumber<documentTitle[parentIndex[tabNumber]][0].recordSet.records.length;blockNumber++)
                                            Container(
                                              padding: EdgeInsets.only(left:  0.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    child:ListTile(
                                                      title: Text(
                                                        timeArray[tabNumber][blockNumber],
                                                        style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w400),
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          rollUpListTable(tabNumber,tabNumber, blockNumber);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  for(int notes=0;notes<documentTitle[tabNumber][blockNumber].recordSet.records.length;notes++)
                                                    if (hideNotesTable[tabNumber][blockNumber])
                                                      Container(
                                                        padding: EdgeInsets.only(left: 5, right: 5),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: <Widget>[
                                                            for(int lineNumber=0;lineNumber<searchTitleList[tabNumber][blockNumber].columns.length;lineNumber++)
                                                              if (hide[tabNumber][lineNumber])
                                                                Container(
                                                                  padding: EdgeInsets.only(left: 0),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <Widget>[
                                                                      Expanded(
                                                                        child: ListTile(
                                                                          title: Text(
                                                                            searchTitleList[tabNumber][blockNumber].columns[lineNumber].title,
                                                                            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w500),
                                                                          ),
                                                                          onTap: () {
                                                                            setState(() {
                                                                              //  rollUpList(index, searchTitleList[index].columns[j].deep);
                                                                            });
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: ListTile(
                                                                          title: Text(documentTitle[tabNumber][blockNumber].recordSet.records[notes].data[columnToAttr[tabNumber][lineNumber]].text,
                                                                              style: TextStyle(fontSize: textSize, color: Colors.black54),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.right,
                                                                              maxLines: 2),
                                                                          onTap: () {},
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                            //SizedBox( height: 30),
                                                            if(recNumber!=docLength[tabNumber]&&loadFlag[tabNumber]!=0)
                                                              Divider(
                                                                  thickness:3,
                                                                  color: Color.fromRGBO(0,134,169,1)
                                                              )
                                                          ],
                                                        ),
                                                      ),

                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  if (loadFlag[tabNumber]==6)  //only text data
                                    Container(
                                      child: Text(''),
                                    ),
                                  /*   for(int a=0;a<documentTitle[i-1].recordSet.records.length;a++)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                     Container(
                                       child: Text(documentTitle[i-1].recordSet.records[a].data[10].text),
                                     ),
                                     Divider(
                                      thickness:3,
                                      color: Color.fromRGBO(0,134,169,1)
                                       )
                                     ]
                                   ),*/
                                ],
                              );
                            },
                          ),
                        )
                    ]),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex:65,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(widget.titleBar,
                      style: TextStyle(fontSize: 18),)),
              ),
              Expanded(
                  flex: 35,
                  child:  Container(
                      alignment: Alignment.center,
                      child: Text(widget.records.data[4].text ,
                        style: TextStyle(fontSize: 16),))
              ),
            ],
          ),
        ),
        body: _buildList());
  }
}
