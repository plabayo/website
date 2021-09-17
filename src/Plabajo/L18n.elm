module Plabajo.L18n exposing
    ( Language(..)
    , negotiateLanguage
    , translate
    )

import Plabajo.L18n.Languages.En
import Plabajo.L18n.Languages.Es
import Plabajo.L18n.Languages.Nl
import Plabajo.L18n.Types exposing (Text(..))


type Language
    = En
    | Nl
    | Es


negotiateLanguage : List String -> Language
negotiateLanguage locales =
    locales
        |> List.foldl
            (\str acc ->
                case acc of
                    Just locale ->
                        Just locale

                    Nothing ->
                        case str |> String.split "-" |> List.head |> Maybe.withDefault "en" |> String.toLower |> String.trim of
                            "en" ->
                                Just En

                            "nl" ->
                                Just Nl

                            "es" ->
                                Just Es

                            _ ->
                                Nothing
            )
            Nothing
        |> Maybe.withDefault En


translate : Language -> Text -> String
translate lang text =
    case lang of
        En ->
            Plabajo.L18n.Languages.En.translate text

        Nl ->
            case Plabajo.L18n.Languages.Nl.translate text of
                Just t ->
                    t

                Nothing ->
                    Plabajo.L18n.Languages.En.translate text

        Es ->
            case Plabajo.L18n.Languages.Es.translate text of
                Just t ->
                    t

                Nothing ->
                    Plabajo.L18n.Languages.En.translate text
