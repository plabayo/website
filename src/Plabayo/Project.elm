module Plabayo.Project exposing
    ( Project
    , bucket
    )

import Plabayo.L18n.Types exposing (Text(..))


type ProjectStatus
    = WIP
    | Released
    | Archived


type alias Project =
    { id : String
    , title : Text
    , description : Text
    , summary : Text
    , url : String
    , featured : Bool
    , status : ProjectStatus
    }


bucket : Project
bucket =
    { id = "bucket"
    , title = ProjectBucketTitle
    , description = ProjectBucketDescription
    , summary = ProjectBucketSummary
    , url = "https://bckt.xyz"
    , featured = True
    , status = WIP
    }


boxTube : Project
boxTube =
    { id = "boxtube"
    , title = ProjectBoxTubeTitle
    , description = ProjectBoxTubeDescription
    , summary = ProjectBoxTubeSummary
    , url = "https://github.com/plabayo/boxtube"
    , featured = True
    , status = WIP
    }
