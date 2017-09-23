module Reactor exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Html exposing (Attribute, Html, div, input, text)
import Main exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = reactorInit
        , view = reactorView
        , update = update
        , subscriptions = subscriptions
        }


reactorInit =
    init { dataPath = "/data/codes.json" }


reactorView model =
    div []
        [ CDN.stylesheet
        , Main.view model
        ]
