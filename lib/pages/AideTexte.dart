import 'package:flutter/material.dart';

class AideTexte extends StatelessWidget {
  const AideTexte({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'aide'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        // Ajout de SingleChildScrollView pour permettre le défilement
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Règles et démarches de l'application mobile.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text("1. **Gestion des Classes**\n"
                "L'application permet de créer, modifier et supprimer des classes scolaires. "
                "Chaque classe possède un identifiant unique, un nom et une année scolaire associée. "
                "Cela permet de structurer les élèves en fonction de leur niveau d'études. Les utilisateurs peuvent facilement "
                "ajouter de nouvelles classes et y associer des élèves, ce qui facilite l'organisation et la gestion des cours.\n\n"
                "2. **Gestion des Élèves**\n"
                "Les élèves sont enregistrés avec leurs informations personnelles telles que leur nom, prénom, date de naissance, "
                "sexe et numéro d'identification. Le champ 'numéro' permet de donner à chaque élève un identifiant unique qui peut "
                "être utilisé pour le suivi scolaire. Les élèves peuvent être affectés à une classe spécifique, ce qui permet de "
                "gérer plus facilement les emplois du temps et les évaluations par classe. De plus, si un élève change de classe, "
                "les modifications sont automatiquement mises à jour dans la base de données.\n\n"
                "3. **Gestion des Enseignants**\n"
                "Les enseignants peuvent être ajoutés à l'application avec des informations telles que leur nom, prénom et adresse email. "
                "Les enseignants sont également associés à des matières spécifiques, ce qui permet de suivre les matières qu'ils enseignent "
                "ainsi que les évaluations qu'ils administrent. L'application assure une gestion centralisée des enseignants, facilitant "
                "la planification et la communication entre les différentes parties prenantes.\n\n"
                "4. **Gestion des Matières**\n"
                "L'application permet de créer des matières scolaires en attribuant à chacune un nom et un coefficient. "
                "Le coefficient joue un rôle crucial dans le calcul des moyennes des élèves et dans l'affichage des résultats finaux. "
                "Les matières peuvent être associées à des classes spécifiques, ce qui permet aux élèves de voir les matières auxquelles "
                "ils sont inscrits. Il est également possible d'ajouter ou de supprimer des matières en fonction des besoins de l'établissement.\n\n"
                "5. **Évaluations et Notes**\n"
                "Les évaluations sont enregistrées avec un nom, une date, une matière et une classe associée. "
                "Cela permet aux enseignants de définir des évaluations pour chaque matière et chaque classe. Lorsqu'une évaluation est effectuée, "
                "les notes des élèves peuvent être enregistrées, et elles sont automatiquement liées à l'élève concerné, à l'évaluation et à la matière. "
                "L'application permet de gérer les résultats des élèves, de suivre leur évolution académique et d'établir des comparaisons entre les différentes évaluations.\n\n"
                "6. **Rapports Scolaires**\n"
                "Chaque élève peut se voir attribuer un rapport contenant sa moyenne générale ainsi que des commentaires sur ses performances. "
                "Ces rapports peuvent être consultés à tout moment et servent de base pour les entretiens et les évaluations pédagogiques. "
                "Les rapports sont automatiquement générés à partir des notes de chaque élève, en tenant compte des coefficients des matières. "
                "Cette fonctionnalité aide à suivre les progrès académiques et à identifier les domaines où les élèves peuvent s'améliorer.\n\n"
                "7. **Pense-Bêtes**\n"
                "La fonctionnalité de 'Pense-Bêtes' permet aux utilisateurs (enseignants et administrateurs) d'ajouter des rappels ou des notes "
                "importantes. Ces pense-bêtes peuvent être utilisés pour des rappels sur les événements scolaires, les dates limites de soumission "
                "ou toute autre information pertinente. Chaque pense-bête contient un titre, un contenu descriptif et une date de création. "
                "Les utilisateurs peuvent marquer ces pense-bêtes comme 'terminés' une fois que l'action est effectuée.\n\n"
                "8. **Gestion des Accès et Sécurisation des Données**\n"
                "L'application permet aux utilisateurs de se connecter avec un email et un mot de passe. Ces informations sont stockées de manière "
                "sécurisée dans la base de données. Un système de gestion de mot de passe et un mécanisme de PIN (code de sécurité) peuvent être "
                "utilisés pour ajouter une couche de sécurité supplémentaire. Cela garantit que seules les personnes autorisées peuvent accéder "
                "à des informations sensibles, telles que les résultats des élèves, les rapports et les informations personnelles.\n\n"
                "En résumé, cette application offre une gestion complète des activités scolaires, avec des fonctionnalités pour gérer les classes, "
                "les élèves, les enseignants, les matières, les évaluations, les résultats scolaires, ainsi que des rappels et des notes administratives. "
                "Elle est conçue pour simplifier le processus de gestion scolaire, améliorer l'efficacité de l'administration et faciliter le suivi des élèves."),
          ],
        ),
      ),
    );
  }
}
