import 'dart:io';
import 'package:sqflite/sqflite.dart'; // Importation pour obtenir le chemin de la base de données
import 'package:file_picker/file_picker.dart'; // Ajoutez cette importation
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour SystemUiOverlayStyle
import 'package:permission_handler/permission_handler.dart'; // Pour gérer les permissions
import 'package:path/path.dart' as path; // Importation correcte
import 'package:path_provider/path_provider.dart'; // Pour obtenir le chemin du répertoire
import 'gestion_classe.dart'; // Remplacez par le chemin correct
import 'ListeEvaluation.dart'; // Importez la page ListeEvaluation
import 'ResultPage.dart';
import 'SearchResultsPage.dart';
import 'Historique.dart';
import 'UserPage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  final FocusNode _searchFocusNode = FocusNode(); // Ajout du FocusNode

  bool _isSearching = false;

  int _currentIndex = 2; // Index de l'onglet sélectionné par défaut (Accueil)
  late List<Widget> _pages; // Déclaration tardive

  // Méthode pour rechercher l'élève par nom et prénom dans la base de données
  Future<void> searchStudent() async {
    String query = _searchController.text;

    // On vérifie si le champ de recherche n'est pas vide
    if (query.isNotEmpty) {
      Database db = await openDatabase(
        path.join(await getDatabasesPath(), 'users.db'),
      );

      // Recherche dans la base de données avec une jointure pour récupérer le nom de la classe
      final List<Map<String, dynamic>> results = await db.rawQuery(
        '''
      SELECT Eleve.*, Classe.nom AS classe_nom 
      FROM Eleve 
      LEFT JOIN Classe ON Eleve.classe_id = Classe.id 
      WHERE Eleve.nom LIKE ? OR Eleve.prenom LIKE ?
      ''',
        ['%$query%', '%$query%'],
      );

      // Si des résultats sont trouvés, naviguez vers la page SearchResultsPage
      if (results.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsPage(searchResults: results),
          ),
        );
      } else {
        // Affichez un message si aucun élève n'est trouvé
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Aucun élève trouvé.")),
        );
      }
    } else {
      // Si la recherche est vide, on réinitialise les résultats
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  // Méthode pour importer la base de données
  Future<void> importerBaseDeDonnees() async {
    var status = await Permission.storage.request();

    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType
            .any, // Changez ici pour permettre tous les types de fichiers
      );

      if (result != null) {
        String? filePath = result.files.single.path;
        String dbPath = path.join(await getDatabasesPath(), 'users.db');

        final importedDbFile = File(filePath!);
        await importedDbFile.copy(dbPath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Base de données importée avec succès !'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Aucun fichier sélectionné.'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Permission refusée. Impossible d\'importer la base de données.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialisation des pages
    _pages = [
      const UserPage(), // Page Utilisateur, redirigée vers la page UserPage
      _buildSearchPage(), // Page de recherche modifiée
      // Page d'accueil
      Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/profile_icon.png', // Icône du profil
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Organiser votre travail",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "plus précis",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Image principale Education dans un Container avec BoxFit.cover et ClipRRect
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 386,
                      height: 221,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/education_image.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Gestion des classes
                _buildMenuItem(
                  iconPath: 'assets/images/class_icon.png',
                  title: 'Gestion des classes',
                  subtitle: 'Gerer vos classes',
                  onTap: () {
                    // Navigation vers la page GestionClass
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GestionClass()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // Gestion des résultats
                _buildMenuItem(
                  iconPath: 'assets/images/result_icon.png',
                  title: 'Gestion des évaluations',
                  subtitle: 'trier vos données',
                  onTap: () {
                    // Navigation vers la page ListeEvaluation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ListeEvaluation()),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // Importer/Exporter
                _buildMenuItem(
                  iconPath: 'assets/images/export_icon.png',
                  title: 'Gestion des résultats',
                  subtitle: 'stocker vos informations',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResultPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // Remplacez l'élément de la page Historique dans _pages par ce code
      const Center(child: Text("Page historique")),

      _buildStatisticsPage(), // Page des statistiques
    ];
  }

  // Méthode pour exporter la base de données
  Future<void> exporterBaseDeDonnees() async {
    // Demande de permission d'accès au stockage
    var status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      // Récupération du chemin de la base de données
      String dbPath = path.join(await getDatabasesPath(), 'users.db');

      // Obtenez le répertoire de téléchargements
      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }

      // Définir le chemin d'exportation
      String exportPath = path.join(downloadsDirectory.path, 'users.db');

      final dbFile = File(dbPath);
      await dbFile.copy(exportPath);

      print('Base de données exportée vers $exportPath');

      // Afficher un SnackBar pour indiquer que l'exportation a réussi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Base de données exportée avec succès !'),
          duration: const Duration(seconds: 2), // Durée d'affichage du SnackBar
        ),
      );
    } else {
      print('Permission denied. Unable to export the database.');

      // Afficher un SnackBar pour indiquer que la permission a été refusée
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Permission refusée. Impossible d\'exporter la base de données.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Méthode pour construire la page de recherche avec la gestion des notes
  Widget _buildSearchPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barre de recherche avec bouton
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: Colors.white54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  focusNode:
                                      _searchFocusNode, // Assignez le FocusNode ici
                                  decoration: const InputDecoration(
                                    hintText: 'Rechercher par nom ou prénom',
                                    hintStyle: TextStyle(
                                        color: Color.fromARGB(137, 70, 68, 68)),
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(
                                      color: Color.fromARGB(238, 70, 68, 68)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Lancer la recherche lorsque le bouton est pressé
                          searchStudent();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6E6E),
                          shape: const CircleBorder(),
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Affichage des résultats de recherche ou de l'image et du texte par défaut
                  _isSearching && _searchResults.isNotEmpty
                      ? Column(
                          children: _searchResults.map((student) {
                            return ListTile(
                              title: Text(
                                '${student['nom']} ${student['prenom']}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              subtitle: Text('Classe: ${student['classe_id']}'),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () {
                                // Action pour afficher les détails de l'élève
                              },
                            );
                          }).toList(),
                        )
                      : _isSearching && _searchResults.isEmpty
                          ? const Center(
                              child: Text(
                                "Aucun élève trouvé.",
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : _buildDefaultSearchContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultSearchContent() {
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/images/searching.png',
            width: 400,
            height: 400,
            fit: BoxFit.contain,
          ),
        ),
        const Center(
          child: Column(
            children: [
              Text(
                "Page de recherche",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                "Ici, vous pouvez rechercher les informations des élèves",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Mise à jour des éléments de menu pour inclure les icônes avec fond
  static Widget _buildMenuItem({
    required String iconPath,
    required String title,
    required String subtitle,
    required void Function() onTap, // Ajout du callback onTap
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFE58D8D), // Couleur de fond rond
          ),
          child: Image.asset(
            iconPath,
            width: 40,
            height: 40,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap, // Exécution du callback onTap
      ),
    );
  }

  // Méthode pour construire la page des statistiques
  Widget _buildStatisticsPage() {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center, // Centre les éléments verticalement
      children: [
        const SizedBox(height: 50),
        // Texte principal
        const Text(
          "Gestion des Fichiers",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey, // Couleur grise
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Conteneur blanc autour de l'image avec une marge et un rayon nul
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0), // Marge externe
          padding: const EdgeInsets.all(8.0), // Espacement interne
          decoration: BoxDecoration(
            color: Colors.white, // Fond blanc
            borderRadius: BorderRadius.circular(50), // Rayon nul
          ),
          child: Image.asset(
            'assets/images/data.png',
            height: 200,
            width: 400,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 100),
        // Texte sous l'image
        const Text(
          "Transférez Vos Données en Toute Simplicité",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400, // Poids régulier
            color: Colors.grey, // Couleur grise
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        // Boutons avec icônes
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .center, // Centre les éléments horizontalement
            children: [
              // Bouton d'importation
              ElevatedButton.icon(
                onPressed: () {
                  _showImportConfirmationDialog();
                },
                icon: const Icon(Icons.upload,
                    color: Colors.white), // Icône pour l'import
                label: const Text(
                  'Ajouter via import',
                  style: TextStyle(
                    color: Colors.white, // Couleur du texte
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Couleur de fond du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Bords arrondis
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                ),
              ),
              const SizedBox(height: 10), // Espacement entre les boutons
              // Bouton d'exportation
              ElevatedButton.icon(
                onPressed: () {
                  exporterBaseDeDonnees();
                },
                icon: const Icon(Icons.download,
                    color: Colors.white), // Icône pour l'export
                label: const Text(
                  'Partager via export',
                  style: TextStyle(
                    color: Colors.white, // Couleur du texte
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Couleur de fond du bouton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Bords arrondis
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

// Afficher une boîte de dialogue pour confirmer l'importation
  void _showImportConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirmation d'importation",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: const Text(
            "Importer signifie supprimer vos données. Voulez vous vraiment continuer ?",
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
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
                importerBaseDeDonnees(); // Exécute l'importation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness:
            Brightness.dark, // Dark icons for light background
      ),
      child: GestureDetector(
        onTap: () {
          // Fermer le clavier si l'utilisateur tape en dehors du champ de texte
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor:
              const Color(0xFFF5E7D5), // Fond de l'application modifié
          body: _currentIndex == 3
              ? HistoriquePage() // Redirige vers la page Historique
              : _pages[
                  _currentIndex], // Affiche la page sélectionnée pour les autres index
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            backgroundColor:
                const Color(0xFF6A5ACD), // Couleur modifiée de la barre de menu
            selectedItemColor: Colors.white, // Couleur des icônes sélectionnées
            unselectedItemColor:
                Colors.white70, // Couleur des icônes non sélectionnées
            showSelectedLabels: false, // Cacher les labels
            showUnselectedLabels: false,
            type: BottomNavigationBarType
                .fixed, // Pour conserver les icônes fixes
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Utilisateur', // Titre pour l'onglet Utilisateur
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Recherche',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Historique',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Statistiques',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Dashboard(),
  ));
}
