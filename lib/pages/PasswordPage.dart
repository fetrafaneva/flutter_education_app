import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import de DatabaseHelper pour gérer la base de données
import 'Dashboard.dart'; // Import de la page Dashboard

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  String firstPin = '';
  String secondPin = '';
  bool isConfirming = false;
  String errorMessage = '';
  String email = ''; // Email de l'utilisateur
  String password = ''; // Mot de passe de l'utilisateur

  void onNumberTap(int number) {
    setState(() {
      if (isConfirming) {
        if (secondPin.length < 4) {
          secondPin += number.toString();
        }
      } else {
        if (firstPin.length < 4) {
          firstPin += number.toString();
        }
      }

      if (firstPin.length == 4 && !isConfirming) {
        isConfirming = true;
      }

      if (secondPin.length == 4 && isConfirming) {
        if (firstPin == secondPin) {
          _savePin(secondPin); // Utilisez le second PIN pour l'enregistrement
        } else {
          errorMessage = 'Les codes ne correspondent pas, veuillez réessayer';
          firstPin = '';
          secondPin = '';
          isConfirming = false;
        }
      }
    });
  }

  Future<void> _savePin(String pin) async {
    try {
      // Effacez la base de données avant d'enregistrer le code PIN
      await DatabaseHelper().clearDatabase();

      // Ensuite, enregistrez le nouveau code PIN
      await DatabaseHelper().insertPin(pin);

      // Redirigez vers le tableau de bord après l'enregistrement du PIN
      _redirectToDashboard();
    } catch (e) {
      setState(() {
        errorMessage =
            'Erreur lors de l\'enregistrement du code PIN: ${e.toString()}'; // Affichez l'erreur
      });
    }
  }

  Future<bool> _authenticate() async {
    final users = await DatabaseHelper().getUsers();

    for (var user in users) {
      if (user['email'] == email && user['password'] == password) {
        return true; // Authentification réussie par email et mot de passe
      }
    }

    final pins = await DatabaseHelper().getPins();
    for (var pinEntry in pins) {
      if (pinEntry['pin'] == firstPin) {
        return true; // Authentification réussie par PIN
      }
    }

    return false; // Échec de l'authentification
  }

  Future<void> _submit() async {
    final isAuthenticated = await _authenticate();
    if (isAuthenticated) {
      _redirectToDashboard(); // Rediriger vers le Dashboard après une authentification réussie
    } else {
      setState(() {
        errorMessage = 'Échec de l\'authentification, veuillez réessayer';
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
      if (isConfirming) {
        if (secondPin.isNotEmpty) {
          secondPin = secondPin.substring(0, secondPin.length - 1);
        }
      } else {
        if (firstPin.isNotEmpty) {
          firstPin = firstPin.substring(0, firstPin.length - 1);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String pin = isConfirming ? secondPin : firstPin;

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
              isConfirming
                  ? 'Confirmez votre code de sécurité'
                  : 'Entrez votre code de sécurité',
              style: const TextStyle(fontSize: 15, color: Color(0xFF6E6E75)),
            ),
            const SizedBox(height: 20),
            Text(
              pin.padRight(4, '•'),
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
                  return const SizedBox.shrink();
                } else if (index == 10) {
                  return numberButton(0);
                } else if (index == 11) {
                  return deleteButton();
                }
                return numberButton(index + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget numberButton(int number) {
    return GestureDetector(
      onTap: () => onNumberTap(number),
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
      onTap: onDeleteTap,
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
