import 'package:flutter/material.dart';
import '../backend/api_client.dart';
import '../components/nav_bar_widget.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../home/home_page/home_page_model.dart';

class ShiftView extends StatefulWidget {
  const ShiftView({super.key});
  static String routeName = 'shiftView';
  static String routePath = '/shiftView';

  @override
  State<ShiftView> createState() => _ShiftViewState();
}

class _ShiftViewState extends State<ShiftView> {
  late Future<List<dynamic>> _futureData;
  late HomePageModel _navModel;

  @override
  void initState() {
    super.initState();
    _futureData = ApiClient.getShift();
    _navModel = createModel(context, () => HomePageModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Turnos', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)));
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Sin turnos registrados', style: TextStyle(fontFamily: 'Readex Pro')));

          final data = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFF14B8A6).withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.timer_rounded, color: Color(0xFF14B8A6), size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Turno #${item['id']}", style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                          Text("Días: ${item['start_day']} a ${item['end_day']}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                          Text("Horario: ${item['check_in_time']} - ${item['departure_time']}", style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: wrapWithModel(
        model: _navModel.navBarModel,
        updateCallback: () => setState(() {}),
        child: const NavBarWidget(),
      ),
    );
  }
}
