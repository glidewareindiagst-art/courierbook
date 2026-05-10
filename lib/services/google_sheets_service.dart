import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../data/models/booking_model.dart';

class GoogleSheetsService {
  static final GoogleSheetsService instance = GoogleSheetsService._();
  GoogleSheetsService._();

  final Dio _dio = Dio();
  
  // This should be your Google Apps Script Web App URL
  static const String scriptUrl = String.fromEnvironment('GOOGLE_SHEETS_SCRIPT_URL', defaultValue: '');

  Future<void> syncBooking(BookingModel booking) async {
    if (scriptUrl.isEmpty) {
      debugPrint('Google Sheets Script URL not configured');
      return;
    }

    try {
      await _dio.post(
        scriptUrl,
        data: booking.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
    } catch (e) {
      debugPrint('Error syncing to Google Sheets: $e');
      rethrow;
    }
  }
}
