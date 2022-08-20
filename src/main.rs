mod templates;

use perseus::{Html, PerseusApp, PerseusRoot};

#[perseus::main(perseus_warp::dflt_server)]
pub fn main<G: Html>() -> PerseusApp<G> {
    PerseusApp::new()
        .template(crate::templates::index::get_template)
        .index_view(|cx| {
            sycamore::view! {
                cx, 
                // We don't need a `<!DOCTYPE html>`, that's added automatically by Perseus (though that can be overriden if you really want by using `.index_view_str()`)
                // We need a `<head>` and a `<body>` at the absolute minimum for Perseus to work properly (otherwise certain script injections will fail)
                head {
                    meta(charset="utf-8")

                    meta(name="referrer", content="origin")
                    meta(name="viewport", content="width=device-width, initial-scale=1.0")

                    meta(name="application-name", content="plabayo")
                    meta(name="generator", content="perseus v0.4.0-beta.7")

                    title { "Plabayo" }

                    meta(name="author", content="Glen De Cauwsemaeker")
                    meta(name="description", content="official website for plabayo.tech")
                    meta(name="keywords", content="org,OSS,open source,free and open source,plabayo,portfolio,info,blog,tech,software,education")

                    link(rel="canonical", href="https://plabayo.tech/")

                    meta(property="og:title", content="Official Plabayo Website")
                    meta(property="og:description", content="Blog, portfolio and consultancy website for plabayo.tech.")
                    meta(property="og:type", content="website")
                    meta(property="og:url", content="https://plabayo.tech/")

                    meta(property="og:image", content="https://raw.githubusercontent.com/plabayo/design/main/art/2d/bin/hero_banner_og.png")
                    meta(property="og:image:secure_url", content="https://raw.githubusercontent.com/plabayo/design/main/art/2d/src/hero_banner_og.png")
                    meta(property="og:image:type", content="image/png")
                    meta(property="og:image:width", content="1200")
                    meta(property="og:image:height", content="630")
                    meta(property="og:image:alt", content="Plabayo's OG Logo Hero Banner")

                    link(rel="stylesheet", href="/.perseus/static/layout.css")
                    link(rel="stylesheet", href="/.perseus/static/theme.css")

                    link(rel="icon", href="/.perseus/static/favicon.ico", sizes="any")
                    link(rel="icon", href="/.perseus/static/icon.svg", type="image/svg+xml")
                    link(rel="apple-touch-icon", href="/.perseus/static/apple-touch-icon.png")
                    link(rel="manifest", href="/.perseus/static/manifest.webmanifest")

                    link(rel="alternate", type="application/rss+xml", title="RSS", href="https://plabayo.tech/rss.xml")
                }
                body {
                    div(id="wrapper") {
                        header {
                            nav(id="site-nav-main") {
                                h1(class="nav-title") {
                                    a(href="/") { "Plabayo.tech" }
                                }
                                ul(class="nav-buttons") {
                                    li {
                                        a(href="/blog") { "Blog" }
                                    }
                                    li {
                                        a(href="/consultants") { "Consultants" }
                                    }
                                    li {
                                        a(href="/projects") { "Projects" }
                                    }
                                    li {
                                        a(href="https://github.com/plabayo", rel="nofollow") { "Github" }
                                    }
                                    li {
                                        a(href="https://liberapay.com/Plabayo", rel="nofollow") { "Donate" }
                                    }
                                    li {
                                        a(href="mailto:contact@plabayo.tech") { "contact@plabayo.tech" }
                                    }
                                }
                            }
                        }
                        main {
                            // This creates an element into which our app will be interpolated
                            // This uses a few tricks internally beyond the classic `<div id="root">`, so we use this wrapper for convenience
                            PerseusRoot()
                        }
                        // Because this is in the index view, this will be below every single one of our pages
                        // Note that elements in here can't be selectively removed from one page, it's all-or-nothing in the index view (it wraps your whole app)
                        // Note also that this won't be reloaded, even when the user switches pages
                        footer {
                            div(id="nav-footer-info") {
                                nav {
                                    a(href="https://github.com/plabayo/website", rel="nofollow") { "website" }
                                    " made with <3 by "
                                    a(href="https://plabayo.tech") { "plabayo.tech" }
                                    " - licensed under "
                                    a(href="https://github.com/plabayo/website/blob/main/LICENSE", rel="nofollow") { "Creative Commons Zero v1.0 Universal" }
                                }
                            }
                        }
                    }
                }
            }
        })
}