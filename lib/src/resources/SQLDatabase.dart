import 'package:lg_controller/src/menu/NavBarMenu.dart';
import 'package:lg_controller/src/models/KMLData.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLDatabase {
  static const int RECENT_SIZE = 12;

  Future<void> saveData(Map<String, List<KMLData>> data) async {
    for (var ic in NavBarMenu.values()) {
      if (ic.title.compareTo(NavBarMenu.RECENTLY_VIEWED.title) == 0) continue;
      await insertInTable(ic.title, data[ic.title]);
    }
  }

  insertInTable(String key, value) async {
    final Database db = await createDatabase('modules' + key);
    for (var mod in value) {
      await db.insert(
        'modules' + key,
        mod.toDatabaseMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<Database> createDatabase(String title) async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'modules_database' + title + '.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE " +
              title +
              "(id INTEGER PRIMARY KEY, title TEXT UNIQUE, desc TEXT UNIQUE, count INTEGER, latitude REAL, longitude REAL, bearing REAL, zoom REAL, tilt REAL)",
        );
      },
      version: 1,
    );
    return database;
  }

  Future<Map<String, List<KMLData>>> getData() async {
    Map<String, List<KMLData>> segData = new Map<String, List<KMLData>>();
    for (var ic in NavBarMenu.values()) {
      segData.addAll({ic.title: new List<KMLData>()});
    }
    for (var ic in NavBarMenu.values()) {
      if (ic.title.compareTo(NavBarMenu.RECENTLY_VIEWED.title) == 0) continue;
      segData[ic.title].addAll(await getValues(ic.title));
    }
    /*for (var ic in NavBarMenu.values()) {
      if(ic.title.compareTo(NavBarMenu.RECENTLY_VIEWED.title)==0) continue;
      List<KMLData> recent = await getRecent(ic.title);
      if (recent != null) segData["Recently_Viewed"].addAll(recent);
    }*/
    List<KMLData> recent = await getRecent();
    if (recent != null) segData["Recently_Viewed"].addAll(recent);
    return segData;
  }

  Future<List<KMLData>> getValues(String key) async {
    Database db = await createDatabase('modules' + key);
    List<Map<String, dynamic>> maps = await db.query('modules' + key);
    if (maps == null) return [];
    return List.generate(maps.length, (i) {
      return KMLData.fromDatabaseMap(maps[i]);
    });
  }

  Future<List<KMLData>> getRecent() async {
    List<KMLData> recent = new List<KMLData>();
    for (var ic in NavBarMenu.values()) {
      if (ic.title.compareTo(NavBarMenu.RECENTLY_VIEWED.title) == 0) continue;
      Database db = await createDatabase('modules' + ic.title);
      List<Map<String, dynamic>> maps = await db
          .rawQuery('SELECT * FROM modules' + ic.title + ' WHERE count > 0');
      if (maps == null) return [];
      for (int i = 0; i < maps.length; i++)
        addInOrder(recent, KMLData.fromDatabaseMap(maps[i]));
    }
    return recent;
  }

  addInOrder(List<KMLData> recent, KMLData data) {
    if (recent.length < RECENT_SIZE)
      recent.add(data);
    else {
      int i = RECENT_SIZE - 1;
      while (i > 0 && recent.elementAt(i - 1).count < data.count) {
        i--;
        recent[i] = recent[i - 1];
      }
      if (recent.elementAt(i).count < data.count) recent[i] = data;
    }
  }

  updateViewed(String key, KMLData data) async {
    if (key.compareTo(NavBarMenu.RECENTLY_VIEWED.title) == 0) return;
    Database db = await createDatabase('modules' + key);
    await db.rawUpdate(
        'UPDATE modules' + key + ' SET count = count+1 WHERE title = ?',
        [data.getTitle()]).catchError((error) {});
  }

  Future<List<KMLData>> getSearchData(String searchText) async {
    List<KMLData> result = new List<KMLData>();
    for (var ic in NavBarMenu.values()) {
      if (ic.title.compareTo(NavBarMenu.RECENTLY_VIEWED.title) == 0) continue;
      result.addAll(await getSearchResult(ic.title, searchText));
    }
    return result;
  }

  Future<List<KMLData>> getSearchResult(String key, String searchText) async {
    Database db = await createDatabase('modules' + key);
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM modules' +
            key +
            ' WHERE title LIKE \'%' +
            searchText +
            '%\'');
    if (maps == null) return [];
    return List.generate(maps.length, (i) {
      return KMLData.fromDatabaseMap(maps[i]);
    });
  }
}
