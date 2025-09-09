# Community Knowledge Hub

**Offline-first, multilingual knowledge viewer + search + local Q&A**

## Vision
Provide reliable, easy-to-distribute knowledge (education, health, agriculture, local guides) that works without internet and supports simple AI-powered Q&A from local data.

## MVP Goals
- Basic offline content viewer (markdown/pdf)
- Full-text search (SQLite FTS5 or Rust/Tantivy)
- Simple extractive Q&A: retrieve top paragraphs and present as answers

## Tech stack (MVP)
- Frontend: Flutter (cross-platform)
- Backend: Rust (lightweight local HTTP service)
- DB / Search: SQLite (FTS5) or Tantivy (Rust)
- Data ingestion: Python scripts (initial)
- CI: GitHub Actions

## Quickstart (developer)
1. Clone repo
2. Setup backend & ingest sample data: `cd scripts && python3 ingest.py`
3. Run backend: `cd backend && cargo run`
4. Run app: `cd app && flutter run`

