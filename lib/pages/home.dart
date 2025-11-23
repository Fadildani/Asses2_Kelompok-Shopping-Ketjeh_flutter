import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme_provider.dart';
import '../database_helper.dart';
import 'package:sqflite/sqflite.dart';


class Product {
  int? id;
  String name;
  int qty;

  Product({this.id, required this.name, required this.qty});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'qty': qty,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      qty: map['qty'] as int? ?? 0,
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  final String username;

  const ShoppingListPage({super.key, required this.username});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final List<Product> _products = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _prepareDatabaseAndLoad();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  Future<void> _prepareDatabaseAndLoad() async {
    // Pastikan tabel products ada, lalu load data
    final db = await _dbHelper.database;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        qty INTEGER NOT NULL
      )
    ''');
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps =
    await db.query('products', orderBy: 'id DESC');
    _products
      ..clear()
      ..addAll(maps.map((m) => Product.fromMap(m)));
    setState(() => _loading = false);
  }

  Future<void> _createProduct(Product p) async {
    final db = await _dbHelper.database;
    final id = await db.insert('products', p.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    p.id = id;
    await _loadProducts();
  }

  Future<void> _updateProduct(Product p) async {
    final db = await _dbHelper.database;
    await db.update('products', p.toMap(),
        where: 'id = ?', whereArgs: [p.id]);
    await _loadProducts();
  }

  Future<void> _deleteProduct(int id) async {
    final db = await _dbHelper.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
    await _loadProducts();
  }

  void _showAddEditDialog({Product? product}) {
    final isEdit = product != null;
    if (isEdit) {
      _nameController.text = product.name;
      _qtyController.text = product.qty.toString();
    } else {
      _nameController.clear();
      _qtyController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Barang' : 'Tambah Barang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah (Qty)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final qtyText = _qtyController.text.trim();
                if (name.isEmpty || qtyText.isEmpty) {
                  // simple validation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nama dan jumlah wajib diisi')),
                  );
                  return;
                }
                final qty = int.tryParse(qtyText) ?? 0;
                if (isEdit) {
                  final updated = Product(id: product!.id, name: name, qty: qty);
                  await _updateProduct(updated);
                } else {
                  final newProduct = Product(name: name, qty: qty);
                  await _createProduct(newProduct);
                }
                Navigator.pop(context);
              },
              child: Text(isEdit ? 'Update' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada produk 🛍️',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final p = _products[index];
        return Card(
          color: const Color(0xFF1565C0),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.white),
            title: Text(
              p.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('Jumlah: ${p.qty}',
                style: const TextStyle(color: Colors.white70)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                  onPressed: () => _showAddEditDialog(product: p),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Produk'),
                        content:
                        Text('Hapus "${p.name}" dari daftar produk?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    ) ??
                        false;
                    if (ok) {
                      await _deleteProduct(p.id!);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.3),
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        title: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: const Text(
                'Shopping Ketjeh',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(themeProv.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => context.read<ThemeProvider>().toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.lightBlue[900],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'My Wallet',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'BTC 2,50,000',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 36,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // --- Icon ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionIcon(Icons.payment, 'Payment', iconSize: 34),
                _buildActionIcon(Icons.shopping_cart, 'Product', iconSize: 34),
                _buildActionIcon(Icons.category, 'Categories', iconSize: 34),
                _buildActionIcon(Icons.more_horiz, 'More', iconSize: 34),
              ],
            ),

            const SizedBox(height: 20),

            // --- Daftar Produk (sebelumnya daftar belanja) ---
            Expanded(
              child: _buildProductList(),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[50],
        onPressed: () => _showAddEditDialog(),
        elevation: 4,
        child: Icon(
          Icons.add,
          color: Colors.blue[800],
          size: 30,
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 0,
        onTap: (index) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_outlined),
            activeIcon: Icon(Icons.swap_horiz),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            activeIcon: Icon(Icons.shopping_basket),
            label: 'Basket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

Widget _buildActionIcon(IconData icon, String label, {double iconSize = 28}) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20), // dikit lebih kecil biar rapet
        child: Icon(icon, color: Colors.blue[700], size: iconSize),
      ),
      const SizedBox(height: 4), // jarak antar ikon dan teks dikurangi
      Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    ],
  );
}
