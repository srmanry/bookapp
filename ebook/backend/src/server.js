import cors from "cors";
import express from "express";
import {
  books,
  favoritesByUser,
  nextBookId,
  nextNoteId,
  nextUserId,
  notesByUser,
  sessions,
  users
} from "./data/store.js";

const app = express();
const port = Number(process.env.PORT || 8080);
const allowedRoles = new Set(["author", "reader"]);

app.use(cors());
app.use(express.json());

const normalizeText = (value) => String(value ?? "").trim();
const normalizeEmail = (value) => normalizeText(value).toLowerCase();

const sanitizeUser = (user) => {
  const { password, ...safeUser } = user;
  return safeUser;
};

const createSession = (userId) => {
  const token = `token-${userId}-${Date.now()}`;
  sessions.set(token, userId);
  return token;
};

const getUserByToken = (token) => {
  if (!token) return null;
  const userId = sessions.get(token);
  if (!userId) return null;
  return users.find((user) => user.id === userId) || null;
};

const getBookById = (bookId) => {
  return books.find((book) => book.id === bookId) || null;
};

const authMiddleware = (req, res, next) => {
  const raw = req.header("authorization") || "";
  const token = raw.replace("Bearer ", "").trim();
  const user = getUserByToken(token);

  if (!user) {
    res.status(401).json({
      success: false,
      message: "Unauthorized. Please login first."
    });
    return;
  }

  req.user = user;
  next();
};

const authorOnlyMiddleware = (req, res, next) => {
  if (req.user.role !== "author") {
    res.status(403).json({
      success: false,
      message: "Only authors can access this feature."
    });
    return;
  }

  next();
};

const authorizeParamUser = (req, res, next) => {
  if (req.user.id !== req.params.userId) {
    res.status(403).json({
      success: false,
      message: "Forbidden. You can only access your own resources."
    });
    return;
  }
  next();
};

app.get("/api/health", (_req, res) => {
  res.json({
    success: true,
    message: "Backend is running",
    timestamp: new Date().toISOString()
  });
});

app.post("/api/auth/signup", (req, res) => {
  const { name, email, password, role } = req.body || {};
  const normalizedName = normalizeText(name);
  const normalizedEmail = normalizeEmail(email);
  const normalizedPassword = String(password ?? "");
  const normalizedRole = normalizeText(role).toLowerCase();

  if (!normalizedName || !normalizedEmail || !normalizedPassword || !normalizedRole) {
    res.status(400).json({
      success: false,
      message: "name, email, password and role are required."
    });
    return;
  }

  if (!allowedRoles.has(normalizedRole)) {
    res.status(400).json({
      success: false,
      message: "role must be either author or reader."
    });
    return;
  }

  const exists = users.some((user) => user.email.toLowerCase() === normalizedEmail);

  if (exists) {
    res.status(409).json({
      success: false,
      message: "Email already exists."
    });
    return;
  }

  const newUser = {
    id: nextUserId(),
    name: normalizedName,
    email: normalizedEmail,
    password: normalizedPassword,
    role: normalizedRole
  };

  users.push(newUser);
  const token = createSession(newUser.id);

  res.status(201).json({
    success: true,
    message: "Signup successful",
    token,
    user: sanitizeUser(newUser)
  });
});

app.post("/api/auth/login", (req, res) => {
  const { email, password } = req.body || {};
  const normalizedEmail = normalizeEmail(email);
  const normalizedPassword = String(password ?? "");

  if (!normalizedEmail || !normalizedPassword) {
    res.status(400).json({
      success: false,
      message: "email and password are required."
    });
    return;
  }

  const matchedUser = users.find(
    (user) =>
      user.email.toLowerCase() === normalizedEmail &&
      user.password === normalizedPassword
  );

  if (!matchedUser) {
    res.status(401).json({
      success: false,
      message: "Invalid email or password."
    });
    return;
  }

  const token = createSession(matchedUser.id);

  res.json({
    success: true,
    message: "Login successful",
    token,
    user: sanitizeUser(matchedUser)
  });
});

app.get("/api/categories", (_req, res) => {
  const categories = [...new Set(books.map((book) => book.category))];
  res.json({
    success: true,
    categories
  });
});

app.get("/api/books", (req, res) => {
  const { q, category, ownerId } = req.query;
  let result = [...books];

  if (ownerId) {
    result = result.filter((book) => book.ownerId === String(ownerId));
  }

  if (category) {
    result = result.filter(
      (book) =>
        book.category.toLowerCase() === String(category).toLowerCase()
    );
  }

  if (q) {
    const text = String(q).toLowerCase();
    result = result.filter(
      (book) =>
        book.title.toLowerCase().includes(text) ||
        book.authorName.toLowerCase().includes(text)
    );
  }

  res.json({
    success: true,
    books: result
  });
});

app.post("/api/books", authMiddleware, authorOnlyMiddleware, (req, res) => {
  const { title, authorName, category, coverUrl, pdfUrl } = req.body || {};
  const normalizedTitle = normalizeText(title);
  const normalizedAuthorName = normalizeText(authorName);
  const normalizedCategory = normalizeText(category);
  const normalizedCoverUrl = normalizeText(coverUrl);
  const normalizedPdfUrl = normalizeText(pdfUrl);

  if (!normalizedTitle || !normalizedAuthorName || !normalizedCategory) {
    res.status(400).json({
      success: false,
      message: "title, authorName and category are required."
    });
    return;
  }

  const newBook = {
    id: nextBookId(),
    title: normalizedTitle,
    authorName: normalizedAuthorName,
    category: normalizedCategory,
    coverUrl: normalizedCoverUrl ||
      "https://m.media-amazon.com/images/I/91h29Crb4LL._AC_UF1000,1000_QL80_.jpg",
    pdfUrl: normalizedPdfUrl || "/assets/pdf/english.pdf",
    ownerId: req.user.id
  };

  books.push(newBook);

  res.status(201).json({
    success: true,
    message: "Book published successfully",
    book: newBook
  });
});

app.delete("/api/books/:bookId", authMiddleware, authorOnlyMiddleware, (req, res) => {
  const { bookId } = req.params;
  const index = books.findIndex((book) => book.id === bookId);

  if (index < 0) {
    res.status(404).json({
      success: false,
      message: "Book not found."
    });
    return;
  }

  if (books[index].ownerId !== req.user.id) {
    res.status(403).json({
      success: false,
      message: "Only the owner can delete this book."
    });
    return;
  }

  books.splice(index, 1);

  Object.keys(favoritesByUser).forEach((userId) => {
    favoritesByUser[userId] = (favoritesByUser[userId] || []).filter(
      (id) => id !== bookId
    );
  });

  Object.keys(notesByUser).forEach((userId) => {
    notesByUser[userId] = (notesByUser[userId] || []).filter(
      (note) => note.bookId !== bookId
    );
  });

  res.json({
    success: true,
    message: "Book deleted successfully"
  });
});

app.get("/api/profile", authMiddleware, (req, res) => {
  const userBooks = books.filter((book) => book.ownerId === req.user.id);
  const favoriteCount = (favoritesByUser[req.user.id] || []).length;
  const noteCount = (notesByUser[req.user.id] || []).length;

  res.json({
    success: true,
    profile: {
      ...sanitizeUser(req.user),
      stats: {
        totalBooks: userBooks.length,
        totalFavorites: favoriteCount,
        totalNotes: noteCount
      }
    }
  });
});

app.put("/api/profile", authMiddleware, (req, res) => {
  const { name, email } = req.body || {};
  const normalizedName = normalizeText(name);
  const normalizedEmail = normalizeEmail(email);

  if (!normalizedName || !normalizedEmail) {
    res.status(400).json({
      success: false,
      message: "name and email are required."
    });
    return;
  }

  const existingUser = users.find(
    (user) =>
      user.email.toLowerCase() === normalizedEmail &&
      user.id !== req.user.id
  );

  if (existingUser) {
    res.status(409).json({
      success: false,
      message: "Email already exists."
    });
    return;
  }

  req.user.name = normalizedName;
  req.user.email = normalizedEmail;

  const userBooks = books.filter((book) => book.ownerId === req.user.id);
  const favoriteCount = (favoritesByUser[req.user.id] || []).length;
  const noteCount = (notesByUser[req.user.id] || []).length;

  res.json({
    success: true,
    message: "Profile updated successfully",
    profile: {
      ...sanitizeUser(req.user),
      stats: {
        totalBooks: userBooks.length,
        totalFavorites: favoriteCount,
        totalNotes: noteCount
      }
    }
  });
});

app.get("/api/users/:userId/books", authMiddleware, authorizeParamUser, authorOnlyMiddleware, (req, res) => {
  const { userId } = req.params;
  const userBooks = books.filter((book) => book.ownerId === userId);

  res.json({
    success: true,
    books: userBooks
  });
});

app.get("/api/users/:userId/favorites", authMiddleware, authorizeParamUser, (req, res) => {
  const { userId } = req.params;
  const favoriteIds = favoritesByUser[userId] || [];
  const favoriteBooks = books.filter((book) => favoriteIds.includes(book.id));

  res.json({
    success: true,
    books: favoriteBooks
  });
});

app.get(
  "/api/users/:userId/favorites/book-ids",
  authMiddleware,
  authorizeParamUser,
  (req, res) => {
    const { userId } = req.params;
    res.json({
      success: true,
      favoriteBookIds: favoritesByUser[userId] || []
    });
  }
);

app.post("/api/users/:userId/favorites", authMiddleware, authorizeParamUser, (req, res) => {
  const { userId } = req.params;
  const { bookId } = req.body || {};
  const normalizedBookId = normalizeText(bookId);

  if (!normalizedBookId) {
    res.status(400).json({
      success: false,
      message: "bookId is required."
    });
    return;
  }

  if (!getBookById(normalizedBookId)) {
    res.status(404).json({
      success: false,
      message: "Book not found."
    });
    return;
  }

  const favoriteIds = favoritesByUser[userId] || [];
  const isAlreadyFavorite = favoriteIds.includes(normalizedBookId);

  favoritesByUser[userId] = isAlreadyFavorite
    ? favoriteIds.filter((id) => id !== normalizedBookId)
    : [...favoriteIds, normalizedBookId];

  res.json({
    success: true,
    message: isAlreadyFavorite ? "Removed from favorite" : "Added to favorite",
    favoriteBookIds: favoritesByUser[userId]
  });
});

app.get("/api/users/:userId/notes", authMiddleware, authorizeParamUser, (req, res) => {
  const { userId } = req.params;
  res.json({
    success: true,
    notes: notesByUser[userId] || []
  });
});

app.post("/api/users/:userId/notes", authMiddleware, authorizeParamUser, (req, res) => {
  const { userId } = req.params;
  const { bookId, text } = req.body || {};
  const normalizedBookId = normalizeText(bookId);
  const normalizedText = normalizeText(text);

  if (!normalizedBookId || !normalizedText) {
    res.status(400).json({
      success: false,
      message: "bookId and text are required."
    });
    return;
  }

  if (!getBookById(normalizedBookId)) {
    res.status(404).json({
      success: false,
      message: "Book not found."
    });
    return;
  }

  const note = {
    id: nextNoteId(),
    bookId: normalizedBookId,
    text: normalizedText
  };

  if (!notesByUser[userId]) {
    notesByUser[userId] = [];
  }

  notesByUser[userId].push(note);

  res.status(201).json({
    success: true,
    message: "Note saved",
    note
  });
});

app.delete(
  "/api/users/:userId/notes/:noteId",
  authMiddleware,
  authorizeParamUser,
  (req, res) => {
    const { userId, noteId } = req.params;
    const previous = notesByUser[userId] || [];
    const next = previous.filter((note) => note.id !== noteId);

    if (next.length === previous.length) {
      res.status(404).json({
        success: false,
        message: "Note not found."
      });
      return;
    }

    notesByUser[userId] = next;

    res.json({
      success: true,
      message: "Note deleted"
    });
  }
);

app.use((_req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found"
  });
});

app.listen(port, () => {
  console.log(`EBook backend running at http://localhost:${port}`);
});
