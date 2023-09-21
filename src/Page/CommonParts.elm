module Page.CommonParts exposing (..)

import Element exposing (..)

-- Fixed value
contentHeight : Float -> Int
contentHeight mainScreenHeight=
    round mainScreenHeight - round mainScreenHeight // 15 - round mainScreenHeight // 13

rgbBlack : Color
rgbBlack =
    rgb255 0 0 0

rgbGray : Color
rgbGray =
    rgb255 128 128 128

rgbLightgray : Color
rgbLightgray =
    rgb255 211 211 211

rgbWhite : Color
rgbWhite =
    rgb255 255 255 255
