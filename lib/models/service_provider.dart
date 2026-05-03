class ServiceProvider {
  final String name;
  final String city;
  final String imageUrl;
  final double rating;
  final int basePriceTnd;
  final List<String> starterMessages;
  final double latitude;
  final double longitude;
  final List<String> availabilitySlots;
  final bool isIdentityVerified;

  const ServiceProvider({
    required this.name,
    required this.city,
    required this.imageUrl,
    required this.rating,
    required this.basePriceTnd,
    required this.starterMessages,
    required this.latitude,
    required this.longitude,
    required this.availabilitySlots,
    this.isIdentityVerified = true,
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
