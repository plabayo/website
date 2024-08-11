#![allow(dead_code)]

use askama::Template;
use rama::http::{response::Html, Body, IntoResponse};

#[derive(Debug, Clone)]
pub struct RenderContext {
    pub pages: [&'static PageContext; 5],
    pub git_sha: &'static str,
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
    style: &'static str,
    button_title: &'static str,
    description_short: &'static str,
}

const CTX: RenderContext = RenderContext {
    pages: [
        &PAGE_CTX_INDEX,
        &PAGE_CTX_RUST,
        &PAGE_CTX_DATA,
        &PAGE_CTX_FOSS,
        &PAGE_CTX_ABOUT,
    ],
    git_sha: env!("VERGEN_GIT_SHA"),
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

#[derive(Debug, Clone)]
pub struct XmlDocument<T>(T);

impl<T: askama::Template> From<XmlDocument<T>> for Body {
    fn from(value: XmlDocument<T>) -> Self {
        let s = value.0.render().expect("render askama template");
        Body::new(s)
    }
}

impl<T: askama::Template> IntoResponse for XmlDocument<T> {
    fn into_response(self) -> rama::http::Response {
        let body: Body = self.into();
        ([("content-type", "text/xml")], body).into_response()
    }
}

macro_rules! page {
    ($template:ident, $path:literal, $slug:literal, {$($key:ident: $value:expr),+$(,)?}) => {
        paste::paste! {
            const [<PAGE_CTX_ $template:upper>]: PageContext = PageContext {
                slug: $slug,
                $($key: $value),+
            };

            #[derive(Debug, Clone, Template)]
            #[template(path = $path)]
            pub struct [<Page $template:camel>] {
                ctx: &'static RenderContext,
                this: &'static PageContext,
            }

            impl [<Page $template:camel>] {
                pub const fn endpoint() -> &'static str {
                    concat!("/", $slug)
                }

                pub fn service() -> Page<Self> {
                    Page(Self {
                        ctx: &CTX,
                        this: &[<PAGE_CTX_ $template:upper>],
                    })
                }
            }
        }
    };
}

page!(index, "index.html", "", {
    title: "Plabayo",
    header: "FOSS Dev and Consultancy Studio",
    card: None,
});

page!(rust, "rust.html", "rust", {
    title: "Plabayo rust consulting",
    header: "Rust Consulting",
    card: Some(PageCardContext {
        icon: "🦀",
        style: "rust",
        button_title: "rust",
        description_short: r##"<p>
            With over a decade of experience in rust we are available
            as experts to train your team, audit your code,
            refactor your existing codebase or help develop your greenfield project.
        </p>"##,
    }),
});

page!(data, "data.html", "data", {
    title: "Plabayo data extraction",
    header: "Data Extraction",
    card: Some(PageCardContext {
        icon: "💾",
        style: "data",
        button_title: "data",
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
});

page!(foss, "foss.html", "foss", {
    title: "Plabayo FOSS",
    header: "Free and Open Source Software",
    card: Some(PageCardContext {
        icon: "🏡",
        style: "rust",
        button_title: "FOSS",
        description_short: r##"<p>
            We develop and maintain Free and Open Source Software
            related to data extraction, education, networking
            and games. All are source available with a permissive license.
        </p>"##,
    }),
});

page!(about, "about.html", "about", {
    title: "about Plabayo",
    header: "About Plabayo",
    card: Some(PageCardContext {
        icon: "👫",
        style: "about",
        button_title: "about",
        description_short: r##"<p>\
            Plabayo was co-founded in 2021 by
            Elizabeth C. Gonzales Belsuzarri and
            Glen Henri J. De Cauwsemaecker as a
            Free and Open Source Software (FOSS) dev and consultancy studio.
        </p>"##,
    }),
});

#[derive(Debug, Clone, Template)]
#[template(path = "sitemap.xml")]
pub struct Sitemap {
    ctx: &'static RenderContext,
}

impl Sitemap {
    pub const fn endpoint() -> &'static str {
        "/sitemap.xml"
    }

    pub fn service() -> XmlDocument<Self> {
        XmlDocument(Self { ctx: &CTX })
    }
}
