module Plabayo.L18n.Languages.En exposing (translate)

import Plabayo.L18n.Types exposing (Text(..))


translate : Text -> String
translate text =
    case text of
        -- Navigation
        NavButtonHome ->
            "Plabajo"

        NavButtonBlog ->
            "Blog"

        NavButtonProjects ->
            "Projects"

        -- Page: Index
        PageIndexIntroP1 params ->
            "Plabayo was co-founded in 2021 by "
                ++ params.coFounderElizabeth
                ++ " and "
                ++ params.coFounderGlen
                ++ """. Our applications and games are the product, not you the user.
All data is yours and yours alone to keep. Privacy and transparency is at core of our mission.
The _"Free"_ in _"Free and Open Source Software"_ (_FOSS_) is about freedom and helps maintain the _civil liberal rights_.
It doesn not mean that all our products are gratis."""

        PageIndexIntroP2 ->
            """Our slogan is _"Play, Work and Grow"_, one we take as serious as it is playful.
Children learn by doing, but it is no different for adults.
Helping you in your life long journey of learning is at the core of our mission.
Thank you for trusting us and for using our products. 
"""

        PageIndexIntroP3 params ->
            "You can reach out to us by mail at " ++ params.emailContact ++ "."

        -- Shared: Page
        SharedPageFooter params ->
            String.concat
                [ "This website is designed and developed by "
                , params.coFounderElizabeth
                , " and "
                , params.coFounderGlen
                , ". This website is licensed under the "
                , params.licenseWeb
                , ". In the repository of that license you'll find the entire source code of this webpage."
                ]

        -- Projects
        ProjectBucketTitle ->
            "Bucket"

        ProjectBucketDescription ->
            """A Free and Open Source Web application allowing you to keep track
of your free time in order to spend that time on growth mindful of the future."""
