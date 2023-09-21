module Page.CommonParts exposing (..)

import Element exposing (..)

-- Fixed value
contentHeight : Float -> Int
contentHeight mainScreenHeight=
    round mainScreenHeight - round mainScreenHeight // 15 - round mainScreenHeight // 13
