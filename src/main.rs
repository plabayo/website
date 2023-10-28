mod router;
mod services;

#[shuttle_runtime::main]
async fn axum() -> shuttle_axum::ShuttleAxum {
    let router = router::new().await;

    tracing::debug!("starting axum router");
    Ok(router.into())
}
