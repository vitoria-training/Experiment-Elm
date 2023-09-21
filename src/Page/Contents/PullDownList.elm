module Page.Contents.PullDownList exposing (..)

import Element exposing (..)
import Page.Contents.Parts.PullDownList_Parts as LP

videolink : Float -> Float -> Element msg
videolink mainScreenWidth mainScreenHeight=
    column [][
        LP.majorItems mainScreenWidth mainScreenHeight "git講習"
        , LP.minorItem mainScreenWidth mainScreenHeight "https://www.youtube.com/embed/Js_8xBDhhwE" "基本コマンド1"
        , LP.minorItem mainScreenWidth mainScreenHeight "https://www.youtube.com/embed/eZ9M16REQiQ" "基本コマンド2"
        , LP.majorItems mainScreenWidth mainScreenHeight "ゲーム講習"
        , LP.minorItem mainScreenWidth mainScreenHeight "https://www.youtube.com/embed/Ht6R3OosXDk" "【初歩編】第1回"
        , LP.minorItem mainScreenWidth mainScreenHeight "https://www.youtube.com/embed/9g-NnkrScng" "【初歩編】第2回"
    ]
