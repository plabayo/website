use maud::html;

/*
<html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>ushift</title>
        </head>
        <body>
            <main>
                <section>
                <h1><a href="https://github.com/plabayo/ushift">ushift</a></h1>
                <article>
                <h2>Libraries and framework to liberate the data of this world.</h2>
                <p>
                    Documentation: <a href="https://docs.rs/ushift">https://docs.rs/ushift</a>.
                <p>
                    A set of libraries to aid you in the data extraction and transformation of
                    liberated data around the world. Libraries can be used individually or
                    as a whole to write a spider from start to finish.
                <p>
                    Follow the progress and learn how to get involved
                    by going to the ushift code repository at:
                    <a href="https://github.com/plabayo/ushift">https://github.com/plabayo/ushift</a>.
                </p>
                <p>
                    A Free and Open Source project actively researched and developed by
                    <a href="https://www.plabayo.tech/">Plabayo.tech</a>.
                </p>
                </article>
                </section>
            </main>
            </body>
        </html>
 */

pub fn index() -> String {
    let html = html! {
        html lang="en" {
            head { 
                meta charset="UTF-8";
                meta name="viewport" content="width=device-width, initial-scale=1.0";
                title { "plabayo" }
                link rel="stylesheet" href="/style.css";
                link rel="shortcut icon" href="/favicon.ico" type="image/x-icon";
                link rel="icon" href="/favicon.ico" type="image/x-icon";
            }
            body {
                main {
                    section {
                        h1 {
                            a href="https://plabayo.tech/" { "Plabayo" }
                        }
                        article {
                            p {
                                "Plabayo was co-founded in 2021 by "
                                a href="https://www.elizadc.me/" { "Elizabeth C. Gonzales Belsuzarri" }
                                " and "
                                a href="https://www.glendc.com/" { "Glen Henri J. De Cauwsemaecker" }
                                " as a Free and Open Source Software (FOSS) development and consultancy studio."
                            }
                            p {
                                "We are located in Ghent, "
                                "Belgium and are available with events on premise within Belgium. "
                                "Remotely we are open to any location and timezone."
                            }
                            p {
                                "Education, Privacy and transparency is at the core of our mission."
                                "We take our craft serious and work on the fringes of playfulness."
                            }
                            p {
                                "If you like or work and would like to donate to us, you can do so at "
                                a href="https://github.com/sponsors/plabayo" { "https://github.com/sponsors/plabayo" }
                                "."
                            }
                        }
                    }
                }
            }
        }
    };
    html.into_string()
}

pub fn stylesheet() -> &'static str {
    include_str!("../static/style.css")
}

pub fn favicon() -> &'static [u8] {
    include_bytes!("../static/favicon.ico")
}