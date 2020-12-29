class DocumentTitleModel {
  String command;
  String count;
  String jSON;
  String recordCount;
  RecordSet recordSet;

  DocumentTitleModel({this.command, this.count, this.jSON, this.recordCount, this.recordSet});

  DocumentTitleModel.fromJson(Map<String, dynamic> json) {
    command = json['Command'];
    count = json['Count'];
    jSON = json['JSON'];
    recordCount = json['RecordCount'];
    recordSet = json['RecordSet'] != null ? new RecordSet.fromJson(json['RecordSet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Command'] = this.command;
    data['Count'] = this.count;
    data['JSON'] = this.jSON;
    data['RecordCount'] = this.recordCount;
    if (this.recordSet != null) {
      data['RecordSet'] = this.recordSet.toJson();
    }
    return data;
  }
}

class RecordSet {
  List<String> attributes;
  List<Records> records;

  RecordSet({this.attributes, this.records});

  RecordSet.fromJson(Map<String, dynamic> json) {
    attributes = json['Attributes'].cast<String>();
    if (json['Records'] != null) {
      records = new List<Records>();
      json['Records'].forEach((v) { records.add(new Records.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Attributes'] = this.attributes;
    if (this.records != null) {
      data['Records'] = this.records.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Records {
  String title;
  List<Data> data;

  Records({this.title});

  Records.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    if (json['Data'] != null) {
     data = new List<Data>();
     json['Data'].forEach((v) {
       try{
       data.add(new Data.fromJson(v));
       }catch(exp){
         if (v!=null){
           Data el = new Data();
           el.id = "0";
           el.text = v;
           data.add( el);}
       }});
    }
  }

Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String id;
  String text;

  Data({this.id, this.text});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }

}

