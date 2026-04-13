from flask import Flask, render_template, request, redirect, url_for
import psycopg2
import psycopg2.extras
from datetime import date

app = Flask(__name__)

# ── DB connection ──────────────────────────────────────────────────────────────
def get_db():
    return psycopg2.connect(
        host="localhost",
        port=5432,
        dbname="Airline",   
        user="postgres",
        password="postgres"      
    )


# ── (a) Start page ─────────────────────────────────────────────────────────────
@app.route("/", methods=["GET"])
def index():
    conn = get_db()
    cur  = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    # Populate airport dropdowns from DB
    cur.execute("SELECT airport_code, name, city, country FROM Airport ORDER BY airport_code")
    airports = cur.fetchall()

    cur.close()
    conn.close()
    return render_template("index.html", airports=airports, today=date.today().isoformat())


# ── (b) Search results ─────────────────────────────────────────────────────────
@app.route("/flights", methods=["GET"])
def search_flights():
    origin      = request.args.get("origin", "").strip().upper()
    destination = request.args.get("destination", "").strip().upper()
    date_from   = request.args.get("date_from", "")
    date_to     = request.args.get("date_to", "")

    errors = []
    if not origin:      errors.append("Origin airport code is required.")
    if not destination: errors.append("Destination airport code is required.")
    if not date_from:   errors.append("Start date is required.")
    if not date_to:     errors.append("End date is required.")
    if date_from and date_to and date_from > date_to:
        errors.append("Start date must be on or before the end date.")

    if errors:
        conn = get_db()
        cur  = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cur.execute("SELECT airport_code, name, city, country FROM Airport ORDER BY airport_code")
        airports = cur.fetchall()
        cur.close(); conn.close()
        return render_template("index.html", airports=airports,
                               today=date.today().isoformat(), errors=errors,
                               origin=origin, destination=destination,
                               date_from=date_from, date_to=date_to)

    conn = get_db()
    cur  = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    query = """
        SELECT
            f.flight_number,
            f.departure_date,
            fs.airline_name,
            fs.origin_code,
            oa.name        AS origin_name,
            oa.city        AS origin_city,
            fs.dest_code,
            da.name        AS dest_name,
            da.city        AS dest_city,
            fs.departure_time,
            fs.duration,
            f.plane_type,
            ac.capacity,
            COUNT(b.pid)   AS booked_seats,
            ac.capacity - COUNT(b.pid) AS available_seats
        FROM Flight f
        JOIN FlightService fs ON f.flight_number = fs.flight_number
        JOIN Airport       oa ON fs.origin_code  = oa.airport_code
        JOIN Airport       da ON fs.dest_code    = da.airport_code
        JOIN Aircraft      ac ON f.plane_type    = ac.plane_type
        LEFT JOIN Booking  b  ON f.flight_number = b.flight_number
                              AND f.departure_date = b.departure_date
        WHERE fs.origin_code = %s
          AND fs.dest_code   = %s
          AND f.departure_date BETWEEN %s AND %s
        GROUP BY
            f.flight_number, f.departure_date,
            fs.airline_name, fs.origin_code, oa.name, oa.city,
            fs.dest_code, da.name, da.city,
            fs.departure_time, fs.duration,
            f.plane_type, ac.capacity
        ORDER BY f.departure_date, fs.departure_time
    """
    cur.execute(query, (origin, destination, date_from, date_to))
    flights = cur.fetchall()
    cur.close(); conn.close()

    return render_template("flights.html",
                           flights=flights,
                           origin=origin, destination=destination,
                           date_from=date_from, date_to=date_to)


# ── (c) Flight detail – seat availability ──────────────────────────────────────
@app.route("/flight/<flight_number>/<departure_date>")
def flight_detail(flight_number, departure_date):
    conn = get_db()
    cur  = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    # Core flight info + capacity / bookings
    cur.execute("""
        SELECT
            f.flight_number,
            f.departure_date,
            fs.airline_name,
            fs.origin_code,
            oa.name        AS origin_name,
            oa.city        AS origin_city,
            fs.dest_code,
            da.name        AS dest_name,
            da.city        AS dest_city,
            fs.departure_time,
            fs.duration,
            f.plane_type,
            ac.capacity,
            COUNT(b.pid)                   AS booked_seats,
            ac.capacity - COUNT(b.pid)     AS available_seats
        FROM Flight f
        JOIN FlightService fs ON f.flight_number = fs.flight_number
        JOIN Airport       oa ON fs.origin_code  = oa.airport_code
        JOIN Airport       da ON fs.dest_code    = da.airport_code
        JOIN Aircraft      ac ON f.plane_type    = ac.plane_type
        LEFT JOIN Booking  b  ON f.flight_number = b.flight_number
                              AND f.departure_date = b.departure_date
        WHERE f.flight_number  = %s
          AND f.departure_date = %s::DATE
        GROUP BY
            f.flight_number, f.departure_date,
            fs.airline_name, fs.origin_code, oa.name, oa.city,
            fs.dest_code, da.name, da.city,
            fs.departure_time, fs.duration,
            f.plane_type, ac.capacity
    """, (flight_number, departure_date))
    flight = cur.fetchone()

    # Seat map – which seats are taken
    cur.execute("""
        SELECT seat_number
        FROM Booking
        WHERE flight_number = %s AND departure_date = %s::DATE
        ORDER BY seat_number
    """, (flight_number, departure_date))
    booked_seats = {row["seat_number"] for row in cur.fetchall()}

    cur.close(); conn.close()

    if not flight:
        return render_template("error.html", message="Flight not found."), 404

    seat_map = []
    for seat in range(1, flight["capacity"] + 1):
        seat_map.append({"number": seat, "booked": seat in booked_seats})

    return render_template("flight_detail.html", flight=flight, seat_map=seat_map)


# ── Error handlers ─────────────────────────────────────────────────────────────
@app.errorhandler(404)
def not_found(e):
    return render_template("error.html", message="Page not found."), 404

@app.errorhandler(500)
def server_error(e):
    return render_template("error.html", message=f"Database error: {e}"), 500


if __name__ == "__main__":
    app.run(debug=True, port=5000)
