module Plabayo.L18n.Languages.Nl exposing (translate)

import Plabayo.L18n.Types exposing (Text(..))


translate : Text -> Maybe String
translate text =
    case text of
        -- Projects
        ProjectBucketTitle ->
            Just "Bucket"

        ProjectBucketDescription ->
            Just """Een Vrije en Open Source Web Applicatie dat je toelaat om je
vrije tijd bij te houden om er zo toekomstgericht gebruik van te kunnen maken."""

        _ ->
            Nothing

