# EBook Backend

Simple REST API backend for this Flutter app.

## Run

```bash
cd backend
npm install
npm run dev
```

Server starts on `http://localhost:8080`.

## Demo Login

- Email: `author@ebook.com`
- Password: `123456`

## Notes

- Signup `role` must be `author` or `reader`.
- Data is stored in memory for now (server restart resets users/books/favorites/notes added at runtime).

## Main Endpoints

- `GET /api/health`
- `POST /api/auth/signup`
- `POST /api/auth/login`
- `GET /api/categories`
- `GET /api/books`
- `POST /api/books` (requires `Authorization: Bearer <token>`)
- `DELETE /api/books/:bookId` (requires token)
- `GET /api/profile` (requires token)
- `GET /api/users/:userId/books` (requires token and same userId)
- `GET /api/users/:userId/favorites` (requires token and same userId)
- `GET /api/users/:userId/favorites/book-ids` (requires token and same userId)
- `POST /api/users/:userId/favorites` (requires token and same userId)
- `GET /api/users/:userId/notes` (requires token and same userId)
- `POST /api/users/:userId/notes` (requires token and same userId)
- `DELETE /api/users/:userId/notes/:noteId` (requires token and same userId)
