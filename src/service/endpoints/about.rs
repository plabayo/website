use askama::Template;

use super::TemplateBody;

#[derive(Debug, Clone, Template)]
#[template(path = "about.html")]
pub struct AboutTemplate;

pub fn service() -> TemplateBody<AboutTemplate> {
    TemplateBody(AboutTemplate)
}
