import 'package:uuid/uuid.dart';
import 'booking_model.dart';

class CustomerModel {
  final String id;
  final String name;
  final String mobileNumber;
  final String? email;
  final String? address;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final SyncStatus syncStatus;
  final bool isDeleted;

  CustomerModel({
    String? id,
    required this.name,
    required this.mobileNumber,
    this.email,
    this.address,
    DateTime? createdAt,
    this.updatedAt,
    this.syncStatus = SyncStatus.offline,
    this.isDeleted = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

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

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] as String,
      name: map['name'] as String,
      mobileNumber: map['mobileNumber'] as String,
      email: map['email'] as String?,
      address: map['address'] as String?,
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
        'name': name,
        'mobileNumber': mobileNumber,
        'email': email,
        'address': address,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'syncStatus': syncStatus.name,
        'isDeleted': isDeleted ? 1 : 0,
      };

  Map<String, dynamic> toJson() => toMap();

  CustomerModel copyWith({
    String? id,
    String? name,
    String? mobileNumber,
    String? email,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}

// SyncStatus is imported from booking_model.dart
