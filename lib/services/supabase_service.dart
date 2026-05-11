import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/models/booking_model.dart';
import '../data/models/customer_model.dart';

class SupabaseService {
  SupabaseService._();
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  static bool _initialized = false;

  static bool get isReady => _initialized;

  static Future<void> initialize() async {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      debugPrint(
        'Supabase: SUPABASE_URL / SUPABASE_ANON_KEY not set; remote sync disabled.',
      );
      return;
    }
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _initialized = true;
  }

  SupabaseClient get client {
    if (!_initialized) {
      throw StateError('Supabase is not initialized');
    }
    return Supabase.instance.client;
  }

  Future<void> upsertBooking(BookingModel booking) async {
    await client.from('bookings').upsert(booking.toJson());
  }

  Future<void> upsertCustomer(CustomerModel customer) async {
    await client.from('customers').upsert(customer.toJson());
  }

  Stream<List<Map<String, dynamic>>> subscribeToBookings() {
    return client.from('bookings').stream(primaryKey: ['id']);
  }
}
