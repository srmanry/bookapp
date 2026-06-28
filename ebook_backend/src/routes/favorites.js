const express = require("express");
const User = require("../models/User");
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

router.get("/users/:userId/favorites", auth, async (req, res) => {
  try {
    const user = await User.findById(req.params.userId).populate("favoriteBooks");
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({
      books: user.favoriteBooks.map(serializeBook),
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.get("/users/:userId/favorites/book-ids", auth, async (req, res) => {
  try {
    const user = await User.findById(req.params.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json({
      favoriteBookIds: user.favoriteBooks.map((id) => id.toString()),
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.post("/users/:userId/favorites", auth, async (req, res) => {
  try {
    const { bookId } = req.body;
    if (!bookId) {
      return res.status(400).json({ message: "bookId is required" });
    }

    const user = await User.findById(req.params.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const index = user.favoriteBooks.findIndex((id) => id.toString() === bookId);
    if (index === -1) {
      user.favoriteBooks.push(bookId);
    } else {
      user.favoriteBooks.splice(index, 1);
    }

    await user.save();

    res.json({
      favoriteBookIds: user.favoriteBooks.map((id) => id.toString()),
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
