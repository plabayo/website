use std::convert::Infallible;

use rama::{
    http::{
        layer::{
            compression::CompressionLayer, map_response_body::MapResponseBodyLayer,
            required_header::AddRequiredResponseHeadersLayer, trace::TraceLayer,
        },
        response::Redirect,
        service::web::WebService,
        Body, Request, Response,
    },
    service::{Service, ServiceBuilder},
};

mod pages;

#[derive(Debug, Clone)]
pub struct State;

pub struct Config {
    pub static_dir: String,
}

pub async fn web_service(
    cfg: Config,
) -> impl Service<State, Request, Response = Response, Error = Infallible> {
    tracing::info!("creating web service with static dir: {}", cfg.static_dir);
    ServiceBuilder::new()
        .layer(MapResponseBodyLayer::new(Body::new))
        .layer(AddRequiredResponseHeadersLayer::new())
        .layer(CompressionLayer::new())
        .layer(TraceLayer::new_for_http())
        .service(
            WebService::default()
                .get(pages::PageIndex::endpoint(), pages::PageIndex::service())
                .get(pages::PageRust::endpoint(), pages::PageRust::service())
                .get(pages::PageData::endpoint(), pages::PageData::service())
                .get(pages::PageFOSS::endpoint(), pages::PageFOSS::service())
                .get(pages::PageAbout::endpoint(), pages::PageAbout::service())
                .not_found(Redirect::temporary("/"))
                .dir("/static", &cfg.static_dir),
        )
}
