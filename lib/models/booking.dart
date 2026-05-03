import 'package:day35/services/storage_service.dart';

enum BookingStatus { pending, completed, cancelled }

class Booking {
  final String id;
  final String providerName;
  final String? clientName;
  final String serviceName;
  final String providerImageUrl;
  final String date;
  final String time;
  final int price;
  final BookingStatus status;
  final double? rating;
  final String? comment;
  final String? arrivalCode;
  final int progressStep;
  final bool safetyCodeVerified;

  Booking({
    required this.id,
    required this.providerName,
    this.clientName,
    required this.serviceName,
    required this.providerImageUrl,
    required this.date,
    required this.time,
    required this.price,
    this.status = BookingStatus.pending,
    this.rating,
    this.comment,
    this.arrivalCode,
    this.progressStep = 0,
    this.safetyCodeVerified = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'providerName': providerName,
    'clientName': clientName,
    'serviceName': serviceName,
    'providerImageUrl': providerImageUrl,
    'date': date,
    'time': time,
    'price': price,
    'status': status.index,
    'rating': rating,
    'comment': comment,
    'arrivalCode': arrivalCode,
    'progressStep': progressStep,
    'safetyCodeVerified': safetyCodeVerified,
  };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'],
    providerName: json['providerName'],
    clientName: json['clientName'],
    serviceName: json['serviceName'],
    providerImageUrl: json['providerImageUrl'],
    date: json['date'],
    time: json['time'],
    price: json['price'],
    status: BookingStatus.values[json['status'] ?? 0],
    rating: json['rating'],
    comment: json['comment'],
    arrivalCode: json['arrivalCode'],
    progressStep: (json['progressStep'] ?? 0).clamp(0, 4),
    safetyCodeVerified: json['safetyCodeVerified'] ?? false,
  );

  Booking copyWith({
    BookingStatus? status,
    double? rating,
    String? comment,
    String? arrivalCode,
    int? progressStep,
    bool? safetyCodeVerified,
    String? clientName,
  }) {
    return Booking(
      id: id,
      providerName: providerName,
      clientName: clientName ?? this.clientName,
      serviceName: serviceName,
      providerImageUrl: providerImageUrl,
      date: date,
      time: time,
      price: price,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      arrivalCode: arrivalCode ?? this.arrivalCode,
      progressStep: progressStep ?? this.progressStep,
      safetyCodeVerified: safetyCodeVerified ?? this.safetyCodeVerified,
    );
  }
}

class BookingStore {
  static final BookingStore instance = BookingStore._();
  BookingStore._();

  List<Booking> get all {
    return StorageService.instance.getBookings().map((e) => Booking.fromJson(e)).toList();
  }

  Future<void> add(Booking booking) async {
    await StorageService.instance.saveBooking(booking.toJson());
  }

  Future<void> updateStatus(String id, BookingStatus status) async {
    final List<Booking> bookings = all;
    final index = bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      bookings[index] = bookings[index].copyWith(status: status);
      await _saveAll(bookings);
    }
  }

  Future<void> completeBooking(String id, double rating, String comment) async {
    final List<Booking> bookings = all;
    final index = bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      bookings[index] = bookings[index].copyWith(
        status: BookingStatus.completed,
        rating: rating,
        comment: comment,
        progressStep: 4,
      );
      await _saveAll(bookings);
    }
  }

  Future<void> updateProgress(String id, int progressStep) async {
    final List<Booking> bookings = all;
    final int index = bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      bookings[index] = bookings[index].copyWith(
        progressStep: progressStep.clamp(0, 4),
      );
      await _saveAll(bookings);
    }
  }

  Future<void> verifySafetyCode(String id) async {
    final List<Booking> bookings = all;
    final int index = bookings.indexWhere((b) => b.id == id);
    if (index != -1) {
      bookings[index] = bookings[index].copyWith(safetyCodeVerified: true);
      await _saveAll(bookings);
    }
  }

  Future<void> _saveAll(List<Booking> bookings) async {
    await StorageService.instance.saveBookings(
      bookings.map((Booking booking) => booking.toJson()).toList(),
    );
  }
}
