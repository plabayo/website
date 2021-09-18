module Plabayo.Material.Palette exposing
    ( darkPalette
    , defaultPalette
    )

import Color exposing (Color)
import Widget.Material exposing (Palette)



-- TODO: change to our own color, this is still the default Material palette


defaultPalette : Palette
defaultPalette =
    { primary = Color.rgb255 0x62 0x00 0xEE
    , secondary = Color.rgb255 0x03 0xDA 0xC6
    , background = Color.rgb255 0xFF 0xFF 0xFF
    , surface = Color.rgb255 0xFF 0xFF 0xFF
    , error = Color.rgb255 0xB0 0x00 0x20
    , on =
        { primary = Color.rgb255 0xFF 0xFF 0xFF
        , secondary = Color.rgb255 0x00 0x00 0x00
        , background = Color.rgb255 0x00 0x00 0x00
        , surface = Color.rgb255 0x00 0x00 0x00
        , error = Color.rgb255 0xFF 0xFF 0xFF
        }
    }



-- TODO: change to our own color, this is still the default dark Material palette


darkPalette : Palette
darkPalette =
    { primary = Color.rgb255 0xBB 0x86 0xFC
    , secondary = Color.rgb255 0x03 0xDA 0xC6
    , background = Color.rgb255 0x12 0x12 0x12
    , surface = Color.rgb255 0x12 0x12 0x12
    , error = Color.rgb255 0xCF 0x66 0x79
    , on =
        { primary = Color.rgb255 0x00 0x00 0x00
        , secondary = Color.rgb255 0x00 0x00 0x00
        , background = Color.rgb255 0xFF 0xFF 0xFF
        , surface = Color.rgb255 0xFF 0xFF 0xFF
        , error = Color.rgb255 0x00 0x00 0x00
        }
    }
