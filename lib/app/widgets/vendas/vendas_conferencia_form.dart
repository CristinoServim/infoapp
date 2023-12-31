import 'package:flutter/material.dart';
import 'package:infoapp/app/config/app_config.dart';
import 'package:infoapp/app/models/vendas/vendas_conferencia/vendas_conf.dart';
import 'package:infoapp/app/screens/conferencia_criar_entregas_screen.dart';
import 'package:infoapp/app/services/api_service.dart';
import 'package:infoapp/app/services/service_barcodescan.dart';
import 'package:infoapp/app/util/SnackbarUtils.dart';
import 'package:infoapp/app/widgets/buttons/custon_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validatorless/validatorless.dart';

class VendasConferenciaForm extends StatefulWidget {
  const VendasConferenciaForm({super.key});

  @override
  VendasConferenciaFormState createState() => VendasConferenciaFormState();
}

class VendasConferenciaFormState extends State<VendasConferenciaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _vendaControllerEC = TextEditingController();
  final TextEditingController _codigoProdutoControllerEC =
      TextEditingController();
  final TextEditingController _quantidadeControllerEC = TextEditingController();

  bool _conferenciaIniciada = false;
  bool _conferenciaEnviada = false;

  List<VedasConfTotal> vendasConfTotalPendente = [];
  List<VedasConfTotal> vendasConfTotalFiltrado = [];

  final String url = AppConfig.apiUrlVendasConferencias;
  final ApiService _apiService = ApiService.create();

  @override
  void initState() {
    super.initState();
    _quantidadeControllerEC.text = '1';

    // Dar o foco inicial ao campo "Código do Produto" após um pequeno atraso
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(FocusNode());
      FocusScope.of(context).requestFocus(_codigoProdutoFocus);
    });
  }

  final FocusNode _codigoProdutoFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!_conferenciaIniciada) ...[
            CustomElevatedButton(
              text: 'Iniciar Conferências',
              onPressed: () {
                setState(() {
                  _conferenciaIniciada = true;
                });
              },
            ),
          ],
          if (_conferenciaIniciada) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _vendaControllerEC,
              decoration: const InputDecoration(labelText: 'Número da Venda'),
              keyboardType: TextInputType.number,
              validator: Validatorless.multiple([
                Validatorless.required('Campo obrigatório'),
                Validatorless.number('Deve ser um número'),
              ]),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantidadeControllerEC,
              decoration:
                  const InputDecoration(labelText: 'Quantidade de Itens'),
              keyboardType: TextInputType.number,
              validator: Validatorless.multiple([
                Validatorless.required('Campo obrigatório'),
                Validatorless.numbersBetweenInterval(
                    0.1, 100000, 'Deve ser um número'),
              ]),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codigoProdutoControllerEC,
              decoration: const InputDecoration(labelText: 'Código do Produto'),
              validator: Validatorless.multiple([
                Validatorless.required('Campo obrigatório'),
              ]),
            ),
            const SizedBox(height: 32),
            CustomElevatedButton(
              text: 'Scanear Código de Barra',
              icon: Icons.qr_code,
              onPressed: () async {
                String barcodeResult = await scanBarcode();
                setState(() {
                  if (barcodeResult != '-1') {
                    _codigoProdutoControllerEC.text = barcodeResult;
                  }
                });
              },
            ),
            const SizedBox(height: 16),
            CustomElevatedButton(
              text: 'Enviar Conferência',
              icon: Icons.send,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _enviarConferencia();
                  _codigoProdutoControllerEC.clear();
                  _quantidadeControllerEC.clear();
                  _quantidadeControllerEC.text = '1';
                }
              },
            ),
            const SizedBox(height: 16),
            if (_conferenciaEnviada) ...{
              CustomElevatedButton(
                text: 'Avançar',
                icon: Icons.arrow_forward,
                onPressed: () {
                  _consultarConferenciaTotal(_vendaControllerEC.text);
                },
              ),
            },
          ],
        ],
      ),
    );
  }

  // void _exibirSnackbar(String mensagem,
  //     {String? actionText,
  //     Color? backgroundColor,
  //     Color? actionTextColor,
  //     VoidCallback? onPressed}) {
  //   String texto = actionText ?? 'Fechar';

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //         content: Text(
  //           mensagem,
  //           style: TextStyle(color: Colors.white), // Cor do texto
  //         ),
  //         duration: const Duration(seconds: 4),
  //         backgroundColor: backgroundColor ??
  //             Theme.of(context).colorScheme.primary, // Cor de fundo
  //         action: SnackBarAction(
  //           label: texto,
  //           textColor: actionTextColor ??
  //               Theme.of(context)
  //                   .colorScheme
  //                   .secondary, // Cor do texto do botão de ação
  //           onPressed: onPressed ??
  //               () {
  //                 // Função padrão para fechar o SnackBar
  //                 ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //               },
  //         )),
  //   );
  // }

  void _mostrarDialogoFaltaConferir() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Falta comferir :'),
            content: Container(
              width: 300, // Largura do container
              height: 300, // Altura do container
              child: ListView.builder(
                itemCount: vendasConfTotalPendente.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        'Produto: ${vendasConfTotalPendente[index].proCodigo.toString()}'),
                    onTap: () {
                      _vendaControllerEC.text =
                          vendasConfTotalPendente[index].venNumero.toString();
                      _codigoProdutoControllerEC.text =
                          vendasConfTotalPendente[index].proCodigo.toString();
                      Navigator.of(context).pop(); // Feche o diálogo
                    },
                  );
                },
              ),
            ), //
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Feche o diálogo
                    },
                    text: 'Sair sem conferir',
                    textColor: Theme.of(context).colorScheme.primary,
                    buttonColor: Theme.of(context).colorScheme.secondary,
                    width: 200, // Defina a largura desejada
                    height: 40, // Defina a altura desejada
                    fontSize: 16, // Defina o tamanho da fonte desejado
                  ),
                  // Adicione mais botões ou outros widgets conforme necessário
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _redirecionar(String numeroVenda) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConferenciaCriarEntregasScreen(
          numeroVenda: numeroVenda,
        ),
      ),
    );
  }

  Future<void> _consultarConferenciaTotal(String vendaNumero) async {
    const urlBase = AppConfig.apiUrlvendasConfTotal;
    final queryParams = {'venNumero': vendaNumero};
    final url = '$urlBase?${_encodeQueryParameters(queryParams)}';

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      var resposta = false;

      if (token == null) {
        SnackbarUtils.exibirSnackbar(
            context, 'Erro de token, tente novamente.');
        return;
      }

      _apiService.setAuthorizationHeader(token);

      final ApiResponse response = await _apiService.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        if (responseData.isNotEmpty) {
          vendasConfTotalPendente = responseData.map((item) {
            return VedasConfTotal(
              venNumero: item['VEN_NUMERO'],
              proCodigo: item['PRO_CODIGO'],
            );
          }).toList();
          _mostrarDialogoFaltaConferir();
        } else {
          SnackbarUtils.exibirSnackbar(context, 'Nenhum resultado encontrado',
              statusCode: response.statusCode);
        }
      } else if (response.statusCode == 422) {
        var errorMessage = response.data['message'];
        var errorMessages = response.data['errors'];

        if (errorMessages != null) {
          if (errorMessages is List) {
            if (errorMessages.isNotEmpty) {
              SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
            } else {
              SnackbarUtils.exibirSnackbar(context, 'Erro na consulta');
            }
          }
        } else if (errorMessage != null) {
          if (errorMessage == "Consulta realizada com sucesso sem resultado") {
            resposta = true;
          } else {
            SnackbarUtils.exibirSnackbar(context, 'Erro na consulta');
          }
        } else {
          SnackbarUtils.exibirSnackbar(context, 'Erro na consulta');
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }

      _apiService.removeAuthorizationHeader();
      if (resposta) {
        _redirecionar(vendaNumero);
      }
    } catch (error) {
      if (error is ApiResponse) {
        if (error.statusCode == 422) {
          var errorMessage = error.data['message'];
          var errorMessages = error.data['errors'];

          if (errorMessages != null) {
            if (errorMessages is List) {
              if (errorMessages.isNotEmpty) {
                SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
              } else {
                SnackbarUtils.exibirSnackbar(context, 'Erro de na consulta');
              }
            }
          } else if (errorMessage != null) {
            SnackbarUtils.exibirSnackbar(context, errorMessage);
          } else if (errorMessages != null) {
            SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
          }
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }
    }
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((entry) {
      return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}';
    }).join('&');
  }

  void _enviarConferencia() async {
    // Obtenha os valores dos controladores
    String venNumero = _vendaControllerEC.text;
    String proCodigo = _codigoProdutoControllerEC.text;
    double quantidadePecas =
        double.tryParse(_quantidadeControllerEC.text) ?? 0.0;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        SnackbarUtils.exibirSnackbar(
            context, 'Erro de token, tente novamente.');
        return;
      }

      _apiService.setAuthorizationHeader(token);

      ApiResponse response = await _apiService.patch(url, {
        'venNumero': venNumero,
        'proCodigo': proCodigo,
        'quantidadePecas': quantidadePecas,
      });

      if (response.statusCode >= 200 && response.statusCode <= 500) {
        var statusCode = response.statusCode;
        var message = response.data['message'];

        if (message != null) {
          if (statusCode == 201) {
            setState(() {
              _conferenciaEnviada = true;
            });
            SnackbarUtils.exibirSnackbar(context, message,
                statusCode: response.statusCode);

            //_exibirSnackbar(message);
          } else if (statusCode == 200 || statusCode == 422) {
            setState(() {
              _conferenciaEnviada = true;
            });

            SnackbarUtils.exibirSnackbar(context, message,
                statusCode: response.statusCode);
          } else {
            SnackbarUtils.exibirSnackbar(
                context, 'Erro interno, tente novamente.');
          }
        } else {
          SnackbarUtils.exibirSnackbar(
              context, 'Erro interno, tente novamente.');
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente.');
      }

      // _apiService.removeAuthorizationHeader();
    } catch (error) {
      if (error is ApiResponse) {
        if (error.statusCode == 422) {
          var errorMessage = error.data['message'];
          var errorMessages = error.data['errors'];

          if (errorMessages != null) {
            if (errorMessages is List) {
              if (errorMessages.isNotEmpty) {
                SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
              } else {
                SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
              }
            }
          } else if (errorMessage != null) {
            SnackbarUtils.exibirSnackbar(context, errorMessage);
          } else if (errorMessages != null) {
            SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
          }
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }
    }
  }
}
