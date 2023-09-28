module Page.Contact.Parts.Contact_Parts exposing (..)

import Element exposing (..)
import Element.Region as Region
import Element.Font as Font

-- Fixed value
contactFormFontSize : Float -> Int
contactFormFontSize mainScreenWidth=
    round mainScreenWidth // 50

-- Display item template
contactFormTitle : Float -> String -> Element msg
contactFormTitle mainScreenWidth title=
    row [ centerY
        , padding 5
        , Font.size ( contactFormFontSize mainScreenWidth )
        , Font.semiBold
        , Region.heading 2 ][
        column [ width fill
            , height fill ] [
            text <| String.toUpper title
        ]
    ]

inputItemName : String -> Element msg
inputItemName itemName= 
    row [ centerY ][
        column [ width fill
            , height fill ] [
            text <| String.toUpper itemName
        ]
    ]