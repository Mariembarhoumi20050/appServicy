class ChatContact {
  final String name;
  final String service;
  final String city;
  final String imageUrl;
  final List<String> starterMessages;
  final int? quotedPriceTnd;
  final int? minNegotiablePriceTnd;
  final String? issueDescription;

  ChatContact({
    required this.name,
    required this.service,
    required this.city,
    required this.imageUrl,
    required this.starterMessages,
    this.quotedPriceTnd,
    this.minNegotiablePriceTnd,
    this.issueDescription,
  });
}
