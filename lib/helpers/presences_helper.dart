import 'package:sqflite/sqflite.dart' as sql;

// Presence SqlConnection pour gérer les opérations de base de données
class SqlConnection {
  // Méthode pour créer les tables de la base de données
  static Future<void> createTables(sql.Database database) async {
    // Crée une table Presences avec des champs id, Presencename, email, password, createdAt
    await database.execute("""CREATE TABLE Presences(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      seanceId INTEGER,
      eleveID INTEGER,
      status TEXT NOT NULL,
      FOREIGN KEY (seanceId) REFERENCES Seances(id),
      FOREIGN KEY (eleveId) REFERENCES Eleves(id)
    )""");
  }

  // Méthode pour ouvrir la base de données et créer les tables si elles n'existent pas
  static Future<sql.Database> db() async {
    return sql.openDatabase("Ifran.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // Créer Presence
  static Future<int> createPresence(
      int seanceId, int eleveId, String status) async {
    final db = await SqlConnection.db();
    final data = {
      'seanceId': seanceId,
      'eleveId': eleveId,
      'status': status,
    };
    final id = await db.insert('Presences', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Récupération de tout la liste
  static Future<List<Map<String, dynamic>>> getAllPresences() async {
    final db = await SqlConnection.db();
    return db.query('Presences', orderBy: "id DESC");
  }

  // Méthode pour récupérer par son ID
  static Future<List<Map<String, dynamic>>> getPresence(int id) async {
    final db = await SqlConnection.db();
    return db.query('Presences', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Méthode pour mettre à jour
  static Future<int> updatePresence(
      int id,
      int seanceId,
      int eleveId,
      String status
  ) async {
    final db = await SqlConnection.db();
    final data = {
      'seanceId': seanceId,
      'eleveId': eleveId,
      'status': status,
    };
    final result =
        await db.update('Presences', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Méthode pour fermer la base de données...
  static Future<void> close() async {
    final db = await SqlConnection.db();
    await db.close();
  }
}
