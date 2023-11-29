use std::time::Duration;

use axum::http::HeaderValue;
use chrono::{DateTime, Local};
use reqwest::StatusCode;
use serde::{de::DeserializeOwned, Deserialize};
use tokio::task::JoinSet;

#[derive(Debug, Clone)]
pub struct Project {
    pub icon: &'static str,
    pub name: &'static str,
    pub description: &'static str,
    pub url: &'static str,
    pub labels: Vec<&'static str>,
    pub repo_name: &'static str,
    pub repo_info: Option<GithubRepoInfo>,
}

#[derive(Debug, Clone, Deserialize)]
pub struct GithubRepoInfo {
    pub stargazers_count: usize,
}

// we use no authentication
async fn github_api_call<T: DeserializeOwned>(url: &str) -> Option<T> {
    let ua = format!("plabayo.tech/web-service-{}", env!("CARGO_PKG_VERSION"));
    for i in 0..3 {
        let send_future = reqwest::Client::builder()
            .user_agent(HeaderValue::from_str(ua.as_str()).expect("user agent should be valid"))
            .build()
            .expect("building request should succeed")
            .get(url)
            .send();

        // send request with timeout
        let result = match tokio::time::timeout(Duration::from_secs(5 + i * 3), send_future).await {
            Ok(result) => result,
            Err(_) => {
                tracing::error!("fetch ({}/3) error: ua={}: {}: timeout", ua, i + 1, url);
                continue;
            }
        };

        let response = match result {
            Ok(response) => response,
            Err(e) => {
                tracing::error!("fetch ({}/3) error: ua={}: {}: {}", i + 1, ua, url, e);
                tokio::time::sleep(Duration::from_millis(100 * (i + 1))).await;
                continue;
            }
        };

        if response.status() == StatusCode::FORBIDDEN {
            tracing::error!(
                "fetch ({}/3) error: fatal: ua={}: {}: received 403 (forbidden): rate limit exceeded?",
                i + 1,
                ua,
                url
            );
            return None;
        }

        if response.status() != StatusCode::OK {
            tracing::error!(
                "fetch ({}/3) error: {}: received bad status {}",
                i + 1,
                url,
                response.status()
            );
            tokio::time::sleep(Duration::from_millis(100 * (i + 1))).await;
            continue;
        }

        match response.json::<T>().await {
            Ok(response) => return Some(response),
            Err(e) => {
                tracing::error!(
                    "fetch ({}/3) error: ua={}: decode error: {}: {}",
                    i + 1,
                    ua,
                    url,
                    e
                );
                tokio::time::sleep(Duration::from_millis(100 * (i + 1))).await;
                continue;
            }
        }
    }

    None
}

impl Project {
    pub fn new(
        icon: &'static str,
        name: &'static str,
        description: &'static str,
        url: &'static str,
        labels: Vec<&'static str>,
        repo_name: &'static str,
    ) -> Self {
        Project {
            icon,
            name,
            description,
            url,
            labels,
            repo_name,
            repo_info: None,
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
    projects: Vec<Project>,
    fetch_time: Option<DateTime<Local>>,
}

impl ProjectCache {
    /// create a new project cache, pre-warmed up
    pub async fn new() -> Self {
        let mut cache = ProjectCache {
            projects: vec![
                Project::new(
                    "✅",
                    "Rust Language Guide",
                    "A guide to aid you in your journey of becoming a Rustacean (Rust developer).",
                    "https://rust-lang.guide/",
                    vec!["rust", "learning", "guide", "educational"],
                    "learn-rust-101"
                ),
                Project::new(
                    "🧪",
                     "Rama",
                     "Distortion proxy software to be anonymous.",
                     "https://ramaproxy.org",
                     vec!["rust", "http", "networking", "proxy", "scraping", "mitm"],
                     "rama"
                 ),
                 Project::new(
                     "🧪",
                     "bckt.xyz",
                     "Link shortener and secret sharing service.",
                     "https://bckt.xyz/",
                     vec!["rust", "webservice"],
                     "bucket"
                 ),
                 Project::new(
                    "🧪",
                    "NES Studio",
                    "A NES emulator and IDE, as a fully featured web application, served as WASM, compiled from Rust.",
                    "https://nes.studio/",
                    vec!["rust", "webservice", "wasm", "emulator", "NES", "IDE"],
                    "nes-studio"
                 ),
                 Project::new(
                     "✅",
                     "tokio-graceful",
                     "Graceful shutdown util for Rust projects using the Tokio Async runtime.",
                     "https://crates.io/crates/tokio-graceful",
                     vec!["rust", "async", "networking"],
                     "tokio-graceful"
                 ),
                 Project::new(
                     "✅",
                     "tower-async",
                     "Tower Async is a library of modular and reusable components for building robust clients and servers. An \"Async Trait\" fork from the original Tower Library.",
                     "https://crates.io/crates/tower-async",
                     vec!["rust", "async", "networking"],
                     "tower-async"
                 ),
                 Project::new(
                    "✅",
                    "plabayo.tech",
                    "This company website, served by our own Rust web service, hosted on shuttle.com",
                    "https://plabayo.tech/",
                    vec!["rust", "webservice"],
                    "website",
                 ),
            ],
            fetch_time: None,
        };
        cache.get_projects(false).await;
        cache
    }

    pub async fn get_projects(&mut self, skip_api_calls: bool) -> (Vec<Project>, bool) {
        let skip_refresh = self
            .fetch_time
            .map(|t| t + chrono::Duration::minutes(30) > Local::now())
            .unwrap_or_default();
        if skip_api_calls || skip_refresh {
            return (self.projects.clone(), skip_refresh);
        }

        // fetch all projects in "parallel"
        let mut fetch_set = JoinSet::new();
        for project in self.projects.iter() {
            let repo_name = project.repo_name;
            fetch_set.spawn(async move {
                let repo_info = github_api_call::<GithubRepoInfo>(&format!(
                    "https://api.github.com/repos/plabayo/{repo_name}"
                ))
                .await;
                (repo_name, repo_info)
            });
        }

        let mut updated_any_project = false;

        // apply all updates, but preserve project order
        while let Some(result) = fetch_set.join_next().await {
            match result {
                Ok((repo_name, repo_info)) => {
                    let mut project_found = false;
                    for project in self.projects.iter_mut() {
                        if project.repo_name == repo_name {
                            project.repo_info = repo_info;
                            project_found = true;
                            updated_any_project = true;
                            break;
                        }
                    }
                    if !project_found {
                        tracing::error!("project not found for update: {}", repo_name);
                    }
                }
                Err(e) => {
                    tracing::error!("project fetch error: {}", e);
                }
            }
        }

        if updated_any_project {
            self.fetch_time = Some(Local::now());
        }

        (self.projects.clone(), true)
    }
}
