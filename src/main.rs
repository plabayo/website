mod router;

#[shuttle_runtime::main]
async fn axum() -> shuttle_axum::ShuttleAxum {
    let router = router::new();

    tracing::debug!("starting axum router");
    Ok(router.into())
}
