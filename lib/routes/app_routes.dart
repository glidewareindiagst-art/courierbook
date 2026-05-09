import 'package:flutter/material.dart';

import '../presentation/booking_form_screen/booking_form_screen.dart';
import '../presentation/bookings_list_screen/bookings_list_screen.dart';
import '../presentation/sign_up_login_screen/sign_up_login_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String signUpLoginScreen = '/sign-up-login-screen';
  static const String bookingFormScreen = '/booking-form-screen';
  static const String bookingsListScreen = '/bookings-list-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SignUpLoginScreen(),
    signUpLoginScreen: (context) => const SignUpLoginScreen(),
    bookingFormScreen: (context) => const BookingFormScreen(),
    bookingsListScreen: (context) => const BookingsListScreen(),
  };
}
