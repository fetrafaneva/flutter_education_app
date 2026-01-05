<p align="center">
  <img src="assets/readme/couverture.png" alt="Class Results Dashboard" width="full" />
</p>



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

<p align="center" style="margin: 20px 0;">
  <img src="assets/readme/Sign Up page.png" alt="Sign Up" width="200" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="assets/readme/Sign In page.png" alt="Sign In" width="200" />
</p>

### Authentication Pages
The authentication pages allow users to log in or sign up easily using their email and password.  
Two login methods are available to ensure accessibility and security.

<p align="center">
  <img src="assets/readme/auth PIN.png" alt="PIN Login" width="200" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="assets/readme/auth email.png" alt="Email Login" width="200" />
</p>

#### Email & Password Login
Users can access the application by entering their email and password.  
All required fields must be completed before tapping the **Log In** button.  
The clean and simple design provides an intuitive login experience.

#### Security Code (PIN) Login
Users can authenticate using a personal security code.  
The numeric keypad allows fast and secure input, while the delete button helps correct mistakes.  
This method adds an extra layer of protection for quick access.

<p align="center">
  <img src="assets/readme/Dashboard.png" alt="Dashboard" width="200" />
</p>

### Dashboard
The dashboard serves as the main home page for organizing and managing educational data.  
It offers three main sections:

- **Class Management:** View and manage registered classes.  
- **Assessment Management:** Organize and track student assessments.  
- **Results Management:** Access and manage students’ results efficiently.

<p align="center">
  <img src="assets/readme/Dashboard class.png" alt="Class Dashboard" width="200" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="assets/readme/info_class.png" alt="Class Info" width="200" />
</p>

### Student Management Page
This page displays the details of a class (e.g., “Seconde”) with the total number of students and a detailed list.  
Each student is presented with a number, full name, and an icon for additional actions.  
A floating action button at the bottom right allows adding new students, while top icons manage class-specific options, such as adding subjects.

<p align="center">
  <img src="assets/readme/matiere.png" alt="Subjects" width="200" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="assets/readme/evaluation.png" alt="Assessments" width="200" />
</p>

### Subject & Assessment Management
Manage subjects and assessments for a specific class.  
This allows organizing class content and tracking student performance efficiently.

<p align="center">
  <img src="assets/readme/note.png" alt="Add Grade" width="200" />
</p>

### Adding a Student’s Grade
Teachers can add grades for students by selecting the subject and semester, entering the score, and adding comments.  
Once validated, the grade is saved to track academic performance efficiently.

<p align="center">
  <img src="assets/readme/info_eleve.png" alt="Student Info" width="200" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img src="assets/readme/info_eleve2.png" alt="Student Grades" width="200" />
</p>

### Student Details Page
Displays a student’s grades and information.  
- The student’s name appears at the top.  
- A table lists subjects with corresponding grades, with icons to edit or delete grades.  
- A selector allows choosing the assessment, and a floating action button lets users add new grades.

<p align="center">
  <img src="assets/readme/School results.png" alt="Class Results Dashboard" width="200" />
</p>

### Class Results Management
Provides an interface to manage academic results of different classes:  

- **View general class information:**  
  - Number of subjects  
  - Current school year  
  - Total number of students  

- **Access class-specific management:**  
  - View or modify subjects, assessments, or students’ results  

This page serves as a dashboard to navigate school data by class level.

<p align="center">
  <img src="assets/readme/class result.png" alt="Class Results" width="200" />
</p>

### Student Results Management
Features include:

- Displaying general class information: subjects, school year, and total students  
- Listing students by number and full name  

<p align="center">
  <img src="assets/readme/eleve result.png" alt="Student Results" width="200" />
</p>

### Student Grade Chart
Displays a student’s detailed academic performance:  
- Grades per subject  
- Overall average and class rank  
- Visual chart for strengths and weaknesses  
- Option to generate a PDF report for sharing or printing

<p align="center">
  <img src="assets/readme/search page.png" alt="Student Search" width="200" />
</p>

### Student Search Page
Allows searching for students by name, ID, or other criteria.  
Search results are displayed in a clear list for easy selection and access to detailed information.

<p align="center">
  <img src="assets/readme/memo section.png" alt="Notes / Memo" width="200" />
</p>

### Notes / Memo Page
Allows users to create, view, and manage notes or memos.  
Users can quickly add, edit, or delete notes, keeping all information organized and easily accessible.

<p align="center">
  <img src="assets/readme/file share.png" alt="Data Import & Export" width="200" />
</p>

### Data Import & Export Page
Enables users to import or export data files easily.  
Users can upload files to update the system or download data for backup, sharing, or offline use.  
The interface ensures smooth and secure data management.

<p align="center">
  <img src="assets/readme/help page.png" alt="Help Page" width="200" />
</p>

### Application Help Page
Provides guidance on using the application, including instructions, tips, and explanations of features.  
Users can quickly find answers to common questions and navigate the app efficiently.
