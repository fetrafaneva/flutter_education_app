import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditNotePage extends StatefulWidget {
  final Map<String, dynamic> matiere;
  final int eleveId;

  const EditNotePage({super.key, required this.matiere, required this.eleveId});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _commentaireController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.matiere['note']?.toString() ?? '';
    _commentaireController.text = widget.matiere['commentaire'] ?? '';
  }

  Future<void> _updateNote() async {
    final db = DatabaseHelper();
    await db.updateNote(
      eleveId: widget.eleveId,
      matiereId: widget.matiere['id'],
      note: double.tryParse(_noteController.text) ?? 0,
      commentaire: _commentaireController.text,
    );
    Navigator.pop(context, true); // Pass `true` to indicate a successful update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la note'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        // Centering the content
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center horizontally
              children: [
                // Titre
                Text(
                  "Matière : ${widget.matiere['nom']}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 20),

                // Champ de texte pour la note
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: "Note",
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    prefixIcon: Icon(Icons.star, color: Colors.blueAccent),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // Champ de texte pour le commentaire
                TextFormField(
                  controller: _commentaireController,
                  decoration: InputDecoration(
                    labelText: "Commentaire",
                    labelStyle: TextStyle(color: Colors.blueAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                    prefixIcon: Icon(Icons.comment, color: Colors.blueAccent),
                  ),
                  maxLines: 4,
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 30),

                // Bouton de mise à jour
                ElevatedButton(
                  onPressed: _updateNote,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 17),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    "Mettre à jour",
                    style: TextStyle(fontSize: 16),
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
