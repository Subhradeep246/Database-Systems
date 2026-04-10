# Quick Start Guide

## Setup Instructions (Windows)

### 1. Prerequisites
- Python 3.8+ installed
- PostgreSQL with pgAdmin 4 running
- Git installed (for repository management)

### 2. Extract and Navigate
```bash
cd C:\Users\91742\Downloads\DBHW3Q1
```

### 3. Create Virtual Environment
```bash
python -m venv venv
venv\Scripts\activate
```

### 4. Install Dependencies
```bash
pip install -r requirements.txt
```

### 5. Database Setup in pgAdmin 4

1. Open pgAdmin 4
2. Right-click on "Databases" → Create → Database
3. Name it (e.g., "airline_db")
4. Right-click the new database → Query Tool
5. Open and run `airline.sql`
6. Execute the script (F5 or ▶ button)

### 6. Configure app.py

Update the DB_CONFIG section in app.py:
```python
DB_CONFIG = {
    'host': 'localhost',
    'database': 'airline_db',  # Your database name
    'user': 'postgres',
    'password': 'your_pgadmin_password',  # Your pgAdmin password
    'port': 5432
}
```

### 7. Run the Application
```bash
python app.py
```

### 8. Access the Application
Open your browser and go to: **http://localhost:5000**

## Usage Example

1. **Search**: 
   - From: JFK
   - To: LAX
   - Dates: 12/29/2025 to 12/31/2025
   - Click "Search Flights"

2. **View Results**: Click "View Details" on any flight

3. **See Details**: Scroll to see seat map and occupancy details

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Connection refused" error | Check PostgreSQL is running, verify credentials in app.py |
| No flights showing | Verify dates are 12/29/2025 to 12/31/2025 |
| Port 5000 already in use | Change port in app.py: `app.run(port=5001)` |
| Module not found errors | Verify venv is activated and run `pip install -r requirements.txt` again |

## File Organization

```
DBHW3Q1/
├── app.py                    ← Main Flask app
├── airline.sql              ← Database file
├── requirements.txt         ← Python packages
├── README.md                ← Full documentation
├── QUICKSTART.md           ← This file
├── templates/
│   └── index.html          ← Web page
└── static/
    ├── style.css           ← Styling
    └── script.js           ← Interactivity
```

## Deactivating Virtual Environment

When you're done:
```bash
deactivate
```

## Next Steps

- Create a GitHub repository
- Push all files except `/venv/` folder
- Share the repository link with your TA
- Be prepared to modify database during demo
