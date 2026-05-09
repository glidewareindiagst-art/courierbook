import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_navigation.dart';
import './widgets/booking_card_widget.dart';
import './widgets/booking_filter_chips_widget.dart';
import './widgets/section_header_widget.dart';
import './widgets/summary_banner_widget.dart';

// ─── Data Model ───────────────────────────────────────────────
enum PaymentType { cod, prepaid }

enum SyncStatus { synced, pending, offline }

class BookingModel {
  final String id;
  final String consignmentNumber;
  final String customerName;
  final String mobileNumber;
  final double weight;
  final double chargedAmount;
  final double costAmount;
  final double profit;
  final PaymentType paymentType;
  final double codAmount;
  final String courierName;
  final DateTime createdAt;
  final SyncStatus syncStatus;

  BookingModel({
    required this.id,
    required this.consignmentNumber,
    required this.customerName,
    required this.mobileNumber,
    required this.weight,
    required this.chargedAmount,
    required this.costAmount,
    required this.profit,
    required this.paymentType,
    required this.codAmount,
    required this.courierName,
    required this.createdAt,
    required this.syncStatus,
  });

  static PaymentType _paymentFromString(String v) {
    switch (v) {
      case 'prepaid':
        return PaymentType.prepaid;
      default:
        return PaymentType.cod;
    }
  }

  static SyncStatus _syncFromString(String v) {
    switch (v) {
      case 'synced':
        return SyncStatus.synced;
      case 'offline':
        return SyncStatus.offline;
      default:
        return SyncStatus.pending;
    }
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    final charged = (map['chargedAmount'] as num).toDouble();
    final cost = (map['costAmount'] as num).toDouble();
    return BookingModel(
      id: map['id'] as String,
      consignmentNumber: map['consignmentNumber'] as String,
      customerName: map['customerName'] as String,
      mobileNumber: map['mobileNumber'] as String,
      weight: (map['weight'] as num).toDouble(),
      chargedAmount: charged,
      costAmount: cost,
      profit: charged - cost,
      paymentType: _paymentFromString(map['paymentType'] as String),
      codAmount: (map['codAmount'] as num).toDouble(),
      courierName: map['courierName'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      syncStatus: _syncFromString(map['syncStatus'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'consignmentNumber': consignmentNumber,
    'customerName': customerName,
    'mobileNumber': mobileNumber,
    'weight': weight,
    'chargedAmount': chargedAmount,
    'costAmount': costAmount,
    'paymentType': paymentType == PaymentType.cod ? 'cod' : 'prepaid',
    'codAmount': codAmount,
    'courierName': courierName,
    'createdAt': createdAt.toIso8601String(),
    'syncStatus': syncStatus.name,
  };
}

// ─── Mock Data ────────────────────────────────────────────────
final List<Map<String, dynamic>> _mockBookingMaps = [
  {
    'id': 'b001',
    'consignmentNumber': 'CB2024051901',
    'customerName': 'Priya Subramaniam',
    'mobileNumber': '9876543210',
    'weight': 1.5,
    'chargedAmount': 180.0,
    'costAmount': 110.0,
    'paymentType': 'cod',
    'codAmount': 1200.0,
    'courierName': 'DTDC',
    'createdAt': '2026-05-09T09:15:00',
    'syncStatus': 'synced',
  },
  {
    'id': 'b002',
    'consignmentNumber': 'CB2024051902',
    'customerName': 'Arjun Mehta',
    'mobileNumber': '9123456780',
    'weight': 3.2,
    'chargedAmount': 320.0,
    'costAmount': 210.0,
    'paymentType': 'prepaid',
    'codAmount': 0.0,
    'courierName': 'BlueDart',
    'createdAt': '2026-05-09T10:22:00',
    'syncStatus': 'synced',
  },
  {
    'id': 'b003',
    'consignmentNumber': 'CB2024051903',
    'customerName': 'Fatima Noor',
    'mobileNumber': '9988776655',
    'weight': 0.8,
    'chargedAmount': 95.0,
    'costAmount': 65.0,
    'paymentType': 'cod',
    'codAmount': 450.0,
    'courierName': 'Delhivery',
    'createdAt': '2026-05-09T11:05:00',
    'syncStatus': 'pending',
  },
  {
    'id': 'b004',
    'consignmentNumber': 'CB2024051904',
    'customerName': 'Ravi Shankar Pillai',
    'mobileNumber': '9012345678',
    'weight': 5.0,
    'chargedAmount': 520.0,
    'costAmount': 390.0,
    'paymentType': 'prepaid',
    'codAmount': 0.0,
    'courierName': 'Ekart',
    'createdAt': '2026-05-09T12:30:00',
    'syncStatus': 'offline',
  },
  {
    'id': 'b005',
    'consignmentNumber': 'CB2024051905',
    'customerName': 'Sunita Devi',
    'mobileNumber': '8765432109',
    'weight': 2.1,
    'chargedAmount': 240.0,
    'costAmount': 170.0,
    'paymentType': 'cod',
    'codAmount': 850.0,
    'courierName': 'DTDC',
    'createdAt': '2026-05-09T13:45:00',
    'syncStatus': 'synced',
  },
  {
    'id': 'b006',
    'consignmentNumber': 'CB2024051906',
    'customerName': 'Mohammed Irfan',
    'mobileNumber': '7654321098',
    'weight': 1.0,
    'chargedAmount': 130.0,
    'costAmount': 95.0,
    'paymentType': 'prepaid',
    'codAmount': 0.0,
    'courierName': 'Xpressbees',
    'createdAt': '2026-05-08T09:00:00',
    'syncStatus': 'synced',
  },
  {
    'id': 'b007',
    'consignmentNumber': 'CB2024051907',
    'customerName': 'Kavitha Ramachandran',
    'mobileNumber': '9345678901',
    'weight': 4.5,
    'chargedAmount': 480.0,
    'costAmount': 360.0,
    'paymentType': 'cod',
    'codAmount': 2200.0,
    'courierName': 'BlueDart',
    'createdAt': '2026-05-08T11:20:00',
    'syncStatus': 'synced',
  },
  {
    'id': 'b008',
    'consignmentNumber': 'CB2024051908',
    'customerName': 'Deepak Verma',
    'mobileNumber': '8901234567',
    'weight': 0.5,
    'chargedAmount': 75.0,
    'costAmount': 55.0,
    'paymentType': 'prepaid',
    'codAmount': 0.0,
    'courierName': 'Delhivery',
    'createdAt': '2026-05-08T14:10:00',
    'syncStatus': 'pending',
  },
];

// ─── Screen ───────────────────────────────────────────────────
class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> {
  // TODO: Replace with Riverpod/Bloc for production
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
    _allBookings = _mockBookingMaps.map(BookingModel.fromMap).toList();
    // Simulate initial load
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _isLoading = false);
    });
    _applyFilters();
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

  Future<void> _onRefresh() async {
    setState(() => _isSyncing = true);
    // TODO: Replace with actual Google Sheets API sync
    await Future.delayed(const Duration(milliseconds: 1500));
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
        label =
            '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
      }
      groups.putIfAbsent(label, () => []).add(b);
    }
    return groups;
  }

  // Today's stats
  List<BookingModel> get _todayBookings {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    return _allBookings.where((b) => b.createdAt.isAfter(start)).toList();
  }

  double get _todayTotalCharged =>
      _todayBookings.fold(0, (sum, b) => sum + b.chargedAmount);
  double get _todayTotalProfit =>
      _todayBookings.fold(0, (sum, b) => sum + b.profit);
  double get _todayCodPending => _todayBookings
      .where((b) => b.paymentType == PaymentType.cod)
      .fold(0, (sum, b) => sum + b.codAmount);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final groups = _groupedBookings;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: const Color(0x1A1565C0),
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CourierBook',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A2340),
              ),
            ),
            Text(
              'All Bookings',
              style: GoogleFonts.ibmPlexSans(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF546E7A),
              ),
            ),
          ],
        ),
        actions: [
          // Sync button
          IconButton(
            onPressed: _isSyncing ? null : _onRefresh,
            icon: _isSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primary,
                    ),
                  )
                : const Icon(
                    Icons.sync_rounded,
                    color: AppTheme.primary,
                    size: 22,
                  ),
            tooltip: 'Sync with Google Sheets',
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.signUpLoginScreen),
            icon: const Icon(
              Icons.logout_rounded,
              color: Color(0xFF90A4AE),
              size: 22,
            ),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 16,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      // Summary Banner
                      SummaryBannerWidget(
                        bookingCount: _todayBookings.length,
                        totalCharged: _todayTotalCharged,
                        totalProfit: _todayTotalProfit,
                        codPending: _todayCodPending,
                      ),
                      const SizedBox(height: 14),

                      // Search Bar
                      _SearchBarWidget(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                      ),
                      const SizedBox(height: 10),

                      // Filter Chips
                      BookingFilterChipsWidget(
                        activeFilter: _activeFilter,
                        onFilterChanged: _onFilterChanged,
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),

              // Content
              if (_isLoading)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => const BookingCardSkeletonWidget(),
                    childCount: 5,
                  ),
                )
              else if (_filteredBookings.isEmpty)
                SliverFillRemaining(
                  child: EmptyStateWidget(
                    iconName: 'local_shipping',
                    title: 'No bookings found',
                    subtitle: _searchQuery.isNotEmpty
                        ? 'No results for "$_searchQuery". Try a different search.'
                        : 'No bookings match the selected filter. Create a new booking to get started.',
                    actionLabel: 'New Booking',
                    onAction: () => Navigator.pushNamed(
                      context,
                      AppRoutes.bookingFormScreen,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 16,
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
        onPressed: () =>
            Navigator.pushNamed(context, AppRoutes.bookingFormScreen),
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

class _SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBarWidget({required this.controller, required this.onChanged});

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
              controller: controller,
              onChanged: onChanged,
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
          if (controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                controller.clear();
                onChanged('');
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