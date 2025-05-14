# 📸 Snapchat Clone App

**Snapchat Clone** s a SwiftUI-based iOS application that allows users to upload and share photos instantly. Using Firebase for data storage and photo uploading, the app offers a clean and modern interface for users to share their moments with friends.


---

## ✨ Features

### 🧭 Navigation
- Uses NavigationView and NavigationLink to browse categories and details.

- Smooth transitions between list and detail views.


### 🖼️ Detail View
- Tapping an item opens a dedicated detail page.
- Shows image, username for the selected item.

---

## 🛠 Tools & Technologies Used

| Technology           | Purpose                                      |
|----------------------|----------------------------------------------|
| Swift                | Primary programming language                 |
| FirebaseAuth         | Allows users to log in with email/password.  |
| FirebaseRealtimeDat  | Stores user data and snaps.             |
| Firebase Storage     | Stores uploaded images             |
| SDWebImage           | Used for image loading and caching.     |

---

## 📂 Code Overview

### `ContentView.swift`
- Main entry view that lists all favorite categories and their items.
- Uses `List`, `Section`, and `NavigationLink`.

🔹 Key Structures:
- `myFavorites`: Array of `FavoriteModel` objects.

---

### `DetailsView.swift`
- Displays detailed information about a selected favorite element.


### `SnapModel.swift`
- Defines the app's core data structures, including the Snap model.

```swift
struct Snap : Identifiable {
    let id = UUID()
    let username: String
    let imageUrlArray: [String]
    let date: Date
    let timeDifference: Int
}

---

## 🎬 Demo Video
