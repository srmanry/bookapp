import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:libararybd/core/widgets/custom_button.dart";
import "package:libararybd/core/widgets/custom_text_field.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/feature/profile/presentation/controller/book_upload_controller.dart";

class BookUploadScreenView extends StatefulWidget {
  const BookUploadScreenView({super.key});

  @override
  State<BookUploadScreenView> createState() => _BookUploadScreenViewState();
}

class _BookUploadScreenViewState extends State<BookUploadScreenView> {
  final BookUploadController _ctrl = Get.put(BookUploadController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  String? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _pickBookFile() async {
    final result = await FilePicker.pickFiles(type: FileType.any);
    if (result == null || result.files.single.path == null) return;

    final file = result.files.single;
    final ext = file.name.split(".").last.toLowerCase();
    if (ext != "pdf" && ext != "epub") {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Only PDF and EPUB files are allowed")),
      );
      return;
    }

    _ctrl.setBookFile(file.path!, file.name);
  }

  Future<void> _pickCoverImage() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      _ctrl.setCoverFile(result.files.single.path!, result.files.single.name);
    }
  }

  Future<void> _onPublish() async {
    final ok = await _ctrl.publishBook(
      title: _titleController.text,
      authorName: _authorController.text,
      category: _selectedCategory ?? "",
    );

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book published successfully")),
      );
      _titleController.clear();
      _authorController.clear();
      setState(() { _selectedCategory = null; });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_ctrl.errorMessage.value)),
    );
  }

  Widget _filePickerTile({
    required String label,
    required String hint,
    required IconData icon,
    required String pickedName,
    required VoidCallback onPick,
  }) {
    final hasPicked = pickedName.isNotEmpty;

    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasPicked ? appColor.withValues(alpha: 0.08) : cardSoftColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: hasPicked ? appColor : borderColor,
            width: hasPicked ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: hasPicked
                    ? appColor.withValues(alpha: 0.14)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                hasPicked ? Icons.check_circle_rounded : icon,
                color: hasPicked ? appColor : mutedTextColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasPicked ? pickedName : hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: hasPicked ? appColor : mutedTextColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.upload_file_rounded,
              color: hasPicked ? appColor : mutedTextColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Publish book")),
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            18, 12, 18, MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardSoftColor,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Share a new story",
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Pick your book file, add details, and publish for readers.",
                      style: TextStyle(color: mutedTextColor, height: 1.45),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _filePickerTile(
                      label: "Book file",
                      hint: "Tap to select PDF or EPUB",
                      icon: Icons.menu_book_rounded,
                      pickedName: _ctrl.pickedBookName.value,
                      onPick: _pickBookFile,
                    ),
                    const SizedBox(height: 14),
                    _filePickerTile(
                      label: "Cover image (optional)",
                      hint: "Tap to select cover image",
                      icon: Icons.image_outlined,
                      pickedName: _ctrl.pickedCoverName.value,
                      onPick: _pickCoverImage,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Book name",
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hinText: "Enter the book title",
                      controller: _titleController,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Author name",
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      hinText: "Enter author name",
                      controller: _authorController,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Category",
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        hintText: "Select a category",
                      ),
                      items: _ctrl.categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() { _selectedCategory = v; }),
                    ),
                    if (_ctrl.uploadStatus.value.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _ctrl.uploadStatus.value,
                            style: const TextStyle(
                              color: appColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 22),
                    _ctrl.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : CustomBottom(
                            name: "Publish",
                            bottomColor: appColor,
                            onTap: _onPublish,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
