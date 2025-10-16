import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<void> fetchUsuarios() async {
    final url = Uri.parse('https://reqres.in/api/users');
    final response = await http.get(url);

    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      print(data['data']);
    }else{
      print('Error al cargar usuarios: ${response.statusCode}');
    }
  }
}