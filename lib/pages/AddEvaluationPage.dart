import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart'; // Importer votre DatabaseHelper

class AddEvaluationPage extends StatefulWidget {
  const AddEvaluationPage({super.key});

  @override
  _AddEvaluationPageState createState() => _AddEvaluationPageState();
}

class _AddEvaluationPageState extends State<AddEvaluationPage> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  int? _selectedMatiereId;
  int? _selectedClasseId;
  String? _errorMessage;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _addEvaluation() async {
    setState(() {
      if (_nomController.text.isEmpty ||
          _selectedClasseId == null ||
          _selectedMatiereId == null) {
        _errorMessage = "Tous les champs doivent être remplis";
      } else {
        _errorMessage = null;
      }
    });

    if (_errorMessage == null) {
      await _databaseHelper.insertEvaluation(
        nom: _nomController.text,
        date: _dateController.text,
        classeId: _selectedClasseId!,
        matiereId: _selectedMatiereId!,
      );
      Navigator.pop(context, true); // Retourner true après l'ajout
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5E7D5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
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
                  'Ajouter une Évaluation',
                  style: TextStyle(
                    color: Color(0xFF6E6E75),
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
                // Champ pour le nom de l'évaluation
                TextField(
                  controller: _nomController,
                  style: const TextStyle(color: Color(0xFF6E6E75)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Nom de l\'évaluation',
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 15),
                // Champ pour la date
                TextField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                  style: const TextStyle(color: Color(0xFF6E6E75)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Date de l\'évaluation',
                    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 15),
                // Dropdown pour les classes
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _databaseHelper.getClasses(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return DropdownButtonFormField<int>(
                      value: _selectedClasseId,
                      hint: const Text('Sélectionner une classe'),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedClasseId = newValue;
                        });
                      },
                      items: snapshot.data!.map((classe) {
                        return DropdownMenuItem<int>(
                          value: classe['id'],
                          child: Text(classe['nom']),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                // Dropdown pour les matières
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _selectedClasseId != null
                      ? _databaseHelper.getMatieresByClasse(_selectedClasseId!)
                      : Future.value([]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return DropdownButtonFormField<int>(
                      value: _selectedMatiereId,
                      hint: const Text('Sélectionner une matière'),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedMatiereId = newValue;
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
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                      ),
                    );
                  },
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),
                const SizedBox(height: 40),
                // Bouton pour ajouter l'évaluation
                ElevatedButton(
                  onPressed: _addEvaluation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDBA5C),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
