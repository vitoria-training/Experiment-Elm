module Page.Parts_elm_ui.Footer exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font

main = 
    Element.layout []<|
        column[width fill][
            footerElement
        ]

footerElement : Element msg
footerElement =
    column [width fill][
        row [Element.width fill][
            el
            [ Background.color (rgb255 128 128 128)
            , Font.color (rgb255 0 0 0)
            , paddingEach { top = 0, left = 10, right = 10, bottom = 30 }
            , width fill
            , height <| px 70
            ]
            (text """© 2023 React Inc. All Rights Reserved.\nI'm happy! thank you!""")
        ]
    ]