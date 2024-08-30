module Graphics exposing (..)

import Element exposing (Attribute, Element, el, html)
import Svg exposing (line, path, svg)
import Svg.Attributes
    exposing
        ( d
        , fill
        , height
        , stroke
        , strokeLinejoin
        , strokeWidth
        , viewBox
        , width
        , x1
        , x2
        , y1
        , y2
        )


arrow : List (Attribute msg) -> Element msg
arrow attr =
    el ([] ++ attr) <|
        html <|
            svg [ viewBox "0 0 100 100", width "100%", height "100%" ]
                [ path
                    [ d "M 10 30 L 50 70 L 90 30 Z" -- This path draws a downward arrow
                    , fill "none"
                    , stroke "white"
                    , strokeWidth "4"
                    , strokeLinejoin "round"
                    ]
                    []
                ]


verticalBar : List (Attribute msg) -> Element msg
verticalBar attr =
    el ([] ++ attr) <|
        html <|
            svg [ viewBox "0 0 50 100", width "100%", height "100%" ]
                [ line
                    [ x1 "25"
                    , y1 "10"
                    , x2 "25"
                    , y2 "90"
                    , stroke "white"
                    , strokeWidth "2"
                    ]
                    []
                ]
