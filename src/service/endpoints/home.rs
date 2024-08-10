use askama::Template;

use super::TemplateBody;

#[derive(Debug, Clone, Template)]
#[template(path = "index.html")]
pub struct IndexTemplate;

pub fn service() -> TemplateBody<IndexTemplate> {
    TemplateBody(IndexTemplate)
}
