import 'package:flutter/material.dart';
import 'database_helper.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  // Contrôleur pour le champ de recherche
  final TextEditingController _searchController = TextEditingController();
  // Liste des pense-bêtes filtrés
  List<Map<String, dynamic>> _filteredPenseBetes = [];
  // Liste des pense-bêtes d'origine
  List<Map<String, dynamic>> _allPenseBetes = [];

  // Fonction pour rechercher par titre
  void _searchPenseBete(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPenseBetes = _allPenseBetes;
      });
    } else {
      setState(() {
        _filteredPenseBetes = _allPenseBetes
            .where((penseBete) =>
                penseBete['titre'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialiser la liste des pense-bêtes au démarrage
    _loadPenseBetes();
  }

  // Charger les pense-bêtes depuis la base de données
  void _loadPenseBetes() async {
    final penseBetes = await DatabaseHelper().getPenseBetes();
    setState(() {
      _allPenseBetes = penseBetes;
      _filteredPenseBetes = penseBetes; // Afficher tout au départ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Historique'),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            // Affiche le dialogue pour ajouter un pense-bête
            showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController titreController = TextEditingController();
                TextEditingController contenuController =
                    TextEditingController();

                return AlertDialog(
                  title: const Text("Ajouter un pense-bête"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titreController,
                        decoration: const InputDecoration(
                          labelText: "Titre",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: contenuController,
                        decoration: const InputDecoration(
                          labelText: "Contenu",
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Annuler"),
                      onPressed: () async {
                        String titre = titreController.text;
                        String contenu = contenuController.text;

                        if (titre.isNotEmpty && contenu.isNotEmpty) {
                          await DatabaseHelper()
                              .insertPenseBete(titre, contenu);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pense-bête ajouté !'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          _loadPenseBetes(); // Recharger les pense-bêtes
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Veuillez remplir tous les champs'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Enregistrer"),
                      onPressed: () async {
                        String titre = titreController.text;
                        String contenu = contenuController.text;

                        if (titre.isNotEmpty && contenu.isNotEmpty) {
                          await DatabaseHelper()
                              .insertPenseBete(titre, contenu);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pense-bête ajouté !'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          _loadPenseBetes(); // Recharger les pense-bêtes
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Veuillez remplir tous les champs'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pense-bêtes",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher par titre...",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Recherche lors de la saisie
                    _searchPenseBete(_searchController.text);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: Future.value(
                    _filteredPenseBetes), // Utiliser la liste filtrée
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Aucun pense-bête trouver",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final penseBete = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            penseBete['titre'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(penseBete['contenu']),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await DatabaseHelper()
                                  .deletePenseBete(penseBete['id']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pense-bête supprimé !'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              _loadPenseBetes(); // Rafraîchir la liste après la suppression
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
