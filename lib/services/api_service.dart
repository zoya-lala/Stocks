import 'package:dio/dio.dart';
import 'package:market_spy/services/storage_service.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://illuminate-production.up.railway.app/api"),
  );

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/local',
        data: {
          "identifier": email,
          "password": password,
        },
      );
      await StorageService.saveToken(response.data["jwt"]);

      return response.data["jwt"];
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> searchStocks(
      String query, String? token) async {
    if (token == null) {
      return [];
    }

    if (query.isEmpty) {
      return [];
    }

    try {
      final response = await _dio.get(
        '/stocks/search',
        queryParameters: {"query": query},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      return [];
    }
  }
}
