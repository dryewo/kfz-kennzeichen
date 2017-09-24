module Main exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Dict exposing (..)
import Html exposing (Attribute, Html, div, input, text, h2)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import Json.Decode as JD


main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { code : String
    , result : String
    , codes : Dict String String
    , codesLoadError : Maybe Http.Error
    }



-- UPDATE


type Msg
    = Change String
    | LoadedCodes (Result Http.Error CodeDict)


type alias CodeDict =
    Dict String String


lookupCode : CodeDict -> String -> String
lookupCode codes code =
    if String.isEmpty code then
        ""
    else
        case Dict.get (String.toUpper code) codes of
            Just res ->
                res

            Nothing ->
                "Not found"


update =
    \msg model -> updateImpl msg model ! []


updateImpl : Msg -> Model -> Model
updateImpl msg model =
    case msg of
        LoadedCodes (Ok codes) ->
            { model | codes = codes }

        LoadedCodes (Err err) ->
            { model | codes = Dict.empty, codesLoadError = Just (Debug.log "err" err) }

        Change newCode ->
            { model | code = newCode, result = lookupCode model.codes newCode }



-- SUBSCRIPTIONS


subscriptions =
    always Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    Grid.container []
        [ Grid.row []
            [ Grid.col [ Col.xs12 ]
                [ h2 [] [ text "KFZ-Kennzeichen" ]
                , Input.text
                    [ Input.large
                    , Input.placeholder "Code"
                    , Input.onInput Change
                    , Input.value (String.toUpper model.code)
                    , Input.attrs [autofocus True, style [("font-size", "48px")]]
                    ]
                , div [style [("font-size", "32px")]] [ text model.result ]
                ]
            ]
        ]



-- INIT


loadCodes : String -> Cmd Msg
loadCodes url =
    Http.send LoadedCodes (Http.get url (JD.dict JD.string))


type alias Flags =
    { dataPath : String }


init : Flags -> ( Model, Cmd Msg )
init flags =
    { code = "", result = "", codes = Dict.fromList [], codesLoadError = Nothing } ! [ loadCodes flags.dataPath ]
