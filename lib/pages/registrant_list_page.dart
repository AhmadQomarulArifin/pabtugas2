// lib/pages/registrant_list_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/registrant_model.dart';
import '../providers/registration_provider.dart';

class RegistrantListPage extends StatefulWidget {
  const RegistrantListPage({super.key});

  @override
  State<RegistrantListPage> createState() => _RegistrantListPageState();
}

class _RegistrantListPageState extends State<RegistrantListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  List<Registrant> _applyFilter(List<Registrant> registrants) {
    return registrants.where((registrant) {
      final matchSearch =
          registrant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          registrant.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          registrant.programStudi.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchFilter = _selectedFilter == 'Semua'
          ? true
          : registrant.programStudi == _selectedFilter;

      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<RegistrationProvider>(
          builder: (context, provider, _) {
            return Text('Daftar Peserta (${provider.count})');
          },
        ),
      ),
      body: Consumer<RegistrationProvider>(
        builder: (context, provider, child) {
          final allRegistrants = provider.registrants;

          final prodiOptions = <String>{
            'Semua',
            ...allRegistrants.map((e) => e.programStudi),
          }.toList();

          final filteredRegistrants = _applyFilter(allRegistrants);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari nama, email, atau program studi...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedFilter,
                  decoration: const InputDecoration(
                    labelText: 'Filter Program Studi',
                    prefixIcon: Icon(Icons.filter_list),
                    border: OutlineInputBorder(),
                  ),
                  items: prodiOptions.map((prodi) {
                    return DropdownMenuItem(
                      value: prodi,
                      child: Text(prodi),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value ?? 'Semua';
                    });
                  },
                ),
              ),
              Expanded(
                child: allRegistrants.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada pendaftar',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Daftar sekarang di halaman registrasi!',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : filteredRegistrants.isEmpty
                        ? const Center(
                            child: Text(
                              'Data tidak ditemukan',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: filteredRegistrants.length,
                            itemBuilder: (context, index) {
                              final registrant = filteredRegistrants[index];

                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(registrant.name[0].toUpperCase()),
                                  ),
                                  title: Text(
                                    registrant.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    '${registrant.programStudi} • ${registrant.email}',
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    onSelected: (value) {
                                      if (value == 'detail') {
                                        Navigator.pushNamed(
                                          context,
                                          '/detail',
                                          arguments: registrant.id,
                                        );
                                      } else if (value == 'edit') {
                                        Navigator.pushNamed(
                                          context,
                                          '/',
                                          arguments: registrant.id,
                                        );
                                      } else if (value == 'delete') {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Hapus Pendaftar?'),
                                            content: Text(
                                              'Yakin hapus ${registrant.name}?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(ctx),
                                                child: const Text('Batal'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  provider.removeRegistrant(registrant.id);
                                                  Navigator.pop(ctx);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                ),
                                                child: const Text('Hapus'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'detail',
                                        child: ListTile(
                                          leading: Icon(Icons.visibility),
                                          title: Text('Detail'),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Text('Edit'),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: ListTile(
                                          leading: Icon(Icons.delete, color: Colors.red),
                                          title: Text('Hapus'),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/detail',
                                      arguments: registrant.id,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/'),
        child: const Icon(Icons.add),
      ),
    );
  }
}