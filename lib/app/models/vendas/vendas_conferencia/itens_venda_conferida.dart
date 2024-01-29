import 'package:infoapp/app/interfaces/vendas/vendas_conferencias/IItens_venda-conferida.dart';

class ItemVenda implements IItensVendaConferida {
  final String proCodigo;
  final String proDescricao;
  final int proEtiq;
  final int ivdNumero;
  final int ivdItem;
  final double ivdQtde;
  final double ivdQtdeConf;
  final String ivdOperacao;

  ItemVenda({
    required this.proCodigo,
    required this.proDescricao,
    required this.proEtiq,
    required this.ivdNumero,
    required this.ivdItem,
    required this.ivdQtde,
    required this.ivdQtdeConf,
    required this.ivdOperacao,
  });
}
