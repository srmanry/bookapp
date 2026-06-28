import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/feature/note/data/model/note_model.dart";
import "package:libararybd/feature/note/presentation/controller/note_controller.dart";

class NoteScreenView extends StatefulWidget {
  const NoteScreenView({super.key});

  @override
  State<NoteScreenView> createState() => _NoteScreenViewState();
}

class _NoteScreenViewState extends State<NoteScreenView> {
  final NoteController _noteController = Get.put(NoteController());

  Future<void> _showAddNoteBottomSheet() async {
    String? selectedBookId = _noteController.userBooks.isNotEmpty
        ? _noteController.userBooks.first.id
        : null;
    final textController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 18,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                        width: 46,
                        height: 5,
                        decoration: BoxDecoration(
                            color: borderColor,
                            borderRadius: BorderRadius.circular(999))),
                  ),
                  const SizedBox(height: 18),
                  const Text("Add note",
                      style: TextStyle(
                          color: titleColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  const Text("Attach a thought, quote, or reminder to a book.",
                      style: TextStyle(color: mutedTextColor)),
                  const SizedBox(height: 18),
                  DropdownButtonFormField<String>(
                    initialValue: selectedBookId,
                    decoration: const InputDecoration(hintText: "Select book"),
                    items: _noteController.userBooks
                        .map((book) => DropdownMenuItem<String>(
                            value: book.id, child: Text(book.title)))
                        .toList(),
                    onChanged: (value) {
                      setSheetState(() {
                        selectedBookId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: textController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        hintText: "Write your note", alignLabelWithHint: true),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        final ok = await _noteController.addNote(
                            bookId: selectedBookId ?? "",
                            text: textController.text);
                        if (ok) {
                          navigator.pop();
                        } else {
                          messenger.showSnackBar(SnackBar(
                              content:
                                  Text(_noteController.errorMessage.value)));
                        }
                      },
                      child: const Text("Save note"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _noteCard(NoteModel note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(_noteController.findBookTitle(note.bookId),
                    style: const TextStyle(
                        color: titleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
              IconButton(
                  onPressed: () => _noteController.deleteNote(note.id),
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: dangerColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(note.text,
              style: const TextStyle(color: mutedTextColor, height: 1.45)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (_noteController.isLoading.value &&
              _noteController.notes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_noteController.errorMessage.value.isNotEmpty &&
              _noteController.notes.isEmpty) {
            return Center(child: Text(_noteController.errorMessage.value));
          }

          return RefreshIndicator(
            onRefresh: _noteController.loadAll,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 120),
              children: [
                Text("Notes",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                const Text("Keep your takeaways and reading reminders close.",
                    style: TextStyle(color: mutedTextColor)),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: cardSoftColor,
                      borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                            color: appColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.sticky_note_2_rounded,
                            color: appColor),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "${_noteController.notes.length} saved notes across ${_noteController.userBooks.length} books.",
                          style: const TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.w600,
                              height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                if (_noteController.notes.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderColor)),
                    child: const Column(
                      children: [
                        Icon(Icons.note_alt_outlined,
                            size: 42, color: mutedTextColor),
                        SizedBox(height: 12),
                        Text("No note added yet",
                            style: TextStyle(
                                color: titleColor,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  )
                else
                  ..._noteController.notes.map(_noteCard),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_noteController.userBooks.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No books available for note")));
            return;
          }
          _showAddNoteBottomSheet();
        },
        backgroundColor: appColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text("Add note"),
      ),
    );
  }
}
