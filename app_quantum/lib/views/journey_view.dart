import 'package:flutter/material.dart';
import '../backend/api_client.dart';
import '../components/nav_bar_widget.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../home/home_page/home_page_model.dart';

class JourneyView extends StatefulWidget {
  const JourneyView({super.key});
  static String routeName = 'journeyView';
  static String routePath = '/journeyView';

  @override
  State<JourneyView> createState() => _JourneyViewState();
}

class _JourneyViewState extends State<JourneyView> {
  late Future<List<dynamic>> _futureData;
  late HomePageModel _navModel;

  @override
  void initState() {
    super.initState();
    _futureData = ApiClient.getJourney();
    _navModel = createModel(context, () => HomePageModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Jornadas', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Color(0xFF14B8A6)));
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Sin jornadas registradas', style: TextStyle(fontFamily: 'Readex Pro')));

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
                      child: const Icon(Icons.route_rounded, color: Color(0xFF14B8A6), size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Jornada #${item['id']}", style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B))),
                          Text("Tipo: ${item['journey_type'] ?? 'N/A'}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
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
