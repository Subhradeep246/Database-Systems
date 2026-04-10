# File Structure & Explanation

## What I've Built For You

A complete Python Flask web application that fulfills all three requirements for your database homework:

### ✅ Requirement A: Search Form
- Start page with dropdown selectors for source/destination airports
- Date range picker for continuous date selection
- Submit button to trigger flight search

### ✅ Requirement B: Flight Display
- Results page showing all matching flights
- Displays: flight number, departure date, origin code, destination code, departure time
- Additional info: airline name, aircraft type, availability status
- Color-coded availability badges (Available/Limited/Full)

### ✅ Requirement C: Flight Details
- Click "View Details" to see detailed flight information
- Shows: number of available seats, plane capacity
- Visual seat map with color-coded seats (booked vs. available)
- Occupancy rate and booking statistics

## File Structure

```
DBHW3Q1/
│
├── app.py                  # Main Flask application with all API routes
├── config.py               # Database configuration (edit with your credentials)
├── requirements.txt        # Python dependencies
├── airline.sql             # Database schema and sample data
│
├── README.md               # Complete documentation
├── QUICKSTART.md          # Fast setup guide
├── FILE_STRUCTURE.md      # This file
├── .gitignore             # Git ignore file
│
├── templates/
│   └── index.html         # Single HTML page with all UI
│
└── static/
    ├── style.css          # Professional CSS styling
    └── script.js          # Frontend JavaScript logic
```

## Key Technologies Used

- **Backend**: Flask (Python web framework)
- **Database**: PostgreSQL (your existing database)
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Connection**: psycopg2 (PostgreSQL adapter)

## How It Works

### 1. User Searches Flights (Frontend)
- User selects origin/destination airports and date range
- JavaScript sends POST request to `/api/search-flights`

### 2. Backend Queries Database (Flask)
```python
@app.route('/api/search-flights', methods=['POST'])
def search_flights():
    # Validates input
    # Queries database for matching flights
    # Calculates available seats
    # Returns JSON response
```

### 3. Results Displayed (Frontend)
- JavaScript receives flight data
- Creates flight card for each result
- Shows key information and availability status

### 4. User Sees Details (Frontend)
- Clicks "View Details" button
- JavaScript requests `/api/flight-details/<flight_number>/<date>`
- Shows seat map, capacity, occupancy rate

### 5. Backend Provides Details
```python
@app.route('/api/flight-details/<flight_number>/<departure_date>')
def get_flight_details(flight_number, departure_date):
    # Fetches flight information
    # Calculations: booked seats, available seats
    # Lists all booked seat numbers
    # Returns complete flight details as JSON
```

## API Endpoints Explained

### POST `/api/search-flights`
**Purpose**: Search for flights by route and date
**Input**: 
```json
{
    "origin": "JFK",
    "destination": "LAX", 
    "start_date": "2025-12-29",
    "end_date": "2025-12-31"
}
```
**Output**: List of flights with basic info and availability

### GET `/api/flight-details/<flight_number>/<departure_date>`
**Purpose**: Get detailed information for a specific flight
**Output**: Complete flight details including seat map

## Database Queries Used

The application uses these main queries:

1. **Airport List** - Load all airports for dropdowns
```sql
SELECT airport_code, name, city FROM airport
```

2. **Flight Search** - Find matching flights with seat counts
```sql
SELECT fs.flight_number, f.departure_date, fs.departure_time, 
       fs.origin_code, fs.dest_code, ac.capacity,
       COUNT(b.pid) as booked_seats
FROM flight f
JOIN flightservice fs ON f.flight_number = fs.flight_number
JOIN aircraft ac ON f.plane_type = ac.plane_type
LEFT JOIN booking b ON f.flight_number = b.flight_number 
WHERE fs.origin_code = ? AND fs.dest_code = ?
  AND f.departure_date BETWEEN ? AND ?
GROUP BY f.flight_number, f.departure_date, ...
```

3. **Booking Details** - Get list of booked seats for a specific flight
```sql
SELECT DISTINCT seat_number FROM booking
WHERE flight_number = ? AND departure_date = ?
ORDER BY seat_number
```

## Frontend Components

### index.html
- **Search Form Section**: Airport dropdowns, date pickers, search button
- **Results Section**: List of matching flights
- **Details Section**: Flight details with seat map
- **Error Section**: Error message display

### style.css
- Modern gradient background
- Card-based layout for flights
- Responsive grid system
- Color-coded availability status
- Mobile-friendly design
- Smooth animations and transitions

### script.js
- Form validation and submission
- AJAX requests to backend API
- Dynamic HTML generation
- Date range validation
- Error handling and display

## Configuration Notes

### In `app.py`, update DB_CONFIG:
```python
DB_CONFIG = {
    'host': 'localhost',           # Your PostgreSQL host
    'database': 'postgres',        # Change to your database name
    'user': 'postgres',            # Your PostgreSQL user
    'password': 'password',        # Your PostgreSQL password
    'port': 5432                   # PostgreSQL port (usually 5432)
}
```

### Or use `config.py`:
Edit the `config.py` file with your database credentials. You can then import it in app.py:
```python
from config import DB_CONFIG
```

## Sample Test Data

The `airline.sql` file includes:
- **12 Airports**: JFK, LAX, ORD, MDW, LHR, CDG, ORY, SFO, MIA, ATL, NRT, SIN
- **4 Aircraft**: CRJ-200 (10 seats), Boeing 737 (20), Airbus A320 (15), Boeing 787 (25)
- **10 Flight Services**: American, United, Delta, British Airways, Air France, Singapore Airlines
- **12 Scheduled Flights**: Dates between 2025-12-29 and 2025-12-31
- **25 Passengers**: Sample passenger data
- **Various Bookings**: Different occupancy levels (empty, partial, full)

### Test Searches:
1. **JFK → LAX** (12/29-12/31): Multiple American Airlines flights with varying bookings
2. **SFO → ORD** (12/31): Fully booked United flight
3. **ATL → MIA** (12/31): Partially booked Delta flight  
4. **ORD → MIA** (12/31): Mostly booked American flight

## Running the Application

### Step-by-Step:
1. Install Python dependencies: `pip install -r requirements.txt`
2. Update database credentials in `app.py`
3. Load database: Run `airline.sql` in pgAdmin 4
4. Start Flask app: `python app.py`
5. Open browser: `http://localhost:5000`

### For Your TA Demo:
- Show flight search functionality
- Display results with various filters
- Click on flights to show seat details
- Be prepared to modify database live during demo
- Have sample queries ready to show

## Customization Tips

### To Change Styling:
Edit `static/style.css` - Main sections:
- Color scheme: Look for `#667eea` (primary purple)
- Font sizes: Search for `font-size` values
- Layout: Grid and flexbox properties

### To Add More Information:
Edit `app.py` route and `templates/index.html`:
- Modify SQL queries to fetch more data
- Add new fields to results display
- Update JavaScript to handle new data

### To Change Port:
In `app.py`, change:
```python
app.run(debug=True, host='localhost', port=5000)  # Change 5000 to another number
```

## Troubleshooting Guide

| Problem | Cause | Solution |
|---------|-------|----------|
| `psycopg2.OperationalError` | Database connection failed | Check DB_CONFIG credentials in app.py |
| No search results | Wrong dates or airport codes | Use sample dates (12/29-12/31) and airport codes from the database |
| `ModuleNotFoundError: No module named 'flask'` | Dependencies not installed | Run `pip install -r requirements.txt` |
| Port 5000 already in use | Another application using port | Change port in app.py or stop other apps |
| "No such file or directory" for templates | Wrong folder structure | Ensure `templates/` and `static/` folders exist |

## Security Notes (For Production)

Before deploying publicly:
1. Set `debug=False` in app.py
2. Generate a strong `SECRET_KEY`
3. Use environment variables for credentials (not hardcoded)
4. Add input validation and SQL injection prevention
5. Use HTTPS instead of HTTP
6. Add user authentication if needed

## For GitHub Submission

Create repository with:
```
✅ app.py
✅ requirements.txt
✅ airline.sql
✅ templates/index.html
✅ static/style.css
✅ static/script.js
✅ README.md
✅ QUICKSTART.md
✅ config.py
✅ .gitignore
❌ venv/ (excluded by .gitignore)
```

Share the GitHub link with your TA for grading.

## Support for Demo

Be prepared to:
- Run queries against the live database
- Add/remove passengers and bookings
- Refresh the web page to see changes
- Demonstrate all three features (search, results, details)
- Show error handling for invalid inputs

Good luck with your assignment! 🎓
