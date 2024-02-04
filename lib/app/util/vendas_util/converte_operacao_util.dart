// operacao_util.dart

class ConverteOperacaoUUtil {
  static String getDescricaoOperacao(String operacao) {
    switch (operacao) {
      case 'V':
        return 'Venda';
      case 'T':
        return 'Troca';
      case 'D':
        return 'Devolução';
      default:
        return 'Operação Desconhecida';
    }
  }
}
