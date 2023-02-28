use axum::{
    response::{IntoResponse, Response},
    routing::get,
    Router,
};
use clap::Parser;

use std::{
    net::{IpAddr, SocketAddr},
    str::FromStr,
};

/// Plabayo stand-alone web server, serving the official Plabayo website.
/// As an alternative to the (cloudflare) worker version found in the /plabayo-worker directory.
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// interface to bind to
    #[arg(short, long, default_value = "127.0.0.1")]
    interface: String,

    /// Port to listen on
    #[arg(short, long, default_value_t = 8080)]
    port: u16,
}

#[tokio::main]
async fn main() {
    let args = Args::parse();

    // initialize tracing
    tracing_subscriber::fmt::init();

    // build our application with a route
    let app = Router::new()
        .route("/", get(index))
        .route("/style.css", get(stylesheet));

    // run our app with hyper
    // `axum::Server` is a re-export of `hyper::Server`
    let interface = IpAddr::from_str(&args.interface).unwrap();
    let addr = SocketAddr::from((interface, args.port));
    tracing::debug!("listening on {}", addr);
    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn index() -> Response {
    let mut resp = plabayo_website::index().into_response();
    resp.headers_mut()
        .insert("Content-Type", "text/html".parse().unwrap());
    resp
}

async fn stylesheet() -> Response {
    let mut resp = plabayo_website::stylesheet().into_response();
    resp.headers_mut()
        .insert("Content-Type", "text/css".parse().unwrap());
    resp
}
