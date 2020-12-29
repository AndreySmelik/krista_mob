class SearchTitleListModel {
  String hasStatus;
  String sequence;
  String name;
  String rights;
  String colorField;
  String styleField;
  String imageFields;
  Params params;
  List<Columns> columns;
  Details details;
  Tools tools;
  SearchTitleListModel(
      {this.hasStatus,
        this.sequence,
        this.name,
        this.rights,
        this.colorField,
        this.styleField,
        this.imageFields,
        this.params,
        this.tools});

  SearchTitleListModel.fromJson(Map<String, dynamic> json) {
    hasStatus = json['HasStatus'];
    sequence = json['Sequence'];
    name = json['Name'];
    rights = json['Rights'];
    colorField = json['ColorField'];
    styleField = json['StyleField'];
    imageFields = json['ImageFields'];
    params =
    json['Params'] != null ? new Params.fromJson(json['Params']) : null;
    details =
    json['Details'] != null ? new Details.fromJson(json['Details']) : null;
    if (json['Columns'] != null) {
      columns = new List<Columns>();
      json['Columns'].forEach((v) { columns.add(new Columns.fromJson(v)); });
    }
    tools =  json['Tools'] != null ? new Tools.fromJson(json['Tools']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HasStatus'] = this.hasStatus;
    data['Sequence'] = this.sequence;
    data['Name'] = this.name;
    data['Rights'] = this.rights;
    data['ColorField'] = this.colorField;
    data['StyleField'] = this.styleField;
    data['ImageFields'] = this.imageFields;
    if (this.params != null) {
      data['Params'] = this.params.toJson();
    }
    if (this.details != null) {
      data['Details'] = this.details.toJson();
    }
    if (this.columns != null) {
      data['Columns'] = this.columns.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Columns {
  String jSONType;
  String title;
  String dataType;
  String fieldName;
  String iD;
  String options;
  String textAjust;
  String width;
  String editStyle;
  String module;
  String deep;
  String titleAjust;
  String image;

  Columns({this.jSONType, this.title, this.dataType, this.fieldName, this.iD, this.options, this.textAjust, this.width, this.editStyle, this.module, this.deep, this.titleAjust, this.image});

  Columns.fromJson(Map<String, dynamic> json) {
    jSONType = json['JSONType'];
    title = json['Title'];
    dataType = json['DataType'];
    fieldName = json['FieldName'];
    iD = json['ID'];
    options = json['Options'];
    textAjust = json['TextAjust'];
    width = json['Width'];
    editStyle = json['EditStyle'];
    module = json['Module'];
    deep = json['Deep'];
    titleAjust = json['TitleAjust'];
    image = json['Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JSONType'] = this.jSONType;
    data['Title'] = this.title;
    data['DataType'] = this.dataType;
    data['FieldName'] = this.fieldName;
    data['ID'] = this.iD;
    data['Options'] = this.options;
    data['TextAjust'] = this.textAjust;
    data['Width'] = this.width;
    data['EditStyle'] = this.editStyle;
    data['Module'] = this.module;
    data['Deep'] = this.deep;
    data['TitleAjust'] = this.titleAjust;
    data['Image'] = this.image;
    return data;
  }
}

class Tools {
  List<Buttons> buttons;

  Tools({this.buttons});

  Tools.fromJson(Map<String, dynamic> json) {
    if (json['Buttons'] != null) {
      buttons = new List<Buttons>();
      json['Buttons'].forEach((v) { buttons.add(new Buttons.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.buttons != null) {
      data['Buttons'] = this.buttons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Buttons {
  String iD;
  String hint;
  String image;
  String shortCut;


  Buttons({this.iD, this.hint, this.image, this.shortCut});

  Buttons.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    hint = json['Hint'];
    image = json['Image'];
    shortCut = json['ShortCut'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Hint'] = this.hint;
    data['Image'] = this.image;
    data['ShortCut'] = this.shortCut;
    return data;
  }
}

class Details {
  List<ItemsDoc> items;

  Details({this.items});

  Details.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<ItemsDoc>();
      json['items'].forEach((v) { items.add(new ItemsDoc.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemsDoc {
  String docCfgID;
  String caption;
  String name;
  String textField;
  String imageFields;
  List<ItemsDocNext> itemsNext;

  ItemsDoc({this.docCfgID, this.caption, this.name, this.textField, this.imageFields, this.itemsNext});

  ItemsDoc.fromJson(Map<String, dynamic> json) {
    docCfgID = json['DocCfgID'];
    caption = json['Caption'];
    name = json['Name'];
    textField = json['TextField'];
    imageFields = json['ImageFields'];
    if (json['items'] != null) {
      itemsNext = new List<ItemsDocNext>();
      json['items'].forEach((v) { itemsNext.add(new ItemsDocNext.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocCfgID'] = this.docCfgID;
    data['Caption'] = this.caption;
    data['Name'] = this.name;
    data['TextField'] = this.textField;
    data['ImageFields'] = this.imageFields;
    if (this.itemsNext != null) {
      data['items'] = this.itemsNext.map((v) => v.toJson()).toList();
    }

    return data;
  }
}


class ItemsDocNext {
  String docCfgID;
  String caption;
  String name;
  String textField;
  String imageFields;


  ItemsDocNext({this.docCfgID, this.caption, this.name, this.textField, this.imageFields});

  ItemsDocNext.fromJson(Map<String, dynamic> json) {
    docCfgID = json['DocCfgID'];
    caption = json['Caption'];
    name = json['Name'];
    textField = json['TextField'];
    imageFields = json['ImageFields'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocCfgID'] = this.docCfgID;
    data['Caption'] = this.caption;
    data['Name'] = this.name;
    data['TextField'] = this.textField;
    data['ImageFields'] = this.imageFields;

    return data;
  }
}



class Params {
  String path;
  String title;
  String paramMapID;
  String nextID;
  String fix;
  String version;
  List<Items> items;

  Params(
      {this.path,
        this.title,
        this.paramMapID,
        this.nextID,
        this.fix,
        this.version,
        this.items});

  Params.fromJson(Map<String, dynamic> json) {
    path = json['Path'];
    title = json['Title'];
    paramMapID = json['ParamMapID'];
    nextID = json['NextID'];
    fix = json['fix'];
    version = json['Version'];
    if (json['Items'] != null) {
      items = new List<Items>();
      json['Items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Path'] = this.path;
    data['Title'] = this.title;
    data['ParamMapID'] = this.paramMapID;
    data['NextID'] = this.nextID;
    data['fix'] = this.fix;
    data['Version'] = this.version;
    if (this.items != null) {
      data['Items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String jSONType;
  String iD;
  String editStyle;
  String shortName;
  String dataType;
  String name;
  String module;
  String options;
  String mapID;
  String orderNo;
  String onInitialize;
  String fieldName;
  String objRef;
  String value;
  String editVal;
  String valType;

  Items(
      {this.jSONType,
        this.iD,
        this.editStyle,
        this.shortName,
        this.dataType,
        this.name,
        this.module,
        this.options,
        this.mapID,
        this.orderNo,
        this.onInitialize,
        this.fieldName,
        this.objRef,
        this.value,
        this.editVal,
        this.valType});

  Items.fromJson(Map<String, dynamic> json) {
    jSONType = json['JSONType'];
    iD = json['ID'];
    editStyle = json['EditStyle'];
    shortName = json['ShortName'];
    dataType = json['DataType'];
    name = json['Name'];
    module = json['Module'];
    options = json['Options'];
    mapID = json['MapID'];
    orderNo = json['OrderNo'];
    onInitialize = json['OnInitialize'];
    fieldName = json['FieldName'];
    objRef = json['ObjRef'];
    value = json['Value'];
    editVal = json['EditVal'];
    valType = json['ValType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JSONType'] = this.jSONType;
    data['ID'] = this.iD;
    data['EditStyle'] = this.editStyle;
    data['ShortName'] = this.shortName;
    data['DataType'] = this.dataType;
    data['Name'] = this.name;
    data['Module'] = this.module;
    data['Options'] = this.options;
    data['MapID'] = this.mapID;
    data['OrderNo'] = this.orderNo;
    data['OnInitialize'] = this.onInitialize;
    data['FieldName'] = this.fieldName;
    data['ObjRef'] = this.objRef;
    data['Value'] = this.value;
    data['EditVal'] = this.editVal;
    data['ValType'] = this.valType;
    return data;
  }
}
