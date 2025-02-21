import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_spy/auth/auth_provider.dart';
import 'package:market_spy/model/stock.dart';
import 'package:market_spy/services/api_service.dart';

final stockProvider =
    FutureProvider.family<List<Stock>, String>((ref, query) async {
  final token = ref.watch(authProvider);
  if (token == null) {
    print("Error: No token available for stock search");
    return [];
  }

  final data = await ApiService().searchStocks(query, token);
  return data.map((stock) => Stock.fromJson(stock)).toList();
});
