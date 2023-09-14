module Page.Parts_elm_ui.List exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font

videolink : Element msg
videolink =
    column [][
        el [width (px 320)
                , height (px 30)
                , Background.color (rgb255 255 255 255)
                , Font.color (rgb255 0 0 0)]
                (Element.text "git講習")
        , row [][
            Element.newTabLink[ width (px 320)
                , height (px 60)
                , Background.color (rgb255 0 0 0)
                , Font.color (rgb255 255 255 255)
            ]
            { url = "https://www.youtube.com/embed/Js_8xBDhhwE"
                , label = text "基本コマンド1"
            }
        ]
        ,  row [][
            Element.newTabLink[ width (px 320)
                , height (px 60)
                , Background.color (rgb255 0 0 0)
                , Font.color (rgb255 255 255 255)
            ]
            { url = "https://www.youtube.com/embed/eZ9M16REQiQ"
                , label = text "基本コマンド2"
            }
        ]
        , el [width (px 320)
                , height (px 30)
                , Background.color (rgb255 255 255 255)
                , Font.color (rgb255 0 0 0)
                ](Element.text "ゲーム講習")
        ,  row [][
            Element.newTabLink[ width (px 320)
                , height (px 60)
                , Background.color (rgb255 0 0 0)
                , Font.color (rgb255 255 255 255)
            ]
            { url = "https://www.youtube.com/embed/Ht6R3OosXDk"
                , label = text "【初歩編】第1回"
            }
        ]
        ,  row [][
            Element.newTabLink[ width (px 320)
                , height (px 60)
                , Background.color (rgb255 0 0 0)
                , Font.color (rgb255 255 255 255)
            ]
            { url = "https://www.youtube.com/embed/9g-NnkrScng"
                , label = text "【初歩編】第2回"
            }
        ]
    ]
