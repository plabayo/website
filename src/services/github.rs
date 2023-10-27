use axum::http::HeaderValue;
use chrono::{DateTime, Local};
use serde::Deserialize;

#[derive(Debug, Clone)]
pub struct Project {
    pub icon: &'static str,
    pub name: &'static str,
    pub description: &'static str,
    pub url: &'static str,
    pub labels: Vec<&'static str>,
    pub github_info: Option<ProjectGithubInfo>,
}

#[derive(Debug, Deserialize)]
struct GithubRepoResponse {
    stargazers_count: usize,
}

async fn get_github_project_info(repo: &'static str) -> Option<ProjectGithubInfo> {
    reqwest::Client::builder()
        .user_agent(HeaderValue::from_static("plabayo/website-0.1"))
        .build()
        .ok()?
        .get(format!("https://api.github.com/repos/plabayo/{repo}"))
        .send()
        .await
        .map_err(|e| {
            tracing::error!("Error fetching star count: {}", e);
            e
        })
        .ok()?
        .json::<GithubRepoResponse>()
        .await
        .map_err(|e| {
            tracing::error!("Error fetching star count: {}", e);
            e
        })
        .ok()
        .map(|response| ProjectGithubInfo {
            repo,
            stars: response.stargazers_count,
        })
}

impl Project {
    pub async fn fetch(
        icon: &'static str,
        name: &'static str,
        description: &'static str,
        url: &'static str,
        labels: Vec<&'static str>,
        repo: &'static str,
    ) -> Self {
        Project {
            icon,
            name,
            description,
            url,
            labels,
            github_info: get_github_project_info(repo).await,
        }
    }
}

#[derive(Debug, Clone)]
pub struct ProjectGithubInfo {
    pub repo: &'static str,
    pub stars: usize,
}

#[derive(Debug)]
pub struct ProjectCache {
    projects: Option<Vec<Project>>,
    fetch_time: DateTime<Local>,
}

impl ProjectCache {
    pub fn new() -> Self {
        ProjectCache {
            projects: None,
            fetch_time: Local::now(),
        }
    }

    pub async fn get_projects(&mut self) -> Vec<Project> {
        if let Some(projects) = self.projects.as_ref() {
            if self.fetch_time + chrono::Duration::minutes(30) > Local::now() {
                return projects.clone();
            }
        }

        let projects = futures::future::join_all(vec![
            Project::fetch(
               "🧪",
                "Rama",
                "Distortion proxy software to be anonymous.",
                "https://github.com/plabayo/rama",
                vec!["rust", "http", "networking", "proxy", "scraping", "mitm"],
                "rama"
            ),
            Project::fetch(
                "✅",
                "Rust Language Guide",
                "A guide to aid you in your journey of becoming a Rustacean (Rust developer).",
                "https://rust-lang.guide/",
                vec!["rust", "learning", "guide", "educational"],
                "learn-rust-101"
            ),
            Project::fetch(
                "🧪",
                "bckt.xyz",
                "Link shortener and secret sharing service.",
                "https://bckt.xyz/",
                vec!["rust", "webservice"],
                "bucket"
            ),
            Project::fetch(
                "✅",
                "tokio-graceful",
                "Graceful shutdown util for Rust projects using the Tokio Async runtime.",
                "https://crates.io/crates/tokio-graceful",
                vec!["rust", "async", "networking"],
                "tokio-graceful"
            ),
            Project::fetch(
                "✅",
                "tower-async",
                "Tower Async is a library of modular and reusable components for building robust clients and servers. An \"Async Trait\" fork from the original Tower Library.",
                "https://crates.io/crates/tower-async",
                vec!["rust", "async", "networking"],
                "tower-async"
            ),
        ]).await;

        self.projects = Some(projects.clone());
        self.fetch_time = Local::now();
        projects
    }
}
