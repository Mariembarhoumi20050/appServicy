import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String role; // 'User' or 'Provider'
  final String imageUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'imageUrl': imageUrl,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
    imageUrl: json['imageUrl'],
  );
}

class ChatMessage {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isMine;
  final int status; // 0 sent, 1 delivered, 2 seen

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isMine = true,
    this.status = 0,
  });

  Map<String, dynamic> toJson() => {
    'senderId': senderId,
    'receiverId': receiverId,
    'text': text,
    'timestamp': timestamp.toIso8601String(),
    'status': status,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json, String currentUserId) => ChatMessage(
    senderId: json['senderId'],
    receiverId: json['receiverId'],
    text: json['text'],
    timestamp: DateTime.parse(json['timestamp']),
    isMine: json['senderId'] == currentUserId,
    status: json['status'] ?? 0,
  );

  ChatMessage copyWith({
    String? senderId,
    String? receiverId,
    String? text,
    DateTime? timestamp,
    bool? isMine,
    int? status,
  }) {
    return ChatMessage(
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMine: isMine ?? this.isMine,
      status: status ?? this.status,
    );
  }
}

class StorageService {
  static final StorageService instance = StorageService._();
  StorageService._();

  late SharedPreferences _prefs;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  // Auth
  Future<void> saveUser(AppUser user) async {
    await _prefs.setString('current_user', jsonEncode(user.toJson()));
  }

  AppUser? getUser() {
    final String? userStr = _prefs.getString('current_user');
    if (userStr == null) return null;
    return AppUser.fromJson(jsonDecode(userStr));
  }

  Future<void> logout() async {
    await _prefs.remove('current_user');
  }

  // Chats
  Future<void> saveMessage(ChatMessage msg) async {
    final List<String> history = _prefs.getStringList('chat_history') ?? [];
    history.add(jsonEncode(msg.toJson()));
    await _prefs.setStringList('chat_history', history);
  }

  List<ChatMessage> getChatHistory(String userId, String otherId) {
    final List<String> history = _prefs.getStringList('chat_history') ?? [];
    final currentUser = getUser();
    if (currentUser == null) return [];

    return history
        .map((e) => ChatMessage.fromJson(jsonDecode(e), currentUser.id))
        .where((m) =>
            (m.senderId == userId && m.receiverId == otherId) ||
            (m.senderId == otherId && m.receiverId == userId))
        .toList();
  }

  // Bookings
  Future<void> saveBooking(Map<String, dynamic> booking) async {
    final List<String> bookings = _prefs.getStringList('bookings') ?? [];
    bookings.add(jsonEncode(booking));
    await _prefs.setStringList('bookings', bookings);
  }

  Future<void> saveBookings(List<Map<String, dynamic>> bookings) async {
    final List<String> encoded = bookings.map(jsonEncode).toList();
    await _prefs.setStringList('bookings', encoded);
  }

  List<Map<String, dynamic>> getBookings() {
    final List<String> bookings = _prefs.getStringList('bookings') ?? [];
    return bookings.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  // Safety
  Future<void> saveEmergencyContact(String contact) async {
    await _prefs.setString('emergency_contact', contact.trim());
  }

  String getEmergencyContact() {
    return _prefs.getString('emergency_contact') ?? '';
  }
}
