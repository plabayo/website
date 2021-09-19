module Shared exposing (Data, Model, Msg(..), SharedMsg(..), seoSummary, template)

import Browser exposing (element)
import Browser.Navigation as Navigation
import DataSource
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font
import Element.Region
import Head.Seo as Seo
import Html exposing (Html)
import Html.Attributes exposing (title)
import Json.Decode
import Pages.Flags exposing (Flags(..))
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path exposing (Path)
import Plabayo.L18n as L18n
import Plabayo.L18n.Types exposing (Text(..), Translator)
import Plabayo.L18n.UI as L18nUI
import Plabayo.Material.Icons as Icons
import Plabayo.Material.Palette as ColorPalettes
import Random
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)
import Widget
import Widget.Material as Material exposing (Palette)


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
    = GoToPage String


type alias Model =
    { showMobileMenu : Bool
    , translate : Translator
    , randomSeed : Random.Seed
    , palette : Palette
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
        , siteName = "Plabayo Website"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Plabayo creates Free and Open Source Software"
        , locale = Nothing
        , title = "Plabayo Free and Open Source Software"
        }


init :
    Maybe Navigation.Key
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
      , palette = ColorPalettes.defaultPalette
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            case globalMsg of
                GoToPage url ->
                    ( model, Navigation.load url )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


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
    { body =
        Element.column
            [ Element.width Element.fill
            , Element.height Element.fill
            , model.palette.background |> ColorPalettes.colorToElement |> Element.Background.color
            ]
            -- menu bar
            [ Element.row
                [ Element.width Element.fill

                -- , Element.Border.widthEach
                --     { bottom = 1
                --     , left = 0
                --     , right = 0
                --     , top = 0
                --     }
                -- , model.palette.primary |> ColorPalettes.colorToElement |> Element.Border.color
                , model.palette.primary |> ColorPalettes.colorToElement |> Element.Font.color

                -- , model.palette.secondary |> ColorPalettes.colorToElement |> Element.Background.color
                ]
                [ Element.column
                    [ Element.alignLeft
                    , Element.padding 10
                    ]
                    [ Widget.button (Material.containedButton model.palette)
                        { text = model.translate NavButtonHome
                        , icon = Icons.home
                        , onPress = Nothing --GoToPage "/" |> SharedMsg |> Just
                        }
                    ]
                , Element.column
                    [ Element.alignRight
                    , Element.paddingXY 20 0
                    ]
                    [ Element.row []
                        [ Element.column
                            [ Element.alignRight
                            , Element.paddingEach
                                { top = 0
                                , right = 0
                                , bottom = 0
                                , left = 10
                                }
                            ]
                            [ Widget.button (Material.containedButton model.palette)
                                { text = model.translate NavButtonBlog
                                , icon = Icons.blog
                                , onPress = Nothing --GoToPage "/" |> SharedMsg |> Just
                                }
                            ]
                        , Element.column
                            [ Element.alignRight
                            , Element.paddingEach
                                { top = 0
                                , right = 0
                                , bottom = 0
                                , left = 10
                                }
                            ]
                            [ Widget.button (Material.containedButton model.palette)
                                { text = model.translate NavButtonProjects
                                , icon = Icons.projects
                                , onPress = Nothing --GoToPage "/" |> SharedMsg |> Just
                                }
                            ]
                        ]
                    ]
                ]

            -- content
            , Element.row
                [ Element.maximum 720 Element.fill |> Element.width
                , Element.centerX
                ]
                [ pageView.body ]

            -- footer
            , Element.row
                [ Element.width Element.fill
                , Element.alignBottom
                ]
                [ Element.column
                    [ Element.Region.footer
                    , Element.maximum 800 Element.fill |> Element.width
                    , Element.centerX
                    ]
                    [ L18nUI.mdBlock
                        model.translate
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
                            , licenseWeb = "[Creative Commons Zero v1.0 Universal](https://github.com/plabayo/website/blob/main/LICENSE)"
                            }
                        )
                    ]
                ]
            ]
            |> Element.layout
                [ Element.width Element.fill
                , Element.height Element.fill
                ]
    , title = pageView.title
    }
