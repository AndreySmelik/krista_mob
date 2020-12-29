class FieldModel {
  String command;
  String jSON;
  String keyFieldName;
  String recordCount;
  List<Fields> fields;

  FieldModel(
      {this.command,
        this.jSON,
        this.keyFieldName,
        this.recordCount,
        this.fields});

  FieldModel.fromJson(Map<String, dynamic> json) {
    command = json['Command'];
    jSON = json['JSON'];
    keyFieldName = json['KeyFieldName'];
    recordCount = json['RecordCount'];
    if (json['Fields'] != null) {
      fields = new List<Fields>();
      json['Fields'].forEach((v) {
        fields.add(new Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Command'] = this.command;
    data['JSON'] = this.jSON;
    data['KeyFieldName'] = this.keyFieldName;
    data['RecordCount'] = this.recordCount;
    if (this.fields != null) {
      data['Fields'] = this.fields.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fields {
  String name;
  String title;
  String type;
  String width;
  String docFieldType;
  String size;
  Values values;
  String alignment;

  Fields(
      {this.name,
        this.title,
        this.type,
        this.width,
        this.docFieldType,
        this.size,
        this.values,
        this.alignment});

  Fields.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    title = json['Title'];
    type = json['Type'];
    width = json['Width'];
    docFieldType = json['DocFieldType'];
    size = json['Size'];
    values =
    json['Values'] != null ? new Values.fromJson(json['Values']) : null;
    alignment = json['Alignment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Title'] = this.title;
    data['Type'] = this.type;
    data['Width'] = this.width;
    data['DocFieldType'] = this.docFieldType;
    data['Size'] = this.size;
    if (this.values != null) {
      data['Values'] = this.values.toJson();
    }
    data['Alignment'] = this.alignment;
    return data;
  }
}

class Values {
  String item0;
  String item1;
  String item2;
  String item3;

  Values({this.item0, this.item1, this.item2, this.item3});

  Values.fromJson(Map<String, dynamic> json) {
    item0 = json['item0'];
    item1 = json['item1'];
    item2 = json['item2'];
    item3 = json['item3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item0'] = this.item0;
    data['item1'] = this.item1;
    data['item2'] = this.item2;
    data['item3'] = this.item3;
    return data;
  }
}