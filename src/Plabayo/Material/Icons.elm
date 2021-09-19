module Plabayo.Material.Icons exposing 
    ( home
    , blog
    , projects
    )


import FeatherIcons
import Widget.Icon exposing (Icon)


home : Icon msg
home =
    FeatherIcons.home
        |> Widget.Icon.elmFeather FeatherIcons.toHtml


blog : Icon msg
blog =
    FeatherIcons.bookOpen
        |> Widget.Icon.elmFeather FeatherIcons.toHtml


projects : Icon msg
projects =
    FeatherIcons.truck
        |> Widget.Icon.elmFeather FeatherIcons.toHtml
