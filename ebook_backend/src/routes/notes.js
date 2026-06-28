const express = require("express");
const Note = require("../models/Note");
const auth = require("../middleware/auth");

const router = express.Router();

router.get("/users/:userId/notes", auth, async (req, res) => {
  try {
    const notes = await Note.find({ userId: req.params.userId }).sort({ createdAt: -1 });
    res.json({ notes: notes.map((n) => n.toJSON()) });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.post("/users/:userId/notes", auth, async (req, res) => {
  try {
    const { bookId, text } = req.body;

    if (!bookId || !text) {
      return res.status(400).json({ message: "bookId and text are required" });
    }

    const note = await Note.create({
      userId: req.params.userId,
      bookId,
      text: text.trim(),
    });

    res.status(201).json({ note: note.toJSON() });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.delete("/users/:userId/notes/:noteId", auth, async (req, res) => {
  try {
    const note = await Note.findOneAndDelete({
      _id: req.params.noteId,
      userId: req.params.userId,
    });

    if (!note) {
      return res.status(404).json({ message: "Note not found" });
    }

    res.json({ message: "Note deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
