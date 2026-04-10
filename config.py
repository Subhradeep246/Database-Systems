"""
Database configuration file for the Airline Flight Search Application
Update these settings with your PostgreSQL credentials
"""

DB_CONFIG = {
    'host': 'localhost',           # PostgreSQL host address
    'database': 'postgres',        # Database name (change to your database)
    'user': 'postgres',            # PostgreSQL username
    'password': 'password',        # PostgreSQL password (change this!)
    'port': 5432                   # PostgreSQL port (default: 5432)
}

# Flask Application Settings
FLASK_ENV = 'development'          # Set to 'production' for deployment
DEBUG = True                       # Set to False for production
SECRET_KEY = 'your-secret-key-here'  # Change this for production

# Application Settings
APP_HOST = 'localhost'
APP_PORT = 5000
THREADS_PER_PAGE = 2
