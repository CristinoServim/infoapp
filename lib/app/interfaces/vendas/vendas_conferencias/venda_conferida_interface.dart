import 'package:infoapp/app/interfaces/vendas/vendas_conferencias/IItens_venda-conferida.dart';

abstract class IVendaConferidaInterface {
  int get venNumero;
  int get cliCodigo;
  String get cliNome;
  List<IItensVendaConferida> get itensVenda;
}
