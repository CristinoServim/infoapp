// import 'dart:async';
// import 'package:dio/dio.dart';

// class ApiResponse {
//   final int statusCode;
//   final dynamic data;

//   ApiResponse(this.statusCode, this.data);
// }

// abstract class HttpService {
//   Future<ApiResponse> post(String url, Map<String, dynamic> data);
//   Future<ApiResponse> patch(String url, Map<String, dynamic> data);
//   Future<ApiResponse> get(String url);

//   void setAuthorizationHeader(String token);
//   void removeAuthorizationHeader();
// }

// class DioService implements HttpService {
//   final Dio _dio;

//   DioService(this._dio) {
//     // Defina o timeout global para 15 segundos
//     _dio.options = BaseOptions(
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//     );
//   }

//   @override
//   Future<ApiResponse> post(String url, Map<String, dynamic> data) async {
//     try {
//       final response = await _dio.post(url, data: data);
//       return ApiResponse(response.statusCode!, response.data);
//     } on DioException catch (e) {
//       if (e.response != null) {
//         // O servidor respondeu, mas com um código de status de erro
//         return ApiResponse(e.response!.statusCode!, e.response!.data);
//       } else if (e.error is TimeoutException) {
//         // Timeout de conexão ou recebimento
//         return ApiResponse(408, 'Tempo limite excedido');
//       } else {
//         // Erro geral, como a falta de conexão com a internet
//         return ApiResponse(500, 'Erro na requisição');
//       }
//     } catch (e) {
//       // Outros erros não relacionados à requisição
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResponse> patch(String url, Map<String, dynamic> data) async {
//     try {
//       final response = await _dio.patch(url, data: data);
//       return ApiResponse(response.statusCode!, response.data);
//     } on DioException catch (e) {
//       if (e.response != null) {
//         // O servidor respondeu, mas com um código de status de erro
//         return ApiResponse(e.response!.statusCode!, e.response!.data);
//       } else if (e.error is TimeoutException) {
//         // Timeout de conexão ou recebimento
//         return ApiResponse(408, 'Tempo limite excedido');
//       } else {
//         // Erro geral, como a falta de conexão com a internet
//         return ApiResponse(500, 'Erro na requisição');
//       }
//     } catch (e) {
//       // Outros erros não relacionados à requisição
//       rethrow;
//     }
//   }

//   @override
//   Future<ApiResponse> get(String url) async {
//     try {
//       final response = await _dio.get(url);
//       return ApiResponse(response.statusCode!, response.data);
//     } on DioException catch (e) {
//       if (e.response != null) {
//         // O servidor respondeu, mas com um código de status de erro
//         return ApiResponse(e.response!.statusCode!, e.response!.data);
//       } else if (e.error is TimeoutException) {
//         // Timeout de conexão ou recebimento
//         return ApiResponse(408, 'Tempo limite excedido');
//       } else {
//         // Erro geral, como a falta de conexão com a internet
//         return ApiResponse(500, 'Erro na requisição');
//       }
//     } catch (e) {
//       return ApiResponse(500, 'Erro na requisição');
//     }
//   }

//   @override
//   void setAuthorizationHeader(String token) {
//     _dio.options.headers['Authorization'] = 'Bearer $token';
//   }

//   @override
//   void removeAuthorizationHeader() {
//     _dio.options.headers.remove('Authorization');
//   }
// }

// class ApiService {
//   final HttpService _httpService;

//   ApiService(this._httpService);

//   factory ApiService.create() {
//     final dioInstance = Dio();
//     final httpService = DioService(dioInstance);
//     return ApiService(httpService);
//   }

//   void setAuthorizationHeader(String token) {
//     (_httpService as DioService).setAuthorizationHeader(token);
//   }

//   void removeAuthorizationHeader() {
//     _httpService.removeAuthorizationHeader();
//   }

//   Future<ApiResponse> post(String url, Map<String, dynamic> data) async {
//     try {
//       return await _httpService.post(url, data);
//     } on TimeoutException catch (e) {
//       print('Tempo limite excedido: $e');
//       rethrow;
//     } catch (e) {
//       print('Erro durante a requisição: $e');
//       rethrow;
//     }
//   }

//   Future<ApiResponse> patch(String url, Map<String, dynamic> data) async {
//     try {
//       return await _httpService.patch(url, data);
//     } on TimeoutException catch (e) {
//       print('Tempo limite excedido: $e');
//       rethrow;
//     } catch (e) {
//       print('Erro durante a requisição: $e');
//       rethrow;
//     }
//   }

//   Future<ApiResponse> get(String url) async {
//     try {
//       return await _httpService.get(url);
//     } on TimeoutException catch (e) {
//       print('Tempo limite excedido: $e');
//       rethrow;
//     } catch (e) {
//       print('Erro durante a requisição: $e');
//       rethrow;
//     }
//   }
// }

import 'dart:async';
import 'package:dio/dio.dart';

class ApiResponse {
  final int statusCode;
  final dynamic data;

  ApiResponse(this.statusCode, this.data);
}

abstract class HttpService {
  Future<ApiResponse> post(String url, Map<String, dynamic> data);
  Future<ApiResponse> patch(String url, Map<String, dynamic> data);
  Future<ApiResponse> get(String url);

  void setAuthorizationHeader(String token);
  void removeAuthorizationHeader();
}

class DioService implements HttpService {
  final Dio _dio;

  DioService(this._dio) {
    // Defina o timeout global para 15 segundos
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    );
  }

  @override
  Future<ApiResponse> post(String url, Map<String, dynamic> data) async {
    return _executeRequest(() async {
      final response = await _dio.post(url, data: data);
      return ApiResponse(response.statusCode!, response.data);
    });
  }

  @override
  Future<ApiResponse> patch(String url, Map<String, dynamic> data) async {
    return _executeRequest(() async {
      final response = await _dio.patch(url, data: data);
      return ApiResponse(response.statusCode!, response.data);
    });
  }

  @override
  Future<ApiResponse> get(String url) async {
    return _executeRequest(() async {
      final response = await _dio.get(url);
      return ApiResponse(response.statusCode!, response.data);
    });
  }

  Future<ApiResponse> _executeRequest(
      Future<ApiResponse> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse(e.response!.statusCode!, e.response!.data);
      } else if (e.error is TimeoutException) {
        return ApiResponse(408, 'Tempo limite excedido');
      } else {
        return ApiResponse(500, 'Erro na requisição');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void setAuthorizationHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void removeAuthorizationHeader() {
    _dio.options.headers.remove('Authorization');
  }
}

class ApiService {
  final HttpService _httpService;

  ApiService(this._httpService);

  factory ApiService.create() {
    final dioInstance = Dio();
    final httpService = DioService(dioInstance);
    return ApiService(httpService);
  }

  void setAuthorizationHeader(String token) {
    (_httpService as DioService).setAuthorizationHeader(token);
  }

  void removeAuthorizationHeader() {
    _httpService.removeAuthorizationHeader();
  }

  Future<ApiResponse> post(String url, Map<String, dynamic> data) async {
    return _executeRequest(() => _httpService.post(url, data));
  }

  Future<ApiResponse> patch(String url, Map<String, dynamic> data) async {
    return _executeRequest(() => _httpService.patch(url, data));
  }

  Future<ApiResponse> get(String url) async {
    return _executeRequest(() => _httpService.get(url));
  }

  Future<ApiResponse> _executeRequest(
      Future<ApiResponse> Function() request) async {
    try {
      return await request();
    } on TimeoutException catch (e) {
      print('Tempo limite excedido: $e');
      rethrow;
    } catch (e) {
      print('Erro durante a requisição: $e');
      rethrow;
    }
  }
}
