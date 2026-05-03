class AgreedBooking {
  final String providerName;
  final String service;
  final String city;
  final int finalPriceTnd;
  final String issueDescription;
  final DateTime agreedAt;

  const AgreedBooking({
    required this.providerName,
    required this.service,
    required this.city,
    required this.finalPriceTnd,
    required this.issueDescription,
    required this.agreedAt,
  });
}

class BookingRepository {
  BookingRepository._();

  static final List<AgreedBooking> _items = <AgreedBooking>[];

  static List<AgreedBooking> all() {
    return List<AgreedBooking>.unmodifiable(_items.reversed);
  }

  static void add(AgreedBooking booking) {
    _items.add(booking);
  }
}
