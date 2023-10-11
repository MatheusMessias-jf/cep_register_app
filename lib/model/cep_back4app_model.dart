class CepsBack4AppModel {
  List<CepBack4AppModel> results = [];

  CepsBack4AppModel(this.results);

  CepsBack4AppModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <CepBack4AppModel>[];
      json['results'].forEach((v) {
        results.add(CepBack4AppModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}

class CepBack4AppModel {
  String? objectId;
  String? cep;
  String? createdAt;
  String? updatedAt;

  CepBack4AppModel({this.objectId, this.cep, this.createdAt, this.updatedAt});

  CepBack4AppModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    cep = json['CEP'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['CEP'] = cep;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
