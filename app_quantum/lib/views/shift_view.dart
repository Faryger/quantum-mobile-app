import 'package:flutter/material.dart';
import '../backend/api_client.dart';

class ShiftView extends StatefulWidget {
  const ShiftView({super.key});
  static String routeName = 'shiftView';
  static String routePath = '/shiftView';

  @override
  State<ShiftView> createState() => _ShiftViewState();
}

class _ShiftViewState extends State<ShiftView> {
  late Future<List<dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = ApiClient.getShift();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shifts')),
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
                  title: Text("Turno ID: \${item['id'] ?? 'N/A'}"),
                  subtitle: Text("Días: \${item['start_day']} a \${item['end_day']} | Horas: \${item['check_in_time']} - \${item['departure_time']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
