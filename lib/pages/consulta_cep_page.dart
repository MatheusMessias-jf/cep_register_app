import 'package:cep_register_app/model/cep_back4app_model.dart';
import 'package:cep_register_app/repositories/back4app/ceps_back4app_repository.dart';
import 'package:flutter/material.dart';
import '../model/viacep_model.dart';
import '../repositories/via_cep_repository.dart';

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key});

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  var cepController = TextEditingController(text: "");
  bool loading = false;
  var viacepModel = ViaCepModel();
  var viaCEPRepository = ViaCepRepository();
  var cepsBack4AppModel = CepsBack4AppModel([]);
  var cepBack4AppRepository = CepBack4AppRepository();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    atualizarCeps();
    super.initState();
  }

  void atualizarCeps() async {
    setState(() {
      loading = true;
    });
    cepsBack4AppModel = await cepBack4AppRepository.obterCeps();
    setState(() {
      loading = false;
    });
  }

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
                    if (viacepModel.cep != null) {
                      atualizarCeps();
                      var estaCadastrado =
                          await cepBack4AppRepository.estaCadastrado(cep);
                      if (!estaCadastrado) {
                        await cepBack4AppRepository.criar(cep);
                        atualizarCeps();
                        setState(() {});
                      }
                      _focusNode.unfocus();
                      atualizarCeps();
                      setState(() {});
                    }
                    setState(() {
                      loading = false;
                    });
                  } else {
                    setState(() {
                      loading = false;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
              viacepModel.cep != null
                  ? Text(
                      viacepModel.logradouro ?? "",
                      style: const TextStyle(fontSize: 22),
                    )
                  : const Text(
                      "Preencha um Cep Válido",
                      style: TextStyle(fontSize: 22),
                    ),
              Text(
                "${viacepModel.localidade ?? ""} - ${viacepModel.uf ?? ""}",
                style: const TextStyle(fontSize: 22),
              ),
              Visibility(
                  visible: loading,
                  child: const Center(child: CircularProgressIndicator())),
              const SizedBox(height: 30),
              Expanded(
                  child: ListView.builder(
                itemCount: cepsBack4AppModel.results.length,
                itemBuilder: (BuildContext bc, int index) {
                  var cep = cepsBack4AppModel.results[index];
                  return Dismissible(
                      onDismissed: (DismissDirection dismissDirection) async {
                        await cepBack4AppRepository.remover(cep.objectId!);
                        atualizarCeps();
                      },
                      key: UniqueKey(),
                      child: Card(
                        child: ListTile(
                          title: Center(
                            child: Text(
                              cep.cep!,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ));
                },
              ))
            ])),
      ),
    );
  }
}
