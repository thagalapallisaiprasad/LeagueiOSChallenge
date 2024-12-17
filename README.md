# LeagueiOSChallenge

iOS application built using Swift and UIKit, implementing user authentication, Users listing, and interaction features. The app provides different navigation options for logged-in users and guest users.

## Features

1. **Authentication:**
   - Login functionality for registered users.
   - Guest access with limited privileges.

2. **Users Listing:**
   - Displays a list of Users fetched from remote APIs.
   - Users and Posts include user avatars, usernames, titles, and descriptions.
   - Interaction enabled only on avatars and usernames.

3. **Navigation:**
   - Logged-in users can log out via a "Logout" button.
   - Guest users can exit via an "Exit" button, which shows a thank-you alert before navigating back to the login screen.

4. **Event Handling:**
   - Tapping on the avatar or username presents detailed user information.

5. **Unit Test Coverage:**
   - Test cases for authentication, Users fetching, and user interactions.

---

## Setup Instructions

### Prerequisites

- Xcode 14 or later
- iOS 15.4 or later

### Installation

1. Open the project in Xcode:
   ```bash
   cd LeagueiOSChallenge
   open LeagueiOSChallenge.xcodeproj
   ```

2. Build and run the project on a simulator or a physical device.

---

## Usage

### Login Screen

- Enter valid credentials and press **Login** to navigate to the Post List.
- Tap **Continue as Guest** to access the Post List without logging in.

### Post List

- View a list of posts with user avatars and usernames.
- Tap on the avatar or username to view user details.
- Logged-in users can log out using the "Logout" button in the navigation bar.
- Guest users can exit using the "Exit" button, which shows a thank-you message.

### User Information

- Displays detailed information about the selected user.
- Accessible via tapping on the avatar or username.

---

## Improvements to Consider

- **Local Database Storage:** Implement local storage (e.g., Core Data) to cache Users and reduce API calls.
- **Persistent Login:** Add a secure local session storage mechanism to retain login state.
- **Offline Mode:** Enable viewing of cached posts when offline.
- **Push Notifications:** Notify users of new Users or updates.

---

## Running Tests

1. Open the project in Xcode.
2. Press `Command + U` to run all tests.
3. View test results in the Test Navigator.

---


