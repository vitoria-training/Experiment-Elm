module Page.Parts_elm_ui.ContactForm exposing (..)

import Element exposing (..)
import Element.Region as Region
import Element.Font as Font

contactElement : Element msg
contactElement =
        row[scrollbarY,
            height <| px 841][
            column[width <| px 260][]
            , column [width fill
                , centerX
                , centerY][
                row [centerY
                    , padding 5]
                    [column [ width fill
                        , height fill
                        , Region.heading 2
                        , Font.size 30
                        , Font.semiBold] [text <| String.toUpper "CONTACT"]
                    ]
                , row [centerY]
                    [ column [ width fill
                        , height fill] [text <| String.toUpper "氏名"]
                    ]
                , row [centerY]
                    [ column [ width fill
                        , height fill] [text <| String.toUpper "メールアドレス"]
                    ]
                , row [centerY]
                    [ column [ width fill
                        , height fill] [text <| String.toUpper "題名"]
                    ]
                , row [centerY]
                    [ column [ width fill
                        , height fill] [text <| String.toUpper "メッセージ本文（任意）"]
                    ]
                ]
            ]