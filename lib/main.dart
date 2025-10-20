import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Buscar Usuarios', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _allUsers = [];
  List<dynamic> _filteredUsers = [];
  bool _loading = false;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    setState(() {
      _loading = true;
    });

    try {
      final users = await ApiService.fetchUsers();
      setState(() {
        _allUsers = users;
        _filteredUsers = users;
        _loading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  void _filterUsers(String searchText) {
    setState(() {
      _searchText = searchText;
      if (searchText.isEmpty) {
        _filteredUsers = _allUsers;
      } else {
        _filteredUsers = _allUsers.where((user) {
          final name = '${user['first_name']} ${user['last_name']}'
              .toLowerCase();
          return name.contains(searchText.toLowerCase());
        }).toList();
      }
    });
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles del Usuario'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user['avatar']),
                ),
              ),
              SizedBox(height: 16),
              Text('ID: ${user['id']}'),
              Text('Nombre: ${user['first_name']} ${user['last_name']}'),
              Text('Email: ${user['email']}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Usuarios'),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _loadUsers)],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              onChanged: _filterUsers,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Información de resultados
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Usuarios encontrados: ${_filteredUsers.length}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // Lista de usuarios
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : _filteredUsers.isEmpty
                ? Center(child: Text('No se encontraron usuarios'))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user['avatar']),
                          ),
                          title: Text(
                            '${user['first_name']} ${user['last_name']}',
                          ),
                          subtitle: Text(user['email']),
                          onTap: () => _showUserDetails(user),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
