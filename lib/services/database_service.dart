import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models/booking_model.dart';
import '../data/models/customer_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('courierbook.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textNullable = 'TEXT';
    const boolType = 'INTEGER NOT NULL'; // 0 for false, 1 for true
    const doubleType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE customers (
  id $idType,
  name $textType,
  mobileNumber $textType,
  email $textNullable,
  address $textNullable,
  createdAt $textType,
  updatedAt $textNullable,
  syncStatus $textType,
  isDeleted $boolType
)
''');

    await db.execute('''
CREATE TABLE bookings (
  id $idType,
  consignmentNumber $textType,
  customerName $textType,
  mobileNumber $textType,
  weight $doubleType,
  chargedAmount $doubleType,
  costAmount $doubleType,
  paymentType $textType,
  codAmount $doubleType,
  courierName $textType,
  createdAt $textType,
  updatedAt $textNullable,
  syncStatus $textType,
  isDeleted $boolType
)
''');
  }

  // --- Customer CRUD ---

  Future<String> createCustomer(CustomerModel customer) async {
    final db = await instance.database;
    await db.insert('customers', customer.toMap());
    return customer.id;
  }

  Future<CustomerModel?> readCustomer(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CustomerModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<CustomerModel>> readAllCustomers() async {
    final db = await instance.database;
    final result = await db.query('customers', where: 'isDeleted = 0', orderBy: 'name ASC');
    return result.map((json) => CustomerModel.fromMap(json)).toList();
  }

  Future<int> updateCustomer(CustomerModel customer) async {
    final db = await instance.database;
    return db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> deleteCustomer(String id) async {
    final db = await instance.database;
    // Soft delete
    return await db.update(
      'customers',
      {'isDeleted': 1, 'syncStatus': 'pending', 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Booking CRUD ---

  Future<String> createBooking(BookingModel booking) async {
    final db = await instance.database;
    await db.insert('bookings', booking.toMap());
    return booking.id;
  }

  Future<BookingModel?> readBooking(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return BookingModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<BookingModel>> readAllBookings() async {
    final db = await instance.database;
    final result = await db.query('bookings', where: 'isDeleted = 0', orderBy: 'createdAt DESC');
    return result.map((json) => BookingModel.fromMap(json)).toList();
  }

  Future<int> updateBooking(BookingModel booking) async {
    final db = await instance.database;
    return db.update(
      'bookings',
      booking.toMap(),
      where: 'id = ?',
      whereArgs: [booking.id],
    );
  }

  Future<int> deleteBooking(String id) async {
    final db = await instance.database;
    // Soft delete
    return await db.update(
      'bookings',
      {'isDeleted': 1, 'syncStatus': 'pending', 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Sync Helpers ---

  Future<List<BookingModel>> getPendingBookings() async {
    final db = await instance.database;
    final result = await db.query('bookings', where: "syncStatus != 'synced'");
    return result.map((json) => BookingModel.fromMap(json)).toList();
  }

  Future<List<CustomerModel>> getPendingCustomers() async {
    final db = await instance.database;
    final result = await db.query('customers', where: "syncStatus != 'synced'");
    return result.map((json) => CustomerModel.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
