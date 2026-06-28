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
  return {
    id: book._id.toString(),
    title: book.title,
    authorName: book.authorName,
    category: book.category,
    coverUrl: book.coverUrl,
    fileUrl,
    fileFormat: inferFileFormat(book.fileFormat, fileUrl),
    pdfUrl: book.pdfUrl,
  };
}

router.get("/users/:userId/books", auth, async (req, res) => {
  try {
    const books = await Book.find({ uploadedBy: req.params.userId }).sort({ createdAt: -1 });

    res.json({ books: books.map(serializeBook) });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
