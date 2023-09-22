module Page.Contact.ContactForm exposing (..)

import Element exposing (..)
import Page.Contact.Parts.ContactForm_Parts as CFP
import Page.CommonParts as CP

-- Fixed value
contactFormWidth : Float -> Int
contactFormWidth mainScreenWidth=
    round mainScreenWidth // 12

contactElement : Float -> Float -> Element msg
contactElement mainScreenWidth mainScreenHeight=
        row[ scrollbarY,
            height <| px ( CP.contentHeight mainScreenHeight ) ][
            column[ width <| px ( contactFormWidth mainScreenWidth ) ][]
            , column [ width fill
                , centerX
                , centerY ][
                CFP.contactFormTitle mainScreenWidth "CONTACT"
                , CFP.inputItemName "氏名"
                , CFP.inputItemName "メールアドレス"
                , CFP.inputItemName "題名"
                , CFP.inputItemName "メッセージ本文（任意）"
            ]
        ]