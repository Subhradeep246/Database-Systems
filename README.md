# Airline Flight Search Web Application

A Python Flask-based web application for searching and viewing flight information from an airline database. This application allows users to search for flights by origin, destination, and date range, and view detailed seat availability information.

## Features

✈️ **Flight Search**
- Search flights by source and destination airport codes
- Specify a continuous date range for departures
- View all available flights with key information

📊 **Flight Details**
- View detailed flight information including airline, aircraft type, and duration
- See real-time seat availability
- Visual seat map showing booked and available seats
- Occupancy rate calculation

🎨 **User-Friendly Interface**
- Modern, responsive web design
- Intuitive navigation between search and results
- Real-time availability status badges
- Mobile-friendly layout

## Prerequisites

- Python 3.8 or higher
- PostgreSQL database with pgAdmin 4
- The airline database from the previous homework assignment loaded

## Installation

### 1. Clone or Download the Project

```bash
cd /path/to/DBHW3Q1
```

### 2. Create a Virtual Environment

```bash
# On Windows
python -m venv venv
venv\Scripts\activate

# On macOS/Linux
python3 -m venv venv
source venv/bin/activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure Database Connection

Edit the `DB_CONFIG` in `app.py` with your PostgreSQL credentials:

```python
DB_CONFIG = {
    'host': 'localhost',
    'database': 'postgres',
    'user': 'postgres',
    'password': 'your_password',  # Change to your pgAdmin password
    'port': 5432
}
```

### 5. Load the Database

Make sure the airline database schema and data from `airline.sql` are loaded into PostgreSQL:

```bash
# Using pgAdmin 4: Open the database, select "Query Tool", and run the airline.sql file
# OR using psql command line:
psql -U postgres -d postgres -f airline.sql
```

## Running the Application

### 1. Start the Flask Application

```bash
python app.py
```

You should see output similar to:
```
 * Serving Flask app 'app'
 * Debug mode: on
 * Running on http://localhost:5000
```

### 2. Open in Web Browser

Navigate to: `http://localhost:5000`

## Usage

### Step 1: Search Flights
1. On the main page, select your origin airport from the dropdown
2. Select your destination airport from the dropdown
3. Choose the start date for your search
4. Choose the end date for your search
5. Click "Search Flights"

### Step 2: View Results
- The application will display all available flights matching your criteria
- Each flight card shows:
  - Flight number and airline name
  - Route (Origin → Destination)
  - Departure time
  - Aircraft type
  - Availability status (Available, Limited, or Full)
  - Number of available seats

### Step 3: View Flight Details
- Click "View Details" on any flight to see:
  - Complete flight information
  - Route details and flight duration
  - Seat availability metrics
  - Visual seat map showing which seats are booked
  - Occupancy rate percentage

## Project Structure

```
DBHW3Q1/
├── app.py                 # Flask application and API endpoints
├── requirements.txt       # Python dependencies
├── airline.sql           # Database schema and data
├── templates/
│   └── index.html        # Main HTML template
└── static/
    ├── style.css         # CSS styling
    └── script.js         # JavaScript for frontend interactions
```

## API Endpoints

### GET `/`
Returns the main search page with all airport options.

### POST `/api/search-flights`
Searches for flights based on criteria.

**Request Body:**
```json
{
    "origin": "JFK",
    "destination": "LAX",
    "start_date": "2025-12-29",
    "end_date": "2025-12-31"
}
```

**Response:**
```json
{
    "flights": [
        {
            "flight_number": "AA101",
            "departure_date": "2025-12-29",
            "origin_code": "JFK",
            "dest_code": "LAX",
            "departure_time": "08:00:00",
            "airline_name": "American Airlines",
            "plane_type": "Boeing 737",
            "capacity": 20,
            "booked_seats": 5,
            "available_seats": 15
        }
    ]
}
```

### GET `/api/flight-details/<flight_number>/<departure_date>`
Returns detailed information about a specific flight.

**Response:**
```json
{
    "flight_number": "AA101",
    "departure_date": "2025-12-29",
    "origin_code": "JFK",
    "dest_code": "LAX",
    "departure_time": "08:00:00",
    "airline_name": "American Airlines",
    "plane_type": "Boeing 737",
    "capacity": 20,
    "booked_seats": 5,
    "available_seats": 15,
    "duration": "3 hours 30 minutes",
    "booked_seat_numbers": [1, 2, 3, 4, 5]
}
```

## Database Schema

The application uses the following tables from the airline database:

- **Airport**: Airport information with codes, names, cities, and countries
- **Aircraft**: Plane types and their capacities
- **FlightService**: Flight information including airline, route, and times
- **Flight**: Specific flights with dates and aircraft assignments
- **Booking**: Passenger bookings and seat assignments

## Testing with Sample Data

The `airline.sql` file includes sample data for testing:
- 12 airports across multiple countries
- 4 aircraft types with different capacities (10-25 seats)
- 10 flight services
- 12 specific flights scheduled between Dec 29-31, 2025
- 25 sample passengers
- Various booking scenarios (full, partial, and empty flights)

### Sample Searches to Try:
1. **JFK to LAX** (Dec 29-31): Shows American Airlines flights with varying occupancy
2. **SFO to ORD** (Dec 31): Shows United Airlines cross-country flight
3. **ATL to MIA** (Dec 30-31): Shows Delta Air Lines short-haul flight

## Features Implemented

✅ **Requirement A**: Search form with airport codes and continuous date range  
✅ **Requirement B**: Display all available flights with required information  
✅ **Requirement C**: Click-to-view flight details with seat availability and capacity  

## Troubleshooting

### Database Connection Error
- Verify PostgreSQL is running
- Check your username and password in `DB_CONFIG`
- Ensure the airline database is loaded into PostgreSQL

### Port Already in Use
If port 5000 is already in use, modify `app.py`:
```python
app.run(debug=True, host='localhost', port=5001)  # Change to different port
```

### No Flights Found
- Verify the date range covers dates with flights in the database
- Check that airports exist in the database
- Use the sample dates: 2025-12-29 to 2025-12-31

## Browser Compatibility

- Chrome/Edge (recommended)
- Firefox
- Safari
- Mobile browsers (responsive design)

## Development Notes

- Debug mode is enabled by default. For production, set `debug=False` in `app.py`
- The application logs all database queries for debugging
- Frontend uses vanilla JavaScript (no external JS frameworks required beyond Flask)

## Demo Preparation

Before your TA demo:
1. Ensure PostgreSQL and pgAdmin 4 are running
2. Verify the airline database is properly loaded
3. Start the Flask application
4. Test with the sample searches listed above
5. Be prepared to show modifications to the database during the demo

## Assignment Submission

Submit the link to your GitHub repository containing:
- `app.py` - Flask application
- `templates/index.html` - HTML template
- `static/style.css` - CSS styling
- `static/script.js` - JavaScript functionality
- `requirements.txt` - Python dependencies
- `airline.sql` - Database schema and data
- `README.md` - This documentation (or your own version)
- `.gitignore` - Include `venv/`, `__pycache__/`, `.pyc` files

## Author

Created for CS 6083 - Database Systems, Spring 2026

## License

Educational use only
