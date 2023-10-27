use std::sync::Arc;

use askama::Template;
use axum::extract::State;

use crate::services::github::Project;

#[derive(Template)]
#[template(path = "../templates/index.html")]
pub struct GetTemplate {
    pub projects: Vec<Project>,
}

pub async fn get(State(state): State<Arc<super::State>>) -> GetTemplate {
    let projects = state.project_cache.lock().await.get_projects().await;
    GetTemplate {
        projects: projects.to_vec(),
    }
}
