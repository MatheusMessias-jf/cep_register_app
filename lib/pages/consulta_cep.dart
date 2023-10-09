import 'package:flutter/material.dart';
import '../model/viacep_model.dart';
import '../repositories/via_cep_repository.dart';

class ConsultaCep extends StatefulWidget {
  const ConsultaCep({super.key});

  @override
  State<ConsultaCep> createState() => _ConsultaCepState();
}

class _ConsultaCepState extends State<ConsultaCep> {
  var cepController = TextEditingController(text: "");
  bool loading = false;
  var viacepModel = ViaCepModel();
  var viaCEPRepository = ViaCepRepository();
  final FocusNode _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulte seu CEP"),
      ),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(children: [
              const Text(
                "Consulta de CEP",
                style: TextStyle(fontSize: 22),
              ),
              TextField(
                focusNode: _focusNode,
                controller: cepController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                onChanged: (String value) async {
                  var cep = value.trim().replaceAll(RegExp(r'[^0-9]'), '');
                  if (value.length == 8) {
                    setState(() {
                      loading = true;
                    });
                    viacepModel = await viaCEPRepository.consultarCEP(cep);
                    _focusNode.unfocus();
                  }
                  setState(() {
                    loading = false;
                  });
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                viacepModel.logradouro ?? "",
                style: const TextStyle(fontSize: 22),
              ),
              Text(
                "${viacepModel.localidade ?? ""} - ${viacepModel.uf ?? ""}",
                style: const TextStyle(fontSize: 22),
              ),
              Visibility(
                  visible: loading, child: const CircularProgressIndicator())
            ])),
      ),
    );
  }
}
