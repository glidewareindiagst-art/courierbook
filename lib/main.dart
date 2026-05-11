import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'core/app_export.dart';
import 'routes/app_routes.dart';
import 'services/auth_service.dart';
import 'services/persistent_auth_service.dart';
import 'services/supabase_service.dart';
import 'services/sync_service.dart';
import 'widgets/custom_error_widget.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
  }

  // Initialize PersistentAuthService
  try {
    await PersistentAuthService.instance.initialize();
  } catch (e) {
    debugPrint('Failed to initialize PersistentAuthService: $e');
  }

  try {
    await SupabaseService.initialize();
  } catch (e) {
    debugPrint('Failed to initialize Supabase: $e');
  }

  await _syncPersistentAuthWithFirebase();

  // Initialize Sync Service
  SyncService.instance.initialize();

  bool hasShownError = false;

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (!hasShownError) {
      hasShownError = true;

      // Reset flag after 3 seconds to allow error widget on new screens
      Future.delayed(const Duration(seconds: 5), () {
        hasShownError = false;
      });

      return CustomErrorWidget(errorDetails: details);
    }
    return const SizedBox.shrink();
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
  ]).then((value) {
    runApp(const MyApp());
  });
}

Future<void> _syncPersistentAuthWithFirebase() async {
  final user = AuthService.instance.currentUser;
  if (user == null) return;
  final stored = PersistentAuthService.instance.getUserPhone();
  final phone = (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
      ? user.phoneNumber!
      : (stored ?? '');
  try {
    await PersistentAuthService.instance.saveLoginSession(
      phoneNumber: phone,
      userId: user.uid,
    );
  } catch (e) {
    debugPrint('Failed to sync auth session to preferences: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'courierbook',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          // 🚨 END CRITICAL SECTION
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          initialRoute: _getInitialRoute(),
        );
      },
    );
  }

  String _getInitialRoute() {
    if (AuthService.instance.currentUser != null) {
      return AppRoutes.bookingsListScreen;
    }
    return AppRoutes.initial;
  }
}
