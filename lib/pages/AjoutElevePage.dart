import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import pour formater la date
import 'database_helper.dart';

class AjoutElevePage extends StatefulWidget {
  final int classeId; // L'ID de la classe à laquelle l'élève sera ajouté

  const AjoutElevePage({super.key, required this.classeId});

  @override
  _AjoutElevePageState createState() => _AjoutElevePageState();
}

class _AjoutElevePageState extends State<AjoutElevePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _dateNaissanceController =
      TextEditingController();
  final TextEditingController _numeroController =
      TextEditingController(); // Nouveau contrôleur pour numéro
  String? _sexe;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Méthode pour ajouter l'élève dans la base de données
  Future<void> _ajouterEleve() async {
    if (_formKey.currentState!.validate()) {
      await _dbHelper.insertEleve(
        nom: _nomController.text,
        prenom: _prenomController.text,
        dateNaissance: _dateNaissanceController.text,
        sexe: _sexe!,
        numero: _numeroController.text, // Ajout du numéro ici
        classeId: widget.classeId,
      );
      Navigator.pop(context); // Retourner à la page précédente après l'ajout
    }
  }

  // Méthode pour afficher le sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Date par défaut : aujourd'hui
      firstDate: DateTime(1900), // Date minimale
      lastDate: DateTime.now(), // Date maximale : aujourd'hui
    );

    if (pickedDate != null) {
      setState(() {
        // Formater la date (par exemple en "yyyy-MM-dd")
        _dateNaissanceController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDC), // Couleur de fond beige
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                'Ajouter une élève',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Remplir les champs',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      _buildTextField(
                        label: "Nom de l'élève",
                        controller: _nomController,
                        hint: "Entrez le nom de l'élève",
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Prénom de l'élève",
                        controller: _prenomController,
                        hint: "Entrez le prénom de l'élève",
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Numéro de l'élève", // Nouveau champ pour numéro
                        controller: _numeroController,
                        hint: "Entrez le numéro de l'élève",
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: "Date de naissance",
                        controller: _dateNaissanceController,
                        hint: "Sélectionnez la date de naissance",
                        readOnly: true,
                        onTap: () {
                          _selectDate(context);
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sexe',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _sexe,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'M', child: Text('Masculin')),
                          DropdownMenuItem(value: 'F', child: Text('Féminin')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _sexe = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Veuillez sélectionner un sexe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _ajouterEleve,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFF5A623), // Bouton orange
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 64),
                          ),
                          child: const Text('Enregistrer'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode utilitaire pour construire un TextField avec un style cohérent
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0), // Bord arrondi
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ce champ est requis';
            }
            return null;
          },
        ),
      ],
    );
  }
}
