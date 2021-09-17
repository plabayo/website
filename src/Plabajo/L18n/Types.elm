module Plabayo.L18n.Types exposing (Text(..), Translator)


type
    Text
    -- Page: Index
    = PageIndexIntroP1
        { coFounderElizabeth : String
        , coFounderGlen : String
        }
    | PageIndexIntroP2
    -- Shared: Page
    | SharedPageFooter
        { coFounderElizabeth : String
        , coFounderGlen : String
        , licenseWeb : String
        }
    -- Projects
    | ProjectBucketTitle
    | ProjectBucketDescription


type alias Translator =
    Text -> String