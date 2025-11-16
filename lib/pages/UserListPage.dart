import 'package:flutter/material.dart';
import 'database_helper.dart'; // Assurez-vous que le chemin est correct

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<Map<String, dynamic>>> _users;
  late Future<List<Map<String, dynamic>>> _pins;

  @override
  void initState() {
    super.initState();
    _users =
        DatabaseHelper().getUsers(); // Récupérer les utilisateurs au démarrage
    _pins = DatabaseHelper().getPins(); // Récupérer les PINs au démarrage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des utilisateurs et PINs'),
      ),
      body: FutureBuilder<List<List<Map<String, dynamic>>>>(
        future: Future.wait([_users, _pins]), // Attendre les deux futures
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun utilisateur ou PIN trouvé'));
          } else {
            final users = snapshot.data![0]; // Liste des utilisateurs
            final pins = snapshot.data![1]; // Liste des PINs
            return ListView.builder(
              itemCount: users.length +
                  pins.length, // Total des utilisateurs et des PINs
              itemBuilder: (context, index) {
                if (index < users.length) {
                  final user = users[index];
                  return ListTile(
                    title: Text(
                        user['email']), // Afficher l'email de l'utilisateur
                    subtitle: Text(
                        'Mot de passe: ${user['password']}'), // Afficher le mot de passe de l'utilisateur
                  );
                } else {
                  final pin = pins[
                      index - users.length]; // Récupérer le PIN correspondant
                  return ListTile(
                    title:
                        Text('Code PIN: ${pin['pin']}'), // Afficher le code PIN
                    subtitle: const Text(
                        'Utilisateur associé'), // Indiquer que c'est un code PIN
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
