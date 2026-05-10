import 'package:uuid/uuid.dart';

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
  final DateTime? updatedAt;
  final SyncStatus syncStatus;
  final bool isDeleted;

  BookingModel({
    String? id,
    required this.consignmentNumber,
    required this.customerName,
    required this.mobileNumber,
    required this.weight,
    required this.chargedAmount,
    required this.costAmount,
    required this.paymentType,
    required this.codAmount,
    required this.courierName,
    DateTime? createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.offline,
    this.isDeleted = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        profit = chargedAmount - costAmount;

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
      paymentType: _paymentFromString(map['paymentType'] as String? ?? 'cod'),
      codAmount: (map['codAmount'] as num?)?.toDouble() ?? 0.0,
      courierName: map['courierName'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
      syncStatus:
          _syncFromString(map['syncStatus'] as String? ?? 'offline'),
      isDeleted: (map['isDeleted'] as int? ?? 0) == 1,
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
        'updatedAt': updatedAt?.toIso8601String(),
        'syncStatus': syncStatus.name,
        'isDeleted': isDeleted ? 1 : 0,
      };

  Map<String, dynamic> toJson() => toMap();

  BookingModel copyWith({
    String? id,
    String? consignmentNumber,
    String? customerName,
    String? mobileNumber,
    double? weight,
    double? chargedAmount,
    double? costAmount,
    PaymentType? paymentType,
    double? codAmount,
    String? courierName,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) {
    return BookingModel(
      id: id ?? this.id,
      consignmentNumber: consignmentNumber ?? this.consignmentNumber,
      customerName: customerName ?? this.customerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      weight: weight ?? this.weight,
      chargedAmount: chargedAmount ?? this.chargedAmount,
      costAmount: costAmount ?? this.costAmount,
      paymentType: paymentType ?? this.paymentType,
      codAmount: codAmount ?? this.codAmount,
      courierName: courierName ?? this.courierName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}
