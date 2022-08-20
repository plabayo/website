use perseus::Template;
use sycamore::prelude::{view, Html, Scope, SsrNode, View};

#[perseus::template_rx]
pub fn index_page<G: Html>(cx: Scope) -> View<G> {
    view! { cx,
        // Don't worry, there are much better ways of styling in Perseus!
        div(style = "display: flex; flex-direction: column; justify-content: center; align-items: center; height: 95vh;") {
            h1 { "Title!" }
            p { "Paragraph" }
        }
    }
}

#[perseus::head]
pub fn head(cx: Scope) -> View<SsrNode> {
    view! { cx,
        title { "Welcome to Perseus!" }
    }
}

pub fn get_template<G: Html>() -> Template<G> {
    Template::new("index").template(index_page).head(head)
}