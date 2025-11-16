import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart'; // Importation du fichier DatabaseHelper

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController =
      TextEditingController(); // Controller pour l'email
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _errorMessage;

  final DatabaseHelper _databaseHelper =
      DatabaseHelper(); // Instance de DatabaseHelper

  // Méthode pour vider la base de données
  Future<void> _clearDatabase() async {
    await _databaseHelper.clearDatabase(); // Appel à la fonction de suppression
  }

  void _register() async {
    setState(() {
      // Vérification si les mots de passe sont égaux
      if (_passwordController.text != _confirmPasswordController.text) {
        _errorMessage = "Les mots de passe ne correspondent pas";
      } else {
        _errorMessage = null;
      }
    });

    if (_errorMessage == null) {
      // Vider la base de données
      await _clearDatabase();

      // Insertion de l'utilisateur dans la base de données
      String email = _emailController.text;
      String password = _passwordController.text;

      await _databaseHelper.insertUser(email, password); // Appel à insertUser

      // Navigation vers le tableau de bord (Dashboard) après l'enregistrement réussi
      Navigator.pushReplacementNamed(context,
          '/dashboard'); // Assurez-vous que '/dashboard' existe dans vos routes
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness:
            Brightness.dark, // Dark icons for light background
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5E7D5), // Background color
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent, // Transparent app bar
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                const Text(
                  'Créer un compte',
                  style: TextStyle(
                    color: Color(0xFF6E6E75), // Text color
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Remplir les champs',
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 40),
                // Champ de saisie de l'email
                TextField(
                  controller: _emailController, // Assignation du controller
                  style: const TextStyle(
                      color: Color(0xFF6E6E75)), // Text color inside input
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'exemple@gmail.com',
                    hintStyle: const TextStyle(
                        color: Color(0xFF9E9E9E)), // Hint text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 15),
                // Champ de saisie du mot de passe
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(
                      color: Color(0xFF6E6E75)), // Text color inside input
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Mot de passe',
                    hintStyle: const TextStyle(
                        color: Color(0xFF9E9E9E)), // Hint text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 15),
                // Champ de confirmation du mot de passe
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(
                      color: Color(0xFF6E6E75)), // Text color inside input
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Confirmer',
                    hintStyle: const TextStyle(
                        color: Color(0xFF9E9E9E)), // Hint text color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                ),
                if (_errorMessage != null) // Affichage du message d'erreur
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 40),
                // Bouton d'enregistrement
                Center(
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDBA5C), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 60),
                    ),
                    child: const Text(
                      'Enregistrer',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
