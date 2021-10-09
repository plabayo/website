module Shared exposing (Data, Model, Msg(..), SharedMsg(..), seoSummary, template)

import Browser exposing (element)
import Browser.Navigation as Navigation
import DataSource
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font
import Element.Region
import Framework
import Framework.Grid
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
    | AnySharedMsg SharedMsg


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

        AnySharedMsg globalMsg ->
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
        Framework.responsiveLayout
            [ model.palette.background |> ColorPalettes.colorToElement |> Element.Background.color
            , Element.height Element.fill
            ]
        <|
            Element.el (Framework.container ++ [ Element.height Element.fill ]) <|
                Element.column
                    [ model.palette.background |> ColorPalettes.colorToElement |> Element.Background.color
                    , Element.height Element.fill
                    ]
                    -- menu bar
                    [ Element.row
                        (Framework.Grid.simple
                            ++ [ model.palette.primary |> ColorPalettes.colorToElement |> Element.Font.color
                               ]
                        )
                        [ Element.column
                            [ Element.alignLeft
                            ]
                            [ Widget.button (Material.containedButton model.palette)
                                { text = model.translate NavButtonHome
                                , icon = Icons.home
                                , onPress = GoToPage "/" |> AnySharedMsg |> toMsg |> Just
                                }
                            ]
                        , Element.column
                            [ Element.alignRight
                            ]
                            [ Element.row []
                                [ Element.column
                                    []
                                    [ Widget.button (Material.textButton model.palette)
                                        { text = model.translate NavButtonBlog
                                        , icon = Icons.blog
                                        , onPress = GoToPage "/blog" |> AnySharedMsg |> toMsg |> Just
                                        }
                                    ]
                                , Element.column
                                    []
                                    [ Widget.button (Material.textButton model.palette)
                                        { text = model.translate NavButtonProjects
                                        , icon = Icons.projects
                                        , onPress = GoToPage "/projects" |> AnySharedMsg |> toMsg |> Just
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
                        (Framework.Grid.section
                            ++ [ Element.width Element.fill
                               , Element.alignBottom
                               ]
                        )
                        [ Element.column
                            [ Element.Region.footer
                            , Element.width Element.fill
                            ]
                            [ L18nUI.mdBlock
                                model.translate
                                [ Element.Font.color (Element.rgb255 102 102 102)
                                , Element.Font.family
                                    [ Element.Font.typeface "Contra"
                                    , Element.Font.serif
                                    ]
                                , Element.Font.size 14
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
    , title = pageView.title
    }
