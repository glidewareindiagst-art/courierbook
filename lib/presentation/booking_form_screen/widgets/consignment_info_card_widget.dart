import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../theme/app_theme.dart';

class ConsignmentInfoCardWidget extends StatelessWidget {
  final TextEditingController consignmentController;
  final TextEditingController courierNameController;
  final ValueChanged<String> onScanned;

  const ConsignmentInfoCardWidget({
    super.key,
    required this.consignmentController,
    required this.courierNameController,
    required this.onScanned,
  });

  void _openScanner(BuildContext context) {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Barcode scanner is available on Android device',
            style: GoogleFonts.ibmPlexSans(fontSize: 13),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => _BarcodeScannerPage(onScanned: onScanned),
        transitionDuration: const Duration(milliseconds: 220),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _FormGroupCard(
      title: 'Consignment Info',
      iconName: 'receipt',
      children: [
        TextFormField(
          controller: consignmentController,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          decoration: InputDecoration(
            labelText: 'Consignment Number',
            hintText: 'e.g. CB2024051901',
            suffixIcon: IconButton(
              onPressed: () => _openScanner(context),
              icon: const Icon(
                Icons.qr_code_scanner_rounded,
                color: AppTheme.primary,
                size: 22,
              ),
              tooltip: 'Scan Barcode',
            ),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Consignment number is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: courierNameController,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.ibmPlexSans(fontSize: 15),
          decoration: const InputDecoration(
            labelText: 'Courier Name',
            hintText: 'e.g. DTDC, BlueDart, Delhivery',
            prefixIcon: Icon(Icons.local_shipping_rounded, size: 20),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return 'Courier name is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _BarcodeScannerPage extends StatefulWidget {
  final ValueChanged<String> onScanned;
  const _BarcodeScannerPage({required this.onScanned});

  @override
  State<_BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<_BarcodeScannerPage> {
  final MobileScannerController _scannerController = MobileScannerController();

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.trim().isNotEmpty) {
        widget.onScanned(value.trim());
        if (mounted) Navigator.of(context).pop();
        return;
      }
    }
  }

  Future<void> _promptManualEntry() async {
    final textCtrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Enter consignment number',
          style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.w600),
        ),
        content: TextField(
          controller: textCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. CB2024051901',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, textCtrl.text.trim()),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    textCtrl.dispose();
    if (!mounted) return;
    if (result != null && result.isNotEmpty) {
      widget.onScanned(result);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          'Scan Barcode',
          style: GoogleFonts.ibmPlexSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Enter manually',
            icon: const Icon(Icons.keyboard_rounded, color: Colors.white),
            onPressed: _promptManualEntry,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),
          Center(
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: Text(
              'Align the barcode inside the frame',
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormGroupCard extends StatelessWidget {
  final String title;
  final String iconName;
  final List<Widget> children;

  const _FormGroupCard({
    required this.title,
    required this.iconName,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A1565C0),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _iconData(iconName),
                  size: 16,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF546E7A),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  IconData _iconData(String name) {
    switch (name) {
      case 'receipt':
        return Icons.receipt_long_rounded;
      case 'person':
        return Icons.person_rounded;
      case 'payment':
        return Icons.currency_rupee_rounded;
      default:
        return Icons.circle_rounded;
    }
  }
}
