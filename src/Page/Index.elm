module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element
import Element.Font
import Element.Region
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Shared.seoSummary
        |> Seo.website


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Plabajo"
    , body =
        Element.column
            [ Element.centerX
            , Element.alignTop
            , Element.width (Element.px 700)
            , Element.Region.mainContent
            ]
            [ Element.row
                [ Element.width Element.fill ]
                [ Element.image [ Element.centerX, Element.width Element.fill ]
                    { src = "/media/index_hero_banner_default_light.svg"
                    , description = "light default version of the Plabajo Hero Banner"
                    }
                ]
            , Element.row
                [ Element.width Element.fill ]
                [ Element.el
                    [ Element.Font.color (Element.rgb255 51 51 51)
                    , Element.Font.size 36
                    , Element.Font.family
                        [ Element.Font.external
                            { url = "/fonts/Lato-HairlineItalic.woff2"
                            , name = "Lato Hairline Italic"
                            }
                        , Element.Font.sansSerif
                        ]
                    , Element.Font.italic
                    , Element.Font.center
                    , Element.padding 10
                    ]
                    (Element.text "Free and Open Source Software")
                ]
            , Element.row
                [ Element.width Element.fill ]
                [ Element.el
                    [ Element.Font.color (Element.rgb255 51 51 51)
                    , Element.Font.family
                        [ Element.Font.external
                            { url = "/fonts/Contra.woff2"
                            , name = "Contra Regular"
                            }
                        , Element.Font.serif
                        ]
                    , Element.padding 10
                    ]
                    (Element.text
                        """
Plabajo was co-founded in 2021 by Elizabeth C. Gonzales Belsuzarri and Glen Henri J. De Cauwsemaecker. Our applications
and games are the product, not you the user. All data is yours and yours alone to keep. Privacy and transparency is at core of our mission.
The _"Free"_ in _"Free and Open Source Software"_ (_FOSS_) is about freedom and helps maintain the _civil liberal rights_.
It doesn not mean that all our products are gratis.

Our slogan is _"Play, Work and Grow"_, one we take as serious as it is playful. Children learn by doing, but it is no different for adults.
We take it as our mission to help you in your life long journey of learning. Thank you for trusting us an using our products. 
"""
                    )
                ]
            , Element.row
                [ Element.Region.navigation
                , Element.width Element.fill
                ]
                [ Element.el
                    [ Element.Font.color (Element.rgb255 51 51 51)
                    , Element.Font.size 28
                    , Element.Font.family
                        [ Element.Font.external
                            { url = "/fonts/Lato-HairlineItalic.woff2"
                            , name = "Lato Hairline Italic"
                            }
                        , Element.Font.sansSerif
                        ]
                    , Element.Font.italic
                    , Element.padding 10
                    ]
                    (Element.link
                        []
                        { url = "/blog" -- TODO: localise this url
                        , label = Element.text "Blog"
                        }
                    )
                ]
            , Element.row
                [ Element.width Element.fill
                ]
                [ Element.el
                    [ Element.Font.color (Element.rgb255 51 51 51)
                    , Element.Font.family
                        [ Element.Font.external
                            { url = "/fonts/Contra.woff2"
                            , name = "Contra Regular"
                            }
                        , Element.Font.serif
                        ]
                    , Element.padding 10
                    ]
                    (Element.text "There are no blog posts yet to read...")
                ]
            , Element.row
                [ Element.Region.navigation
                , Element.width Element.fill
                ]
                [ Element.el
                    [ Element.Font.color (Element.rgb255 51 51 51)
                    , Element.Font.size 28
                    , Element.Font.family
                        [ Element.Font.external
                            { url = "/fonts/Lato-HairlineItalic.woff2"
                            , name = "Lato Hairline Italic"
                            }
                        , Element.Font.sansSerif
                        ]
                    , Element.Font.italic
                    , Element.padding 10
                    ]
                    (Element.text "Projects")
                ]
            , Element.row
                [ Element.width Element.fill
                ]
                [ Element.el
                    [ Element.Font.color (Element.rgb255 51 51 51)
                    , Element.Font.family
                        [ Element.Font.external
                            { url = "/fonts/Contra.woff2"
                            , name = "Contra Regular"
                            }
                        , Element.Font.serif
                        ]
                    , Element.padding 10
                    ]
                    (Element.column
                        []
                        [ Element.text "We are currently working hard on bucket, a FOSS time tracker:"
                        , Element.link [] { url = "https://bckt.xyz", label = Element.text "bckt.xyz" }
                        ]
                    )
                ]
            , Shared.footer
            ]
    }
