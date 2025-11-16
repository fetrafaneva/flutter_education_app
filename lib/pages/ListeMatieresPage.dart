import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importer le helper de base de données

class ListeMatieresPage extends StatefulWidget {
  final int classeId;

  const ListeMatieresPage({
    super.key,
    required this.classeId,
  });

  @override
  _ListeMatieresPageState createState() => _ListeMatieresPageState();
}

class _ListeMatieresPageState extends State<ListeMatieresPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _matieres = [];

  @override
  void initState() {
    super.initState();
    _loadMatieres();
  }

  void _loadMatieres() async {
    // Charge les matières associées à la classe
    final data = await _dbHelper.getMatieresByClasse(widget.classeId);
    setState(() {
      _matieres = data;
    });
  }

  void _showAddMatiereDialog() {
    String nom = '';
    double coef = 1.0; // Valeur par défaut

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter une Matière'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  nom = value;
                },
                decoration:
                    const InputDecoration(hintText: "Nom de la matière"),
              ),
              TextField(
                onChanged: (value) {
                  coef = double.tryParse(value) ?? 1.0;
                },
                decoration: const InputDecoration(hintText: "Coefficient"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (nom.isNotEmpty) {
                  // Ajoute la matière à la base de données
                  await _dbHelper.insertMatiere(nom, coef);
                  final newMatiereId = await _dbHelper.getLastInsertId();
                  await _dbHelper.insertMatiereClasse(
                      newMatiereId, widget.classeId);
                  _loadMatieres(); // Recharge la liste des matières
                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _showEditMatiereDialog(
      int matiereId, String currentNom, double currentCoef) {
    String nom = currentNom;
    double coef = currentCoef;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier la Matière'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  nom = value;
                },
                decoration:
                    const InputDecoration(hintText: "Nom de la matière"),
                controller: TextEditingController(text: currentNom),
              ),
              TextField(
                onChanged: (value) {
                  coef = double.tryParse(value) ?? currentCoef;
                },
                decoration: const InputDecoration(hintText: "Coefficient"),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: currentCoef.toString()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (nom.isNotEmpty) {
                  // Met à jour la matière dans la base de données
                  await _dbHelper.updateMatiere(matiereId, nom, coef);
                  _loadMatieres(); // Recharge la liste des matières
                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
                }
              },
              child: const Text(
                'Enregistrer',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteMatiere(int matiereId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirmation de suppression",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: const Text(
            "Voulez-vous vraiment supprimer cette matière ?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Annuler",
                style: TextStyle(color: Color(0xFF6E6E75)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _dbHelper.deleteMatiere(matiereId);
                _loadMatieres(); // Recharge la liste des matières
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: const Text(
                "Confirmer",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Matières'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _matieres.isEmpty
          ? const Center(child: Text('Aucune matière disponible'))
          : ListView.builder(
              itemCount: _matieres.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_matieres[index]['nom']),
                  subtitle: Text('Coefficient: ${_matieres[index]['coef']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditMatiereDialog(
                          _matieres[index]['id'],
                          _matieres[index]['nom'],
                          _matieres[index]['coef'],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            _confirmDeleteMatiere(_matieres[index]['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMatiereDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
