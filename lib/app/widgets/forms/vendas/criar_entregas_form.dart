import 'package:flutter/material.dart';
import 'package:infoapp/app/config/app_config.dart';
import 'package:infoapp/app/models/vendas/vendas_conferencia/itens_venda_conferida.dart';
import 'package:infoapp/app/models/vendas/vendas_conferencia/prestador_ent.dart';
import 'package:infoapp/app/models/vendas/vendas_conferencia/status_ent_conferencia.dart';
import 'package:infoapp/app/models/vendas/vendas_conferencia/venda_conferida_models.dart';
import 'package:infoapp/app/services/api_service.dart';
import 'package:infoapp/app/util/SnackbarUtils.dart';
import 'package:infoapp/app/util/parametro_de_consultas.dart';
import 'package:infoapp/app/util/parse_util.dart';
import 'package:infoapp/app/widgets/buttons/custon_elevated_button.dart';
import 'package:infoapp/app/widgets/listagens/vendas/vendas_conferencias/vendas_listagem_conferida.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validatorless/validatorless.dart';

class CriarEntregasForm extends StatefulWidget {
  final String numeroVenda;
  const CriarEntregasForm({Key? key, required this.numeroVenda})
      : super(key: key);

  @override
  CriarEntregasFormState createState() => CriarEntregasFormState();
}

class CriarEntregasFormState extends State<CriarEntregasForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _vendaControllerEC = TextEditingController();
  final TextEditingController _motoristaControllerEC = TextEditingController();
  final TextEditingController _observacaoControllerEC = TextEditingController();
  final TextEditingController _kmControllerEC = TextEditingController();
  final TextEditingController _statusControllerEC = TextEditingController();
  TextEditingController filterController = TextEditingController();

  final ApiService _apiService = ApiService.create();

  List<PrestadorEnt> prestadores = [];
  List<PrestadorEnt> prestadoresFiltrados = [];

  List<StatusEntConferencia> status = [];
  List<StatusEntConferencia> statusFiltrados = [];

  List<VendaConferida> listaDeVendasConferidas = [];
  //List<VendaConferida> listaDeVendasConferidas1 = [
  //   VendaConferida(
  //     venNumero: 9,
  //     cliCodigo: 1,
  //     cliNome: 'A VISTA',
  //     itensVenda: [
  //       ItemVenda(
  //         proCodigo: 1,
  //         proDescricao: 'FILTRO TECFIL PSH 025 HIDRAULICO',
  //         proEtiq: 1,
  //         ivdNumero: 19,
  //         ivdItem: 1,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 0.000,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 2,
  //         proDescricao: 'FILTRO TECFIL PSH 025 ',
  //         proEtiq: 2,
  //         ivdNumero: 20,
  //         ivdItem: 2,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 2,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 3,
  //         proDescricao: 'FILTRO TECFIL  ',
  //         proEtiq: 1,
  //         ivdNumero: 21,
  //         ivdItem: 3,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 0.000,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 1,
  //         proDescricao: 'FILTRO TECFIL PSH 025 HIDRAULICO',
  //         proEtiq: 1,
  //         ivdNumero: 19,
  //         ivdItem: 1,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 0.000,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 2,
  //         proDescricao: 'FILTRO TECFIL PSH 025 ',
  //         proEtiq: 2,
  //         ivdNumero: 20,
  //         ivdItem: 2,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 2,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 3,
  //         proDescricao: 'FILTRO TECFIL  ',
  //         proEtiq: 1,
  //         ivdNumero: 21,
  //         ivdItem: 3,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 0.000,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 1,
  //         proDescricao: 'FILTRO TECFIL PSH 025 HIDRAULICO',
  //         proEtiq: 1,
  //         ivdNumero: 19,
  //         ivdItem: 1,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 0.000,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 2,
  //         proDescricao: 'FILTRO TECFIL PSH 025 ',
  //         proEtiq: 2,
  //         ivdNumero: 20,
  //         ivdItem: 2,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 2,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 3,
  //         proDescricao: 'FILTRO TECFIL  ',
  //         proEtiq: 1,
  //         ivdNumero: 21,
  //         ivdItem: 3,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 0.000,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 1,
  //         proDescricao: 'FILTRO TECFIL PSH 025 HIDRAULICO',
  //         proEtiq: 1,
  //         ivdNumero: 19,
  //         ivdItem: 1,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 0.000,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 2,
  //         proDescricao: 'FILTRO TECFIL PSH 025 ',
  //         proEtiq: 2,
  //         ivdNumero: 20,
  //         ivdItem: 2,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 2,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 3,
  //         proDescricao: 'FILTRO TECFIL  ',
  //         proEtiq: 1,
  //         ivdNumero: 21,
  //         ivdItem: 3,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 0.000,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 1,
  //         proDescricao: 'FILTRO TECFIL PSH 025 HIDRAULICO',
  //         proEtiq: 1,
  //         ivdNumero: 19,
  //         ivdItem: 1,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 0.000,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 2,
  //         proDescricao: 'FILTRO TECFIL PSH 025 ',
  //         proEtiq: 2,
  //         ivdNumero: 20,
  //         ivdItem: 2,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 2,
  //         ivdOperacao: 'V',
  //       ),
  //       ItemVenda(
  //         proCodigo: 3,
  //         proDescricao: 'FILTRO TECFIL  ',
  //         proEtiq: 1,
  //         ivdNumero: 21,
  //         ivdItem: 3,
  //         ivdQtde: 1.000,
  //         ivdQtdeConf: 0.000,
  //         ivdOperacao: 'V',
  //       ),
  //     ],
  //   ),
  //   // Adicione mais elementos conforme necessário
  //
  //];

  @override
  void initState() {
    super.initState();
    _vendaControllerEC.text = widget.numeroVenda;
    _vendaControllerEC.text = widget.numeroVenda;
  }

  @override
  void dispose() {
    // Dispose dos controladores
    _vendaControllerEC.dispose();
    _motoristaControllerEC.dispose();
    _observacaoControllerEC.dispose();
    _kmControllerEC.dispose();
    _statusControllerEC.dispose();
    filterController.dispose();

    super.dispose();
  }

  String _codigoMotoristaSelecionado = '';

  String _codigoStatusSelecionado = '';

  Future<bool> _criarEntrega() async {
    const url = AppConfig.apiUrlCriarEntregasConferencia;
    int? venNumero = tryParseInt(_vendaControllerEC.text);
    int? codMotorista = tryParseInt(_codigoMotoristaSelecionado);
    String observacao = _observacaoControllerEC.text;
    int? codStatus = tryParseInt(_codigoStatusSelecionado);
    double? km = tryParseDouble(_kmControllerEC.text);

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        SnackbarUtils.exibirSnackbar(context, 'Erro de token, tente novamente');
        return false;
      }

      _apiService.setAuthorizationHeader(token);

      ApiResponse response = await _apiService.post(url, {
        'venNumero': venNumero,
        'codMotorista': codMotorista,
        'observacao': observacao,
        'codStatus': codStatus,
        'km': km,
      });

      if (response.statusCode >= 200 && response.statusCode <= 500) {
        var statusCode = response.statusCode;
        var message = response.data.containsKey('message')
            ? response.data['message']
            : null;
        var errorMessages = response.data.containsKey('errors')
            ? response.data['errors']
            : null;

        // Verifique se tanto message quanto errorMessages são null

        if (message == null && errorMessages == null) {
          SnackbarUtils.exibirSnackbar(
              context, 'Resposta inválida do servidor,tente novamente.',
              statusCode: statusCode);
          return false;
        }

        if (message != null || errorMessages != null) {
          if (statusCode == 201) {
            setState(() {});
            SnackbarUtils.exibirSnackbar(
                context, response.data['message'].toString(),
                statusCode: statusCode);
            _apiService.removeAuthorizationHeader();
            return true;
          } else if (statusCode == 422 || statusCode == 401) {
            Color backgroundColor = Color.fromARGB(240, 239, 93, 93);
            if (statusCode == 401) {
              backgroundColor = Theme.of(context)
                  .colorScheme
                  .secondary; // Altera a cor se o statusCode for 401
            }
            if (errorMessages != null) {
              if (errorMessages is List) {
                if (errorMessages.isNotEmpty) {
                  SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
                } else {
                  SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
                }
              }
            } else if (message is List) {
              if (message.isNotEmpty) {
                SnackbarUtils.exibirSnackbar(context, message[0],
                    backgroundColor: backgroundColor);
              } else {
                SnackbarUtils.exibirSnackbar(context, 'Erro na consulta');
              }
            } else {
              SnackbarUtils.exibirSnackbar(context, message,
                  backgroundColor: backgroundColor);
            }
          } else {
            SnackbarUtils.exibirSnackbar(
                context, 'Erro interno, tente novamente');
          }
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente.');
      }
    } catch (error) {
      if (error is ApiResponse) {
        if (error.statusCode == 422) {
          var errorMessage = error.data['message'];
          var errorMessages = error.data['errors'];

          if (errorMessages != null) {
            if (errorMessage != null) {
              SnackbarUtils.exibirSnackbar(context, errorMessage);
            } else if (errorMessages != null) {
              if (errorMessages is List) {
                if (errorMessages.isNotEmpty) {
                  // Use a primeira mensagem de erro para exibição
                  SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
                } else {
                  SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
                }
              } else {
                SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
              }
            } else {
              SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
            }
          }
        } else {
          SnackbarUtils.exibirSnackbar(
              context, 'Erro interno, tente novamente');
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }
    }
    return false;
  }

  Future<void> _consultaStatus() async {
    // Substitua a URL pelo endpoint correto para consultar os status
    const url = AppConfig.apiUrlConsultaStatusEnt;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        SnackbarUtils.exibirSnackbar(context, 'Erro de token, tente novamente');
        return;
      }

      _apiService.setAuthorizationHeader(token);

      final ApiResponse response = await _apiService.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> itensStatus = response.data['ITENS_STATUS'];
        if (itensStatus.isNotEmpty) {
          status = itensStatus.map((item) {
            return StatusEntConferencia(
              tbsCodigo: item['TBS_CODIGO'],
              tbsDescricao: item['TBS_DESCRICAO'].toLowerCase(),
            );
          }).toList();
        } else {
          SnackbarUtils.exibirSnackbar(context, 'Nenhum resultado encontrado',
              statusCode: response.statusCode);
        }
      } else if (response.statusCode == 422) {
        var message = response.data['message'];
        var errorMessages = response.data['errors'];
        if (errorMessages != null) {
          if (errorMessages is List) {
            if (errorMessages.isNotEmpty) {
              SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
            } else {
              SnackbarUtils.exibirSnackbar(context, 'Erro na consulta');
            }
          }
        } else if (message != null) {
          // Verifique se message é uma lista e trate-o adequadamente
          if (message is List) {
            if (message.isNotEmpty) {
              SnackbarUtils.exibirSnackbar(context, message[0]);
            } else {
              SnackbarUtils.exibirSnackbar(context, 'Erro na consulta');
            }
          } else {
            SnackbarUtils.exibirSnackbar(context, message);
          }
        } else {
          SnackbarUtils.exibirSnackbar(context, 'Erro na consulta');
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }

      _apiService.removeAuthorizationHeader();
    } catch (error) {
      if (error is ApiResponse) {
        if (error.statusCode == 422) {
          var message = error.data['message'];
          var errorMessages = error.data['errors'];

          if (errorMessages != null) {
            if (errorMessages is List) {
              if (errorMessages.isNotEmpty) {
                SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
              } else {
                SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
              }
            }
          } else if (message != null) {
            SnackbarUtils.exibirSnackbar(context, message);
          } else if (errorMessages != null) {
            SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
          }
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }
    }
  }

  void _mostrarDialogoStatus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Selecione o Status'),
            content: Container(
              width: 300, // Largura do container
              height: 500, // Altura do container
              child: ListView.builder(
                itemCount: status.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(status[index].tbsDescricao),
                    onTap: () {
                      _codigoStatusSelecionado =
                          status[index].tbsCodigo.toString();

                      _statusControllerEC.text = status[index].tbsDescricao;
                      Navigator.of(context).pop(); // Feche o diálogo
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _mostrarDialogoMotoristas() {
    TextEditingController filterController = TextEditingController(); //
    String apelido = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Digite o apelido do motorista'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: filterController,
                    decoration: const InputDecoration(
                        labelText: 'Apelido do Motorista'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    apelido = filterController.text.trim().toLowerCase();
                    if (apelido.isNotEmpty) {
                      Navigator.of(context).pop();

                      prestadoresFiltrados = prestadores
                          .where((prestador) => prestador.preApelido
                              .toLowerCase()
                              .contains(apelido.toLowerCase()))
                          .toList();

                      _mostrarListaMotoristasFiltrada(context);
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarListaMotoristasFiltrada(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Selecione um motorista'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  TextField(
                    controller: filterController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar motoristas',
                    ),
                    onChanged: (text) {
                      // Atualizar a lista filtrada sempre que o texto é alterado
                      setState(() {
                        prestadoresFiltrados = prestadores
                            .where((prestador) => prestador.preApelido
                                .toLowerCase()
                                .trim()
                                .contains(text.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  prestadoresFiltrados.isEmpty
                      ? const Text('Nenhum motorista encontrado.')
                      : SizedBox(
                          height: prestadoresFiltrados.length * 80.0,
                          child: ListView.builder(
                            itemCount: prestadoresFiltrados.length,
                            itemBuilder: (context, index) {
                              // Crie uma representação visual personalizada
                              String codigoNomeConcatenado =
                                  '${prestadoresFiltrados[index].preCodigo}-${prestadoresFiltrados[index].preApelido}';

                              return ListTile(
                                title: Text(codigoNomeConcatenado),
                                onTap: () {
                                  // Atribua o código do motorista selecionado
                                  _codigoMotoristaSelecionado =
                                      prestadoresFiltrados[index]
                                          .preCodigo
                                          .toString();

                                  _motoristaControllerEC.text =
                                      codigoNomeConcatenado;
                                  Navigator.of(context)
                                      .pop(); // Fecha o diálogo
                                },
                              );
                            },
                          ),
                        ),
                  if (prestadoresFiltrados.isEmpty)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o diálogo
                      },
                      child: const Text('Fechar'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _consultaPrestadores() async {
    const url = AppConfig.apiUrlConsultaPrestadoresConferencia;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        return;
      }

      _apiService.setAuthorizationHeader(token);

      final ApiResponse response = await _apiService.get(url);

      if (response.statusCode == 200) {
        prestadores = (response.data as List<dynamic>).map((item) {
          return PrestadorEnt(
            preCodigo: item['PRE_CODIGO'],
            preApelido: item['PRE_APELIDO'],
          );
        }).toList();
        // Faça algo com a lista de prestadores, se necessário
      } else if (response.statusCode == 422) {
        var message = response.data['message'];
        var errorMessages = response.data['errors'];
        if (errorMessages != null) {
          if (errorMessages is List) {
            if (errorMessages.isNotEmpty) {
              SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
            } else {
              SnackbarUtils.exibirSnackbar(context, errorMessages[0]);

              //_exibirSnackbar('Erro na consulta');
            }
          }
        } else if (message != null) {
          // Verifique se message é uma lista e trate-o adequadamente
          if (message is List) {
            if (message.isNotEmpty) {
              SnackbarUtils.exibirSnackbar(context, message[0]);
            } else {
              SnackbarUtils.exibirSnackbar(context, 'Erro na consulta');
            }
          } else {
            SnackbarUtils.exibirSnackbar(context, message);
          }
        } else {
          SnackbarUtils.exibirSnackbar(context, 'Erro na consulta');
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }
      _apiService.removeAuthorizationHeader();
    } catch (error) {
      if (error is ApiResponse) {
        if (error.statusCode == 422) {
          var message = error.data['message'];
          var errorMessages = error.data['errors'];

          if (errorMessages != null) {
            if (errorMessages is List) {
              if (errorMessages.isNotEmpty) {
                SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
              } else {
                SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
              }
            }
          } else if (message != null) {
            SnackbarUtils.exibirSnackbar(context, message);
          } else if (errorMessages != null) {
            SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
          }
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }
    }
  }

  void redirecionar(String numeroVenda) {
    //print(listaDeVendasConferidas[0]);
    //print('Detalhes dos itens de venda:');
    // for (var itemVenda in listaDeVendasConferidas[0].itensVenda) {
    //   print('Código do produto: ${itemVenda.proCodigo}');
    //   print('Descrição do produto: ${itemVenda.proDescricao}');
    //   print('Etiq: ${itemVenda.proEtiq}');
    //   print('Número do item: ${itemVenda.ivdNumero}');
    //   print('Qtde: ${itemVenda.ivdQtde}');
    //   print('Qtde Conf: ${itemVenda.ivdQtdeConf}');
    //   print('Operação: ${itemVenda.ivdOperacao}');
    //   print('----------------------');
    // }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              VendasList(listaDeVendasConferidas: listaDeVendasConferidas)),
    );
  }

  Future<void> _listarVendaConferida() async {
    const urlBase = AppConfig.apiUrlVendaConferida;
    final queryParams = {'venNumero': _vendaControllerEC.text};
    final url = '$urlBase?${encodeQueryParameters(queryParams)}';

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        SnackbarUtils.exibirSnackbar(
            context, 'Erro de token, tente novamente.');
        return;
      }

      _apiService.setAuthorizationHeader(token);
      var message = null;
      var errorMessages = null;

      final ApiResponse response = await _apiService.get(url);
      if (response.data != null) {
        if (response.data is List) {
          // Se a resposta for uma lista, itere sobre os elementos
          for (var item in response.data as List<dynamic>) {
            if (item is Map<String, dynamic>) {
              // Se o elemento for um mapa, verifique as chaves 'message' e 'errors'
              message = item.containsKey('message') ? item['message'] : null;
              errorMessages =
                  item.containsKey('errors') ? item['errors'] : null;

              // Faça o que for necessário com message e errorMessages
            }
          }
        } else if (response.data is Map<String, dynamic>) {
          // Se a resposta for um mapa, verifique as chaves 'message' e 'errors'
          message = response.data.containsKey('message')
              ? response.data['message']
              : null;
          errorMessages = response.data.containsKey('errors')
              ? response.data['errors']
              : null;

          // Faça o que for necessário com message e errorMessages
        }
      }

      if (response.statusCode == 200) {
        if (response.data != null) {
          listaDeVendasConferidas = (response.data as List<dynamic>)
              .map((item) {
                try {
                  var itensVendaList = <ItemVenda>[];

                  if (item.containsKey('itensVenda') &&
                      item['itensVenda'] is List) {
                    itensVendaList =
                        (item['itensVenda'] as List<dynamic>).map((itemVenda) {
                      return ItemVenda(
                        proCodigo: itemVenda['proCodigo'] ?? '',
                        proDescricao: itemVenda['proDescricao'] ?? '',
                        proEtiq: itemVenda['proEtiq'] ?? 0,
                        ivdNumero: itemVenda['ivdNumero'] ?? 0,
                        ivdItem: itemVenda['ivdItem'] ?? 0,
                        ivdQtde: (itemVenda['ivdQtde'] ?? 0)
                            .toDouble(), // Converter para double
                        ivdQtdeConf: (itemVenda['ivdQtdeConf'] ?? 0)
                            .toDouble(), // Converter para double
                        ivdOperacao: itemVenda['ivdOperacao'] ?? '',
                      );
                    }).toList();
                  }

                  return VendaConferida(
                    venNumero: item['venNumero'] ?? 0,
                    entNumero: item['entNumero'],
                    cliCodigo: item['cliCodigo'] ?? 0,
                    cliNome: item['cliNome'] ?? '',
                    preCodigo: item['preCodigo'],
                    preApelido: item['preApelido'],
                    itensVenda: itensVendaList,
                  );
                } catch (e) {
                  print('Erro durante o mapeamento de itens de venda: $e');
                  return null;
                }
              })
              .whereType<VendaConferida>()
              .toList();

          // print('listaconferida : $listaDeVendasConferidas');
          redirecionar(_vendaControllerEC.text);
        } else {
          print('Erro: Resposta da API é nula');
        }

        // Faça algo com a lista de prestadores, se necessário
      } else if (response.statusCode == 422) {
        if (errorMessages != null) {
          if (errorMessages is List) {
            if (errorMessages.isNotEmpty) {
              SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
            } else {
              SnackbarUtils.exibirSnackbar(context, errorMessages[0]);

              //_exibirSnackbar('Erro na consulta');
            }
          }
        }
      } else if (response.statusCode == 401) {
        if (errorMessages != null) {
          if (errorMessages is List) {
            if (errorMessages.isNotEmpty) {
              SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
            } else {
              SnackbarUtils.exibirSnackbar(context, errorMessages[0]);

              //_exibirSnackbar('Erro na consulta');
            }
          }
        }
      } else if (message != null) {
        // Verifique se message é uma lista e trate-o adequadamente
        if (message is List) {
          if (message.isNotEmpty) {
            SnackbarUtils.exibirSnackbar(context, message[0]);
          } else {
            SnackbarUtils.exibirSnackbar(context, 'Erro na consulta');
          }
        } else {
          SnackbarUtils.exibirSnackbar(context, message);
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }
      _apiService.removeAuthorizationHeader();
    } catch (error) {
      print('Erro: $error');
      if (error is ApiResponse) {
        if (error.statusCode == 422) {
          var message = error.data['message'];
          var errorMessages = error.data['errors'];

          if (errorMessages != null) {
            if (errorMessages is List) {
              if (errorMessages.isNotEmpty) {
                SnackbarUtils.exibirSnackbar(context, errorMessages[0]);
              } else {
                SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
              }
            }
          } else if (message != null) {
            SnackbarUtils.exibirSnackbar(context, message);
          } else if (errorMessages != null) {
            SnackbarUtils.exibirSnackbar(context, 'Erro de validação');
          }
        }
      } else {
        SnackbarUtils.exibirSnackbar(context, 'Erro interno, tente novamente');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          TextFormField(
            initialValue: widget.numeroVenda,
            decoration: const InputDecoration(labelText: 'Número da Venda'),
            enabled: false,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _motoristaControllerEC,
                  readOnly: true, // Define como somente leitura
                  decoration: InputDecoration(
                    labelText: 'Motorista',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        await _consultaPrestadores();
                        if (prestadores.isNotEmpty) {
                          _mostrarDialogoMotoristas();
                        }
                      },
                    ),
                  ),
                  validator: Validatorless.multiple(
                      [Validatorless.required('Motorista é requerido')]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _observacaoControllerEC,
            decoration:
                const InputDecoration(labelText: 'Observação de Entrega'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _kmControllerEC,
            decoration: const InputDecoration(labelText: 'Kilometragem'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              } else {
                try {
                  double.parse(value);
                  return null; // É um número, aceitar
                } catch (e) {
                  return 'Deve ser um número';
                }
              }
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _statusControllerEC,
                  readOnly: true, // Define como somente leitura
                  decoration: InputDecoration(
                    labelText: 'Status',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        await _consultaStatus();
                        if (status.isNotEmpty) {
                          _mostrarDialogoStatus();
                        } else {
                          SnackbarUtils.exibirSnackbar(
                              context, 'Status nao encontrado,tente de novo');
                        }
                      },
                    ),
                  ),
                  validator: Validatorless.multiple(
                      [Validatorless.required('Status é requerido')]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          CustomElevatedButton(
            text: 'Criar Entrega ',
            icon: Icons.add,
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                await _criarEntrega();
                // if (sucesso) {
                //   _vendaControllerEC.clear();
                //   Navigator.pushReplacementNamed(context, '/conferencia');
                // }
              }
            },
          ),
          const SizedBox(height: 16),
          CustomElevatedButton(
            text: 'Relatório',
            icon: Icons.list,
            onPressed: () async {
              await _listarVendaConferida();
            },
          ),
          const SizedBox(height: 16),
          CustomElevatedButton(
            text: 'Finalizar',
            icon: Icons.exit_to_app,
            onPressed: () {
              setState(() {
                _vendaControllerEC.clear();
                Navigator.pushReplacementNamed(context, '/conferencia');
              });
            },
          ),
        ],
      ),
    );
  }
}
