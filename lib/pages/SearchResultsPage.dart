import 'package:flutter/material.dart';
import 'DetailsElevePage.dart'; // Assurez-vous d'importer la page de détails de l'élève

class SearchResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;

  const SearchResultsPage({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats de Recherche'),
        backgroundColor: Colors.teal, // Use a color consistent with your theme
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
                        searchResults.length.toString(),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Nombre d\'élèves trouvés',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
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
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final student = searchResults[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Text(
                        student['numero'].toString(),
                        style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      title: Text(
                        '${student['nom']} ${student['prenom']}',
                        style: TextStyle(color: Colors.blueGrey[900]),
                      ),
                      subtitle: Text(
                        'Classe: ${student['classe_nom']}',
                        style: TextStyle(color: Colors.blueGrey[600]),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.teal,
                      ),
                      onTap: () {
                        // Naviguer vers la page de détails de l'élève
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsElevePage(eleve: student),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
