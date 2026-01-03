# 🥷🏽 Flutter Education App

This project is a mobile application for teachers built with Flutter.
The application helps teachers manage educational activities such as classes, students, subjects, grades, and evaluations through a secure and easy-to-use mobile interface.

It was developed as an academic project (Mémoire) and focuses on improving the digital management of teaching activities.

## 📦 Tech Stack

### Mobile:

- `Flutter`
- `Dart`

### Backend:

- `Sqflite`

### UI & Tools:

- `Material Design`
- `Form Validation`
- `State Management`

## 🦄 Features

Here's what you can do with Flutter Education App:

- **User Authentication**: Teachers can securely log in to access the application and their personal data.

- **Class Management**: Create and manage classes assigned to teachers.

- **Student Management**: Add, update, and view student information.

- **Subject Management**: Manage subjects taught by each teacher.

- **Grade & Evaluation Management**: Record, update, and consult student grades and evaluations.

- **Educational Activity Tracking**: Organize and monitor teaching activities efficiently.

- **Mobile-Friendly Interface**: Use the application easily on mobile devices with a clean and intuitive UI.

## 👩🏽‍🍳 The Process

The project started with an analysis of teachers’ needs in managing educational activities.
Based on this analysis, I designed the application architecture and defined the main features required for effective teaching management.

Next, I implemented the authentication system to secure access to the application.
Then, I developed the core functionalities such as class management, student management, and grade handling, using Flutter and Dart.

Special attention was given to data organization, user navigation, and form validation to ensure reliability and ease of use.

Throughout the development, I documented each step as part of my academic mémoire, which helped me better understand the system and improve my technical and analytical skills.

## 📚 What I Learned

During this project, I gained strong experience in mobile application development and educational system design.

### Authentication & User Management:

- **Secure Access**: I learned how to implement user authentication and protect application features.

- **Session Logic**: Managing user sessions helped me understand access control in mobile apps.

### Flutter & Dart Development

- **UI Construction**: I learned how to build structured screens using Flutter widgets.

- **State Handling:**: Managing application state improved my understanding of dynamic UI updates.

### 📈 Overall Growth:

Each part of this project strengthened my ability to analyze requirements, design mobile solutions, and document technical work.
It was not only about coding, but also about understanding how technology can support education and teachers’ daily work.

## How can it be improved?

- Add role management (admin / teacher)
- Integrate attendance tracking
- Connect to a remote backend

## Running the Project

To run the project in your local environment, follow these steps:

1. Clone the repository: `git clone https://github.com/fetrafaneva/flutter_education_app.git`
2. Install dependencies:
       `flutter pub get`
   
3. Run the application:
       `flutter run`

## 📸 Screenshots

<p align="center">
  <img src="assets/readme/Sign Up page.png" alt="Sign Up" width="200" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <!-- espace entre les images -->
  <img src="assets/readme/Sign In page.png" alt="Sign In" width="200" />
</p>

The authentication page allows users to log in or sign up. Users can access their account easily using their email and password.

<p align="center">
  <img src="assets/readme/Sign Up page.png" alt="Sign Up" width="200" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <!-- espace entre les images -->
  <img src="assets/readme/Sign In page.png" alt="Sign In" width="200" />
</p>

The application offers two types of login methods to ensure both accessibility and security for users.

### Email & Password Login

This screen allows users to access the application by entering their email address and password.
All required fields must be completed before tapping the “Log In” button.
The simple and clean design provides an intuitive and user-friendly login experience.

### Security Code Login

This screen enables users to authenticate using a personal security code.
The numeric keypad allows fast and secure input, while the delete button helps correct any mistakes.
This method adds an extra layer of protection and is ideal for quick access.
