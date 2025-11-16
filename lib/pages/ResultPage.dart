import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'ClassResultPage.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Map<String, dynamic>> classes = [];

  @override
  void initState() {
    super.initState();
    _fetchClasses();
  }

  Future<void> _fetchClasses() async {
    final dbHelper = DatabaseHelper();
    List<Map<String, dynamic>> classesFromDb = await dbHelper.getClasses();
    List<Map<String, dynamic>> updatedClasses = [];

    for (var classData in classesFromDb) {
      int classId = classData['id'];
      int studentCount = await dbHelper.getEleveCountByClasse(classId);
      int matiereCount = await dbHelper.getMatiereCountByClasse(classId);

      // Récupérer les étudiants pour cette classe
      List<Map<String, dynamic>> students =
          await dbHelper.getStudentsByClasse(classId);

      // Mise à jour des données de la classe
      Map<String, dynamic> updatedClassData =
          Map<String, dynamic>.from(classData);
      updatedClassData['studentCount'] = studentCount;
      updatedClassData['matiereCount'] = matiereCount;
      updatedClassData['students'] = students; // Ajouter les étudiants
      updatedClasses.add(updatedClassData);
    }

    setState(() {
      classes = updatedClasses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Gérer vos résultats scolaires",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        toolbarHeight: 100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.builder(
          itemCount: classes.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                _buildClassCard(classes[index]),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFFAFAFA),
    );
  }

  Widget _buildClassCard(Map<String, dynamic> classData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassResultPage(
                classData: classData), // Passer les données de classe
          ),
        );
      },
      child: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                classData['nom'] ?? '',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E4A89)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.book, size: 18, color: Color(0xFFE91E63)),
                  const SizedBox(width: 8),
                  Text(
                    "${classData['matiereCount'] ?? 0} Matières",
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 18, color: Color(0xFF2196F3)),
                  const SizedBox(width: 8),
                  Text(
                    "Année scolaire: ${classData['annee_scolaire'] ?? ''}",
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.group, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    "Nombre d'élèves : ${classData['studentCount'] ?? 0}",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(186, 106, 112, 106)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
