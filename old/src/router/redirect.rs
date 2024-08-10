use axum::response::Redirect;

pub async fn projects() -> Redirect {
    Redirect::permanent("/#projects")
}
