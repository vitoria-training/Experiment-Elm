module Page.Footer exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Page.CommonParts as CP

-- Fixed value
footerFontSize : Float -> Int
footerFontSize mainScreenWidth =
    round mainScreenWidth // 70

footerHeight : Float -> Int
footerHeight mainScreenHeight =
    round mainScreenHeight // 13

footerPadding : { top : number, left : number, right : number, bottom : number }
footerPadding =
    { top = 0
    , left = 10
    , right = 10
    , bottom = 30 }

-- Display item template
footerElement : Float -> Float -> Element msg
footerElement mainScreenWidth mainScreenHeight=
    column [width fill][
        row [Element.width fill][
            el[ Background.color CP.rgbGray
            , Font.color CP.rgbBlack
            , Font.size ( footerFontSize mainScreenWidth )
            , paddingEach footerPadding
            , width fill
            , height <| px ( footerHeight mainScreenHeight )
            ]
            (text """© 2023 React Inc. All Rights Reserved.\nI'm happy! thank you!""")
        ]
    ]