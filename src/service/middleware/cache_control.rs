use bytes::Bytes;
use rama::error::BoxError;
use rama::http::dep::http_body;
use rama::http::headers::{CacheControl, ETag, HeaderMapExt, IfNoneMatch};
use rama::http::{Body, IntoResponse, Request, Response, StatusCode, Uri};
use rama::{Context, Layer, Service};
use std::fmt;
use std::hash::{DefaultHasher, Hash, Hasher};
use std::time::Duration;

#[derive(Debug, Clone, Default)]
#[non_exhaustive]
pub struct CacheControlLayer;

impl<S> Layer<S> for CacheControlLayer {
    type Service = CacheControlService<S>;

    fn layer(&self, inner: S) -> Self::Service {
        CacheControlService::new(inner)
    }
}

#[derive(Clone)]
pub struct CacheControlService<S> {
    inner: S,
}

impl<S> CacheControlService<S> {
    pub fn new(service: S) -> Self {
        Self { inner: service }
    }
}

impl<S, State, ReqBody, ResBody> Service<State, Request<ReqBody>> for CacheControlService<S>
where
    S: Service<State, Request<ReqBody>, Response = Response<ResBody>>,
    State: Send + Sync + 'static,
    ReqBody: Send + 'static,
    ResBody: http_body::Body<Data = Bytes> + Send + Sync + 'static,
    ResBody::Error: Into<BoxError>,
{
    type Response = Response;
    type Error = S::Error;

    async fn serve(
        &self,
        ctx: Context<State>,
        req: Request<ReqBody>,
    ) -> Result<Self::Response, Self::Error> {
        let mut hasher = DefaultHasher::new();
        ETagHash {
            uri: req.uri(),
            git_sha: env!("VERGEN_GIT_SHA"),
        }
        .hash(&mut hasher);
        let etag: ETag = format!("\"{}\"", hasher.finish()).parse().unwrap();

        if req
            .headers()
            .typed_get::<IfNoneMatch>()
            .map(|m| !m.precondition_passes(&etag))
            .unwrap_or_default()
        {
            // shortcut in case content dit not change
            return Ok(StatusCode::NOT_MODIFIED.into_response());
        }

        let mut res = self
            .inner
            .serve(ctx, req)
            .await
            .map(|res| res.map(Body::new))?;

        // add cache control + ETag to res headers

        let headers = res.headers_mut();
        headers.typed_insert(etag);
        headers.typed_insert(
            CacheControl::new()
                .with_public()
                .with_max_age(Duration::from_secs(3600)),
        );

        Ok(res)
    }
}

#[derive(Hash)]
struct ETagHash<'a> {
    uri: &'a Uri,
    git_sha: &'static str,
}

impl<S> fmt::Debug for CacheControlService<S>
where
    S: fmt::Debug,
{
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("CacheControlService")
            .field("inner", &self.inner)
            .finish()
    }
}
