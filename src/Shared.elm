module Shared exposing (Data, Model, Msg(..), SharedMsg(..), footer, seoSummary, template)

import Browser.Navigation
import DataSource
import Element exposing (Element)
import Element.Font
import Element.Region
import Head.Seo as Seo
import Html exposing (Html)
import Json.Decode
import Pages.Flags exposing (Flags(..))
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Plabajo.L18n as L18n
import Plabajo.L18n.UI as L18nUI
import Plabajo.L18n.Types exposing (Translator, Text(..))
import Random
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
    , translate : Translator
    , randomSeed : Random.Seed
    }


type alias Flags =
    { availableLocales : List String
    , initialRandomSeed : Int
    }


flagsDecoder : Json.Decode.Decoder Flags
flagsDecoder =
    Json.Decode.map2 Flags
        (Json.Decode.field "availableLocales" (Json.Decode.list Json.Decode.string))
        (Json.Decode.field "initialRandomSeed" Json.Decode.int)


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
    let
        ( language, seed ) =
            case flags of
                BrowserFlags rawFlags ->
                    Json.Decode.decodeValue flagsDecoder rawFlags
                        |> Result.andThen (\df -> ( L18n.negotiateLanguage df.availableLocales, df.initialRandomSeed ) |> Ok)
                        |> Result.withDefault ( L18n.En, 0 )

                PreRenderFlags ->
                    ( L18n.En, 0 )
    in
    ( { showMobileMenu = True
      , translate = L18n.translate language
      , randomSeed = Random.initialSeed seed
      }
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


footer : Model -> Element msg
footer sharedModel =
    Element.row
        [ Element.Region.footer
        , Element.width Element.fill
        ]
        [ L18nUI.mdBlock
            sharedModel.translate
            [ Element.Font.color (Element.rgb255 102 102 102)
            , Element.Font.family
                [ Element.Font.typeface "Contra"
                , Element.Font.serif
                ]
            , Element.Font.size 14
            , Element.paddingXY 10 20
            ]
            (SharedPageFooter
                { coFounderElizabeth = "[Elizabeth C. Gonzales Belsuzarri](https://www.linkedin.com/in/elizabeth-gonzales-belsuzarri-72173214/)"
                , coFounderGlen = "[Glen Henri J. De Cauwsemaecker](https://www.glendc.com/)"
                , licenseWeb = "[Creative Commons Zero v1.0 Universal](https://github.com/plabajo/website/blob/main/LICENSE)"
                }
            )
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
