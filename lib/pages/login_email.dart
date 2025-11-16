import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart'; // Importation du fichier DatabaseHelper

class InscriptionEmail extends StatefulWidget {
  const InscriptionEmail({super.key});

  @override
  _InscriptionEmailState createState() => _InscriptionEmailState();
}

class _InscriptionEmailState extends State<InscriptionEmail> {
  final TextEditingController _emailController =
      TextEditingController(); // Controller pour l'email
  final TextEditingController _passwordController =
      TextEditingController(); // Controller pour le mot de passe
  String? _errorMessage; // Variable pour le message d'erreur

  final DatabaseHelper _databaseHelper =
      DatabaseHelper(); // Instance de DatabaseHelper

  void _login() async {
    setState(() {
      // Vérification si les champs sont vides
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        _errorMessage = "Tous les champs doivent être remplis";
      } else {
        _errorMessage = null;
      }
    });

    if (_errorMessage == null) {
      // Récupération des informations de l'utilisateur
      String email = _emailController.text;
      String password = _passwordController.text;

      // Vérification des informations d'identification dans la base de données
      bool loginSuccessful =
          await _databaseHelper.validateUser(email, password);

      if (loginSuccessful) {
        // Navigation vers le tableau de bord (Dashboard) après la connexion réussie
        Navigator.pushReplacementNamed(context,
            '/dashboard'); // Assurez-vous que '/dashboard' existe dans vos routes
      } else {
        setState(() {
          _errorMessage =
              "Email ou mot de passe incorrect"; // Message d'erreur si les informations sont incorrectes
        });
      }
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
                const SizedBox(height: 100),
                const Text(
                  'Se connecter',
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
                // Email field
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
                // Password field
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
                if (_errorMessage !=
                    null) // Display error message if fields are empty
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 40),
                // Login button
                Center(
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDBA5C), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 60),
                    ),
                    child: const Text(
                      'Se connecter',
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
