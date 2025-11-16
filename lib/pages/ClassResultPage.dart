import 'package:flutter/material.dart';
import 'EleveResultPage.dart';

class ClassResultPage extends StatelessWidget {
  final Map<String, dynamic> classData;

  const ClassResultPage({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> students =
        classData['students'] as List<Map<String, dynamic>>? ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(classData['nom'] ?? 'Liste des élèves'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildClassInfo(classData),
            const SizedBox(height: 20),
            const Text(
              'Liste des élèves',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildStudentList(context, students),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassInfo(Map<String, dynamic> classData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          classData['nom'] ?? 'Nom de la classe',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          Icons.book,
          "Nombre de matières: ${classData['matiereCount']}",
          const Color(0xFFE91E63),
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          Icons.calendar_today,
          "Année scolaire: ${classData['annee_scolaire']}",
          const Color(0xFF2196F3),
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          Icons.group,
          "Nombre d'élèves: ${classData['studentCount']}",
          const Color.fromARGB(186, 106, 112, 106),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 10),
        Text(text),
      ],
    );
  }

  Widget _buildStudentList(
      BuildContext context, List<Map<String, dynamic>> students) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: _buildStudentCard(context, student, index + 1),
        );
      },
    );
  }

  Widget _buildStudentCard(
      BuildContext context, Map<String, dynamic> student, int rank) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EleveResultPage(studentData: student),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 40),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${student['nom']} ${student['prenom']}",
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.play_arrow,
                          color: Color.fromARGB(165, 0, 0, 0)),
                    ],
                  ),
                  onPressed: () {
                    // Action pour le bouton play
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            top: 12,
            child: Text(
              "${student['numero']}",
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
