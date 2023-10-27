use std::path::PathBuf;

use axum::{routing::get, Router};
use tower::ServiceBuilder;
use tower_cookies::CookieManagerLayer;
use tower_http::{
    compression::CompressionLayer, normalize_path::NormalizePathLayer, services::ServeDir,
    trace::TraceLayer,
};

mod index;
mod memory;
mod not_found;
mod redirect;
mod shared;

fn new_root() -> Router {
    Router::new()
        .route("/", get(index::get))
        .route("/projects", get(redirect::projects))
        .route("/robots.txt", get(memory::get_robots_txt))
        .route("/sitemap.xml", get(memory::get_sitemap_xml))
        .layer(CookieManagerLayer::new())
}

pub fn new() -> Router {
    Router::new()
        .nest_service("/static", ServeDir::new(PathBuf::from("static")))
        .nest("/", new_root())
        .fallback(not_found::any)
        .layer(
            ServiceBuilder::new()
                .layer(TraceLayer::new_for_http())
                .layer(CompressionLayer::new())
                .layer(NormalizePathLayer::trim_trailing_slash()),
        )
}
