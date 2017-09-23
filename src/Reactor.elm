module Reactor exposing (..)

import Html
import Main exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init { dataPath = "/data/codes.json" }
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
