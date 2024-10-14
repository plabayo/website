#![allow(dead_code)]

use askama::Template;
use rama::http::{response::Html, Body, IntoResponse};

#[derive(Debug, Clone)]
pub struct RenderContext {
    pub pages: [&'static PageContext; 6],
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
    header: &'static str,
    style: &'static str,
    button_title: &'static str,
    description_short: &'static str,
}

const CTX: RenderContext = RenderContext {
    pages: [
        &PAGE_CTX_INDEX,
        &PAGE_CTX_RUST,
        &PAGE_CTX_DATA,
        &PAGE_CTX_PORT,
        &PAGE_CTX_ABOUT,
        &PAGE_CTX_FOSS,
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
        header: "Rust Experts",
        button_title: "Rust",
        description_short: r##"<p>
            Our team has more than 10 years of experience using the Rust language,
            providing us with the expertise to offer a range of services to your business.
        </p><p>
            We can train your team, audit your code, refactor your existing codebase,
            or assist with the development of your new project.
            Whatever your needs are, we're here to help.
        </p>"##,
    }),
});

page!(data, "data.html", "data", {
    title: "Plabayo data extraction",
    header: "Data Extraction",
    card: Some(PageCardContext {
        icon: "💾",
        header: "Data Extraction",
        style: "data",
        button_title: "Data",
        description_short: r##"<p>
            Our team specializes in extracting valuable data from the internet, transforming it into actionable insights,
            and delivering it to you. We offer our services as either a consulting contract
            or a customized solution tailored to meet your specific needs.
        </p><p>
            Trust us to provide you with the most accurate and relevant information available,
            so you can make informed decisions for your business.
        </p>"##,
    }),
});

page!(port, "port.html", "port", {
    title: "Plabayo Software Port",
    header: "Port Existing Software",
    card: Some(PageCardContext {
        icon: "📦",
        header: "Port Existing Software",
        style: "rust",
        button_title: "Port",
        description_short: r##"<p>
            Our business has extensive experience in porting existing software into a better version of itself using Rust.
            We can help your business with the process from start to finish, or act as a trainer/mentor
            to guide you through the process.
        </p>
        <p>
            We specialize in porting software for performance reasons coming from languages such
            as JavaScript, Python, Golang, Java, and C#. Additionally,
            we have experience in porting C and C++ software for security reasons.
            Our team has extensive experience with all these languages on a variety of platforms.
        </p>"##,
    }),
});

page!(foss, "foss.html", "foss", {
    title: "Plabayo FOSS",
    header: "Free and Open Source Software",
    card: Some(PageCardContext {
        icon: "🧭",
        header: "FOSS",
        style: "rust",
        button_title: "FOSS",
        description_short: r##"<p>
            Our business specializes in developing and maintaining Free and Open Source Software (FOSS)
            solutions for data extraction, education, networking, and gaming.
        </p><p>
            All of our software is source available with a permissive license,
            giving you the freedom to use, modify, and distribute it.
            Trust us to provide you with reliable and secure software solutions that align with your business goals.
        </p>"##,
    }),
});

page!(about, "about.html", "about", {
    title: "about Plabayo",
    header: "About Plabayo",
    card: Some(PageCardContext {
        icon: "👫",
        header: "About us",
        style: "about",
        button_title: "About",
        description_short: r##"<p>
            Plabayo is a FOSS development and consultancy studio co-founded in 2021 by Elizabeth C. Gonzales Belsuzarri and Glen Henri J. De Cauwsemaecker.
            We offer custom software development, team training, and code auditing to drive business innovation and growth.
        </p><p>
            Trust us for reliable and secure software solutions.
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
