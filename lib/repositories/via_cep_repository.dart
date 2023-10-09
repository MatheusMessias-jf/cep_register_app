import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/viacep_model.dart';

class ViaCepRepository {
  Future<ViaCepModel> consultarCEP(String cep) async {
    var response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return ViaCepModel.fromJson(json);
    }
    return ViaCepModel();
  }
}
