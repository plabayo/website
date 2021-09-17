module Plabayo.L18n exposing
    ( Language(..)
    , negotiateLanguage
    , translate
    )

import Plabayo.L18n.Languages.En
import Plabayo.L18n.Languages.Es
import Plabayo.L18n.Languages.Nl
import Plabayo.L18n.Types exposing (Text(..))


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
            Plabayo.L18n.Languages.En.translate text

        Nl ->
            case Plabayo.L18n.Languages.Nl.translate text of
                Just t ->
                    t

                Nothing ->
                    Plabayo.L18n.Languages.En.translate text

        Es ->
            case Plabayo.L18n.Languages.Es.translate text of
                Just t ->
                    t

                Nothing ->
                    Plabayo.L18n.Languages.En.translate text
