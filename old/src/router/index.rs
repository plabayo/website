use std::sync::Arc;

use askama::Template;
use axum::{extract::State, http::HeaderMap};

use crate::services::github::Project;

#[derive(Template)]
#[template(path = "../templates/index.html")]
pub struct GetTemplate {
    pub projects: Vec<Project>,
    pub fetch_projects: bool,
}

pub async fn get(State(state): State<Arc<super::State>>, headers: HeaderMap) -> GetTemplate {
    let skip_api_calls = !headers.contains_key("Hx-Request");
    let (projects, skip_refresh) = state
        .project_cache
        .lock()
        .await
        .get_projects(skip_api_calls)
        .await;

    GetTemplate {
        projects: projects.to_vec(),
        fetch_projects: !skip_refresh,
    }
}
