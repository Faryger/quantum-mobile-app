import 'package:flutter/material.dart';
import '../backend/api_client.dart';

class ContractView extends StatefulWidget {
  const ContractView({super.key});
  static String routeName = 'contractView';
  static String routePath = '/contractView';

  @override
  State<ContractView> createState() => _ContractViewState();
}

class _ContractViewState extends State<ContractView> {
  late Future<List<dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = ApiClient.getContracts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contracts')),
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
                  title: Text("Contrato ID: \${item['id'] ?? 'N/A'}"),
                  subtitle: Text("Valor: \${item['value']} | Inicio: \${item['start_date']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
