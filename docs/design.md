# API Design Document

## Technology Stack
- **Framework:** Ruby on Rails (API-only)
- **Database:** MySQL
- **Authentication:** JWT (JSON Web Tokens)

---

## Database Schema

### Users

| Column | Type | Details |
|--------|------|---------|
| id | bigint | Primary Key, Auto Increment |
| email | string | Unique, Not Null |
| encrypted_password | string | Not Null |
| name | string | |
| role | enum (user, admin) | Default: user |
| created_at | datetime | Auto-generated |
| updated_at | datetime | Auto-generated |

---

## API Endpoints

### Authentication

- **POST** `/api/register`
  - **Params:** `email`, `password`, `name`
  - **Response:** JWT Token, User info

- **POST** `/api/login`
  - **Params:** `email`, `password`
  - **Response:** JWT Token, User info

---

### User Profile Management

- **GET** `/api/profile`
  - **Auth Required:** User JWT
  - **Response:** User profile information

- **PUT** `/api/profile`
  - **Auth Required:** User JWT
  - **Params:** `name`, `email`, optionally `password`
  - **Response:** Updated user profile

---

### Admin User Management

- **GET** `/api/admin/users`
  - **Auth Required:** Admin JWT
  - **Response:** List of all users

- **GET** `/api/admin/users/:id`
  - **Auth Required:** Admin JWT
  - **Response:** User details

- **PUT** `/api/admin/users/:id`
  - **Auth Required:** Admin JWT
  - **Params:** `name`, `email`, `role`
  - **Response:** Updated user details

- **DELETE** `/api/admin/users/:id`
  - **Auth Required:** Admin JWT
  - **Response:** Success message

---

## JWT Authentication
- Use JWT Bearer Token authentication
- Tokens include payload with user id and role
- Token expiration: 24 hours
- Secure endpoints by checking roles (`user` or `admin`) on each request

---

## HTTP Status Codes
- `200 OK` – Success
- `201 Created` – Resource created
- `400 Bad Request` – Validation error
- `401 Unauthorized` – Authentication failure
- `403 Forbidden` – Access denied
- `404 Not Found` – Resource not found
- `422 Unprocessable Entity` – Data processing errors
- `500 Internal Server Error` – Server errors

---

## Example Response

```json
{
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "John Doe",
    "role": "user",
    "created_at": "2025-03-23T10:00:00Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

## Development Guidelines

- Follow RESTful conventions strictly
- Write comprehensive unit tests for each endpoint
- Implement logging and error handling consistently
- Adhere to Rails best practices, utilizing concerns and service objects to keep controllers clean

This document provides everything needed for developers to start coding the described API service immediately.

