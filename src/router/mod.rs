use std::{path::PathBuf, sync::Arc};

use axum::{routing::get, Router};
use tokio::sync::Mutex;
use tower::ServiceBuilder;
use tower_http::{
    compression::CompressionLayer, normalize_path::NormalizePathLayer, services::ServeDir,
    trace::TraceLayer,
};

use crate::services::github::ProjectCache;

mod index;
mod memory;
mod not_found;
mod redirect;
mod shared;

#[derive(Debug, Clone)]
pub struct State {
    project_cache: Arc<Mutex<ProjectCache>>,
}

async fn new_root() -> Router {
    let project_cache = ProjectCache::new().await;
    Router::new()
        .route("/", get(index::get))
        .route("/projects", get(redirect::projects))
        .route("/robots.txt", get(memory::get_robots_txt))
        .route("/sitemap.xml", get(memory::get_sitemap_xml))
        .with_state(Arc::new(State {
            project_cache: Arc::new(Mutex::new(project_cache)),
        }))
}

pub async fn new() -> Router {
    let index_root = new_root().await;
    Router::new()
        .nest_service("/static", ServeDir::new(PathBuf::from("static")))
        .nest("/", index_root)
        .fallback(not_found::any)
        .layer(
            ServiceBuilder::new()
                .layer(TraceLayer::new_for_http())
                .layer(CompressionLayer::new())
                .layer(NormalizePathLayer::trim_trailing_slash()),
        )
}
