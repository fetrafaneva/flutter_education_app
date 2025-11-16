import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Créez la table users
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)',
        );

        // Créez une nouvelle table pour les PINs
        await db.execute(
          'CREATE TABLE pins(id INTEGER PRIMARY KEY AUTOINCREMENT, pin TEXT)',
        );

        // Table Classe
        await db.execute('''
          CREATE TABLE Classe(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            annee_scolaire TEXT NOT NULL
          )
        ''');

        // Table Élève avec le champ "numéro"
        await db.execute('''
          CREATE TABLE Eleve(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            prenom TEXT NOT NULL,
            date_naissance DATE NOT NULL,
            numero TEXT NOT NULL, 
            classe_id INTEGER,
            sexe TEXT CHECK(sexe IN ('M', 'F')) NOT NULL,
            FOREIGN KEY (classe_id) REFERENCES Classe(id) ON DELETE SET NULL
          )
        ''');

        // Table Enseignant
        await db.execute('''
          CREATE TABLE Enseignant(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            prenom TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE
          )
        ''');

        // Table Matière
        await db.execute('''
          CREATE TABLE Matiere(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            coef REAL NOT NULL
          )
        ''');

        // Table Matière_Classe
        await db.execute('''
          CREATE TABLE Matiere_Classe(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            classe_id INTEGER,
            matiere_id INTEGER,
            FOREIGN KEY (classe_id) REFERENCES Classe(id) ON DELETE CASCADE,
            FOREIGN KEY (matiere_id) REFERENCES Matiere(id) ON DELETE CASCADE
          )
        ''');

        // Table Évaluation
        await db.execute('''
          CREATE TABLE Evaluation(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT NOT NULL,
            date DATE NOT NULL,
            matiere_id INTEGER,
            classe_id INTEGER,
            FOREIGN KEY (matiere_id) REFERENCES Matiere(id) ON DELETE SET NULL,
            FOREIGN KEY (classe_id) REFERENCES Classe(id) ON DELETE SET NULL
          )
        ''');

        // Table Note avec la colonne 'matiere_id'
        await db.execute('''
          CREATE TABLE Note(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            eleve_id INTEGER,
            evaluation_id INTEGER,
            matiere_id INTEGER,  -- Ajout de la colonne matiere_id
            note REAL NOT NULL,
            commentaire TEXT,
            FOREIGN KEY (eleve_id) REFERENCES Eleve(id) ON DELETE CASCADE,
            FOREIGN KEY (evaluation_id) REFERENCES Evaluation(id) ON DELETE CASCADE,
            FOREIGN KEY (matiere_id) REFERENCES Matiere(id) ON DELETE CASCADE  -- Référence à la table Matiere
          )
        ''');

        // Table Rapport
        await db.execute('''
          CREATE TABLE Rapport(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            eleve_id INTEGER,
            moyenne_generale REAL,
            commentaires TEXT,
            FOREIGN KEY (eleve_id) REFERENCES Eleve(id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
        CREATE TABLE PenseBete (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        contenu TEXT NOT NULL,
        date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
        statut INTEGER DEFAULT 0
      )
    ''');
      },
    );
  }

  // Insertion d'un élève avec le champ "numéro"
  Future<void> insertEleve({
    required String nom,
    required String prenom,
    required String dateNaissance,
    required String sexe,
    required String numero, // Nouveau champ pour le numéro
    required int classeId,
  }) async {
    final db = await database;
    await db.insert(
      'Eleve',
      {
        'nom': nom,
        'prenom': prenom,
        'date_naissance': dateNaissance,
        'sexe': sexe,
        'numero': numero, // Enregistrement du numéro
        'classe_id': classeId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertEvaluation({
    required String nom,
    required String date,
    required int classeId,
    required int matiereId,
  }) async {
    final db = await database;
    await db.insert(
      'Evaluation',
      {
        'nom': nom,
        'date': date,
        'classe_id': classeId,
        'matiere_id': matiereId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertUser(String email, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMatiereClasse(int matiereId, int classeId) async {
    final db = await database;
    await db.insert(
      'Matiere_Classe',
      {
        'matiere_id': matiereId,
        'classe_id': classeId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer les matières associées à une classe
  Future<List<Map<String, dynamic>>> getMatieresByClasse(int classeId) async {
    final db = await database;
    return await db.rawQuery('''
    SELECT M.id, M.nom, M.coef
    FROM Matiere M
    INNER JOIN Matiere_Classe MC ON M.id = MC.matiere_id
    WHERE MC.classe_id = ?
  ''', [classeId]);
  }

  // Récupérer l'ID de la dernière insertion
  Future<int> getLastInsertId() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT last_insert_rowid() AS id');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> insertMatiere(String nom, double coef) async {
    final db = await database;
    await db.insert(
      'Matiere',
      {
        'nom': nom,
        'coef': coef,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> getEleveCountByClasse(int classeId) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM Eleve WHERE classe_id = ?', [classeId]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<void> insertPin(String pin) async {
    final db = await database;
    await db.insert(
      'pins',
      {'pin': pin},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getPins() async {
    final db = await database;
    return await db.query('pins');
  }

  Future<bool> validateUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  Future<void> insertNote({
    required int eleveId,
    required int evaluationId,
    required int matiereId, // Ajout de matiereId ici
    required double note,
    String? commentaire,
  }) async {
    final db = await database;
    await db.insert(
      'Note',
      {
        'eleve_id': eleveId,
        'evaluation_id': evaluationId,
        'matiere_id': matiereId, // Insertion de matiereId
        'note': note,
        'commentaire': commentaire,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertClasse(String nom, String anneeScolaire) async {
    final db = await database;
    await db.insert(
      'Classe',
      {
        'nom': nom,
        'annee_scolaire': anneeScolaire,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getClasses() async {
    final db = await database;
    return await db.query('Classe');
  }

  Future<List<Map<String, dynamic>>> getElevesByClasse(int classeId) async {
    final db = await database;
    return await db.query(
      'Eleve',
      where: 'classe_id = ?',
      whereArgs: [classeId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllEvaluations() async {
    final db = await database;
    // Utilisez le nom correct de la table: 'Evaluation'
    return await db.query('Evaluation');
  }

  Future<List<Map<String, dynamic>>> getEvaluationsByClasse(
      int classeId) async {
    final db = await database; // Ensure you get the database instance
    return await db.query(
      'Evaluation',
      where: 'classe_id = ?',
      whereArgs: [classeId],
    );
  }

  Future<List<Map<String, dynamic>>> getEvaluationsByMatiere(
      int matiereId) async {
    final db =
        await database; // Assurez-vous d'obtenir votre base de données ici
    final List<Map<String, dynamic>> result = await db
        .query('Evaluation', where: 'matiere_id = ?', whereArgs: [matiereId]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getMatieresAvecNotes(
      int eleveId, int classeId) async {
    final db = await database;

    // Requête SQL corrigée
    final result = await db.rawQuery('''
    SELECT m.id, m.nom, m.coef, n.note, n.commentaire
    FROM Matiere_Classe mc
    JOIN Matiere m ON mc.matiere_id = m.id
    LEFT JOIN Note n ON n.matiere_id = m.id AND n.eleve_id = ?
    WHERE mc.classe_id = ?
  ''', [eleveId, classeId]);

    return result;
  }

  Future<List<Map<String, dynamic>>> getMatieresAvecNotesPourEvaluation(
      int evaluationId) async {
    final db = await database;

    // Assuming you want to join the Note table with Matiere and Evaluation
    final result = await db.rawQuery('''
    SELECT m.id, m.nom, m.coef, n.note, n.commentaire
    FROM Matiere m
    LEFT JOIN Note n ON n.matiere_id = m.id
    LEFT JOIN Evaluation e ON e.id = n.evaluation_id
    WHERE e.id = ?
  ''', [evaluationId]);

    return result;
  }

  Future<List<Map<String, dynamic>>> getMatieresAvecNotesPourEvaluationParNom(
      String nomEvaluation, int eleveId) async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT m.id, m.nom, n.note, m.coef AS coefficient  
    FROM Matiere m
    JOIN Note n ON m.id = n.matiere_id
    JOIN Evaluation e ON n.evaluation_id = e.id
    WHERE e.nom = ? AND n.eleve_id = ? 
  ''', [nomEvaluation, eleveId]);

    return result;
  }

  Future<Map<String, dynamic>?> getClasseById(int id) async {
    final db = await database;
    final result = await db.query(
      'Classe',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> getMatiereCountByClasse(int classId) async {
    final db = await database;
    final countQuery = await db.rawQuery('''
    SELECT COUNT(DISTINCT m.id) AS matiereCount
    FROM Matiere m
    WHERE m.id IN (
      SELECT mc.matiere_id 
      FROM Matiere_Classe mc 
      WHERE mc.classe_id = ?
    )
  ''', [classId]);

    // Extract the matiere count from the result
    int matiereCount =
        countQuery.isNotEmpty ? countQuery.first['matiereCount'] as int : 0;
    return matiereCount;
  }

  Future<int> getClassIdByName(String className) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      'Classe', // Remplacez 'class' par 'Classe'
      where: 'nom = ?',
      whereArgs: [className],
    );

    if (results.isNotEmpty) {
      return results
          .first['id']; // Assurez-vous que 'id' est le nom de votre champ d'ID
    } else {
      throw Exception('Classe non trouvée');
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsByClasse(int classeId) async {
    return await getElevesByClasse(classeId);
  }

  // Ajoutez cette méthode à votre classe DatabaseHelper
  Future<String?> getClasseNomById(int classeId) async {
    final db =
        await database; // Assurez-vous d'initialiser votre base de données
    final List<Map<String, dynamic>> result = await db.query(
      'classe', // Remplacez 'classe' par le nom réel de votre table de classe
      where: 'id = ?',
      whereArgs: [classeId],
    );
    if (result.isNotEmpty) {
      return result.first['nom'] as String?;
    }
    return null;
  }

  Future<List<double>> getMoyennesDesElevesDeClassePourEvaluation(
      int classeId, String evaluationNom) async {
    final db = await database;

    final results = await db.rawQuery('''
    SELECT n.eleve_id, AVG(n.note * m.coef) / AVG(m.coef) AS moyenne
    FROM Note n
    JOIN Evaluation e ON n.evaluation_id = e.id
    JOIN Matiere m ON n.matiere_id = m.id
    JOIN Eleve el ON n.eleve_id = el.id
    WHERE e.nom = ? AND el.classe_id = ?
    GROUP BY n.eleve_id
  ''', [evaluationNom, classeId]);

    return results.map((row) => row['moyenne'] as double).toList();
  }

  Future<void> deleteEleve(int eleveId) async {
    final db =
        await database; // Assurez-vous d'obtenir l'instance de la base de données
    await db.delete(
      'Eleve', // Nom de la table
      where: 'id = ?', // Condition pour le delete
      whereArgs: [eleveId], // ID de l'élève à supprimer
    );
  }

  Future<void> updateEleve(Map<String, dynamic> eleve) async {
    final db = await database; // Retrieve your database instance

    await db.update(
      'eleve', // Table name
      eleve, // The updated student data
      where: 'id = ?', // Specify which student to update
      whereArgs: [eleve['id']], // Arguments for the where clause
    );
  }

  Future<void> deleteMatiere(int matiereId) async {
    final db =
        await database; // Ensure 'database' is initialized properly in DatabaseHelper
    await db.delete(
      'Matiere', // Replace 'matieres' with the actual name of your table if it's different
      where: 'id = ?',
      whereArgs: [matiereId],
    );
  }

  Future<void> updateNote({
    required int eleveId,
    required int matiereId,
    required double note,
    String? commentaire,
  }) async {
    final db = await database;
    await db.update(
      'Note',
      {
        'note': note,
        'commentaire': commentaire,
      },
      where: 'eleve_id = ? AND matiere_id = ?',
      whereArgs: [eleveId, matiereId],
    );
  }

  Future<List<Map<String, dynamic>>> getEvaluationsWithSubject() async {
    final db = await database;

    // Jointure entre la table des évaluations, celle des matières, et celle des classes
    final List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT evaluation.id, evaluation.nom, evaluation.date, 
           matiere.nom AS matiere_nom, classe.nom AS classe_nom
    FROM evaluation
    LEFT JOIN matiere ON evaluation.matiere_id = matiere.id
    LEFT JOIN classe ON evaluation.classe_id = classe.id
  ''');

    return results;
  }

  Future<void> deleteEvaluation(int id) async {
    final db = await database;
    await db.delete(
      'evaluation',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertPenseBete(String titre, String contenu) async {
    final db = await database;
    await db.insert(
      'PenseBete',
      {
        'titre': titre,
        'contenu': contenu,
        'date_creation': DateTime.now().toIso8601String(),
        'statut': 0, // Par exemple, statut par défaut
      },
    );
  }

  Future<List<Map<String, dynamic>>> getPenseBetes() async {
    final db = await database;
    return await db.query('PenseBete', orderBy: 'date_creation DESC');
  }

  Future<void> deletePenseBete(int id) async {
    final db = await database;
    await db.delete('PenseBete', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteNoteForMatiere(int eleveId, int matiereId) async {
    final db = await database;
    await db.delete(
      'note',
      where: 'eleve_id = ? AND matiere_id = ?',
      whereArgs: [eleveId, matiereId],
    );
  }

  Future<int> updateMatiere(int id, String nom, double coef) async {
    final db =
        await database; // Assurez-vous que la méthode `database` retourne l'instance de la base de données

    // Met à jour la matière en fonction de son identifiant
    return await db.update(
      'matiere', // Nom de la table
      {
        'nom': nom,
        'coef': coef,
      },
      where: 'id = ?', // Condition de sélection pour identifier la matière
      whereArgs: [id], // Argument correspondant à l'ID de la matière
    );
  }

  Future<void> clearDatabase() async {
    final db = await database;

    // Liste de toutes les tables que vous voulez vider
    List<String> tables = [
      'users',
      'pins',
      'Classe',
      'Eleve',
      'Enseignant',
      'Matiere',
      'Matiere_Classe',
      'Evaluation',
      'Note',
      'Rapport',
      'PenseBete',
    ];

    // Vider toutes les tables en utilisant une boucle
    for (String table in tables) {
      await db.delete(table);
    }
  }

  Future<void> deleteClasse(int classId) async {
    final db = await database;

    try {
      // Essayez d'exécuter la suppression
      print("Tentative de suppression de la classe avec ID: $classId");
      await db.delete(
        'Classe', // Nom de la table
        where: 'id = ?',
        whereArgs: [classId],
      );
      print("Classe supprimée avec succès.");
    } catch (e) {
      print("Erreur lors de la suppression de la classe: $e");
      throw Exception("Erreur lors de la suppression de la classe");
    }
  }
}
