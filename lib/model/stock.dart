class Stock {
  final String name;
  final String symbol;

  final String imageUrl;
  final String description;

  Stock({
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.description,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      name: json['name'] ?? 'Unknown',
      symbol: json['symbol'] ?? 'N/A',
      imageUrl: json['image']?['url'] ?? '',
      description: json['description'] ?? 'No description available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}
