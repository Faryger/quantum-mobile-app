import 'package:flutter/material.dart';
import '../backend/api_client.dart';

class SupportView extends StatefulWidget {
  const SupportView({super.key});
  static String routeName = 'supportView';
  static String routePath = '/supportView';

  @override
  State<SupportView> createState() => _SupportViewState();
}

class _SupportViewState extends State<SupportView> {
  late Future<List<dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = ApiClient.getSupport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supports')),
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
                  title: Text("Soporte ID: \${item['id'] ?? 'N/A'}"),
                  subtitle: Text("URL: \${item['url'] ?? 'N/A'}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
