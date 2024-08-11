#![allow(dead_code)]

use askama::Template;
use rama::http::{response::Html, Body, IntoResponse};

#[derive(Debug, Clone)]
pub struct RenderContext {
    pub pages: [&'static PageContext; 5],
}

#[derive(Debug, Clone)]
pub struct PageContext {
    title: &'static str,
    header: &'static str,
    slug: &'static str,
    card: Option<PageCardContext>,
}

#[derive(Debug, Clone)]
pub struct PageCardContext {
    icon: &'static str,
    description_short: &'static str,
}

const PAGE_CTX_INDEX: PageContext = PageContext {
    title: "Plabayo",
    header: "FOSS dev and consultancy studio",
    slug: "",
    card: None,
};

const PAGE_CTX_RUST: PageContext = PageContext {
    title: "Plabayo rust consulting",
    header: "rust consulting",
    slug: "rust",
    card: Some(PageCardContext {
        icon: "🦀",
        description_short: r##"<p>
            With over a decade of experience in rust we are available
            as experts to train your team, audit your code,
            refactor your existing codebase or help develop your greenfield project.
        </p>"##,
    }),
};

const PAGE_CTX_DATA: PageContext = PageContext {
    title: "Plabayo data extraction",
    header: "data extraction",
    slug: "data",
    card: Some(PageCardContext {
        icon: "💾",
        description_short: r##"<p>
            We are experts in extracting data from the net,
            and transforming it into objects ready to help you succeed.
        </p>
        <p>
            You can hire our services to provide you with data feeds,
            data sets, reverse engineering of mobile apps and APIs and more.
            If the data is public we can make it cleanly accessible for you.
        </p>"##,
    }),
};

const PAGE_CTX_FOSS: PageContext = PageContext {
    title: "Plabayo FOSS",
    header: "FOSS dev and consultancy studio",
    slug: "foss",
    card: Some(PageCardContext {
        icon: "💾",
        description_short: r##"<p>
            We develop and maintain Free and Open Source Software
            related to data extraction, education, networking
            and games. All are source available with a permissive license.
        </p>"##,
    }),
};

const PAGE_CTX_ABOUT: PageContext = PageContext {
    title: "about Plabayo",
    header: "about",
    slug: "about",
    card: Some(PageCardContext {
        icon: "👫",
        description_short: r##"<p>\
            Plabayo was co-founded in 2021 by
            Elizabeth C. Gonzales Belsuzarri and
            Glen Henri J. De Cauwsemaecker as a
            Free and Open Source Software (FOSS) dev and consultancy studio.
        </p>"##,
    }),
};

const CTX: RenderContext = RenderContext {
    pages: [
        &PAGE_CTX_INDEX,
        &PAGE_CTX_RUST,
        &PAGE_CTX_DATA,
        &PAGE_CTX_FOSS,
        &PAGE_CTX_ABOUT,
    ],
};

#[derive(Debug, Clone)]
pub struct Page<T>(T);

impl<T: askama::Template> From<Page<T>> for Body {
    fn from(value: Page<T>) -> Self {
        let s = value.0.render().expect("render askama template");
        Body::new(s)
    }
}

impl<T: askama::Template> IntoResponse for Page<T> {
    fn into_response(self) -> rama::http::Response {
        let body: Body = self.into();
        Html(body).into_response()
    }
}

macro_rules! page {
    ($name:ident, $ctx:ident, $slug:literal, $template:literal) => {
        #[derive(Debug, Clone, Template)]
        #[template(path = $template)]
        pub struct $name {
            ctx: &'static RenderContext,
            this: &'static PageContext,
        }

        impl $name {
            pub const fn endpoint() -> &'static str {
                concat!("/", $slug)
            }

            pub fn service() -> Page<Self> {
                Page(Self {
                    ctx: &CTX,
                    this: &$ctx,
                })
            }
        }
    };
}

page!(PageIndex, PAGE_CTX_INDEX, "", "index.html");
page!(PageRust, PAGE_CTX_RUST, "rust", "rust.html");
page!(PageData, PAGE_CTX_DATA, "data", "data.html");
page!(PageFOSS, PAGE_CTX_FOSS, "foss", "foss.html");
page!(PageAbout, PAGE_CTX_ABOUT, "about", "about.html");
