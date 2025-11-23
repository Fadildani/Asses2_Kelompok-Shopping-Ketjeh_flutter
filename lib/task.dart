/*
 * File: task.dart
 * Deskripsi: Model data untuk objek Task.
 * Berisi properti dan metode konversi toMap/fromMap.
 * Sesuai dengan Slide 4.
 */

class Task {
  int? id;
  String title;
  String description;
  int isDone; // 0 = false, 1 = true

  Task({
    this.id,
    required this.title,
    required this.description,
    this.isDone = 0,
  });

  // Konversi objek Task menjadi Map.
  // Digunakan saat INSERT dan UPDATE.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  // Factory constructor untuk membuat Task dari Map.
  // Digunakan saat READ (Query).
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'],
    );
  }
}
