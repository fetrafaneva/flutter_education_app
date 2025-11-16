import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_palette.dart'; // Import de la classe des palettes
import 'EmailPage.dart'; // Import de la page Email
import 'PasswordPage.dart'; // Import de la page Password

class Inscription extends StatelessWidget {
  const Inscription({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor:
            Colors.transparent, // Rendre la barre de statut transparente
        statusBarIconBrightness:
            Brightness.dark, // Icônes sombres (pour fond clair)
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Rendre l'AppBar transparente
          elevation: 0, // Enlever l'ombre
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Retour à la page précédente
            },
          ),
        ),
        backgroundColor:
            AppPalette.palette1['background'], // Utilisation de la palette1
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligner tout à gauche
          children: [
            // Image centrée en haut
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 40), // Ajustement de l'espace en haut
                child: Image.asset(
                  'assets/images/add-user.png',
                  width: 180,
                  height: 180,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Texte aligné à gauche
            const Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 35), // Marge à gauche et à droite
              child: Text(
                'Créer un nouveau',
                style: TextStyle(
                  color: Color(0xFF6E6E75), // Couleur de texte définie
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                'compte',
                style: TextStyle(
                  color: Color(0xFF6E6E75), // Couleur de texte définie
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                'Veuillez choisir une méthode pour vous inscrire :',
                style: TextStyle(
                  color: Color(0xFF6E6E75),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 30), // Espace avant les boîtes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Première boîte pour Email
                  GestureDetector(
                    onTap: () {
                      // Naviguer vers la page Email
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EmailPage()),
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Ombre
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(
                            20), // Marge interne pour l'alignement
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Aligner tout à gauche
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Colors.red,
                              size: 24, // Taille réduite de l'icône
                            ),
                            SizedBox(height: 35), // Ajustement de l'espacement
                            Text(
                              'with',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(173, 3, 3, 3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Deuxième boîte pour Password
                  GestureDetector(
                    onTap: () {
                      // Naviguer vers la page Password
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PasswordPage()),
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3), // Ombre
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(
                            20), // Marge interne pour l'alignement
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Aligner tout à gauche
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: Colors.black,
                              size: 24, // Taille réduite de l'icône
                            ),
                            SizedBox(height: 35), // Ajustement de l'espacement
                            Text(
                              'with',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(173, 3, 3, 3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
