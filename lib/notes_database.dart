import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:noteapp/model/note.dart';
import'package:path_provider/path_provider.dart';
class NoteDatabase extends ChangeNotifier{
static late Isar isar;

static Future<void> initialize() async {
final dir = await getApplicationDocumentsDirectory();
isar = await Isar.open(
  [NoteSchema],
  directory: dir.path
);
}

final List<Note> currentNotes = [];

Future<void> addnote(String textFromUser ) async {
  final newNote = Note()..text = textFromUser;

await isar.writeTxn(() => isar.notes.put(newNote));

fetchNotes();

}

Future<void> fetchNotes() async {
  List<Note> fetchedNotes = await isar.notes.where().findAll();
  currentNotes.clear();
  currentNotes.addAll(fetchedNotes);
  notifyListeners();
  }

  Future<void> updateNotes(int id, String newText) async {
final existingNote = await isar.notes.get(id);
if (existingNote != null) {
existingNote.text = newText;
await isar.writeTxn(() => isar.notes.put(existingNote));
await fetchNotes();
}
  }

  Future<void> deleteNotes(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
  
  }