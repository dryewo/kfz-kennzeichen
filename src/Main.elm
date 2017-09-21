module Main exposing (..)

import Dict exposing (..)
import Html exposing (Attribute, Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import Json.Decode as JD


main =
    Html.program
        { init = init
        , update = \msg model -> update msg model ! []
        , view = view
        , subscriptions = \_ -> Sub.none
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


update : Msg -> Model -> Model
update msg model =
    case msg of
        LoadedCodes (Ok codes) ->
            { model | codes = codes }

        LoadedCodes (Err err) ->
            { model | codes = Dict.empty, error = Just (Debug.log "err" err) }

        Change newCode ->
            { model | code = newCode, result = lookupCode model.codes newCode }



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


init : ( Model, Cmd Msg )
init =
    { code = "", result = "", codes = Dict.fromList [], error = Nothing } ! [ loadCodes "/data/codes.json" ]
