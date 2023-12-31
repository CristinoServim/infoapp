// barcode_scanner.dart

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Future<String> scanBarcode() async {
  try {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Cor de fundo do cabeçalho do scanner
      'Cancelar', // Texto do botão de cancelar
      true, // Exibir ícone de flash
      ScanMode.BARCODE, // Modo de scanner (pode ser QR_CODE também)
    );

    return barcodeScanRes;
  } catch (e) {
    // Lide com erros durante a leitura do código de barras
    print('Erro ao escanear código de barras: $e');
    return ''; // Retorna uma string vazia em caso de erro
  }
}
