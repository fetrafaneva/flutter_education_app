import 'package:flutter/material.dart';
import 'database_helper.dart';

class ModifierElevePage extends StatefulWidget {
  final Map<String, dynamic> eleve;

  const ModifierElevePage({super.key, required this.eleve});

  @override
  _ModifierElevePageState createState() => _ModifierElevePageState();
}

class _ModifierElevePageState extends State<ModifierElevePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  // Add other controllers as needed

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.eleve['nom']);
    _prenomController = TextEditingController(text: widget.eleve['prenom']);
    // Initialize other controllers
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    // Dispose other controllers
    super.dispose();
  }

  void _modifierEleve() async {
    final updatedEleve = {
      'id': widget.eleve['id'],
      'nom': _nomController.text,
      'prenom': _prenomController.text,
      // Add other fields here
    };

    await _dbHelper.updateEleve(updatedEleve);

    Navigator.pop(context, true); // Return true to indicate changes were made
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Élève'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            // Add other input fields as necessary
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _modifierEleve,
              child: const Text('Enregistrer les modifications'),
            ),
          ],
        ),
      ),
    );
  }
}
