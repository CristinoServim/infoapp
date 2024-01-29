import 'package:infoapp/app/interfaces/vendas/vendas_conferencias/IItens_venda-conferida.dart';
import 'package:infoapp/app/interfaces/vendas/vendas_conferencias/venda_conferida_interface.dart';

class VendaConferida implements IVendaConferidaInterface {
  final int venNumero;
  final int? entNumero;
  final int cliCodigo;
  final String cliNome;
  final int? preCodigo;
  final String? preApelido;
  final List<IItensVendaConferida> itensVenda;

  VendaConferida({
    required this.venNumero,
    this.entNumero,
    required this.cliCodigo,
    required this.cliNome,
    this.preCodigo,
    this.preApelido,
    required this.itensVenda,
  });

  factory VendaConferida.fromJson(Map<String, dynamic> json) {
    return VendaConferida(
      venNumero: json['venNumero'],
      entNumero: json['entNumero'],
      cliCodigo: json['cliCodigo'],
      cliNome: json['cliNome'],
      preCodigo: json['preCodigo'],
      preApelido: json['preApelido'],
      itensVenda: [],
    );
  }
  @override
  String toString() {
    return 'VendaConferida(venNumero: $venNumero, entNumero: $entNumero, cliCodigo: $cliCodigo, cliNome: $cliNome, preCodigo: $preCodigo, preApelido: $preApelido, itensVenda: $itensVenda)';
  }
}
