const express = require("express");
const Book = require("../models/Book");
const auth = require("../middleware/auth");

const router = express.Router();

function inferFileFormat(fileFormat, fileUrl) {
  const normalizedFormat = (fileFormat || "").trim().toLowerCase();
  if (normalizedFormat === "epub" || normalizedFormat === "pdf") {
    return normalizedFormat;
  }

  const normalizedUrl = (fileUrl || "").trim().toLowerCase();
  if (normalizedUrl.endsWith(".epub")) {
    return "epub";
  }
  if (normalizedUrl.endsWith(".pdf")) {
    return "pdf";
  }

  return "unknown";
}

function serializeBook(book) {
  const fileUrl = book.fileUrl || book.pdfUrl || "";
  const fileFormat = inferFileFormat(book.fileFormat, fileUrl);

  return {
    id: book._id.toString(),
    title: book.title,
    authorName: book.authorName,
    category: book.category,
    coverUrl: book.coverUrl,
    fileUrl,
    fileFormat,
    pdfUrl: book.pdfUrl,
  };
}

router.get("/categories", async (_req, res) => {
  try {
    const categories = await Book.distinct("category");
    const defaults = ["Health", "Religion", "Academic", "Sports", "Programming"];
    const merged = [...new Set([...defaults, ...categories])];
    res.json({ categories: merged });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.get("/books", async (req, res) => {
  try {
    const { q, category } = req.query;
    const filter = {};

    if (category) {
      filter.category = category;
    }
    if (q) {
      filter.$or = [
        { title: { $regex: q, $options: "i" } },
        { authorName: { $regex: q, $options: "i" } },
      ];
    }

    const books = await Book.find(filter).sort({ createdAt: -1 });

    res.json({ books: books.map(serializeBook) });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.post("/books", auth, async (req, res) => {
  try {
    const {
      title,
      authorName,
      category,
      coverUrl,
      fileUrl,
      fileFormat,
      pdfUrl,
    } = req.body;

    if (!title || !authorName || !category) {
      return res.status(400).json({ message: "Title, authorName, and category are required" });
    }

    const normalizedFileUrl = (fileUrl || pdfUrl || "").trim();
    const normalizedFileFormat = inferFileFormat(fileFormat, normalizedFileUrl);

    const book = await Book.create({
      title,
      authorName,
      category,
      coverUrl: coverUrl || "",
      fileUrl: normalizedFileUrl,
      fileFormat: normalizedFileFormat,
      pdfUrl: normalizedFileFormat === "pdf" ? normalizedFileUrl : pdfUrl || "",
      uploadedBy: req.userId,
    });

    res.status(201).json({ book: serializeBook(book) });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.delete("/books/:bookId", auth, async (req, res) => {
  try {
    const book = await Book.findById(req.params.bookId);
    if (!book) {
      return res.status(404).json({ message: "Book not found" });
    }

    if (book.uploadedBy.toString() !== req.userId) {
      return res.status(403).json({ message: "You can only delete your own books" });
    }

    await book.deleteOne();
    res.json({ message: "Book deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
