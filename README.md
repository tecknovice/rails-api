# Rails API - User Management System

A secure RESTful API for user management built with Ruby on Rails. This API provides authentication using JWT tokens and includes both user and admin functionality.

## Technology Stack

- **Framework:** Ruby on Rails 8.0.2 (API-only)
- **Database:** MySQL
- **Authentication:** JWT (JSON Web Tokens)
- **Ruby Version:** 3.4.1

## Prerequisites

Before you begin, ensure you have the following installed:

- Ruby 3.4.1 or higher
- Rails 8.0.2
- MySQL
- Bundler

## Installation

### 1. Clone the repository

```bash
git clone <repository-url>
cd rails-api
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Set up database

Update the database configuration in `config/database.yml` if needed, then run:

```bash
bin/rails db:create db:migrate db:seed
```

This will create the database, run migrations, and seed the database with sample data including an admin user and several regular users.

## Running the Application

```bash
bin/rails server
```

The API will be available at `http://localhost:3000`.

## API Documentation

### Authentication

#### Registration
```
POST /api/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

#### Login
```
POST /api/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

Both endpoints return a JWT token that must be included in the Authorization header for authenticated requests.

### User Profile Management

#### Get Profile
```
GET /api/profile
Authorization: <JWT Token>
```

#### Update Profile
```
PUT /api/profile
Authorization: <JWT Token>
Content-Type: application/json

{
  "name": "Updated Name",
  "email": "updated@example.com"
}
```

### Admin User Management

#### List All Users
```
GET /api/admin/users
Authorization: <Admin JWT Token>
```

#### Get Single User
```
GET /api/admin/users/:id
Authorization: <Admin JWT Token>
```

#### Update User
```
PUT /api/admin/users/:id
Authorization: <Admin JWT Token>
Content-Type: application/json

{
  "name": "Updated By Admin",
  "role": "user"
}
```

#### Delete User
```
DELETE /api/admin/users/:id
Authorization: <Admin JWT Token>
```

## Test Credentials

The seed data provides the following accounts for testing:

- **Admin:**
  - Email: admin@example.com
  - Password: password123

- **Regular User:**
  - Email: user1@example.com
  - Password: password123

## Examples Using Curl

### Login as Admin
```bash
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"password123"}'
```

### List Users (Admin Only)
```bash
curl -X GET http://localhost:3000/api/admin/users \
  -H "Authorization: <Admin JWT Token>" \
  -H "Content-Type: application/json"
```

## Running Tests

```bash
bin/rails test
```

## Security Features

- JWT token authentication
- Role-based access control
- Password encryption using BCrypt
- Token expiration (24 hours)

## License

This project is licensed under the MIT License.
