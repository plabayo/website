module Page.Projects exposing (Data, Model, Msg, page)

import Browser
import Browser.Navigation as Navigation
import DataSource exposing (DataSource)
import Element
import Element.Font
import Element.Input
import Element.Region
import Framework.Card
import Framework.Grid
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Plabayo.L18n.Types exposing (Text(..))
import Plabayo.L18n.UI as L18nUI
import Plabayo.Material.Icons as Icons
import Plabayo.Project exposing (Project, ProjectStatus(..), projects, projetCard)
import Shared
import View exposing (View)
import Widget
import Widget.Material as Material


type alias Model =
    ()


type Msg
    = GoToPage String


type alias RouteParams =
    {}


page : PageWithState RouteParams Data Model Msg
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildWithLocalState { init = init, update = update, subscriptions = subscriptions, view = view }


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


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> ( Model, Cmd Msg )
init maybeUrl sharedModel static =
    ( ()
    , Cmd.none
    )


update :
    PageUrl
    -> Maybe Navigation.Key
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> Msg
    -> Model
    -> ( Model, Cmd Msg )
update pageUrl maybeNavKey sharedModel static msg model =
    case msg of
        GoToPage url ->
            ( model, Navigation.load url )


subscriptions :
    Maybe PageUrl
    -> RouteParams
    -> Path
    -> Model
    -> Sub Msg
subscriptions maybeUrl route path model =
    Sub.none


projectCards : Shared.Model -> List (Element.Element Msg)
projectCards sharedModel =
    projects
        |> List.filter (\project -> project.status == StatusWIP || project.status == StatusReleased)
        |> List.map (projetCard sharedModel (\url -> GoToPage url))


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel model static =
    { title = sharedModel.translate PageProjectsTitle
    , body =
        Element.column
            [ Element.centerX
            , Element.alignTop
            , Element.paddingXY 0 30
            , Element.width Element.fill
            , Element.Region.mainContent
            ]
            [ Element.row
                [ Element.width Element.fill ]
                [ Element.image [ Element.width Element.fill ]
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
            , Element.row [ Element.width Element.fill ]
                [ Element.column
                    (Framework.Grid.simple ++ [ Element.paddingXY 0 20 ])
                    (projectCards sharedModel)
                ]
            ]
    }
