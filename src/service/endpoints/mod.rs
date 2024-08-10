use rama::http::{response::Html, Body, IntoResponse};

pub mod about;
pub mod home;

#[derive(Debug, Clone)]
pub struct TemplateBody<T>(T);

impl<T: askama::Template> From<TemplateBody<T>> for Body {
    fn from(value: TemplateBody<T>) -> Self {
        let s = value.0.render().expect("render askama template");
        Body::new(s)
    }
}

impl<T: askama::Template> IntoResponse for TemplateBody<T> {
    fn into_response(self) -> rama::http::Response {
        let body: Body = self.into();
        Html(body).into_response()
    }
}
