use middleware::CacheControlLayer;
use rama::{
    http::{
        dep::mime::TEXT_HTML,
        headers::{Accept, HeaderMapExt},
        layer::{
            compression::CompressionLayer, required_header::AddRequiredResponseHeadersLayer,
            set_header::SetResponseHeaderLayer, trace::TraceLayer,
        },
        matcher::HttpMatcher,
        response::Redirect,
        service::web::{IntoEndpointService, WebService},
        HeaderName, HeaderValue, IntoResponse, Request, Response, StatusCode,
    },
    layer::HijackLayer,
    Layer, Service,
};
use std::{convert::Infallible, sync::Arc};

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
    (
        HijackLayer::new(
            HttpMatcher::post("/fly/health"),
            Arc::new(StatusCode::OK.into_endpoint_service()),
        ),
        CacheControlLayer::default(),
        AddRequiredResponseHeadersLayer::new(),
        SetResponseHeaderLayer::if_not_present(
            HeaderName::from_static("x-hire-us"),
            HeaderValue::from_static(
                "rust development, training, data extraction and reverse engineering",
            ),
        ),
        CompressionLayer::new(),
        TraceLayer::new_for_http(),
    )
        .layer(
            page_web_service!(
                PageIndex, PageRust, PageData, PagePort, PageFoss, PageAbout, Sitemap
            )
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
