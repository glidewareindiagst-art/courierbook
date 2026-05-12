import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_navigation.dart';
import '../../services/auth_service.dart';
import './widgets/booking_card_widget.dart';
import './widgets/booking_filter_chips_widget.dart';
import './widgets/section_header_widget.dart';
import './widgets/summary_banner_widget.dart';

// ─── Screen ───────────────────────────────────────────────────
class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> {
  List<BookingModel> _allBookings = [];
  List<BookingModel> _filteredBookings = [];
  String _activeFilter = 'All';
  String _searchQuery = '';
  bool _isLoading = true;
  bool _isSyncing = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);
    try {
      final bookings = await DatabaseService.instance.readAllBookings();
      if (mounted) {
        setState(() {
          _allBookings = bookings;
          _isLoading = false;
          _applyFilters();
        });
      }
    } catch (e) {
      debugPrint('Error loading bookings: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    List<BookingModel> result = List.from(_allBookings);

    // Filter
    switch (_activeFilter) {
      case 'COD':
        result = result.where((b) => b.paymentType == PaymentType.cod).toList();
        break;
      case 'Prepaid':
        result = result
            .where((b) => b.paymentType == PaymentType.prepaid)
            .toList();
        break;
      case 'Today':
        result = result.where((b) => b.createdAt.isAfter(todayStart)).toList();
        break;
      case 'Synced':
        result = result
            .where((b) => b.syncStatus == SyncStatus.synced)
            .toList();
        break;
    }

    // Search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where(
            (b) =>
                b.consignmentNumber.toLowerCase().contains(q) ||
                b.customerName.toLowerCase().contains(q) ||
                b.mobileNumber.contains(q) ||
                b.courierName.toLowerCase().contains(q),
          )
          .toList();
    }

    setState(() => _filteredBookings = result);
  }

  void _onFilterChanged(String filter) {
    setState(() => _activeFilter = filter);
    _applyFilters();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
    _applyFilters();
  }

  Widget _buildSummaryBanner() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrow = todayStart.add(const Duration(days: 1));
    final todayBookings = _allBookings
        .where(
          (b) =>
              !b.createdAt.isBefore(todayStart) && b.createdAt.isBefore(tomorrow),
        )
        .toList();
    final totalCharged = todayBookings.fold<double>(
      0,
      (s, b) => s + b.chargedAmount,
    );
    final totalProfit =
        todayBookings.fold<double>(0, (s, b) => s + b.profit);
    final codPending = todayBookings
        .where((b) => b.paymentType == PaymentType.cod)
        .fold<double>(0, (s, b) => s + b.codAmount);
    return SummaryBannerWidget(
      bookingCount: todayBookings.length,
      totalCharged: totalCharged,
      totalProfit: totalProfit,
      codPending: codPending,
    );
  }

  Future<void> _onRefresh() async {
    setState(() => _isSyncing = true);
    // TODO: Replace with actual Google Sheets API sync
    await Future.delayed(const Duration(milliseconds: 1500));
    await _loadBookings();
    if (!mounted) return;
    setState(() => _isSyncing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cloud_done_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'Synced with Google Sheets',
              style: GoogleFonts.ibmPlexSans(fontSize: 13),
            ),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Group bookings by date
  Map<String, List<BookingModel>> get _groupedBookings {
    final Map<String, List<BookingModel>> groups = {};
    final now = DateTime.now();
    for (final b in _filteredBookings) {
      final d = b.createdAt;
      String label;
      if (d.year == now.year && d.month == now.month && d.day == now.day) {
        label = 'Today';
      } else if (d.year == now.year &&
          d.month == now.month &&
          d.day == now.day - 1) {
        label = 'Yesterday';
      } else {
        label = '${d.day}/${d.month}/${d.year}';
      }

      if (!groups.containsKey(label)) {
        groups[label] = [];
      }
      groups[label]!.add(b);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final groups = _groupedBookings;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Courier Book',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A2340),
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Manage your daily bookings',
                            style: GoogleFonts.ibmPlexSans(
                              fontSize: 13,
                              color: const Color(0xFF90A4AE),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      if (_isSyncing)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primary,
                          ),
                        )
                      else
                        IconButton(
                          onPressed: _onRefresh,
                          icon: const Icon(
                            Icons.sync_rounded,
                            color: AppTheme.primary,
                            size: 22,
                          ),
                          tooltip: 'Sync with Sheets',
                        ),
                      IconButton(
                        onPressed: () async {
                          await AuthService.instance.signOut();
                          if (!mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.signUpLoginScreen,
                            (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: AppTheme.errorColor,
                          size: 22,
                        ),
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: _buildSummaryBanner(),
              ),

              // Search & Filters
              SliverAppBar(
                pinned: true,
                floating: false,
                elevation: 0,
                backgroundColor: AppTheme.backgroundLight,
                automaticallyImplyLeading: false,
                toolbarHeight: 110,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _SearchBarWidget(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                      ),
                      const SizedBox(height: 12),
                      BookingFilterChipsWidget(
                        activeFilter: _activeFilter,
                        onFilterChanged: _onFilterChanged,
                      ),
                    ],
                  ),
                ),
              ),

              // List
              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(child: LoadingSkeletonWidget()),
                )
              else if (_filteredBookings.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyStateWidget(
                    height: 320,
                    iconName: 'search',
                    title: _searchQuery.isEmpty
                        ? 'No bookings yet'
                        : 'No results found',
                    subtitle: _searchQuery.isEmpty
                        ? 'Tap the + button to create your first booking.'
                        : 'Try adjusting your search or filters.',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final keys = groups.keys.toList();
                        int itemIndex = 0;
                        for (final key in keys) {
                          if (index == itemIndex) {
                            // Section header
                            return Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 4),
                              child: SectionHeaderWidget(
                                label: key,
                                count: groups[key]!.length,
                              ),
                            );
                          }
                          itemIndex++;
                          final groupItems = groups[key]!;
                          for (int i = 0; i < groupItems.length; i++) {
                            if (index == itemIndex) {
                              return _AnimatedBookingCard(
                                booking: groupItems[i],
                                animationIndex: itemIndex,
                              );
                            }
                            itemIndex++;
                          }
                        }
                        return null;
                      },
                      childCount: groups.entries.fold<int>(
                        0,
                        (sum, e) => sum + 1 + e.value.length,
                      ),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AppRoutes.bookingFormScreen);
          if (result == true) {
            _loadBookings();
          }
        },
        icon: const Icon(Icons.add_rounded, size: 20),
        label: Text(
          'New Booking',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: const AppNavigation(currentIndex: 0),
    );
  }
}

class _AnimatedBookingCard extends StatefulWidget {
  final BookingModel booking;
  final int animationIndex;

  const _AnimatedBookingCard({
    required this.booking,
    required this.animationIndex,
  });

  @override
  State<_AnimatedBookingCard> createState() => _AnimatedBookingCardState();
}

class _AnimatedBookingCardState extends State<_AnimatedBookingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0.05, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    final delay = Duration(
      milliseconds: (widget.animationIndex * 40).clamp(0, 400),
    );
    Future.delayed(delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: BookingCardWidget(booking: widget.booking),
        ),
      ),
    );
  }
}

class _SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBarWidget({required this.controller, required this.onChanged});

  @override
  State<_SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<_SearchBarWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.outlineVariantLight),
        boxShadow: [
          BoxShadow(
            color: const Color(0x061565C0),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search_rounded, size: 18, color: Color(0xFF90A4AE)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              style: GoogleFonts.ibmPlexSans(
                fontSize: 14,
                color: const Color(0xFF1A2340),
              ),
              decoration: InputDecoration(
                hintText: 'Search by consignment, customer, courier...',
                hintStyle: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  color: const Color(0xFF90A4AE),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if (widget.controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                widget.controller.clear();
                widget.onChanged('');
              },
              icon: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Color(0xFF90A4AE),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
