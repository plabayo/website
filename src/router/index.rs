use askama::Template;

#[derive(Template)]
#[template(path = "../templates/index.html")]
pub struct GetTemplate {
    pub projects: Vec<Project>,
}

pub struct Project {
    pub icon: &'static str,
    pub name: &'static str,
    pub description: &'static str,
    pub url: &'static str,
    pub labels: Vec<&'static str>,
}

pub async fn get() -> GetTemplate {
    GetTemplate {
        projects: vec![
            Project {
                icon: "🧪",
                name: "Rama",
                description: "Distortion proxy software to be anonymous.",
                url: "https://github.com/plabayo/rama",
                labels: vec!["rust", "http", "networking", "proxy", "scraping", "mitm"],
            },
            Project {
                icon: "✅",
                name: "Rust Language Guide",
                description:
                    "A guide to aid you in your journey of becoming a Rustacean (Rust developer).",
                url: "https://rust-lang.guide/",
                labels: vec!["rust", "learning", "guide", "educational"],
            },
            Project {
                icon: "🧪",
                name: "bckt.xyz",
                description: "Link shortener and secret sharing service.",
                url: "https://bckt.xyz/",
                labels: vec!["rust", "webservice"],
            },
            Project {
                icon: "✅",
                name: "tokio-graceful",
                description:
                    "Graceful shutdown util for Rust projects using the Tokio Async runtime.",
                url: "https://crates.io/crates/tokio-graceful",
                labels: vec!["rust", "async", "networking"],
            },
        ],
    }
}
