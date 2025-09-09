use axum::{routing::get, Router, extract::Query, Json};
use serde::Serialize;
use rusqlite::{Connection, params};

#[derive(Serialize)]
struct Hit {
    id: i64,
    title: String,
    snippet: String,
}

async fn search_handler(Query(params): Query<std::collections::HashMap<String, String>>) -> Json<Vec<Hit>> {
    let q = params.get("q").map(|s| s.as_str()).unwrap_or("");
    let conn = Connection::open("data/knowledge.db").expect("db open");

    let mut stmt = conn.prepare(
        "SELECT id, title, snippet(docs_fts, '<b>', '</b>', '...', -1, 64) as snippet
         FROM docs_fts
         JOIN documents ON docs_fts.rowid = documents.id
         WHERE docs_fts MATCH ?
         LIMIT 10"
    ).unwrap();

    let mut rows = stmt.query(params![q]).unwrap();
    let mut res = Vec::new();

    while let Some(row) = rows.next().unwrap() {
        let id: i64 = row.get(0).unwrap();
        let title: String = row.get(1).unwrap();
        let snippet: String = row.get(2).unwrap();
        res.push(Hit { id, title, snippet });
    }

    Json(res)
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/search", get(search_handler));

    println!("Listening on 127.0.0.1:3000");
    axum::Server::bind(&"127.0.0.1:3000".parse().unwrap())
        .serve(app.into_make_service())
        .await
        .unwrap();
}
