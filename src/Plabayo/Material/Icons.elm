module Plabayo.Material.Icons exposing (..)

import FeatherIcons
import Widget.Icon exposing (Icon)

blog : Icon msg
blog =
    FeatherIcons.bookOpen
        |> Widget.Icon.elmFeather FeatherIcons.toHtml

projects : Icon msg
projects =
    FeatherIcons.truck
        |> Widget.Icon.elmFeather FeatherIcons.toHtml
