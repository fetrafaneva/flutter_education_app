import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_palette.dart';
import 'inscription.dart'; // Import de la page d'inscription
import 'login_pin.dart'; // Import de la page d'inscription PIN
import 'login_email.dart'; // Import de la page d'inscription Email

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppPalette.palette1['background'],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 131),
                child: Image.asset(
                  'assets/images/add-user.png',
                  width: 180,
                  height: 180,
                ),
              ),
            ),
            const SizedBox(height: 80),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                'Se connecter à votre',
                style: TextStyle(
                  color: Color(0xFF6E6E75),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 35, bottom: 15),
              child: const Text(
                'compte',
                style: TextStyle(
                  color: Color(0xFF6E6E75),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'pas de compte ?',
                    style: TextStyle(
                      color: Color(0xFF6E6E75),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Naviguer vers la page Inscription
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Inscription()),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'S\'inscrire',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Première boîte pour Email
                  GestureDetector(
                    onTap: () {
                      // Naviguer vers la page d'inscription Email
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InscriptionEmail()),
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Colors.red,
                              size: 24,
                            ),
                            SizedBox(height: 35),
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
                      // Naviguer vers la page d'inscription PIN
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InscriptionPin()),
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: Colors.black,
                              size: 24,
                            ),
                            SizedBox(height: 35),
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
