#!/usr/bin/env python3
# scripts/ingest.py
import sqlite3
import glob
import os
import markdown
from datetime import datetime

DB = "data/knowledge.db"
ART_DIR = "data/articles"

def create_db():
    os.makedirs("data", exist_ok=True)
    conn = sqlite3.connect(DB)
    cur = conn.cursor()
    cur.execute("PRAGMA journal_mode = WAL;")
    # documents table + fts5 virtual table for search
    cur.execute("""
    CREATE TABLE IF NOT EXISTS documents (
        id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        path TEXT,
        language TEXT,
        updated_at TEXT
    );
    """)
    cur.execute("""
    CREATE VIRTUAL TABLE IF NOT EXISTS docs_fts USING fts5(content, title, content='documents', content_rowid='id');
    """)
    conn.commit()
    conn.close()

def ingest_files():
    conn = sqlite3.connect(DB)
    cur = conn.cursor()
    for mdfile in glob.glob(f"{ART_DIR}/*.md"):
        with open(mdfile, 'r', encoding='utf-8') as f:
            text = f.read()
        # simple title extraction
        title = os.path.basename(mdfile).replace('.md','')
        updated = datetime.utcnow().isoformat()
        cur.execute("INSERT INTO documents (title, content, path, language, updated_at) VALUES (?, ?, ?, ?, ?)",
                    (title, text, mdfile, "my", updated))
        rowid = cur.lastrowid
        # insert into fts
        cur.execute("INSERT INTO docs_fts(rowid, content, title) VALUES (?, ?, ?)", (rowid, text, title))
    conn.commit()
    conn.close()

if __name__ == "__main__":
    create_db()
    ingest_files()
    print("Ingest finished. DB:", DB)
