
import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/credentials_info_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/role_toggle_widget.dart';

class SignUpLoginScreen extends StatefulWidget {
  const SignUpLoginScreen({super.key});

  @override
  State<SignUpLoginScreen> createState() => _SignUpLoginScreenState();
}

class _SignUpLoginScreenState extends State<SignUpLoginScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  int _selectedRole = 0; // 0 = Admin, 1 = Staff
  bool _isLoading = false;
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
    _logoController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  void _onRoleChanged(int role) {
    setState(() => _selectedRole = role);
  }

  void _onLogin(String email, String password) async {
    setState(() => _isLoading = true);
    // TODO: Replace with real auth API call (Firebase/backend)
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Mock credential validation
    final adminEmail = 'admin@courierbook.in';
    final staffEmail = 'staff@courierbook.in';
    final validPassword = 'courier@2024';

    bool valid = false;
    if (_selectedRole == 0 &&
        email == adminEmail &&
        password == validPassword) {
      valid = true;
    } else if (_selectedRole == 1 &&
        email == staffEmail &&
        password == validPassword) {
      valid = true;
    }

    if (valid) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.bookingsListScreen,
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid credentials — use the demo accounts below to sign in',
            style: GoogleFonts.ibmPlexSans(fontSize: 13),
          ),
          backgroundColor: AppTheme.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 480 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Animated Logo
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primary.withAlpha(77),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_shipping_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'CourierBook',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A2340),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Fast. Reliable. Always in sync.',
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF546E7A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Role Toggle
                  RoleToggleWidget(
                    selectedRole: _selectedRole,
                    onRoleChanged: _onRoleChanged,
                  ),

                  const SizedBox(height: 24),

                  // Login Form
                  LoginFormWidget(
                    isLoading: _isLoading,
                    selectedRole: _selectedRole,
                    onLogin: _onLogin,
                  ),

                  const SizedBox(height: 24),

                  // Demo Credentials Info
                  CredentialsInfoWidget(selectedRole: _selectedRole),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
