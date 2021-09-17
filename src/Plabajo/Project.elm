module Plabayo.Project exposing (..)

import Plabayo.L18n.Types exposing (Text(..))


type alias Project =
    { title : Text
    , description : Text
    , url : String
    , icon : String
    }


bucket : Project
bucket =
    Project
        { title = ProjectBucketTitle
        , description = ProjectBucketDescription
        , url = "https://bckt.xyz"
        , icon = "/media/project_bucket_icon.svg"
        }
