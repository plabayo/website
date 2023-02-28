use worker::*;

mod utils;

fn log_request(req: &Request) {
    console_log!(
        "{} - [{}], located at: {:?}, within: {}",
        Date::now().to_string(),
        req.path(),
        req.cf().coordinates().unwrap_or_default(),
        req.cf().region().unwrap_or_else(|| "unknown region".into())
    );
}

#[event(fetch)]
pub async fn main(req: Request, env: Env, _ctx: worker::Context) -> Result<Response> {
    log_request(&req);

    // Optionally, get more helpful error messages written to the console in the case of a panic.
    utils::set_panic_hook();

    // Optionally, use the Router to handle matching endpoints, use ":name" placeholders, or "*name"
    // catch-alls to match on specific patterns. Alternatively, use `Router::with_data(D)` to
    // provide arbitrary data that will be accessible in each route via the `ctx.data()` method.
    let router = Router::new();

    // Add as many routes as your Worker needs! Each route will get a `Request` for handling HTTP
    // functionality and a `RouteContext` which you can use to  and get route parameters and
    // Environment bindings like KV Stores, Durable Objects, Secrets, and Variables.
    router
        .get("/", |_, _| Response::from_html(plabayo_website::index()))
        .get("/style.css", |_, _| {
            let mut headers = Headers::new();
            headers.set("content-type", "text/css")?;

            let data = plabayo_website::stylesheet().as_bytes().to_vec();
            Response::from_body(ResponseBody::Body(data))
                .and_then(|resp| Ok(resp.with_headers(headers)))
        })
        .get("/favicon.ico", |_, _| {
            let mut headers = Headers::new();
            headers.set("content-type", "image/x-icon")?;

            let data = plabayo_website::favicon().to_vec();
            Response::from_body(ResponseBody::Body(data))
                .and_then(|resp| Ok(resp.with_headers(headers)))
        })
        .run(req, env)
        .await
}
