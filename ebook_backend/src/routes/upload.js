const express = require("express");
const multer = require("multer");
const path = require("path");
const crypto = require("crypto");
const auth = require("../middleware/auth");

const router = express.Router();

function createStorage(subfolder) {
  return multer.diskStorage({
    destination: path.join(__dirname, "../../uploads", subfolder),
    filename: (_req, file, cb) => {
      const unique = crypto.randomBytes(12).toString("hex");
      const ext = path.extname(file.originalname).toLowerCase();
      cb(null, `${unique}${ext}`);
    },
  });
}

const bookUpload = multer({
  storage: createStorage("books"),
  limits: { fileSize: 50 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    if ([".pdf", ".epub"].includes(ext)) {
      cb(null, true);
    } else {
      cb(new Error("Only PDF and EPUB files are allowed"));
    }
  },
});

const coverUpload = multer({
  storage: createStorage("covers"),
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    const ext = path.extname(file.originalname).toLowerCase();
    if ([".jpg", ".jpeg", ".png", ".webp"].includes(ext)) {
      cb(null, true);
    } else {
      cb(new Error("Only JPG, PNG, and WebP images are allowed"));
    }
  },
});

router.post("/upload/book", auth, bookUpload.single("file"), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: "No file uploaded" });
  }

  const ext = path.extname(req.file.filename).toLowerCase();
  const fileFormat = ext === ".epub" ? "epub" : "pdf";

  res.json({
    fileUrl: `/uploads/books/${req.file.filename}`,
    fileFormat,
    originalName: req.file.originalname,
  });
});

router.post("/upload/cover", auth, coverUpload.single("file"), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: "No file uploaded" });
  }

  res.json({
    coverUrl: `/uploads/covers/${req.file.filename}`,
    originalName: req.file.originalname,
  });
});

router.use((err, _req, res, _next) => {
  if (err instanceof multer.MulterError) {
    if (err.code === "LIMIT_FILE_SIZE") {
      return res.status(413).json({ message: "File too large" });
    }
    return res.status(400).json({ message: err.message });
  }
  if (err) {
    return res.status(400).json({ message: err.message });
  }
});

module.exports = router;
