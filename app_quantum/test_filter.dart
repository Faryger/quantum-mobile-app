import 'package:supabase_flutter/supabase_flutter.dart';
void main() {
  var t = Supabase.instance.client.from('t').select();
  t.not('exit_time', 'is', null);
  t.isFilter('exit_time', null);
}
