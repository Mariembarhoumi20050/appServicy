class ServiceProvider {
  final String name;
  final String city;
  final String imageUrl;
  final double rating;
  final int basePriceTnd;
  final List<String> starterMessages;

  const ServiceProvider({
    required this.name,
    required this.city,
    required this.imageUrl,
    required this.rating,
    required this.basePriceTnd,
    required this.starterMessages,
  });
}

class ServiceExtra {
  final String name;
  final String imageUrl;
  final int priceTnd;

  const ServiceExtra({
    required this.name,
    required this.imageUrl,
    required this.priceTnd,
  });
}
