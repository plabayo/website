module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element
import Element.Font
import Element.Region
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Plabayo.L18n.Types exposing (Text(..))
import Plabayo.L18n.UI as L18nUI
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
    { title = "Plabayo"
    , body =
        Element.column
            [ Element.centerX
            , Element.alignTop
            , Element.paddingXY 0 30
            , Element.width (Element.px 700)
            , Element.Region.mainContent
            ]
            [ Element.row
                [ Element.width Element.fill ]
                [ Element.image [ Element.centerX, Element.width Element.fill ]
                    { src = "/media/index_hero_banner_default_light.svg"
                    , description = "light default version of the Plabayo Hero Banner"
                    }
                ]
            , Element.row
                [ Element.width Element.fill ]
                [ Element.el
                    [ Element.Font.color (Element.rgb255 51 51 51)
                    , Element.Font.size 36
                    , Element.Font.family
                        [ Element.Font.typeface "Lato Hairline Italic"
                        , Element.Font.sansSerif
                        ]
                    , Element.Font.extraLight
                    , Element.Font.italic
                    , Element.Font.center
                    , Element.padding 10
                    ]
                    (Element.text "Free and Open Source Software")
                ]
            , Element.row
                [ Element.width Element.fill ]
                [ L18nUI.mdBlock
                    sharedModel.translate
                    [ Element.Font.color (Element.rgb255 51 51 51)
                    , Element.Font.family
                        [ Element.Font.typeface "Contra"
                        , Element.Font.serif
                        ]
                    , Element.padding 10
                    ]
                    (PageIndexIntroP1
                        { coFounderElizabeth = "[Elizabeth C. Gonzales Belsuzarri](https://www.linkedin.com/in/elizabeth-gonzales-belsuzarri-72173214/)"
                        , coFounderGlen = "[Glen Henri J. De Cauwsemaecker](https://www.glendc.com/)"
                        }
                    )
                ]
            , Element.row
                [ Element.width Element.fill ]
                [ L18nUI.mdBlock
                    sharedModel.translate
                    [ Element.Font.color (Element.rgb255 51 51 51)
                    , Element.Font.family
                        [ Element.Font.typeface "Contra"
                        , Element.Font.serif
                        ]
                    , Element.padding 10
                    ]
                    PageIndexIntroP2
                ]
            , Element.row
                [ Element.Region.navigation
                , Element.width Element.fill
                ]
                [ Element.el
                    [ Element.Font.color (Element.rgb255 51 51 51)
                    , Element.Font.size 28
                    , Element.Font.family
                        [ Element.Font.typeface "Lato Hairline Italic"
                        , Element.Font.sansSerif
                        ]
                    , Element.Font.extraLight
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
                        [ Element.Font.typeface "Contra"
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
                        [ Element.Font.typeface "Lato Hairline Italic"
                        , Element.Font.sansSerif
                        ]
                    , Element.Font.extraLight
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
                        [ Element.Font.typeface "Contra"
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
            , Shared.footer sharedModel
            ]
    }
