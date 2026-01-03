import 'package:flutter/material.dart';

void main() {
  runApp(TomaTurnosApp());
}

class TomaTurnosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String? _errorMessage;

  final Map<String, Map<String, dynamic>> users = {
    'Turno78': {'password': 'Liverpool78', 'page': PaginaSolicitudTurnos()},
    'Admin78': {'password': 'Liverpool78', 'page': PaginaAdministradorTurnos()},
    'Vista78': {'password': 'Liverpool78', 'page': PaginaVisualizacionTurnos()},
  };

  void _login() {
    final username = _userController.text;
    final password = _passController.text;

    if (users.containsKey(username) &&
        users[username]!['password'] == password) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => users[username]!['page']),
      );
    } else {
      setState(() {
        _errorMessage = 'Usuario o contraseña incorrectos';
      });
    }
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inicio de Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _login,
                child: const Text('Ingresar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaginaSolicitudTurnos extends StatefulWidget {
  @override
  _PaginaSolicitudTurnosState createState() => _PaginaSolicitudTurnosState();
}

class _PaginaSolicitudTurnosState extends State<PaginaSolicitudTurnos> {
  int turnoActual = 0;
  final List<Map<String, dynamic>> turnos = [];

  void solicitarTurno() {
    setState(() {
      turnoActual++;
      turnos.add({
        'turno': turnoActual,
        'fechaHora': DateTime.now(),
        'estado': 'Pendiente',
      });
    });
  }

  String formatFechaHora(DateTime fechaHora) {
    return '${fechaHora.day.toString().padLeft(2, '0')}/${fechaHora.month.toString().padLeft(2, '0')}/${fechaHora.year} hora: ${fechaHora.hour % 12 == 0 ? 12 : fechaHora.hour % 12}:${fechaHora.minute.toString().padLeft(2, '0')} ${fechaHora.hour >= 12 ? 'pm' : 'am'}';
  }

  void cerrarSesion() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        title: Text(
          'Toma Turnos Liverpool Galerias Guadalajara',
          style: TextStyle(fontSize: 45, color: Colors.white),
        ),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: cerrarSesion,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Toma un Turno',
              style: TextStyle(
                  fontSize: 40, color: const Color.fromARGB(255, 38, 37, 37)),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: solicitarTurno,
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(55),
                backgroundColor: Colors.pink,
              ),
              child: Text(
                'Turno',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            if (turnoActual > 0) ...[
              SizedBox(height: 20),
              Text(
                'Turno: ${turnoActual.toString().padLeft(3, '0')}',
                style: TextStyle(
                    fontSize: 26, color: const Color.fromARGB(255, 50, 49, 49)),
              ),
              Text(
                'Fecha y hora: ${formatFechaHora(DateTime.now())}',
                style: TextStyle(
                    fontSize: 22, color: const Color.fromARGB(255, 50, 49, 49)),
              ),
              Text(
                '¡Gracias por tu preferencia!',
                style: TextStyle(
                    fontSize: 23, color: const Color.fromARGB(255, 50, 49, 49)),
              ),
              Text(
                'Liverpool Galerias Guadalajara',
                style: TextStyle(
                    fontSize: 23, color: const Color.fromARGB(255, 50, 49, 49)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PaginaAdministradorTurnos extends StatefulWidget {
  @override
  _PaginaAdministradorTurnosState createState() =>
      _PaginaAdministradorTurnosState();
}

class _PaginaAdministradorTurnosState extends State<PaginaAdministradorTurnos> {
  final List<Map<String, dynamic>> turnos = [];

  void actualizarEstado(int index, String nuevoEstado) {
    setState(() {
      turnos[index]['estado'] = nuevoEstado;
    });
  }

  void cerrarSesion() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Administrador de Turnos',
          style: TextStyle(
              fontSize: 40, color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: cerrarSesion,
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
            'Turnos Solicitados: ${turnos.length}',
            style: TextStyle(fontSize: 18, color: Colors.pink),
          ),
          Text(
            'Turnos Finalizados: ${turnos.where((t) => t['estado'] == 'Finalizado').length}',
            style: TextStyle(fontSize: 18, color: Colors.pink),
          ),
          Text(
            'Turnos Pendientes: ${turnos.where((t) => t['estado'] == 'Pendiente').length}',
            style: TextStyle(fontSize: 18, color: Colors.pink),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: turnos.length,
              itemBuilder: (context, index) {
                final turno = turnos[index];
                return ListTile(
                  title: Text('Turno ${turno['turno']}'),
                  subtitle: Text('Fecha y hora: ${turno['fechaHora']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => actualizarEstado(index, 'Llamado'),
                        child: Text('Llamar'),
                      ),
                      ElevatedButton(
                        onPressed: () => actualizarEstado(index, 'Pendiente'),
                        child: Text('Pendiente'),
                      ),
                      ElevatedButton(
                        onPressed: () => actualizarEstado(index, 'Finalizado'),
                        child: Text('Finalizar'),
                      ),
                    ],
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

class PaginaVisualizacionTurnos extends StatelessWidget {
  final List<Map<String, dynamic>> turnos = [];

  void cerrarSesion(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final turnosLlamados =
        turnos.where((turno) => turno['estado'] == 'Llamado').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Liverpool Guadalajara'),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => cerrarSesion(context),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  'Imágenes',
                  style: TextStyle(fontSize: 18, color: Colors.pink),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  'Turnos Llamados',
                  style: TextStyle(fontSize: 18, color: Colors.pink),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: turnosLlamados.length,
                    itemBuilder: (context, index) {
                      final turno = turnosLlamados[index];
                      return ListTile(
                        title: Text('Turno ${turno['turno']}'),
                        subtitle: Text('Fecha y hora: ${turno['fechaHora']}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
