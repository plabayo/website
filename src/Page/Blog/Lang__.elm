module Page.Blog.Lang__ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (Element)
import Element.Font
import Element.Region
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { lang : Maybe String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    DataSource.succeed
        [ { lang = Nothing }
        ]


data : RouteParams -> DataSource Data
data routeParams =
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
    { title = "Plabayo Blog"
    , body =
        Element.column
            [ Element.centerX
            , Element.alignTop
            , Element.width (Element.px 700)
            , Element.Region.mainContent
            ]
            [ Element.row
                [ Element.width Element.fill
                , Element.Region.navigation
                ]
                [ Element.column
                    [ Element.padding 10 ]
                    [ Element.link []
                        { label =
                            Element.row []
                                [ Element.column []
                                    [ Element.image [ Element.width (Element.px 40) ]
                                        { src = "/media/logo_filled_default.svg"
                                        , description = "light default version of the Plabayo Logo"
                                        }
                                    ]
                                ,  Element.column
                                    []
                                    [ Element.text "Plabayo"
                                    ]
                                ]
                        , url = "/"
                        }
                    ]
                , Element.column
                    [ Element.padding 10 ]
                    [ Element.link []
                        { label = Element.text "Blog"
                        , url = "/blog" -- todo: localize link
                        }
                    ]
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
            ]
    }
