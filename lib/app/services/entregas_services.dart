import 'package:infoapp/app/config/app_config.dart';
import 'package:infoapp/app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntregasService {
  final HttpService _httpService;
  static List<Map<String, dynamic>> prestadores = [];

  EntregasService(this._httpService);

  final ApiService _apiService = ApiService.create();
  final url = AppConfig.apiUrlConsultaPrestadoresConferencia;

  Future<void> consultaPrestadores() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        return;
      }

      _httpService.setAuthorizationHeader(token);

      final ApiResponse response = await _httpService.get(url);

      if (response.statusCode == 200) {
        EntregasService.prestadores =
            List<Map<String, dynamic>>.from(response.data['data']);
        print('Consulta de prestadores realizada com sucesso');
        // Faça algo com a lista de prestadores, se necessário
      } else {
        print('Erro ao consultar prestadores');
      }

      _httpService.removeAuthorizationHeader();
    } catch (error) {
      print('Erro durante a requisição: $error');
    }
  }

  // Adicione outras funções relacionadas a entregas conforme necessário
}
