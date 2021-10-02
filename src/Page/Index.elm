module Page.Index exposing (Data, Model, Msg, page)

import Browser
import Browser.Navigation as Navigation
import DataSource exposing (DataSource)
import Element
import Element.Font
import Element.Region
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Plabayo.L18n.Types exposing (Text(..))
import Plabayo.L18n.UI as L18nUI
import Plabayo.Material.Icons as Icons
import Plabayo.Project exposing (Project, ProjectStatus(..), projects)
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


projetCard : Shared.Model -> Project -> Element.Element msg
projetCard sharedModel project =
    Element.row
        [ Element.width Element.fill
        , Element.paddingXY 0 10
        ]
        [ Element.column
            [ Element.px 80 |> Element.width
            ]
            [ Element.image
                    [ Element.centerX
                    , Element.centerY
                    , Element.width Element.fill
                    ]
                    { src = "/media/projects/" ++ project.id ++ "_card_icon.svg"
                    , description = "logo for project with id " ++ project.id
                    }
                ]
        , Element.column
            [ Element.fillPortion 8 |> Element.width
            , Element.alignRight
            , Element.paddingEach
                { left = 20
                , right = 0 
                , top = 0
                , bottom = 0
                }
            ]
            [ Element.row
                [ Element.width Element.fill
                , Element.paddingXY 0 5
                ]
                [ Element.column
                    [ Element.alignLeft
                    , Element.alignBottom
                    ]
                    [ Element.el
                        [ Element.Region.heading 1
                        , Element.Font.bold
                        ]
                        (Element.text (sharedModel.translate project.title))
                    ]
                , Element.column
                    [ Element.alignRight
                    , Element.alignBottom
                    ]
                    [ Element.link
                        [ Element.Font.size 16
                        , Element.Font.italic
                        ]
                        { url = project.url
                        , label = Element.text project.url
                        }
                    ]
                ]
            , Element.row
                [ Element.width Element.fill
                , Element.paddingXY 0 10
                ]
                [ Element.el
                    [ Element.Font.size 16
                    ]
                    (Element.text (sharedModel.translate project.summary))
                ]
            ]
        ]


projectCards : Shared.Model -> List (Element.Element msg)
projectCards sharedModel =
    projects
        |> List.filter (\project -> (project.status == StatusWIP || project.status == StatusReleased) && project.featured)
        |> List.map (projetCard sharedModel)


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel model static =
    { title = "Plabayo"
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
                [ Element.width Element.fill
                , Element.Font.color (Element.rgb255 51 51 51)
                , Element.Font.family
                    [ Element.Font.typeface "Contra"
                    , Element.Font.serif
                    ]
                , Element.padding 10
                ]
                [ Element.column [ Element.width Element.fill ]
                    [ Element.row [ Element.paddingXY 0 5 ]
                        [ L18nUI.mdBlock
                            sharedModel.translate
                            []
                            (PageIndexIntroP1
                                { coFounderElizabeth = "[Elizabeth C. Gonzales Belsuzarri](https://www.linkedin.com/in/elizabeth-gonzales-belsuzarri-72173214/)"
                                , coFounderGlen = "[Glen Henri J. De Cauwsemaecker](https://www.glendc.com/)"
                                }
                            )
                        ]
                    , Element.row [ Element.paddingXY 0 5 ]
                        [ L18nUI.mdBlock
                            sharedModel.translate
                            []
                            PageIndexIntroP2
                        ]
                    , Element.row [ Element.paddingXY 0 5 ]
                        [ L18nUI.mdBlock
                            sharedModel.translate
                            []
                            (PageIndexIntroP3
                                { emailContact = "[contact@plabayo.tech](mailto:contact@plabayo.tech)"
                                }
                            )
                        ]
                    ]
                ]
            , Element.row
                [ Element.Region.navigation
                , Element.width Element.fill
                ]
                [ Element.el
                    [ Element.padding 10
                    ]
                    (Widget.button (Material.textButton sharedModel.palette)
                        { text = sharedModel.translate NavButtonBlog
                        , icon = Icons.blog
                        , onPress = GoToPage "/blog" |> Just
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
                    [ Element.padding 10
                    ]
                    (Widget.button (Material.textButton sharedModel.palette)
                        { text = sharedModel.translate NavButtonProjects
                        , icon = Icons.projects
                        , onPress = GoToPage "/projects" |> Just
                        }
                    )
                ]
            , Element.row
                [ Element.width Element.fill
                ]
                [ Element.column
                    [ Element.width Element.fill ]
                    (projectCards sharedModel)
                ]
            ]
    }
