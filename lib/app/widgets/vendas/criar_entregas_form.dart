import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:infoapp/app/config/app_config.dart';
import 'package:infoapp/app/models/vendas/vendas_conferencia/prestador_ent.dart';
import 'package:infoapp/app/models/vendas/vendas_conferencia/status_ent_conferencia.dart';
import 'package:infoapp/app/services/api_service.dart';
import 'package:infoapp/app/util/SnackbarUtils.dart';
import 'package:infoapp/app/util/parse_util.dart';
import 'package:infoapp/app/widgets/buttons/custon_elevated_button.dart';
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
        var message = response.data['message'];

        if (message != null) {
          if (statusCode == 201) {
            setState(() {});
            SnackbarUtils.exibirSnackbar(
                context, response.data['message'].toString(),
                statusCode: response.statusCode);
            _apiService.removeAuthorizationHeader();
            return true;
          } else {
            SnackbarUtils.exibirSnackbar(
                context, 'Erro interno, tente novamente.');
          }
        } else {
          SnackbarUtils.exibirSnackbar(
              context, 'Erro interno, tente novamente.');
        }
      }
      _apiService.removeAuthorizationHeader();
    } catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 422) {
          var errorMessage = error.response?.data['message'];
          var errorMessages = error.response?.data['errors'];

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
            text: 'Criar Entrega e Finalizar',
            icon: Icons.add,
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                bool sucesso = await _criarEntrega();
                if (sucesso) {
                  _vendaControllerEC.clear();
                  Navigator.pushReplacementNamed(context, '/conferencia');
                }
              }
            },
          ),
          const SizedBox(height: 16),
          CustomElevatedButton(
            text: 'Finalizar sem Entrega',
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
