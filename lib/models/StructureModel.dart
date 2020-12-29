class StructureModel {
  List<Sections> sections;

  StructureModel({this.sections});

  StructureModel.fromJson(Map<String, dynamic> json) {
    if (json['Sections'] != null) {
      sections = new List<Sections>();
      json['Sections'].forEach((v) {
        sections.add(new Sections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sections != null) {
      data['Sections'] = this.sections.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sections {
  String iD;
  String name;
  String height;
  List<SubSections> subSections;
  String title;
  String cLSID;
  String image;
  List<Documents> documents;
  List<Reports> reports;
  List<Pages> pages;

  Sections(
      {this.iD, this.name, this.height, this.subSections, this.title, this.cLSID, this.image,this.documents,this.reports,this.pages});

  Sections.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    height = json['Height'];
    if (json['Sections'] != null) {
      subSections = new List<SubSections>();
      json['Sections'].forEach((v) {
        subSections.add(new SubSections.fromJson(v));
      });
    }
    title = json['Title'];
    cLSID = json['CLSID'];
    image = json['Image'];
    if (json['Documents'] != null) {
      documents = new List<Documents>();
      json['Documents'].forEach((v) {
        documents.add(new Documents.fromJson(v));
      });
    }
    if (json['Reports'] != null) {
      reports = new List<Reports>();
      json['Reports'].forEach((v) {
        reports.add(new Reports.fromJson(v));
      });
    }
    if (json['Pages'] != null) {
      pages = new List<Pages>();
      json['Pages'].forEach((v) {
        pages.add(new Pages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Height'] = this.height;
    if (this.subSections != null) {
      data['Sections'] = this.subSections.map((v) => v.toJson()).toList();
    }
    data['Title'] = this.title;
    data['CLSID'] = this.cLSID;
    data['Image'] = this.image;
    if (this.documents != null) {
      data['Documents'] = this.documents.map((v) => v.toJson()).toList();
    }
    if (this.reports != null) {
      data['Reports'] = this.reports.map((v) => v.toJson()).toList();
    }
    if (this.pages != null) {
      data['Pages'] = this.pages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubSections {
  String iD;
  String name;
  String cLSID;
  String height;
  String image;
  List<Documents> documents;
  List<Reports> reports;
  List<Pages> pages;

  SubSections({this.iD, this.name, this.cLSID, this.height,this.image,this.documents,this.reports,this.pages});

  SubSections.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    cLSID = json['CLSID'];
    height = json['Height'];
    image = json['Image'];
    if (json['Documents'] != null) {
      documents = new List<Documents>();
      json['Documents'].forEach((v) {
        documents.add(new Documents.fromJson(v));
      });
    }
    if (json['Reports'] != null) {
      reports = new List<Reports>();
      json['Reports'].forEach((v) {
        reports.add(new Reports.fromJson(v));
      });
    }
    if (json['Pages'] != null) {
      pages = new List<Pages>();
      json['Pages'].forEach((v) {
        pages.add(new Pages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['CLSID'] = this.cLSID;
    data['Height'] = this.height;
    data['Image'] = this.image;
    if (this.documents != null) {
      data['Documents'] = this.documents.map((v) => v.toJson()).toList();
    }
    if (this.reports != null) {
      data['Reports'] = this.reports.map((v) => v.toJson()).toList();
    }
    if (this.pages != null) {
      data['Pages'] = this.pages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  String docCfgID;
  String name;
  String deep;

  Documents({this.docCfgID, this.name, this.deep});

  Documents.fromJson(Map<String, dynamic> json) {
    docCfgID = json['DocCfgID'];
    name = json['Name'];
    deep = json['Deep'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocCfgID'] = this.docCfgID;
    data['Name'] = this.name;
    data['Deep'] = this.deep;
    return data;
  }
}

class Reports {
  String name;
  String iD;
  bool enabled;
  List<Items> items;

  Reports({this.name, this.iD, this.enabled, this.items});

  Reports.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    iD = json['ID'];
    enabled = json['Enabled'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['ID'] = this.iD;
    data['Enabled'] = this.enabled;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String name;
  String iD;

  Items({this.name, this.iD});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    iD = json['ID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['ID'] = this.iD;
    return data;
  }
}

class Pages {
  String name;
  String cLSID;
  String path;
  String progID;

  Pages({this.name, this.cLSID, this.path, this.progID});

  Pages.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    cLSID = json['CLSID'];
    path = json['Path'];
    progID = json['ProgID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['CLSID'] = this.cLSID;
    data['Path'] = this.path;
    data['ProgID'] = this.progID;
    return data;
  }
}

class SubItems {
  String name;
  String iD;
  List<Items> items;

  SubItems({this.name, this.iD, this.items});

  SubItems.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    iD = json['ID'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['ID'] = this.iD;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}