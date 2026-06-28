const mongoose = require("mongoose");

const bookSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true },
    authorName: { type: String, required: true, trim: true },
    category: { type: String, required: true, trim: true },
    coverUrl: { type: String, default: "" },
    fileUrl: { type: String, default: "" },
    fileFormat: {
      type: String,
      enum: ["epub", "pdf", "unknown"],
      default: "unknown",
    },
    pdfUrl: { type: String, default: "" },
    uploadedBy: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  },
  { timestamps: true }
);

bookSchema.index({ title: "text", authorName: "text" });

module.exports = mongoose.model("Book", bookSchema);
