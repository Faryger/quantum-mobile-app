import 'package:flutter/material.dart';
import '../backend/api_client.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});
  static String routeName = 'scheduleView';
  static String routePath = '/scheduleView';

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late Future<List<dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = ApiClient.getSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedules')),
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
                  title: Text("Horario ID: \${item['id'] ?? 'N/A'}"),
                  subtitle: Text("CheckIn: \${item['check_in_time']} | Departure: \${item['departure_time']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
