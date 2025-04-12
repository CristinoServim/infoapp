class AppConfig {
  static const String apiUrlBase =
      'https://api.infobrasilsistemas.com.br/v1-ibra';
  //static const String apiUrlBase = 'http://192.168.1.210:5003/v1-ibra';
  // static const String apiUrlBase = 'http://192.168.253.94:5003/v1-ibra';
  //urls auth
  static const String apiUrlLogin = '$apiUrlBase/login';
  static const String apiUrlSignup = '$apiUrlBase/signup';
  //urls VendasConferencia
  static const String apiUrlVendasConferencias =
      '$apiUrlBase/vendasconferencias';
  static const String apiUrlvendasConfTotal =
      '$apiUrlBase/consultarvendasconftotal';
  static const String apiUrlVendaConferida =
      '$apiUrlBase/listarVendasConferida';

  //urls entregasconferencia
  static const String apiUrlCriarEntregasConferencia =
      '$apiUrlBase/criarentregasconferencias';
  static const String apiUrlConsultaPrestadoresConferencia =
      '$apiUrlBase/prestadoresentregasconferencias';
  static const String apiUrlConsultaStatusEnt =
      '$apiUrlBase/consulta-status-entregas';
}
