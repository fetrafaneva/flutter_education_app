import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import DatabaseHelper
import 'DetailsClassePage.dart'; // Import DetailsClassePage

class GestionClass extends StatefulWidget {
  const GestionClass({super.key});

  @override
  _GestionClassState createState() => _GestionClassState();
}

class _GestionClassState extends State<GestionClass> {
  List<Map<String, dynamic>> _classes = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Map<String, dynamic>? _selectedClass; // To track the selected class
  bool _isLongPressed = false; // To track the long press state

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  void _loadClasses() async {
    final data = await _dbHelper.getClasses();
    setState(() {
      // Copy the data into a modifiable list
      _classes = List<Map<String, dynamic>>.from(data);
    });
  }

  void _showAddClassDialog() {
    final TextEditingController nomController = TextEditingController();
    final TextEditingController anneeScolaireController =
        TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF3F8ED),
          title: const Text('Ajouter une classe',
              style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nomController,
                  decoration:
                      const InputDecoration(labelText: 'Nom de la classe'),
                ),
                TextField(
                  controller: anneeScolaireController,
                  decoration:
                      const InputDecoration(labelText: 'Année scolaire'),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child:
                  const Text('Annuler', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  if (nomController.text.isEmpty ||
                      anneeScolaireController.text.isEmpty) {
                    errorMessage = "Tous les champs doivent être remplis";
                  } else {
                    errorMessage = null;
                  }
                });

                if (errorMessage == null) {
                  await _dbHelper.insertClasse(
                    nomController.text,
                    anneeScolaireController.text,
                  );
                  Navigator.of(context).pop();
                  _loadClasses();
                }
              },
              child:
                  const Text('Ajouter', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  // Function to show a confirmation dialog before deletion
  void _showDeleteConfirmationDialog(int classId) {
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
            "Êtes-vous sûr de vouloir supprimer cette classe ?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: const Text(
                "Annuler",
                style: TextStyle(color: Color(0xFF6E6E75)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                _deleteClass(classId); // Supprime la classe
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

  void _deleteClass(int classId) async {
    await _dbHelper.deleteClasse(classId);
    setState(() {
      // Copy the list to a modifiable list before removing
      _classes = List<Map<String, dynamic>>.from(_classes);
      _classes.removeWhere((classe) => classe['id'] == classId);
      _isLongPressed = false; // Reset the long press state
      _selectedClass = null; // Reset the selected class
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedClass = null; // Deselect class when tapping outside
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Gérer vos classes',
            style:
                TextStyle(color: Colors.black, fontSize: 18), // Taille réduite
          ),
          backgroundColor: const Color(0xFFF3F8ED),
          elevation: 0,
          actions: [
            if (_isLongPressed)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  if (_selectedClass != null) {
                    _showDeleteConfirmationDialog(_selectedClass!['id']);
                    setState(() {
                      _isLongPressed = false;
                      _selectedClass = null;
                    });
                  }
                },
              ),
          ],
        ),
        body: Container(
          color: const Color(0xFFF3F8ED),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Liste des classes',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _classes.length,
                  itemBuilder: (context, index) {
                    final classe = _classes[index];
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          _isLongPressed = true;
                          _selectedClass = classe;
                        });
                      },
                      onTap: () {
                        if (_isLongPressed) {
                          setState(() {
                            _selectedClass = null; // Deselect on single tap
                            _isLongPressed = false;
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsClassePage(
                                classeId: classe['id'],
                                classeNom: classe['nom'],
                                anneeScolaire: classe['annee_scolaire'],
                              ),
                            ),
                          ).then((_) {
                            _loadClasses();
                          });
                        }
                      },
                      child: _buildClassItem(
                        icon: Icons.class_,
                        className: classe['nom'],
                        anneeScolaire: classe['annee_scolaire'],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text(
                        'Ajouter Classe',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      onPressed: _showAddClassDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEAD7C3),
                        padding: const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 27.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassItem({
    required IconData icon,
    required String className,
    required String anneeScolaire,
  }) {
    // Déterminer si l'élément est sélectionné
    bool isSelected =
        _selectedClass != null && _selectedClass!['nom'] == className;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue[100]
              : const Color(
                  0xFFF5F5F5), // Couleur différente pour la classe sélectionnée
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 4,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          leading: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(icon, color: Colors.black),
          ),
          title: Text(
            className,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.date_range, size: 18, color: Colors.black54),
              const SizedBox(width: 5),
              Text(
                'Année scolaire: $anneeScolaire',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 20, color: Colors.black54),
        ),
      ),
    );
  }
}
