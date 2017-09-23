module Main exposing (..)

import Dict exposing (..)
import Html exposing (Attribute, Html, div, input, text)
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
    , error : Maybe Http.Error
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
            { model | codes = Dict.empty, error = Just (Debug.log "err" err) }

        Change newCode ->
            { model | code = newCode, result = lookupCode model.codes newCode }



-- SUBSCRIPTIONS


subscriptions =
    always Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Region code", onInput Change, value model.code ] []
        , div [] [ text model.result ]
        ]



-- INIT


loadCodes : String -> Cmd Msg
loadCodes url =
    Http.send LoadedCodes (Http.get url (JD.dict JD.string))


type alias Flags =
    { dataPath : String }


init : Flags -> ( Model, Cmd Msg )
init flags =
    { code = "", result = "", codes = Dict.fromList [], error = Nothing } ! [ loadCodes flags.dataPath ]
