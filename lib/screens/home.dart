import 'package:flutter/material.dart';
import 'package:market_spy/model/stock.dart';
import 'package:market_spy/screens/stock_detail_screen.dart';
import 'package:market_spy/services/storage_service.dart';

import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  bool hasSearched = false;

  void _searchStocks() async {
    String query = searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      hasSearched = true;
    });

    String? token = await StorageService.getToken();
    if (token == null) {
      setState(() => isLoading = false);
      _showError("Authentication error: Token missing.");
      return;
    }

    try {
      List<Map<String, dynamic>> results =
          await ApiService().searchStocks(query, token);

      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (error) {
      setState(() => isLoading = false);
      _showError("Failed to fetch stock data.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToStockDetails(Map<String, dynamic> stockData) {
    Stock stock = Stock.fromJson(stockData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StockDetailsScreen(stock: stock),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade600],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Stocks Search',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 6,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    enableInteractiveSelection: false,
                    cursorColor: Colors.blue.shade600,
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Enter stock name",
                      hintStyle: TextStyle(color: Colors.blue.shade600),
                      prefixIcon:
                          Icon(Icons.search, color: Colors.blue.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: (_) => _searchStocks(),
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.white54,
                      ))
                    : Expanded(
                        child: searchResults.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                        hasSearched
                                            ? Icons.search_off
                                            : Icons.search,
                                        size: 80,
                                        color: Colors.white54),
                                    SizedBox(height: 10),
                                    Text(
                                      hasSearched
                                          ? "No stocks found."
                                          : "Search for stocks above.",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white54),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: searchResults.length,
                                itemBuilder: (context, index) {
                                  final stock = searchResults[index];
                                  return Card(
                                    // color: Colors.grey[50],
                                    surfaceTintColor: Colors.transparent,
                                    elevation: 3,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Colors.grey[350]!),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(8),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: stock['image'] != null &&
                                                stock['image']['url'] != null &&
                                                stock['image']['url'].isNotEmpty
                                            ? Image.network(
                                                stock['image']['url'],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        size: 50,
                                                        color: Colors.grey),
                                              )
                                            : Icon(Icons.image,
                                                size: 50, color: Colors.grey),
                                      ),
                                      title: Text(
                                        stock['name'] ?? "Unknown Stock",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      subtitle: Text(
                                        stock['symbol'] ??
                                            "No symbol available",
                                        style:
                                            TextStyle(color: Colors.grey[700]),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          color: Colors.blue.shade600),
                                      onTap: () =>
                                          _navigateToStockDetails(stock),
                                    ),
                                  );
                                },
                              ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
