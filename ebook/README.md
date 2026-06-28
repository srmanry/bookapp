# libararybd

Flutter ebook app with a local Node.js backend.

## Run Backend

```bash
cd backend
npm install
npm run dev
```

Backend runs at `http://localhost:8080`.

Demo login credentials:

- Email: `author@ebook.com`
- Password: `123456`

## Run Flutter

```bash
flutter pub get
flutter run
```

Default Flutter backend base URL is `http://10.0.2.2:8080/api` (Android emulator).

For iOS simulator/macOS/web you can run with:

```bash
flutter run --dart-define=BACKEND_BASE_URL=http://127.0.0.1:8080/api
```

## Integrated Features

- Auth: signup and login with role
- Home: list books from backend, search, category filter, favorite toggle
- Favorite: view and remove favorite books
- Note: add and delete notes linked to your books
- Profile: live profile and stats (books/favorites/notes)
- Publish Book: create new books
- Your Books: list and delete your own books
