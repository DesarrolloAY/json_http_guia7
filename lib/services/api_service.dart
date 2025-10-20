import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<List<dynamic>> fetchUsers() async {
    final url = Uri.parse('https://reqres.in/api/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; // Retorna lista de Maps
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}
