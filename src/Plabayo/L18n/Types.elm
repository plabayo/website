module Plabayo.L18n.Types exposing (Text(..), Translator)


type
    Text
    -- Navigation:
    = NavButtonHome
    | NavButtonBlog
    | NavButtonProjects
      -- Page: Index
    | PageIndexIntroP1
        { coFounderElizabeth : String
        , coFounderGlen : String
        }
    | PageIndexIntroP2
    | PageIndexIntroP3
        { emailContact : String
        }
      -- Shared: Page
    | SharedPageFooter
        { coFounderElizabeth : String
        , coFounderGlen : String
        , licenseWeb : String
        }
      -- Project: Bucket
    | ProjectBucketTitle
    | ProjectBucketDescription
    | ProjectBucketSummary
      -- Project: BoxTube
    | ProjectBoxTubeTitle
    | ProjectBoxTubeDescription
    | ProjectBoxTubeSummary


type alias Translator =
    Text -> String
