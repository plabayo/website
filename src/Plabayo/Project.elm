module Plabayo.Project exposing
    ( Project
    , ProjectStatus(..)
    , boxTube
    , bucket
    , projects
    , projetCard
    )

import Element
import Element.Font
import Element.Input
import Element.Region
import Framework.Card
import Framework.Grid
import Plabayo.L18n.Types exposing (Text(..))
import Shared


projetCard : Shared.Model -> (String -> msg) -> Project -> Element.Element msg
projetCard sharedModel toMsg project =
    Element.Input.button
        Framework.Card.fill
        { onPress = toMsg project.url |> Just
        , label =
            Element.row
                Framework.Grid.spaceEvenly
                [ Element.column
                    [ Element.alignTop
                    , Element.px 80 |> Element.width
                    ]
                    [ Element.image
                        [ Element.width Element.fill
                        ]
                        { src = "/media/projects/" ++ project.id ++ "_card_icon.svg"
                        , description = "logo for project with id " ++ project.id
                        }
                    ]
                , Element.column
                    [ Element.width Element.fill
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
                            , Element.Font.size 16
                            , Element.Font.italic
                            , Element.Font.alignRight
                            ]
                            [ Element.text project.url ]
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
        }


type ProjectStatus
    = StatusWIP
    | StatusReleased
    | StatusArchived
    | StatusHidden


type alias Project =
    { id : String
    , title : Text
    , description : Text
    , summary : Text
    , url : String
    , featured : Bool
    , status : ProjectStatus
    }


projects : List Project
projects =
    [ bucket
    , boxTube
    ]


bucket : Project
bucket =
    { id = "bucket"
    , title = ProjectBucketTitle
    , description = ProjectBucketDescription
    , summary = ProjectBucketSummary
    , url = "https://bckt.xyz"
    , featured = True
    , status = StatusWIP
    }


boxTube : Project
boxTube =
    { id = "boxtube"
    , title = ProjectBoxTubeTitle
    , description = ProjectBoxTubeDescription
    , summary = ProjectBoxTubeSummary
    , url = "https://github.com/plabayo/boxtube"
    , featured = True
    , status = StatusWIP
    }
