import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../core/app_export.dart';
import 'supabase_service.dart';
import 'google_sheets_service.dart';

class SyncService {
  static final SyncService instance = SyncService._();
  SyncService._();

  bool _isSyncing = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  void initialize() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((result) => result != ConnectivityResult.none)) {
        syncPendingData();
      }
    });
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }

  Future<void> syncPendingData() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      // 1. Sync Customers
      final pendingCustomers = await DatabaseService.instance.getPendingCustomers();
      for (var customer in pendingCustomers) {
        await _syncCustomer(customer);
      }

      // 2. Sync Bookings
      final pendingBookings = await DatabaseService.instance.getPendingBookings();
      for (var booking in pendingBookings) {
        await _syncBooking(booking);
      }
    } catch (e) {
      debugPrint('Sync error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncCustomer(CustomerModel customer) async {
    try {
      await SupabaseService.instance.upsertCustomer(customer);
      
      final updatedCustomer = customer.copyWith(
        syncStatus: SyncStatus.synced,
        updatedAt: DateTime.now(),
      );
      await DatabaseService.instance.updateCustomer(updatedCustomer);
    } catch (e) {
      debugPrint('Error syncing customer ${customer.id}: $e');
    }
  }

  Future<void> _syncBooking(BookingModel booking) async {
    try {
      // Sync to Supabase
      await SupabaseService.instance.upsertBooking(booking);
      
      // Sync to Google Sheets
      try {
        await GoogleSheetsService.instance.syncBooking(booking);
      } catch (e) {
        debugPrint('Google Sheets sync failed, but Supabase succeeded: $e');
      }
      
      final updatedBooking = booking.copyWith(
        syncStatus: SyncStatus.synced,
        updatedAt: DateTime.now(),
      );
      await DatabaseService.instance.updateBooking(updatedBooking);
    } catch (e) {
      debugPrint('Error syncing booking ${booking.id}: $e');
    }
  }
}
