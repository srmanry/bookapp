require("dotenv").config();
const express = require("express");
const cors = require("cors");
const path = require("path");
const mongoose = require("mongoose");

const authRoutes = require("./routes/auth");
const bookRoutes = require("./routes/books");
const noteRoutes = require("./routes/notes");
const favoriteRoutes = require("./routes/favorites");
const profileRoutes = require("./routes/profile");
const userBookRoutes = require("./routes/userBooks");
const uploadRoutes = require("./routes/upload");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/uploads", express.static(path.join(__dirname, "../uploads")));

app.use("/api/auth", authRoutes);
app.use("/api", bookRoutes);
app.use("/api", noteRoutes);
app.use("/api", favoriteRoutes);
app.use("/api", profileRoutes);
app.use("/api", userBookRoutes);
app.use("/api", uploadRoutes);

app.get("/", (_req, res) => {
  res.json({ message: "eBook API is running" });
});

const PORT = process.env.PORT || 8080;

mongoose
  .connect(process.env.MONGODB_URI)
  .then(() => {
    console.log("Connected to MongoDB");
    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error("MongoDB connection error:", err.message);
    process.exit(1);
  });
