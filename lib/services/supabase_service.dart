import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/booking_model.dart';
import '../data/models/customer_model.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  // Initialize Supabase - call this in main()
  static Future<void> initialize() async {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception(
          'SUPABASE_URL and SUPABASE_ANON_KEY must be defined using --dart-define.');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  // Get Supabase client
  SupabaseClient get client => Supabase.instance.client;

  Future<void> upsertBooking(BookingModel booking) async {
    await client.from('bookings').upsert(booking.toJson());
  }

  Future<void> upsertCustomer(CustomerModel customer) async {
    await client.from('customers').upsert(customer.toJson());
  }

  Stream<List<Map<String, dynamic>>> subscribeToBookings() {
    return client.from('bookings').stream(primaryKey: ['id']);
  }

  Stream<List<Map<String, dynamic>>> subscribeToCustomers() {
    return client.from('customers').stream(primaryKey: ['id']);
  }
}
