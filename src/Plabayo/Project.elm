module Plabayo.Project exposing
    ( Project
    , ProjectStatus(..)
    , boxTube
    , bucket
    , projects
    )

import Plabayo.L18n.Types exposing (Text(..))


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
