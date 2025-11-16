import 'package:flutter/material.dart';
import 'database_helper.dart'; // Importer le DatabaseHelper pour gérer les évaluations
import 'AddEvaluationPage.dart'; // Importer la page d'ajout d'évaluation

class ListeEvaluation extends StatefulWidget {
  const ListeEvaluation({super.key});

  @override
  _ListeEvaluationState createState() => _ListeEvaluationState();
}

class _ListeEvaluationState extends State<ListeEvaluation> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> _getEvaluations() async {
    return await _databaseHelper.getEvaluationsWithSubject();
  }

  Future<void> _deleteEvaluation(int id) async {
    await _databaseHelper.deleteEvaluation(id);
    setState(() {}); // Rafraîchir la liste après suppression
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Évaluations"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getEvaluations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur lors du chargement des évaluations'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune évaluation trouvée'));
          } else {
            final evaluations = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: evaluations.length,
              itemBuilder: (context, index) {
                final evaluation = evaluations[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      evaluation['nom'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          'Matière: ${evaluation['matiere_nom'] ?? 'Inconnue'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Classe: ${evaluation['classe_nom'] ?? 'Inconnue'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Date: ${evaluation['date']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Confirmation"),
                            content: const Text(
                                "Êtes-vous sûr de vouloir supprimer cette évaluation ?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Annuler"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text(
                                  "Supprimer",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _deleteEvaluation(evaluation['id']);
                        }
                      },
                    ),
                    onTap: () {
                      // Action lors du clic sur une évaluation
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEvaluationPage(),
            ),
          );

          if (result == true) {
            setState(() {}); // Rafraîchir la liste après ajout
          }
        },
        icon: const Icon(
          Icons.add,
          size: 20, // Adjust the icon size for better visibility
        ),
        label: const Text(
          "Ajouter",
          style: TextStyle(
            fontSize: 18, // Adjust the label font size
          ),
        ),
        backgroundColor: const Color.fromARGB(217, 55, 20, 251),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        // Increase button size by adjusting the extended shape (minSize and maxSize)
        extendedPadding: EdgeInsets.symmetric(
            horizontal: 30, vertical: 15), // Adjust size with padding
      ),
    );
  }
}
