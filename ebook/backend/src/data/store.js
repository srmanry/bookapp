export const users = [
  {
    id: "u1",
    name: "Demo Author",
    email: "author@ebook.com",
    password: "123456",
    role: "author"
  },
  {
    id: "u2",
    name: "Demo Reader",
    email: "reader@ebook.com",
    password: "123456",
    role: "reader"
  }
];

export const books = [
  {
    id: "b1",
    title: "Flutter for Beginners",
    authorName: "Demo Author",
    category: "Programming",
    coverUrl:
      "https://m.media-amazon.com/images/I/91h29Crb4LL._AC_UF1000,1000_QL80_.jpg",
    pdfUrl: "/assets/pdf/english.pdf",
    ownerId: "u1"
  },
  {
    id: "b2",
    title: "Sports Psychology",
    authorName: "Demo Author",
    category: "Sports",
    coverUrl:
      "https://m.media-amazon.com/images/I/61M5J4aM-aL._SL1500_.jpg",
    pdfUrl: "/assets/pdf/english.pdf",
    ownerId: "u1"
  },
  {
    id: "b3",
    title: "Academic Writing 101",
    authorName: "Demo Author",
    category: "Academic",
    coverUrl:
      "https://m.media-amazon.com/images/I/71vMGRog+iL._SL1360_.jpg",
    pdfUrl: "/assets/pdf/english.pdf",
    ownerId: "u1"
  },
  {
    id: "b4",
    title: "Daily Health Habits",
    authorName: "Wellness Team",
    category: "Health",
    coverUrl:
      "https://m.media-amazon.com/images/I/81l3rZK4lnL._SL1500_.jpg",
    pdfUrl: "/assets/pdf/english.pdf",
    ownerId: "u2"
  }
];

export const favoritesByUser = {
  u2: ["b1", "b2"]
};

export const notesByUser = {
  u2: [
    {
      id: "n1",
      bookId: "b1",
      text: "Chapter 3 is very useful for UI state management."
    }
  ]
};

export const sessions = new Map();

let userCounter = 3;
let bookCounter = 5;
let noteCounter = 2;

export const nextUserId = () => `u${userCounter++}`;
export const nextBookId = () => `b${bookCounter++}`;
export const nextNoteId = () => `n${noteCounter++}`;
