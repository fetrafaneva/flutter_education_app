import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import de DatabaseHelper pour gérer la base de données
import 'Dashboard.dart'; // Import de la page Dashboard

class InscriptionPin extends StatefulWidget {
  const InscriptionPin({super.key});

  @override
  _InscriptionPinState createState() => _InscriptionPinState();
}

class _InscriptionPinState extends State<InscriptionPin> {
  String pin = ''; // Utilisez une seule variable pour le PIN
  String errorMessage = '';

  void onNumberTap(int number) {
    setState(() {
      if (pin.length < 4) {
        pin += number.toString();
      }

      // Vérifier si le PIN est complet et authentifier
      if (pin.length == 4) {
        _authenticatePin(pin); // Authentification avec le PIN
      }
    });
  }

  Future<void> _authenticatePin(String pin) async {
    final pins = await DatabaseHelper().getPins();
    bool isPinValid = false;

    // Vérifiez si le PIN entré est valide
    for (var pinEntry in pins) {
      if (pinEntry['pin'] == pin) {
        isPinValid = true;
        break;
      }
    }

    // Si le PIN est valide, redirigez vers le Dashboard
    if (isPinValid) {
      _redirectToDashboard();
    } else {
      // Afficher un message d'erreur
      setState(() {
        errorMessage = 'Échec de l\'authentification, le PIN est incorrect';
        // Ne pas réinitialiser le PIN pour permettre à l'utilisateur de le corriger
      });

      // Ajout d'un délai avant la réinitialisation du message d'erreur
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          errorMessage =
              ''; // Réinitialiser le message d'erreur après 2 secondes
        });
      });
    }
  }

  void _redirectToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard()),
    );
  }

  void onDeleteTap() {
    setState(() {
      if (pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1); // Supprimer le dernier chiffre
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFEAD7C3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFFEAD7C3),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              'Entrez votre code de sécurité',
              style: const TextStyle(fontSize: 15, color: Color(0xFF6E6E75)),
            ),
            const SizedBox(height: 20),
            Text(
              pin.padRight(4,
                  '•'), // Affiche le PIN avec des points pour les chiffres cachés
              style: const TextStyle(
                  fontSize: 35, letterSpacing: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            if (errorMessage.isNotEmpty)
              Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            const Spacer(),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                if (index == 9) {
                  return const SizedBox.shrink(); // Case vide
                } else if (index == 10) {
                  return numberButton(0); // Bouton 0
                } else if (index == 11) {
                  return deleteButton(); // Bouton de suppression
                }
                return numberButton(index + 1); // Boutons de 1 à 9
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget numberButton(int number) {
    return GestureDetector(
      onTap: () => onNumberTap(number), // Appel de la fonction onNumberTap
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(231, 251, 251, 251),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(fontSize: 20, color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget deleteButton() {
    return GestureDetector(
      onTap: onDeleteTap, // Appel de la fonction onDeleteTap
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE0B2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(Icons.backspace, color: Colors.red),
        ),
      ),
    );
  }
}
