const mongoose = require("mongoose");

const noteSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    bookId: { type: mongoose.Schema.Types.ObjectId, ref: "Book", required: true },
    text: { type: String, required: true, trim: true },
  },
  { timestamps: true }
);

noteSchema.methods.toJSON = function () {
  return {
    id: this._id.toString(),
    bookId: this.bookId.toString(),
    text: this.text,
  };
};

module.exports = mongoose.model("Note", noteSchema);
