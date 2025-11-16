import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'AjoutElevePage.dart';
import 'ListeMatieresPage.dart';
import 'DetailsElevePage.dart';
import 'ModifierElevePage.dart';

class DetailsClassePage extends StatefulWidget {
  final int classeId;
  final String classeNom;
  final String anneeScolaire;

  const DetailsClassePage({
    super.key,
    required this.classeId,
    required this.classeNom,
    required this.anneeScolaire,
  });

  @override
  _DetailsClassePageState createState() => _DetailsClassePageState();
}

class _DetailsClassePageState extends State<DetailsClassePage> {
  List<Map<String, dynamic>> _filteredEleves = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadEleves();
  }

  void _loadEleves() async {
    final data = await _dbHelper.getElevesByClasse(widget.classeId);
    setState(() {
      _filteredEleves = data;
    });
  }

  void _deleteEleve(int eleveId) async {
    // Show confirmation dialog before deletion
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer cet élève ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Non'),
              onPressed: () {
                Navigator.of(context).pop(false); // User pressed No
              },
            ),
            TextButton(
              child: const Text('Oui'),
              onPressed: () {
                Navigator.of(context).pop(true); // User pressed Yes
              },
            ),
          ],
        );
      },
    );

    // If the user confirmed, proceed with deletion
    if (confirmed == true) {
      await _dbHelper
          .deleteEleve(eleveId); // Delete the student from the database
      _loadEleves(); // Reload the list of students
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.classeNom,
          style: TextStyle(color: Colors.blueGrey[900]),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.subject,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ListeMatieresPage(classeId: widget.classeId),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        _filteredEleves.length.toString(),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Nombre d\'élèves',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredEleves.length,
              itemBuilder: (context, index) {
                final eleve = _filteredEleves[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text(
                            eleve['numero'].toString(),
                            style: TextStyle(
                              color: Colors.blueGrey[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          title: Text(
                            '${eleve['nom']} ${eleve['prenom']}',
                            style: TextStyle(color: Colors.blueGrey[900]),
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.menu, color: Colors.teal),
                            onSelected: (value) {
                              if (value == 'modifier') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ModifierElevePage(eleve: eleve),
                                  ),
                                ).then((changesMade) {
                                  if (changesMade == true) {
                                    _loadEleves(); // Reload the list if changes were made
                                  }
                                });
                              } else if (value == 'supprimer') {
                                _deleteEleve(
                                    eleve['id']); // Suppression de l'élève
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem<String>(
                                  value: 'modifier',
                                  child: Text('Modifier'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'supprimer',
                                  child: Text('Supprimer'),
                                ),
                              ];
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsElevePage(eleve: eleve),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  label: const Text(
                    'Ajouter un élève',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AjoutElevePage(classeId: widget.classeId),
                      ),
                    ).then((_) {
                      _loadEleves();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF52C3FF),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 27),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
