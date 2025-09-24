import 'package:sqflite/sqflite.dart' as sql;

// Classe SqlConnection pour gérer les opérations de base de données
class SqlConnection {
  // Méthode pour créer les tables de la base de données
  static Future<void> createTables(sql.Database database) async {
    // Crée une table Classes avec des champs id, Classename, email, password, createdAt
    await database.execute("""CREATE TABLE Classes(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      niveau TEXT NOT NULL,
      spécialite TEXT NOT NULL,
    )""");
  }

  // Méthode pour ouvrir la base de données et créer les tables si elles n'existent pas
  static Future<sql.Database> db() async {
    return sql.openDatabase("Ifran.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }
 
  // Créer Classe
  static Future<int> createClasse(
      String niveau, String specialite,) async {
    final db = await SqlConnection.db();
    final data = {
      'niveau': niveau,
      'specialite': specialite,
    };
    final id = await db.insert('Classes', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Récupération de tout la liste
  static Future<List<Map<String, dynamic>>> getAllClasses() async {
    final db = await SqlConnection.db();
    return db.query('Classes', orderBy: "id DESC");
  }

  // Méthode pour récupérer par son ID
  static Future<List<Map<String, dynamic>>> getClasse(int id) async {
    final db = await SqlConnection.db();
    return db.query('Classes', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Méthode pour mettre à jour
  static Future<int> updateClasse(
      int id, String niveau, String specialite) async {
    final db = await SqlConnection.db();
    final data = {
      'niveau': niveau,
      'specialite':specialite,
    };
    final result =
        await db.update('Classes', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Méthode pour supprimer
  static Future<void> deleteClasse(int id) async {
    final db = await SqlConnection.db();
    try {
      await db.delete("Classes", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e.toString());
    }
  }

  // Méthode pour fermer la base de données...
  static Future<void> close() async {
    final db = await SqlConnection.db();
    await db.close();
  }
}