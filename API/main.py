

# REST API - CULTURAL LOOM
# File: main.py
# Framework: FastAPI
# Database: MySQL (cultural_loom)
# Author: Meriem MOUWAFFAK
# Project: RNCP Bloc 1 - Cultural Infrastructure Analysis
# Date: February 2026

import os
from typing import Optional, List, Dict, Any, Generator

import mysql.connector
from mysql.connector.pooling import MySQLConnectionPool

from fastapi import FastAPI, HTTPException, Query, Depends
from fastapi.middleware.cors import CORSMiddleware



# ─────────────────────────────────────────────────────────────
# FastAPI App Configuration
# ─────────────────────────────────────────────────────────────

app = FastAPI(
    title="Cultural Loom API",
    description="REST API for cultural accessibility analysis in France - RNCP Certification Project",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# CORS Configuration (Development)
ALLOWED_ORIGINS = os.getenv("ALLOWED_ORIGINS", "http://localhost:5173,http://localhost:3000").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=[o.strip() for o in ALLOWED_ORIGINS if o.strip()],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ─────────────────────────────────────────────────────────────
# Database Connection Pool
# ─────────────────────────────────────────────────────────────

POOL: Optional[MySQLConnectionPool] = None

def _env(name: str, default: Optional[str] = None) -> str:
    """Get environment variable with error handling"""
    v = os.getenv(name, default)
    if v is None or v == "":
        raise RuntimeError(f"Missing environment variable: {name}")
    return v

@app.on_event("startup")
def startup() -> None:
    """Initialize MySQL connection pool at startup"""
    global POOL
    try:
        POOL = MySQLConnectionPool(
            pool_name="cultural_loom_pool",
            pool_size=int(os.getenv("DB_POOL_SIZE", "10")),
            host=_env("DB_HOST", "localhost"),
            user=_env("DB_USER", "root"),
            password=_env("DB_PASSWORD", "Fabrique37Fabrique"),                   # Set in .env file
            database=_env("DB_NAME", "cultural_loom_v2"),
            autocommit=True,
        )
        print("[STARTUP] Database connection pool initialized")
    except Exception as e:
        print(f"[STARTUP] Failed to initialize DB pool: {e}")

def get_db_conn() -> Generator[mysql.connector.MySQLConnection, None, None]:
    """Dependency: provides pooled MySQL connection"""
    if POOL is None:
        raise HTTPException(status_code=500, detail="Database pool not initialized")
    
    conn = None
    try:
        conn = POOL.get_connection()
        yield conn
    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=f"Database error: {err}")
    finally:
        if conn is not None:
            try:
                conn.close()
            except Exception:
                pass

# ─────────────────────────────────────────────────────────────
# ENDPOINT 1: Root (API Information)
# ─────────────────────────────────────────────────────────────

@app.get("/", tags=["Info"])
def root() -> Dict[str, Any]:
    """
    API root endpoint - returns API information and available endpoints
    """
    return {
        "name": "Cultural Loom API",
        "version": "1.0.0",
        "description": "Analysis of cultural accessibility and territorial inequalities in France",
        "project": "RNCP Bloc 1 Certification - Data Analyst",
        "author": "Meriem MOUWAFFAK",
        "endpoints": {
            "/": "API information",
            "/venues": "List cultural venues (with filters)",
            "/communes": "List communes (with filters)",
            "/stats/commune/{commune_code}": "Statistics for specific commune",
            "/stats/density": "Top communes by cultural density",
            "/stats/dept/{dept_code}": "Department-level statistics",
            "/health": "Health check",
        },
        "documentation": {
            "swagger": "/docs",
            "redoc": "/redoc",
        },
    }

# ─────────────────────────────────────────────────────────────
# ENDPOINT 2: List Venues
# ─────────────────────────────────────────────────────────────

@app.get("/venues", tags=["Venues"])
def get_venues(
    limit: int = Query(default=100, ge=1, le=1000, description="Maximum number of results"),
    offset: int = Query(default=0, ge=0, le=100000, description="Pagination offset"),
    commune_code: Optional[str] = Query(default=None, description="Filter by commune INSEE code"),
    dept_code: Optional[str] = Query(default=None, description="Filter by department code"),
    venue_type: Optional[str] = Query(default=None, description="Filter by venue type (e.g., 'Conservatoire')"),
    conn: mysql.connector.MySQLConnection = Depends(get_db_conn),
) -> Dict[str, Any]:
    """
    Retrieve cultural venues with optional filters and pagination.
    
    **Business Logic:** Returns BASILIC cultural venues data with filtering capabilities
    for territorial analysis and venue type exploration.
    """
    cursor = conn.cursor(dictionary=True)
    try:
        # Base query
        query = """
            SELECT 
                id,
                nom AS name,
                type_equipement_ou_lieu AS venue_type,
                domaine AS cultural_domain,
                code_insee_norm AS commune_code,
                dept_code,
                region,
                latitude,
                longitude
            FROM cultural_venues
            WHERE 1=1
        """
        params: List[Any] = []
        
        # Apply filters
        if commune_code:
            query += " AND code_insee_norm = %s"
            params.append(commune_code)
        
        if dept_code:
            query += " AND dept_code = %s"
            params.append(dept_code)
        
        if venue_type:
            query += " AND type_equipement_ou_lieu LIKE %s"
            params.append(f"%{venue_type}%")
        
        # Pagination
        query += " LIMIT %s OFFSET %s"
        params.extend([limit, offset])
        
        cursor.execute(query, params)
        rows = cursor.fetchall()
        
        return {
            "count": len(rows),
            "limit": limit,
            "offset": offset,
            "filters": {
                "commune_code": commune_code,
                "dept_code": dept_code,
                "venue_type": venue_type
            },
            "venues": rows
        }
    finally:
        cursor.close()

# ─────────────────────────────────────────────────────────────
# ENDPOINT 3: List Communes
# ─────────────────────────────────────────────────────────────

@app.get("/communes", tags=["Communes"])
def get_communes(
    limit: int = Query(default=100, ge=1, le=1000, description="Maximum results"),
    offset: int = Query(default=0, ge=0, le=100000, description="Pagination offset"),
    dept_code: Optional[str] = Query(default=None, description="Filter by department"),
    region_code: Optional[str] = Query(default=None, description="Filter by region"),
    name_search: Optional[str] = Query(default=None, description="Search by commune name"),
    conn: mysql.connector.MySQLConnection = Depends(get_db_conn),
) -> Dict[str, Any]:
    """
    List French communes with filters.
    
    **Business Logic:** Provides commune reference data for territorial exploration
    before running detailed statistics queries.
    """
    cursor = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT 
                commune_code,
                commune_name,
                postal_code,
                dept_code,
                region_code,
                population
            FROM communes
            WHERE 1=1
        """
        params: List[Any] = []
        
        if dept_code:
            query += " AND dept_code = %s"
            params.append(dept_code)
        
        if region_code:
            query += " AND region_code = %s"
            params.append(region_code)
        
        if name_search:
            query += " AND commune_name LIKE %s"
            params.append(f"%{name_search}%")
        
        query += " LIMIT %s OFFSET %s"
        params.extend([limit, offset])
        
        cursor.execute(query, params)
        rows = cursor.fetchall()
        
        return {
            "count": len(rows),
            "limit": limit,
            "offset": offset,
            "communes": rows
        }
    finally:
        cursor.close()

# ─────────────────────────────────────────────────────────────
# ENDPOINT 4: Commune Statistics
# ─────────────────────────────────────────────────────────────

@app.get("/stats/commune/{commune_code}", tags=["Statistics"])
def get_commune_stats(
    commune_code: str,
    conn: mysql.connector.MySQLConnection = Depends(get_db_conn),
) -> Dict[str, Any]:
    """
    Get comprehensive statistics for a specific commune.
    
    **Business Logic:** Joins venues + population + income data to produce
    a complete commune profile (venue count, density, socio-economic context).
    """
    cursor = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT
                c.commune_code,
                c.commune_name,
                c.population,
                c.dept_code,
                c.region_code,
                COUNT(v.id) AS total_venues,
                ROUND((COUNT(v.id) * 1000.0) / NULLIF(c.population, 0), 2) AS venues_per_1000,
                i.median_income,
                i.gini_index,
                i.poverty_rate
            FROM communes c
            LEFT JOIN cultural_venues v ON c.commune_code = v.code_insee_norm
            LEFT JOIN income_communes i ON c.commune_code = i.code_insee
            WHERE c.commune_code = %s
            GROUP BY
                c.commune_code, c.commune_name, c.population,
                c.dept_code, c.region_code,
                i.median_income, i.gini_index, i.poverty_rate
        """
        cursor.execute(query, (commune_code,))
        row = cursor.fetchone()
        
        if not row:
            raise HTTPException(
                status_code=404, 
                detail=f"Commune {commune_code} not found in database"
            )
        
        return row
    finally:
        cursor.close()

# ─────────────────────────────────────────────────────────────
# ENDPOINT 5: Cultural Density Ranking
# ─────────────────────────────────────────────────────────────

@app.get("/stats/density", tags=["Statistics"])
def get_density_ranking(
    limit: int = Query(default=20, ge=1, le=100, description="Number of top communes"),
    min_population: int = Query(default=5000, ge=0, le=10_000_000, description="Minimum population filter"),
    conn: mysql.connector.MySQLConnection = Depends(get_db_conn),
) -> Dict[str, Any]:
    """
    Rank communes by cultural density (venues per 1,000 inhabitants).
    
    **Business Logic:** Identifies high cultural supply areas by normalizing
    venue count by population, with minimum threshold to avoid small-population bias.
    """
    cursor = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT
                c.commune_code,
                c.commune_name,
                c.dept_code,
                c.population,
                COUNT(v.id) AS total_venues,
                ROUND((COUNT(v.id) * 1000.0) / NULLIF(c.population, 0), 2) AS venues_per_1000
            FROM communes c
            LEFT JOIN cultural_venues v ON c.commune_code = v.code_insee
            WHERE c.population >= %s
            GROUP BY c.commune_code, c.commune_name, c.dept_code, c.population
            HAVING COUNT(v.id) > 0
            ORDER BY venues_per_1000 DESC
            LIMIT %s
        """
        cursor.execute(query, (min_population, limit))
        rows = cursor.fetchall()
        
        return {
            "count": len(rows),
            "min_population": min_population,
            "ranking": rows
        }
    finally:
        cursor.close()

# ─────────────────────────────────────────────────────────────
# ENDPOINT 6: Department Statistics
# ─────────────────────────────────────────────────────────────

@app.get("/stats/dept/{dept_code}", tags=["Statistics"])
def get_dept_stats(
    dept_code: str,
    conn: mysql.connector.MySQLConnection = Depends(get_db_conn),
) -> Dict[str, Any]:
    """
    Get aggregated statistics at department level.
    
    **Business Logic:** Aggregates commune-level data to department scale
    for territorial comparison and regional policy analysis.
    """
    cursor = conn.cursor(dictionary=True)
    try:
        query = """
            SELECT
                d.dept_code,
                d.dept_name,
                d.region_code,
                COUNT(DISTINCT c.commune_code) AS total_communes,
                SUM(c.population) AS total_population,
                COUNT(v.id) AS total_venues,
                ROUND((COUNT(v.id) * 1000.0) / NULLIF(SUM(c.population), 0), 2) AS venues_per_1000,
                ROUND(AVG(i.median_income), 0) AS avg_median_income,
                ROUND(AVG(i.poverty_rate), 2) AS avg_poverty_rate
            FROM departments d
            LEFT JOIN communes c ON d.dept_code = c.dept_code
            LEFT JOIN cultural_venues v ON c.commune_code = v.code_insee_norm
            LEFT JOIN income_communes i ON c.commune_code = i.code_insee
            WHERE d.dept_code = %s
            GROUP BY d.dept_code, d.dept_name, d.region_code
        """
        cursor.execute(query, (dept_code,))
        row = cursor.fetchone()
        
        if not row:
            raise HTTPException(
                status_code=404,
                detail=f"Department {dept_code} not found"
            )
        
        return row
    finally:
        cursor.close()

# ─────────────────────────────────────────────────────────────
# ENDPOINT 7: Health Check
# ─────────────────────────────────────────────────────────────

@app.get("/health", tags=["Info"])
def health_check(conn: mysql.connector.MySQLConnection = Depends(get_db_conn)) -> Dict[str, Any]:
    """
    API health check - verifies database connectivity.
    """
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT 1")
        _ = cursor.fetchone()
        return {
            "status": "healthy",
            "database": "connected",
            "message": "Cultural Loom API is operational"
        }
    except Exception as e:
        return {
            "status": "unhealthy",
            "database": "disconnected",
            "error": str(e)
        }
    finally:
        cursor.close()
