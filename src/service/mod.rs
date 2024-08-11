use middleware::CacheControlLayer;
use rama::{
    http::{
        dep::mime::TEXT_HTML,
        headers::{Accept, HeaderMapExt},
        layer::{
            compression::CompressionLayer, required_header::AddRequiredResponseHeadersLayer,
            trace::TraceLayer,
        },
        response::Redirect,
        service::web::WebService,
        IntoResponse, Request, Response, StatusCode,
    },
    service::{Service, ServiceBuilder},
};
use std::convert::Infallible;

mod middleware;
mod pages;

#[derive(Debug, Clone)]
pub struct State;

pub struct Config {
    pub static_dir: String,
}

macro_rules! page_web_service {
    ($($name:ident),+$(,)?) => {
        WebService::default()
        $(
            .get(pages::$name::endpoint(), pages::$name::service())
        )+
    };
}

pub async fn web_service(
    cfg: Config,
) -> impl Service<State, Request, Response = Response, Error = Infallible> {
    tracing::info!("creating web service with static dir: {}", cfg.static_dir);
    ServiceBuilder::new()
        .layer(CacheControlLayer::default())
        .layer(AddRequiredResponseHeadersLayer::new())
        .layer(CompressionLayer::new())
        .layer(TraceLayer::new_for_http())
        .service(
            page_web_service!(PageIndex, PageRust, PageData, PageFoss, PageAbout, Sitemap)
                .not_found(|req: Request| async move {
                    if req
                        .headers()
                        .typed_get::<Accept>()
                        .map(|a| a.iter().any(|q| q.value == TEXT_HTML))
                        .unwrap_or_default()
                    {
                        Redirect::temporary("/").into_response()
                    } else {
                        StatusCode::NOT_FOUND.into_response()
                    }
                })
                .dir("/", &cfg.static_dir),
        )
}
