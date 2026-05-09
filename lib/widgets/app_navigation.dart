import 'package:flutter/material.dart';
import '../core/app_export.dart';
import '../routes/app_routes.dart';

class AppNavigation extends StatelessWidget {
  final int currentIndex;

  const AppNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        if (index == currentIndex) return;
        final routes = [
          AppRoutes.bookingsListScreen,
          AppRoutes.bookingFormScreen,
        ];
        if (index < routes.length) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            routes[index],
            (route) => false,
          );
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.list_alt_outlined),
          selectedIcon: Icon(Icons.list_alt_rounded),
          label: 'Bookings',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_box_outlined),
          selectedIcon: Icon(Icons.add_box_rounded),
          label: 'New Booking',
        ),
      ],
    );
  }
}
