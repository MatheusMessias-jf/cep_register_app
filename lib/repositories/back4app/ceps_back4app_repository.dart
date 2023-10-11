import 'package:cep_register_app/model/cep_back4app_model.dart';

import 'back4app_custom_dio.dart';

class CepBack4AppRepository {
  var _customDio = Back4AppCustomDio();

  CepBack4AppRepository();

  Future<CepsBack4AppModel> obterCeps() async {
    var url = "/CEP";
    var result = await _customDio.dio.get(url);
    return CepsBack4AppModel.fromJson(result.data);
  }

  Future<bool> estaCadastrado(String cep) async {
    var url = "/CEP";
    url = "$url/?where={\"CEP\":\"$cep\"}";
    var result = await _customDio.dio.get(url);
    var cepsBack4AppModel = CepsBack4AppModel.fromJson(result.data);
    if (cepsBack4AppModel.results.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> criar(String cep) async {
    try {
      await _customDio.dio.post("/CEP", data: "{\"CEP\":\"$cep\"}");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(CepBack4AppModel cepBack4AppModel) async {
    try {
      await _customDio.dio.put("/Tarefas/${cepBack4AppModel.objectId}",
          data: cepBack4AppModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      await _customDio.dio.delete("/CEP/$objectId");
      //data: cepBack4AppModel.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
