module Site exposing (config)

import DataSource
import Head
import MimeType
import Pages.Manifest as Manifest
import Pages.Url
import Path
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig Data
config =
    { data = data
    , canonicalUrl = "https://plabayo.tech"
    , manifest = manifest
    , head = head
    }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head static =
    [ Head.icon [ ( 32, 32 ) ] MimeType.Png (localIconUrl MimeType.Png 32)
    , Head.icon [ ( 16, 16 ) ] MimeType.Png (localIconUrl MimeType.Png 16)
    , Head.appleTouchIcon (Just 180) (localIconUrl MimeType.Png 180)
    , Head.appleTouchIcon (Just 192) (localIconUrl MimeType.Png 192)
    , Head.rssLink "/blog/feed.xml"
    , Head.sitemapLink "/sitemap.xml"
    ]


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = "Plabayo Free and Open Source Software"
        , description = "Plabayo is an indie studio creating Free and Open Source Software"
        , startUrl = Route.Index |> Route.toPath
        , icons =
            [ localIcon MimeType.Png 192
            , localIcon MimeType.Png 512
            ]
        }
        |> Manifest.withShortName "Plabayo"


localIcon :
    MimeType.MimeImage
    -> Int
    -> Manifest.Icon
localIcon mimeType width =
    { src = localIconUrl mimeType width
    , sizes = [ ( width, width ) ]
    , mimeType = mimeType |> Just
    , purposes = [ Manifest.IconPurposeAny, Manifest.IconPurposeMaskable ]
    }


localIconUrl :
    MimeType.MimeImage
    -> Int
    -> Pages.Url.Url
localIconUrl mimeType width =
    let
        extension =
            case mimeType of
                MimeType.Png ->
                    ".png"

                _ ->
                    ".png"
    in
    Pages.Url.fromPath <|
        Path.fromString <|
            "/media/icon_"
                ++ String.fromInt width
                ++ extension



-- TODO: support ful manifest with color and all
