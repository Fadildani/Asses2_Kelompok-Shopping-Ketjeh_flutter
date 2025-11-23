/*
 * File: database_helper.dart
 * Deskripsi: Kelas Singleton untuk mengelola koneksi dan operasi database SQLite.
 * Menggabungkan semua fungsi dari Slide 4, 5, 6, 7, 8, dan 9.
 */

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'task.dart'; // Impor model Task

class DatabaseHelper {
  // --- AWAL BAGIAN SINGLETON (Slide 4) ---
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static Database? _database;
  // --- AKHIR BAGIAN SINGLETON ---

  // Getter untuk database
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Jika _database null, inisialisasi
    _database = await _initDB();
    return _database!;
  }

  // --- (C)REATE: Inisialisasi DB & Buat Tabel (Slide 5) ---
  Future<Database> _initDB() async {
    // Mendapatkan path direktori database
    String path = join(await getDatabasesPath(), 'task_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Jalankan perintah SQL untuk membuat tabel
        await db.execute('''
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT,
            isDone INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  // --- (C)REATE: Fungsi Insert Data (Slide 6) ---
  Future<int> createTask(Task task) async {
    final db = await database;

    // Gunakan 'helper' insert dari sqflite
    // 'id' yang dikembalikan adalah id baris yang baru saja dimasukkan
    return await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // --- (R)EAD: Fungsi Query Data (Slide 7) ---
  Future<List<Task>> getTasks() async {
    final db = await database;

    // Query tabel dan urutkan berdasarkan ID
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: 'id DESC',
    );

    // Konversi List<Map> menjadi List<Task> menggunakan factory constructor
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  // --- (U)PDATE: Fungsi Update Data (Slide 8) ---
  Future<int> updateTask(Task task) async {
    final db = await database;

    // Update data berdasarkan 'id'
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // --- (D)ELETE: Fungsi Delete Data (Slide 9) ---
  Future<int> deleteTask(int id) async {
    final db = await database;

    // Hapus data berdasarkan 'id'
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
