import 'package:flutter/material.dart';
import 'package:myapp/pages/AideTexte.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:myapp/pages/AideTexte.dart' as aideTexte;

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  // Cette fonction obtient le chemin du répertoire racine et lance la vidéo
  Future<void> _launchVideo() async {
    final directory = await getExternalStorageDirectory();
    final videoPath =
        '${directory!.parent.path}/aide.mp4'; // Vidéo dans la racine

    print('Path to video: $videoPath');

    if (await File(videoPath).exists()) {
      final Uri videoUri = Uri.file(videoPath);
      if (await canLaunch(videoUri.toString())) {
        await launch(videoUri.toString(),
            forceSafariVC: false, forceWebView: false);
      } else {
        throw 'Could not launch $videoUri';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("La vidéo n'existe pas à la racine du répertoire")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Besoin d\'aide ?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF5E7D5),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Regarder la vidéo d'aide",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(144, 0, 0, 0))),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _launchVideo,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/images/video.png',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover),
                    ),
                    const Icon(Icons.play_circle_fill,
                        size: 50, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text("voir détail",
                        style: TextStyle(color: Colors.blue, fontSize: 14)),
                    Icon(Icons.arrow_forward, color: Colors.blue, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 85),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(199, 209, 213, 209),
                        borderRadius: BorderRadius.circular(0)),
                    child: const Text(
                        "Une page d'aide contenant les règles et démarches de l'application mobile",
                        style: TextStyle(fontSize: 15, color: Colors.black87)),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        // Navigation vers la page AideTexte
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AideTexte()),
                        );
                      },
                      child: Text("Document Text",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(224, 218, 53, 7))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const Text("Un problème ? Dites-le nous",
                  style: TextStyle(fontSize: 15)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {},
                child: const Text("men@education.gov.mg",
                    style: TextStyle(color: Colors.blue, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
