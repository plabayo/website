module Plabajo.L18n.Languages.Es exposing (translate)

import Plabajo.L18n.Types exposing (Text(..))


translate : Text -> Maybe String
translate text =
    case text of
        _ ->
            Nothing
