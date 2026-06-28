const express = require("express");
const User = require("../models/User");
const Book = require("../models/Book");
const Note = require("../models/Note");
const auth = require("../middleware/auth");

const router = express.Router();

router.get("/profile", auth, async (req, res) => {
  try {
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const [totalBooks, totalNotes] = await Promise.all([
      Book.countDocuments({ uploadedBy: req.userId }),
      Note.countDocuments({ userId: req.userId }),
    ]);
    const totalFavorites = user.favoriteBooks.length;

    res.json({
      profile: {
        ...user.toPublicJSON(),
        stats: {
          totalBooks,
          totalFavorites,
          totalNotes,
        },
      },
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

router.put("/profile", auth, async (req, res) => {
  try {
    const { name, email } = req.body;

    if (!name || !email) {
      return res.status(400).json({ message: "Name and email are required" });
    }

    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const trimmedEmail = email.toLowerCase().trim();
    if (trimmedEmail !== user.email) {
      const existing = await User.findOne({ email: trimmedEmail });
      if (existing) {
        return res.status(409).json({ message: "Email already in use" });
      }
    }

    user.name = name.trim();
    user.email = trimmedEmail;
    await user.save();

    res.json({ profile: user.toPublicJSON() });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
