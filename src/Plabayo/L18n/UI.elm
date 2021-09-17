module Plabayo.L18n.UI exposing (hyperlink, mdBlock, paragraph, text)

import Plabayo.L18n
import Plabayo.L18n.Types exposing (Text(..), Translator)
import Element exposing (Element)
import Markdown.Parser
import Markdown.Renderer
import Plabayo.Markdown


text : Translator -> Text -> Element msg
text translate txt =
    Element.text <| translate txt


paragraph : Translator -> List (Element.Attribute msg) -> Text -> Element msg
paragraph translate attributes txt =
    Element.paragraph attributes [ text translate txt ]


mdBlock : Translator -> List (Element.Attribute msg) -> Text -> Element msg
mdBlock translate attributes txt =
    let
        rawText =
            translate txt

        mdElementsResult =
            Markdown.Parser.parse rawText
                |> Result.mapError deadEndsToString
                |> Result.andThen (\ast -> Markdown.Renderer.render Plabayo.Markdown.renderer ast)
    in
    case mdElementsResult of
        Err _ ->
            Element.el attributes <| Element.text rawText

        Ok mdElements ->
            Element.paragraph attributes mdElements


deadEndsToString deadEnds =
    deadEnds
        |> List.map Markdown.Parser.deadEndToString
        |> String.join "\n"


hyperlink : Translator -> List (Element.Attribute msg) -> Text -> String -> Element msg
hyperlink translate attributes label url =
    Element.link attributes
        { label = translate label |> Element.text , url = url }
