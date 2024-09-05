import'package:flutter/material.dart';
import 'package:noteapp/model/note.dart';
import 'package:noteapp/notes_database.dart';
import 'package:provider/provider.dart';

class NotesPage  extends StatefulWidget {
  const NotesPage ({super.key});

  @override
  State<NotesPage > createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage > {
final textController =TextEditingController();

@override
void initState(){
  super.initState();

  readNotes();
}
  void createNote() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {

              context.read<NoteDatabase>().addnote(textController.text);

              textController.clear();
              Navigator.pop(context);
            }, 
            child: const Text("Create"),
            )
        ],
      )
      );
      
  }

  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  void updateNotes(Note note) {

    textController.text = note.text;
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: TextField(controller:textController),
        actions: [
          MaterialButton(
            onPressed: (){
              context
              .read<NoteDatabase>()
              .updateNotes(note.id, textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("update"),
            )
        ],
      )
      );

  }

  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNotes(id);
  }
  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();

    List<Note> currentNotes = noteDatabase.currentNotes;    return  Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: currentNotes.length,
          itemBuilder: (context, index) {
            final note = currentNotes[index];

            return ListTile(
              title: Text(note.text),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                   IconButton(
                    onPressed: () => updateNotes(note), 
                    icon: const Icon(Icons.edit),
                    ),

                    IconButton(
                    onPressed: () => deleteNote(note.id), 
                    icon: const Icon(Icons.delete),
                    )
                ],
              ),
            );
          }          ),
    );
  }
}