module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element
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
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
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
            , Element.width (Element.px 960)
            ]
            [ Element.row
                [ Element.width Element.fill ]
                [ Element.image [ Element.centerX ]
                    { src = "/media/index_hero_banner_default_light.svg"
                    , description = "light default version of the Plabajo Hero Banner"
                    }
                ]
            , Element.row
                [ Element.width Element.fill ]
                [ Element.text "play, work and grow" ]
            , Element.row
                [ Element.width Element.fill ]
                [ Element.text "> Plabajo was co-founded in 2021 by Elizabeth C. Gonzales Belsuzarri and Glen Henri J. De Cauwsemaecker. _" ]
            ]
    }
