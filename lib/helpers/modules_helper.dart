import 'package:sqflite/sqflite.dart' as sql;

// Module SqlConnection pour gérer les opérations de base de données
class SqlConnection {
  // Méthode pour créer les tables de la base de données
  static Future<void> createTables(sql.Database database) async {
    // Crée une table Modules avec des champs id, Modulename, email, password, createdAt
    await database.execute("""CREATE TABLE Modules(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nom TEXT NOT NULL,
    )""");
  }

  // Méthode pour ouvrir la base de données et créer les tables si elles n'existent pas
  static Future<sql.Database> db() async {
    return sql.openDatabase("Ifran.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }
 
  // Créer Module
  static Future<int> createModule(
      String nom) async {
    final db = await SqlConnection.db();
    final data = {
      'nom': nom,
    };
    final id = await db.insert('Modules', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Récupération de tout la liste
  static Future<List<Map<String, dynamic>>> getAllModules() async {
    final db = await SqlConnection.db();
    return db.query('Modules', orderBy: "id DESC");
  }

  // Méthode pour récupérer par son ID
  static Future<List<Map<String, dynamic>>> getModule(int id) async {
    final db = await SqlConnection.db();
    return db.query('Modules', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Méthode pour mettre à jour
  static Future<int> updateModule(
      int id, String nom) async {
    final db = await SqlConnection.db();
    final data = {
      'nom': nom,
    };
    final result =
        await db.update('Modules', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Méthode pour supprimer
  static Future<void> deleteModule(int id) async {
    final db = await SqlConnection.db();
    try {
      await db.delete("Modules", where: "id = ?", whereArgs: [id]);
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
