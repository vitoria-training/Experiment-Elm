module Page.Contents.Parts.PullDownList_Parts exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Page.CommonParts as CP

-- Fixed value
listHeight : Float -> Int
listHeight mainScreenHeight =
    round mainScreenHeight // 20

listWidth : Float -> Int
listWidth mainScreenWidth =
    round mainScreenWidth // 6

-- Display item template
majorItems : Float -> Float -> String -> Element msg
majorItems mainScreenWidth mainScreenHeight title =
    el[ width <| px ( listWidth mainScreenWidth )
        , height <| px ( listHeight mainScreenHeight )
        , Background.color CP.rgbWhite
        , Font.color CP.rgbBlack
    ]( Element.text title )


minorItem : Float -> Float -> String -> String -> Element msg
minorItem mainScreenWidth mainScreenHeight linkUrl linkTitle =
    row [][ Element.newTabLink[ width <| px ( listWidth mainScreenWidth )
        , height <| px ( listHeight mainScreenHeight )
        , Background.color CP.rgbBlack
        , Font.color CP.rgbWhite
        ]
        { url = linkUrl
            , label = text linkTitle
        }
    ]