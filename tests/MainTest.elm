module MainTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Works"
        [ test "Indeed" <|
            \() ->
                Expect.equal 1 1
        ]
