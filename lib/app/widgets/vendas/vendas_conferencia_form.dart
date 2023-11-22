import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class VendasConferenciaForm extends StatefulWidget {
  const VendasConferenciaForm({super.key});

  @override
  VendasConferenciaFormState createState() => VendasConferenciaFormState();
}

class VendasConferenciaFormState extends State<VendasConferenciaForm> {
  final TextEditingController _vendaController = TextEditingController();
  final TextEditingController _produtoController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();

  bool _conferenciaIniciada = false;
  final String apiUrl = 'http://192.168.253.94:5001/v1-ibra/vendasconferencias';
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                // Lógica para iniciar a conferência
                setState(() {
                  _conferenciaIniciada = true;
                });
              },
              child: const Text('Iniciar Conferência'),
            ),
            if (_conferenciaIniciada) ...[
              ElevatedButton(
                onPressed: () {
                  // Lógica para finalizar a conferência
                  setState(() {
                    _conferenciaIniciada = false;
                  });
                },
                child: const Text('Finalizar Conferência'),
              ),
            ],
          ],
        ),
        if (_conferenciaIniciada) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _vendaController,
            decoration: const InputDecoration(labelText: 'Número da Venda'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _produtoController,
            decoration: const InputDecoration(labelText: 'Código do Produto'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _quantidadeController,
            decoration: const InputDecoration(labelText: 'Quantidade de Itens'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              _enviarConferencia();

              // Limpar os campos após enviar a conferência
              _produtoController.clear();
              _quantidadeController.clear();
            },
            child: const Text('Enviar Conferência'),
          ),
        ],
      ],
    );
  }

  void _enviarConferencia() async {
    // Obtenha os valores dos controladores
    String numeroVenda = _vendaController.text;
    String codigoProduto = _produtoController.text;
    double quantidade = double.tryParse(_quantidadeController.text) ?? 0.0;

    try {
      // Faça a chamada PATCH usando o Dio
      Response response = await dio.patch(apiUrl, data: {
        'number': numeroVenda,
        'codigoProduto': codigoProduto,
        'quantidade': quantidade,
      });

      // Verifique se o código de status está na faixa de 2xx (indicando sucesso)
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Exiba a resposta do backend
        print('Resposta do Backend: ${response.data}');

        // Adicione aqui a lógica adicional que desejar com a resposta do backend
      } else {
        // Se a resposta não for bem-sucedida ou for nula, lide com isso adequadamente
        print(
            'Erro ao enviar conferência. Código de status: ${response.statusCode}');
      }
    } catch (error) {
      // Lide com erros aqui
      print('Erro ao enviar conferência: $error');
    }
  }
}
