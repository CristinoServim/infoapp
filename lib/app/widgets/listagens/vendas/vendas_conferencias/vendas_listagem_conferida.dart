import 'package:flutter/material.dart';
import 'package:infoapp/app/interfaces/vendas/vendas_conferencias/venda_conferida_interface.dart';
import 'package:infoapp/app/util/vendas_util/converte_operacao_util.dart';
import 'package:infoapp/app/widgets/buttons/custon_elevated_button.dart';

class VendasList extends StatelessWidget {
  final List<IVendaConferidaInterface> listaDeVendasConferidas;

  VendasList({
    required this.listaDeVendasConferidas,
  });
  @override
  Widget build(BuildContext context) {
    print(listaDeVendasConferidas);
    return ListView.builder(
      itemCount: listaDeVendasConferidas.length,
      itemBuilder: (context, index) {
        var venda = listaDeVendasConferidas[index];

        return Material(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                child: ListTile(
                  title: Text(
                    'Venda nº: ${venda.venNumero}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
                child: ListTile(
                  title: Text(
                    'Cliente: ${venda.cliCodigo} - ${venda.cliNome}',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Substitua pela cor desejada
                    ),
                  ),
                  // Adicione mais informações conforme necessário
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                height: 5,
                color: Theme.of(context).colorScheme.primary,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: venda.itensVenda
                        .map(
                          (item) => Column(
                            children: [
                              ListTile(
                                title: Text('Produto: ${item.proDescricao}'),
                                subtitle: Text(
                                  'Qtde Venda: ${item.ivdQtde} | Qtde a Conferir: ${item.ivdQtde * item.proEtiq}  | Qtde Conferida: ${item.ivdQtdeConf} | Operação: ${ConverteOperacaoUUtil.getDescricaoOperacao(item.ivdOperacao)}',
                                ),
                                // Adicione mais informações conforme necessário
                              ),
                              Divider(
                                  height: 1,
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Alinha o botão à direita
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      text: 'Fechar',
                      icon: Icons.list,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40)
            ],
          ),
        );
      },
    );
  }
}
