# CS 6083 – Problem Set #3 · Q1: Airline Web Application

A Flask web app that provides a browser-based front-end for the Airline PostgreSQL database.

---

## Features

| Part | What it does |
|------|-------------|
| **(a) Search Form** | Select origin & destination from dropdowns, pick a date range, click Search |
| **(b) Flight List** | Displays all matching flights (flight #, airline, date, origin, destination, departure time, duration, aircraft, availability badge + mini progress bar) |
| **(c) Flight Detail** | Click any flight to see capacity, booked seats, available seats, occupancy bar, and a full visual seat map |

---

## Prerequisites

- Python 3.8+
- PostgreSQL running locally (pgAdmin 4)
- The airline schema and data already loaded (`airline.sql`)

---

## Setup

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Edit DB credentials in app.py (lines 10-15)
#    Change dbname / user / password to match your pgAdmin setup

# 3. Run the app
python app.py
```

Then open **http://localhost:5000** in your browser.

---

## Database Connection (app.py lines 10-15)

```python
def get_db():
    return psycopg2.connect(
        host="localhost",
        port=5432,
        dbname="Airline",    # ← your DB name
        user="postgres",     # ← your PostgreSQL username
        password="postgres"  # ← your PostgreSQL password
    )
```

> **Note:** Update the `host`, `port`, `user`, and `password` values to match your PostgreSQL setup. The `dbname` should be `"Airline"` if using the provided schema.

---

## Project Structure

```
airline_app/
├── app.py                   # Flask routes + SQL queries
├── requirements.txt
├── README.md
└── templates/
    ├── base.html            # Shared layout / CSS
    ├── index.html           # (a) Search form
    ├── flights.html         # (b) Flight results table
    ├── flight_detail.html   # (c) Seat availability + seat map
    └── error.html           # Error page
```

---

## URL Routes

| Route | Description |
|-------|-------------|
| `GET /` | Search form (part a) |
| `GET /flights?origin=JFK&destination=LAX&date_from=2026-04-10&date_to=2026-04-12` | Flight results (part b) |
| `GET /flight/<flight_number>/<date>` | Seat detail for one flight (part c) |

---

## Sample Test Data

Try searching:
- **JFK → LAX**, date range `2026-04-10` to `2026-04-12` — finds AA101, AA205
- **ATL → MIA**, date `2026-04-12` — finds DL410 (almost full!)
- **SFO → ORD**, date `2026-04-12` — finds UA302 (fully booked)
