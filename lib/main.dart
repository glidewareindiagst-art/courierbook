import 'package:flutter/services.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';
import './routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'services/supabase_service.dart';
import 'services/sync_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'services/persistent_auth_service.dart';

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

  // Initialize Supabase
  try {
    await SupabaseService.initialize();
  } catch (e) {
    debugPrint('Failed to initialize Supabase: $e');
  }

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
    // Check if user is logged in with Firebase
    final isFirebaseLoggedIn = AuthService.instance.isLoggedIn;
    
    // Check if persistent session exists
    final hasSession = PersistentAuthService.instance.hasActiveSession();
    
    // Validate session
    final isSessionValid = PersistentAuthService.instance.isSessionValid();

    if (isFirebaseLoggedIn && hasSession && isSessionValid) {
      // User has valid session - go to main app
      return AppRoutes.bookingsListScreen;
    }

    // No valid session - go to login
    return AppRoutes.initial;
  }
}
