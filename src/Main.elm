module Main exposing (..)

import Dict exposing (..)
import Html exposing (Attribute, Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { code : String
    , result : String
    }


model : Model
model =
    { code = "", result = "" }



-- UPDATE


type Msg
    = Change String


codes =
    Dict.fromList
        [ ( "B", "Berlin" )
        , ( "HH", "Hamburg" )
        ]


lookupCode : String -> String
lookupCode code =
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
        Change newCode ->
            { model | code = newCode, result = lookupCode newCode }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Region code", onInput Change ] []
        , div [] [ text model.result ]
        ]
