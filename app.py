"""
Airline Flight Search Web Application
Flask-based frontend for querying flight information
"""

from flask import Flask, render_template, request, jsonify
import psycopg2
from datetime import datetime, timedelta
import os

app = Flask(__name__)

# Database configuration
DB_CONFIG = {
    'host': 'localhost',
    'database': 'Airline',
    'user': 'postgres',
    'password': 'Subhradeep@123',  # Change this to your pgAdmin password
    'port': 5432
}

def get_db_connection():
    """Create and return a database connection"""
    conn = psycopg2.connect(**DB_CONFIG)
    return conn

@app.route('/')
def index():
    """Display the main search page"""
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Get all airport codes for the dropdown
    cur.execute("""
        SELECT airport_code, name, city 
        FROM airport 
        ORDER BY airport_code
    """)
    airports = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return render_template('index.html', airports=airports)

@app.route('/api/search-flights', methods=['POST'])
def search_flights():
    """Search for flights based on origin, destination, and date range"""
    data = request.json
    origin = data.get('origin', '').upper()
    destination = data.get('destination', '').upper()
    start_date = data.get('start_date')
    end_date = data.get('end_date')
    
    # Validation
    if not origin or not destination or not start_date or not end_date:
        return jsonify({'error': 'All fields are required'}), 400
    
    if origin == destination:
        return jsonify({'error': 'Origin and destination must be different'}), 400
    
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        # Query to get flights matching the criteria
        query = """
            SELECT 
                fs.flight_number,
                f.departure_date,
                fs.origin_code,
                fs.dest_code,
                fs.departure_time,
                fs.airline_name,
                f.plane_type,
                ac.capacity,
                COALESCE(COUNT(b.pid), 0) as booked_seats
            FROM flight f
            JOIN flightservice fs ON f.flight_number = fs.flight_number
            JOIN aircraft ac ON f.plane_type = ac.plane_type
            LEFT JOIN booking b ON f.flight_number = b.flight_number 
                AND f.departure_date = b.departure_date
            WHERE fs.origin_code = %s 
                AND fs.dest_code = %s
                AND f.departure_date >= %s
                AND f.departure_date <= %s
            GROUP BY 
                fs.flight_number, 
                f.departure_date, 
                fs.origin_code, 
                fs.dest_code, 
                fs.departure_time,
                fs.airline_name,
                f.plane_type,
                ac.capacity
            ORDER BY f.departure_date, fs.departure_time
        """
        
        cur.execute(query, (origin, destination, start_date, end_date))
        flights = cur.fetchall()
        
        cur.close()
        conn.close()
        
        # Format results
        result = []
        for flight in flights:
            available_seats = flight[7] - flight[8]  # capacity - booked_seats
            result.append({
                'flight_number': flight[0],
                'departure_date': flight[1].isoformat() if flight[1] else None,
                'origin_code': flight[2],
                'dest_code': flight[3],
                'departure_time': str(flight[4]) if flight[4] else None,
                'airline_name': flight[5],
                'plane_type': flight[6],
                'capacity': flight[7],
                'booked_seats': flight[8],
                'available_seats': available_seats
            })
        
        if not result:
            return jsonify({'flights': [], 'message': 'No flights found'}), 200
        
        return jsonify({'flights': result}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/flight-details/<flight_number>/<departure_date>')
def get_flight_details(flight_number, departure_date):
    """Get detailed information about a specific flight"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        # Get flight details
        query = """
            SELECT 
                fs.flight_number,
                f.departure_date,
                fs.origin_code,
                fs.dest_code,
                fs.departure_time,
                fs.airline_name,
                f.plane_type,
                ac.capacity,
                COALESCE(COUNT(b.pid), 0) as booked_seats,
                fs.duration
            FROM flight f
            JOIN flightservice fs ON f.flight_number = fs.flight_number
            JOIN aircraft ac ON f.plane_type = ac.plane_type
            LEFT JOIN booking b ON f.flight_number = b.flight_number 
                AND f.departure_date = b.departure_date
            WHERE fs.flight_number = %s AND f.departure_date = %s
            GROUP BY 
                fs.flight_number, 
                f.departure_date, 
                fs.origin_code, 
                fs.dest_code, 
                fs.departure_time,
                fs.airline_name,
                f.plane_type,
                ac.capacity,
                fs.duration
        """
        
        cur.execute(query, (flight_number, departure_date))
        flight = cur.fetchone()
        
        if not flight:
            cur.close()
            conn.close()
            return jsonify({'error': 'Flight not found'}), 404
        
        available_seats = flight[7] - flight[8]  # capacity - booked_seats
        
        # Get passenger list (booked seats)
        cur.execute("""
            SELECT DISTINCT seat_number 
            FROM booking 
            WHERE flight_number = %s AND departure_date = %s
            ORDER BY seat_number
        """, (flight_number, departure_date))
        
        booked_seat_numbers = [row[0] for row in cur.fetchall()]
        
        cur.close()
        conn.close()
        
        result = {
            'flight_number': flight[0],
            'departure_date': flight[1].isoformat() if flight[1] else None,
            'origin_code': flight[2],
            'dest_code': flight[3],
            'departure_time': str(flight[4]) if flight[4] else None,
            'airline_name': flight[5],
            'plane_type': flight[6],
            'capacity': flight[7],
            'booked_seats': flight[8],
            'available_seats': available_seats,
            'duration': str(flight[9]) if flight[9] else None,
            'booked_seat_numbers': booked_seat_numbers
        }
        
        return jsonify(result), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='localhost', port=5000)
