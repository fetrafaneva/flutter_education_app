import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'EditNotePage.dart';

class DetailsElevePage extends StatefulWidget {
  final Map<String, dynamic> eleve;

  const DetailsElevePage({super.key, required this.eleve});

  @override
  _DetailsElevePageState createState() => _DetailsElevePageState();
}

class _DetailsElevePageState extends State<DetailsElevePage> {
  String activeMenu = 'Note';
  List<Map<String, dynamic>> matieres = [];
  int? selectedEvaluationId;
  String? selectedEvaluationNom;
  String? nomClasse; // Variable pour stocker le nom de la classe

  @override
  void initState() {
    super.initState();
    _loadEvaluations();
    _loadNomClasse(); // Charger le nom de la classe
  }

  Future<void> _deleteNote(int matiereId) async {
    final db = DatabaseHelper();
    int eleveId = widget.eleve['id'];

    // Suppression de la note pour cette matière et cet élève
    await db.deleteNoteForMatiere(eleveId, matiereId);

    _loadMatieresAvecNotes(); // Recharge les matières avec leurs notes après suppression
  }

  Future<void> _loadNomClasse() async {
    final db = DatabaseHelper();
    int classeId = widget.eleve['classe_id'];

    // Charger le nom de la classe
    final classe = await db.getClasseById(classeId);
    setState(() {
      nomClasse = classe?['nom'] ?? 'Non assigné';
    });
  }

  Future<void> _loadEvaluations() async {
    final db = DatabaseHelper();
    int classeId = widget.eleve['classe_id'];

    // Charger les évaluations
    final List<Map<String, dynamic>> evaluations =
        await db.getEvaluationsByClasse(classeId);
    setState(() {
      if (evaluations.isNotEmpty) {
        selectedEvaluationId = evaluations[0]['id'];
        selectedEvaluationNom = evaluations[0]['nom'];
      }
    });

    _loadMatieresAvecNotes();
  }

  void _showDeleteConfirmationDialog(int matiereId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Supprimer la note"),
          content: const Text(
              "Êtes-vous sûr de vouloir supprimer cette note pour cette matière ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                _deleteNote(matiereId);
                Navigator.of(context).pop();
              },
              child:
                  const Text("Supprimer", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadMatieresAvecNotes() async {
    if (selectedEvaluationNom == null) return;

    final db = DatabaseHelper();
    final List<Map<String, dynamic>> result =
        await db.getMatieresAvecNotesPourEvaluationParNom(
            selectedEvaluationNom!, widget.eleve['id']);

    setState(() {
      matieres = result;
    });
    print("Loaded matieres: $matieres");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.eleve['nom'],
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(179, 57, 57, 57),
                  ),
                ),
                Text(
                  widget.eleve['prenom'],
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(228, 90, 90, 90),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.grey),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        toolbarHeight: 100,
      ),
      body: Container(
        color: const Color(0xFFEBF5FD),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 320,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _buildMenuButton(
                        'Note', const Color(0xFFF6AD2C), activeMenu == 'Note'),
                    _buildMenuButton('Descriptions', const Color(0xFFF6AD2C),
                        activeMenu == 'Détail'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: activeMenu == 'Note'
                    ? _buildNoteContent()
                    : _buildDetailContent(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddNoteDialog(context);
                  },
                  label: const Text('Ajouter note',
                      style: TextStyle(color: Colors.white)),
                  icon: const Icon(Icons.add, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF52C3FF),
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String label, Color color, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            activeMenu = label == 'Descriptions' ? 'Détail' : label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: isActive ? color : Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoteContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEvaluationDropdown(),
        const SizedBox(height: 20),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2), // Colonne plus large pour la matière
            1: FlexColumnWidth(1), // Colonne pour la note
            2: FixedColumnWidth(
                48), // Largeur fixe pour l'icône de modification
            3: FixedColumnWidth(48), // Largeur fixe pour l'icône de suppression
          },
          border: TableBorder.all(
              color: Colors.grey.shade300), // Bordure du tableau
          children: [
            // En-tête du tableau
            TableRow(
              decoration: BoxDecoration(color: Colors.blueAccent.shade100),
              children: const [
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Matière',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Note',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(), // Cellule vide pour l'icône de modification
                SizedBox(), // Cellule vide pour l'icône de suppression
              ],
            ),
            // Lignes de données du tableau
            ...matieres.map((matiere) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8.0),
                    child: Text(
                      matiere['nom'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 8.0),
                    child: Text(
                      matiere['note'] != null
                          ? (matiere['note'] % 1 == 0
                              ? matiere['note'].toInt().toString().padLeft(2,
                                  '0') // Affiche l'entier avec 0 devant si nécessaire
                              : matiere['note'].toStringAsFixed(
                                  2)) // Affiche avec deux décimales pour les notes décimales
                          : 'Aucune note',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.blueAccent),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      final bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNotePage(
                            matiere: matiere,
                            eleveId: widget.eleve['id'],
                          ),
                        ),
                      );
                      // Refresh data if note was updated
                      if (result == true) {
                        _loadMatieresAvecNotes();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showDeleteConfirmationDialog(matiere['id']);
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détail de l\'élève',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Nom :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.eleve['nom']),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Prénom :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.eleve['prenom']),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Date de naissance :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.eleve['date_naissance']),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Numéro :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.eleve['numero']),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Sexe :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.eleve['sexe']),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Classe :",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(nomClasse ?? 'Non assigné'), // Utilisez nomClasse
          ],
        ),
      ],
    );
  }

  Widget _buildEvaluationDropdown() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchEvaluations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text("Erreur lors du chargement des évaluations");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Aucune évaluation disponible");
        }

        // Utiliser un ensemble pour suivre les noms uniques
        final seenNames = <String>{};
        // Filtrer les évaluations pour ne garder que les noms uniques
        final uniqueEvaluations = snapshot.data!.where((evaluation) {
          final isUnique = seenNames.add(evaluation['nom']);
          return isUnique; // inclure uniquement si le nom n'a pas encore été vu
        }).toList();

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFF52C3FF)), // Blue border
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: DropdownButton<int>(
            value: selectedEvaluationId,
            hint: const Text("Sélectionner une évaluation"),
            underline: SizedBox(), // Remove the default underline
            isExpanded: true, // Make dropdown take full width
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF52C3FF)),
            onChanged: (int? newEvaluationId) {
              setState(() {
                selectedEvaluationId = newEvaluationId;
                selectedEvaluationNom = uniqueEvaluations.firstWhere(
                    (evaluation) => evaluation['id'] == newEvaluationId)['nom'];
              });
              _loadMatieresAvecNotes();
            },
            items: uniqueEvaluations.map((evaluation) {
              return DropdownMenuItem<int>(
                value: evaluation['id'],
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    evaluation['nom'],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchEvaluations() async {
    final db = DatabaseHelper();
    int classeId = widget.eleve['classe_id'];
    return await db.getEvaluationsByClasse(classeId);
  }

  void _showAddNoteDialog(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    final TextEditingController commentaireController = TextEditingController();
    int? selectedMatiereId;
    String? selectedMatiereNom;
    int? selectedEvaluationId;
    String? selectedEvaluationNom;

    Future<List<Map<String, dynamic>>> fetchMatieres() async {
      final db = DatabaseHelper();
      int classeId = widget.eleve['classe_id'];
      return await db.getMatieresByClasse(classeId);
    }

    Future<List<Map<String, dynamic>>> fetchEvaluations() async {
      if (selectedMatiereId != null) {
        final db = DatabaseHelper();
        return await db.getEvaluationsByMatiere(selectedMatiereId!);
      }
      return [];
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Ajouter une note",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sélecteur de matière
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchMatieres(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Erreur lors du chargement des matières");
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text("Aucune matière disponible");
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: DropdownButtonFormField<int>(
                            value: selectedMatiereId,
                            hint: const Text("Sélectionner une matière"),
                            onChanged: (int? newMatiereId) {
                              setState(() {
                                selectedMatiereId = newMatiereId;
                                selectedMatiereNom = snapshot.data!.firstWhere(
                                    (matiere) =>
                                        matiere['id'] == newMatiereId)['nom'];
                              });
                            },
                            items: snapshot.data!.map((matiere) {
                              return DropdownMenuItem<int>(
                                value: matiere['id'],
                                child: Text(matiere['nom']),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Sélecteur d'évaluation
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: fetchEvaluations(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              "Erreur lors du chargement des évaluations");
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text("Aucune évaluation disponible");
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: DropdownButtonFormField<int>(
                            value: selectedEvaluationId,
                            hint: const Text("Sélectionner une évaluation"),
                            onChanged: (int? newEvaluationId) {
                              setState(() {
                                selectedEvaluationId = newEvaluationId;
                                selectedEvaluationNom = snapshot.data!
                                    .firstWhere((evaluation) =>
                                        evaluation['id'] ==
                                        newEvaluationId)['nom'];
                              });
                            },
                            items: snapshot.data!.map((evaluation) {
                              return DropdownMenuItem<int>(
                                value: evaluation['id'],
                                child: Text(evaluation['nom']),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Champ de la note
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          labelText: "Note",
                          labelStyle: const TextStyle(color: Color(0xFF6E6E75)),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),

                    // Champ de commentaire
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: TextField(
                        controller: commentaireController,
                        decoration: InputDecoration(
                          labelText: "Commentaire",
                          labelStyle: const TextStyle(color: Color(0xFF6E6E75)),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
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
                  onPressed: () {
                    // Logique pour ajouter la note dans la base de données
                    if (selectedMatiereId != null &&
                        selectedEvaluationId != null) {
                      DatabaseHelper().insertNote(
                        eleveId: widget.eleve['id'],
                        matiereId: selectedMatiereId!,
                        evaluationId: selectedEvaluationId!,
                        note: double.tryParse(noteController.text) ?? 0,
                        commentaire: commentaireController.text,
                      );
                      Navigator.of(context).pop();
                      _loadMatieresAvecNotes(); // Recharge les matières et notes
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDBA5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 60),
                  ),
                  child: const Text(
                    "Ajouter",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
