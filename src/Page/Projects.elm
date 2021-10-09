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
            (Framework.Grid.simple ++ [ Element.paddingXY 0 20 ])
            (projectCards sharedModel)
    }
