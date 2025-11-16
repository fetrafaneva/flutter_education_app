import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart'
    as pw; // Assurez-vous d'importer le package PDF correctement
import 'package:printing/printing.dart';
import 'database_helper.dart';

class EleveResultPage extends StatefulWidget {
  final Map<String, dynamic> studentData;

  const EleveResultPage({super.key, required this.studentData});

  @override
  _EleveResultPageState createState() => _EleveResultPageState();
}

class _EleveResultPageState extends State<EleveResultPage> {
  List<Map<String, dynamic>> evaluations = [];
  List<Map<String, dynamic>> notes = [];
  String? selectedEvaluationId;
  String? selectedEvaluationNom;
  String? classeNom;

  double? moyenne; // Variable pour stocker la moyenne de l'élève
  int? rang; // Variable pour stocker le rang de l'élève

  @override
  void initState() {
    super.initState();
    _loadClasseNom();
    _loadEvaluations();
  }

  Future<void> _loadClasseNom() async {
    final db = DatabaseHelper();
    String? nom = await db.getClasseNomById(widget.studentData['classe_id']);
    setState(() {
      classeNom = nom;
    });
  }

  Future<void> _loadEvaluations() async {
    final db = DatabaseHelper();
    int classeId = widget.studentData['classe_id'];

    final evals = await db.getEvaluationsByClasse(classeId);
    setState(() {
      evaluations = evals;
      if (evaluations.isNotEmpty) {
        selectedEvaluationId = evaluations.first['id'].toString();
        selectedEvaluationNom = evaluations.first['nom'];
        _loadNotesForEvaluation(selectedEvaluationNom!);
      }
    });
  }

  Future<void> _loadNotesForEvaluation(String evaluationNom) async {
    final db = DatabaseHelper();
    final loadedNotes = await db.getMatieresAvecNotesPourEvaluationParNom(
        evaluationNom, widget.studentData['id']);
    print("Notes chargées: $loadedNotes");
    for (var note in loadedNotes) {
      print(
          "Matière: ${note['nom']}, Note: ${note['note']}, Coefficient: ${note['coefficient']}");
    }

    setState(() {
      notes = loadedNotes;
      print("Notes chargées : $notes"); // Affiche les données de notes
      _calculateMoyenne(); // Calculez la moyenne après le chargement des notes
    });
  }

  void _calculateMoyenne() {
    double totalNotes = 0.0;
    double totalCoefficients = 0.0;

    for (var note in notes) {
      double noteValue = note['note'] ?? 0.0;
      double coefficient = note['coefficient'] ?? 1.0;

      totalNotes += noteValue * coefficient;
      totalCoefficients += coefficient;
    }

    setState(() {
      moyenne = totalCoefficients > 0 ? totalNotes / totalCoefficients : 0.0;
    });
    _calculateClasseRank(); // Calculez le rang après avoir défini la moyenne
  }

  Future<void> _calculateClasseRank() async {
    final db = DatabaseHelper();
    List<double> allAverages =
        await db.getMoyennesDesElevesDeClassePourEvaluation(
            widget.studentData['classe_id'], selectedEvaluationNom!);

    setState(() {
      // Calcul de la moyenne de la classe et classement
      allAverages
          .sort((a, b) => b.compareTo(a)); // Classement en ordre décroissant
      rang = allAverages.indexOf(moyenne ?? 0.0) + 1;
    });
  }

  List<BarChartGroupData> _createBarGroups() {
    return notes.asMap().entries.map(
      (entry) {
        // Vérifiez la valeur de la note pour choisir la couleur
        Color barColor = (entry.value['note'] ?? 0) < 10
            ? Colors.red // Couleur rouge si la note est inférieure à 10
            : Colors.blueAccent; // Couleur bleue sinon

        return BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              toY: (entry.value['note'] ?? 0).toDouble(),
              color: barColor, // Appliquez la couleur choisie
              width: 10,
              borderRadius: BorderRadius.circular(30),
            ),
          ],
          showingTooltipIndicators: [0],
        );
      },
    ).toList();
  }

  Future<void> _generatePdf() async {
    // Créer un document PDF
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Informations de l\'élève',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text(
                'Nom: ${widget.studentData['nom']} ${widget.studentData['prenom']}'),
            pw.Text('Numéro: ${widget.studentData['numero']}'),
            pw.Text('Classe: ${classeNom ?? "Inconnue"}'),
            pw.SizedBox(height: 20),
            pw.Text('Évaluation: ${selectedEvaluationNom ?? "Aucune"}',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            // Création d'un tableau pour les notes
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Matière')),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Note')),
                  pw.Padding(
                      padding: const pw.EdgeInsets.all(8.0),
                      child: pw.Text('Coefficient')),
                ]),
                ...notes.map((note) {
                  return pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(note['nom'] ?? '')),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(note['note'].toString())),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(note['coefficient'].toString())),
                  ]);
                }),
              ],
            ),
            pw.SizedBox(height: 20),
            // Affichage de la moyenne et du rang
            if (moyenne != null)
              pw.Text('Moyenne: ${moyenne!.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
            if (rang != null)
              pw.Text('Rang dans la classe: $rang',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ],
        );
      },
    ));

    // Créer le nom du fichier avec le nom, prénom et le nom de l'évaluation
    String fileName =
        "${widget.studentData['nom']}_${widget.studentData['prenom']}_${selectedEvaluationNom ?? 'Evaluation'}.pdf";

    // Remplacer les caractères spéciaux dans le nom du fichier

    // Imprimer ou afficher le PDF
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: fileName); // Utiliser le nom de fichier ici
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Notes'),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                setState(() {
                  selectedEvaluationId = value;
                  selectedEvaluationNom = evaluations.firstWhere(
                      (eval) => eval['id'].toString() == value)['nom'];
                });
                _loadNotesForEvaluation(selectedEvaluationNom!);
              },
              itemBuilder: (context) {
                // Utiliser un Map pour éviter les doublons basés sur le nom
                var uniqueEvaluations = <String, Map<String, dynamic>>{};
                for (var evaluation in evaluations) {
                  uniqueEvaluations[evaluation['nom']] = evaluation;
                }

                // Convertir les valeurs du Map en une liste pour l'affichage
                return uniqueEvaluations.values.map((evaluation) {
                  return PopupMenuItem<String>(
                    value: evaluation['id'].toString(),
                    child: Row(
                      children: [
                        Text(evaluation['nom']),
                        const SizedBox(width: 8),
                        if (selectedEvaluationId == evaluation['id'].toString())
                          const Icon(Icons.check, size: 16),
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          ],
        ),
        backgroundColor: Colors.teal, // Ajout de la couleur teal comme fond
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                      text: 'Nom: ',
                      style: TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 0, 0, 0))),
                  TextSpan(
                    text:
                        '${widget.studentData['nom']} ${widget.studentData['prenom']}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(149, 0, 0, 0)),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                      text: 'Classe: ',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  TextSpan(
                    text: classeNom ?? "Inconnue",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(149, 0, 0, 0)),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                      text: 'Numéro: ',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                  TextSpan(
                    text: '${widget.studentData['numero']}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(149, 0, 0, 0)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Affichage du diagramme
            SizedBox(
              height: 200,
              child: notes.isNotEmpty
                  ? BarChart(
                      BarChartData(
                        maxY: 20,
                        barGroups: _createBarGroups(),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (index, _) {
                                String nomMatiere =
                                    notes[index.toInt()]['nom'] ?? 'Matière';
                                return Text(
                                  nomMatiere.length > 4
                                      ? nomMatiere.substring(0, 4)
                                      : nomMatiere,
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 5,
                              getTitlesWidget: (value, _) {
                                return Text(
                                  '${value.toInt()}',
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipPadding:
                                const EdgeInsets.all(7), // Ajuste l'espacement
                            tooltipMargin: 8,
                            fitInsideHorizontally: true,
                            fitInsideVertically: true,
                            tooltipRoundedRadius:
                                8, // Rayon pour un effet carré ou arrondi
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${rod.toY.toInt()}',
                                const TextStyle(
                                    color: Colors
                                        .white), // Couleur du texte dans le tooltip
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : const Center(child: Text('Aucune note disponible')),
            ),
            const SizedBox(height: 50),

            // Placer la moyenne et le rang après le graphique
            if (moyenne != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'Moyenne: ${moyenne!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: moyenne! < 10
                          ? Colors.red
                          : Colors.green, // Red if below 10, green otherwise
                    ),
                  ),
                ),
              ),
            if (rang != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'Rang dans la classe: $rang',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // You can choose any color
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _generatePdf,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal, // Text color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  elevation: 5, // Add shadow for a 3D effect
                  shadowColor:
                      Colors.black.withOpacity(0.2), // Light shadow color
                ),
                icon: const Icon(
                  Icons.picture_as_pdf, // Icon for generating PDF
                  size: 24, // Size of the icon
                  color: Colors.white, // Icon color
                ),
                label: const Text(
                  'Générer PDF',
                  style: TextStyle(
                    fontSize: 18, // Font size
                    fontWeight: FontWeight.w600, // Font weight for emphasis
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
