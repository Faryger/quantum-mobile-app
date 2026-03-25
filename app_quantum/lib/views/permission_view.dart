import 'package:flutter/material.dart';
import '../backend/api_client.dart';

class PermissionView extends StatefulWidget {
  const PermissionView({super.key});
  static String routeName = 'permissionView';
  static String routePath = '/permissionView';

  @override
  State<PermissionView> createState() => _PermissionViewState();
}

class _PermissionViewState extends State<PermissionView> {
  late Future<List<dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = ApiClient.getPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: FutureBuilder<List<dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: \${snapshot.error}'));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Sin registros'));

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Permiso ID: \${item['id'] ?? 'N/A'} - Usuario Data ID: \${item['user_data_id'] ?? 'N/A'}"),
                  subtitle: Text("Razón: \${item['personal_reason'] ?? item['family_situation_detail']}\nFechas: \${item['init_date']} a \${item['end_date']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
