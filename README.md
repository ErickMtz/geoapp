# Geolocation API with External Integration
This project provides a simple API for managing geolocation data, backed by a PostgreSQL database, and integrated with an external geolocation service provider, ipstack. With this API, you can add, delete, and retrieve geolocation data based on IP addresses or URLs.

## Features:
Database Backed: Utilizes PostgreSQL database for storing geolocation data.
External Integration: Integrates with ipstack to fetch geolocation data.
CRUD Operations: Supports basic CRUD operations (Create, Read, Delete) for managing geolocation data.
Authentication: Utilizes JWT authentication.

## API Endpoints:
POST `/authenticate`: to obtain JWT token by providing email and password. A seed user is provided with email: `user@example.com` and password: `password`.\
GET `/api/v1/geolocations`: to list all stored geolocations.\
GET `/api/v1/geolocations/:ip`: to show a specific geolocation.\
DELETE `/api/v1/geolocations/:ip`: to remove a geolocation.\
POST `/api/v1/geolocations`: to return an existing geolocation or create a new geolocation with the given data returned by the external service provider.

## Setup Instructions with Docker:
1. Clone the repository.
2. Navigate to the project directory.
3. Run the following commands:

```bash
docker-compose build
```
```bash
docker-compose up
```

Access the API at http://localhost:{PORT}.

## Usage:
1. Fetch JWT Token:
    - Make a POST request to `/authenticate` with `email` and `password` to obtain a JWT token.
2. Access Geolocation Endpoints:
    - Use the obtained token in the Authorization header for making requests to `/api/v1/geolocations`.
    - Available actions: `index`, `show`, `create`, `delete`.
    - `show` and `delete` endpoints accept an IP parameter.
    - `create` endpoint accepts an `IP` parameter and finds or creates a geolocation object.
  
## Example:
- To fetch geolocation data for a specific IP:
  ```bash
  GET /api/v1/geolocations/:ip
  ```
- To add geolocation data for a new IP:
  ```bash
  POST /api/v1/geolocations
  ```
  Requests body:
  ```json
  {
      "geolocation": {
          "ip": "8.8.8.8"
      }
  }
  ```

