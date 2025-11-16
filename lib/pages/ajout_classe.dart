import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart'; // Importation du fichier DatabaseHelper

class AjoutClasse extends StatefulWidget {
  const AjoutClasse({super.key});

  @override
  _AjoutClasseState createState() => _AjoutClasseState();
}

class _AjoutClasseState extends State<AjoutClasse> {
  final TextEditingController _nomController =
      TextEditingController(); // Controller pour le nom de la classe
  final TextEditingController _anneeScolaireController =
      TextEditingController(); // Controller pour l'année scolaire
  String? _errorMessage;

  final DatabaseHelper _databaseHelper =
      DatabaseHelper(); // Instance de DatabaseHelper

  void _ajouterClasse() async {
    setState(() {
      // Vérification si les champs ne sont pas vides
      if (_nomController.text.isEmpty ||
          _anneeScolaireController.text.isEmpty) {
        _errorMessage = "Tous les champs doivent être remplis";
      } else {
        _errorMessage = null;
      }
    });

    if (_errorMessage == null) {
      // Insertion de la classe dans la base de données
      String nom = _nomController.text;
      String anneeScolaire = _anneeScolaireController.text;

      await _databaseHelper.insertClasse(nom,
          anneeScolaire); // Assurez-vous d'avoir la méthode insertClasse dans DatabaseHelper

      // Navigation vers le tableau de bord (Dashboard) après l'ajout réussi
      Navigator.pop(
          context); // Retourner à la page précédente ou vers une autre page
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
                  'Ajouter une classe',
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
                // Nom de la classe field
                TextField(
                  controller: _nomController, // Assignation du controller
                  style: const TextStyle(
                      color: Color(0xFF6E6E75)), // Text color inside input
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Nom de la classe',
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
                // Année scolaire field
                TextField(
                  controller: _anneeScolaireController,
                  style: const TextStyle(
                      color: Color(0xFF6E6E75)), // Text color inside input
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Année scolaire',
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
                // Add class button
                Center(
                  child: ElevatedButton(
                    onPressed: _ajouterClasse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFDBA5C), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 60),
                    ),
                    child: const Text(
                      'Ajouter',
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
