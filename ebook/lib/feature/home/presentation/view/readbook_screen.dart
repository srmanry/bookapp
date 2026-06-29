import "dart:typed_data";

import "package:epub_view/epub_view.dart";
import "package:flutter/material.dart";
import "package:internet_file/internet_file.dart";
import "package:libararybd/core/util/custom_color.dart";
import "package:libararybd/core/widgets/app_surfaces.dart";
import "package:libararybd/feature/home/data/model/book_model.dart";
import "package:syncfusion_flutter_pdfviewer/pdfviewer.dart";

class ReadBookScreenView extends StatefulWidget {
  const ReadBookScreenView({super.key, required this.book});

  final BookModel book;

  @override
  State<ReadBookScreenView> createState() => _ReadBookScreenViewState();
}

class _ReadBookScreenViewState extends State<ReadBookScreenView> {
  EpubController? _epubController;
  bool _isPreparingEpub = false;
  String _epubErrorMessage = "";

  @override
  void initState() {
    super.initState();
    if (widget.book.isEpub && widget.book.hasReadableFile) {
      _loadEpubController();
    }
  }

  @override
  void dispose() {
    _epubController?.dispose();
    super.dispose();
  }

  bool _isAssetPath(String path) {
    return !path.startsWith("http://") && !path.startsWith("https://");
  }

  String _normalizeAssetPath(String path) {
    return path.startsWith("/") ? path.substring(1) : path;
  }

  Future<void> _loadEpubController() async {
    setState(() {
      _isPreparingEpub = true;
      _epubErrorMessage = "";
    });

    try {
      final Future<EpubBook> document;
      if (_isAssetPath(widget.book.fileUrl)) {
        document = EpubDocument.openAsset(
          _normalizeAssetPath(widget.book.fileUrl),
        );
      } else {
        final Uint8List fileBytes = await InternetFile.get(widget.book.fileUrl);
        document = EpubDocument.openData(fileBytes);
      }

      if (!mounted) return;

      setState(() {
        _epubController = EpubController(document: document);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _epubErrorMessage = "Unable to open this EPUB file.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isPreparingEpub = false;
        });
      }
    }
  }

  Widget _unsupportedState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppSectionCard(
          radius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.menu_book_outlined,
                size: 48,
                color: mutedTextColor,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: titleColor, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReader() {
    if (!widget.book.hasReadableFile) {
      return _unsupportedState("This book does not have a readable file yet.");
    }

    if (widget.book.isEpub) {
      if (_isPreparingEpub) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_epubErrorMessage.isNotEmpty) {
        return _unsupportedState(_epubErrorMessage);
      }
      if (_epubController != null) {
        return EpubView(
          controller: _epubController!,
          onDocumentError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
          },
        );
      }
    }

    if (widget.book.isPdf) {
      final fileUrl = widget.book.fileUrl;
      if (_isAssetPath(fileUrl)) {
        return SfPdfViewer.asset(_normalizeAssetPath(fileUrl));
      }
      return SfPdfViewer.network(fileUrl);
    }

    return _unsupportedState(
      "Unsupported book format. Please upload an EPUB or PDF file.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: AppBackground(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionCard(
                  color: cardSoftColor,
                  radius: 24,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          AppPill(label: widget.book.category),
                          AppPill(
                            label: widget.book.formatLabel,
                            foregroundColor: titleColor,
                            backgroundColor: surfaceColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.book.title,
                        style: const TextStyle(
                          color: titleColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.book.authorName,
                        style: const TextStyle(
                          color: mutedTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: borderColor),
                        boxShadow: [
                          BoxShadow(
                            color: titleColor.withValues(alpha: 0.07),
                            blurRadius: 22,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: _buildReader(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
