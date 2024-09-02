use std::time::Duration;

use clap::{command, Parser};
use rama::{http::server::HttpServer, rt::Executor};
use tracing::level_filters::LevelFilter;
use tracing_subscriber::layer::SubscriberExt;
use tracing_subscriber::util::SubscriberInitExt;
use tracing_subscriber::{fmt, EnvFilter};

mod service;

#[derive(Debug, Parser)]
#[command(name = "plabayo_www")]
#[command(bin_name = "plabayo_www")]
#[command(version, about, long_about = None)]
struct Cli {
    #[arg(short = 'p', long, default_value_t = 8080)]
    /// the port to listen on
    port: u16,

    #[arg(short = 'i', long, default_value = "127.0.0.1")]
    /// the interface to listen on
    interface: String,

    #[arg(short = 'd', long, default_value = "./static")]
    /// the dir location for the static dir
    dir: String,
}

#[tokio::main]
async fn main() {
    let cli = Cli::parse();

    tracing_subscriber::registry()
        .with(fmt::layer())
        .with(
            EnvFilter::builder()
                .with_default_directive(LevelFilter::INFO.into())
                .from_env_lossy(),
        )
        .init();

    let addr = format!("{}:{}", cli.interface, cli.port);
    tracing::info!("running service at: {addr}");

    let cfg = service::Config {
        static_dir: cli.dir,
    };

    let state = service::State;

    let graceful = rama::graceful::Shutdown::default();

    graceful.spawn_task_fn(move |guard| async move {
        let exec = Executor::graceful(guard.clone());
        let web_service = service::web_service(cfg).await;

        HttpServer::auto(exec)
            .listen_graceful_with_state(guard, state, addr, web_service)
            .await
            .unwrap();
    });

    graceful
        .shutdown_with_limit(Duration::from_secs(30))
        .await
        .expect("graceful shutdown");
}
