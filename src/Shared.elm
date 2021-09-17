module Shared exposing (Data, Model, Msg(..), SharedMsg(..), footer, seoSummary, template)

import Browser.Navigation
import DataSource
import Element exposing (Element)
import Element.Font
import Element.Region
import Head.Seo as Seo
import Html exposing (Html)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    }


seoSummary : Seo.Common
seoSummary =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Plabajo Website"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Plabajo creates Free and Open Source Software"
        , locale = Nothing
        , title = "Plabajo Free and Open Source Software"
        }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


footer : Element msg
footer =
    Element.row
        [ Element.Region.footer
        , Element.width Element.fill
        ]
        [ Element.el
            [ Element.Font.center ]
            -- TODO: add links & markdown
            (Element.text "Website by Elizabeth C. Gonzales Belsuzarri and Glen Henri J. De Cauwsemaecker, licensed by CC BY NC SA 4.0.")
        ]


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    { body = Element.layout [ Element.width Element.fill ] pageView.body
    , title = pageView.title
    }
