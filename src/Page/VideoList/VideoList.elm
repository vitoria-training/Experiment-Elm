module Page.VideoList.VideoList exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Page.CommonParts as CP

-- Fixed value
videoTitleFontSize : Float -> Int
videoTitleFontSize mainScreenWidth=
      round mainScreenWidth // 40

videoWindowWidth : Float -> Int
videoWindowWidth mainScreenWidth=
      ( round mainScreenWidth - round mainScreenWidth // 7 ) // 3

videoWindowHeight : Float -> Int
videoWindowHeight mainScreenHeight=
      round mainScreenHeight // 2

videoListElement : Float -> Float -> Element msg
videoListElement mainScreenWidth mainScreenHeight=
      let  
            assumption title video =
                  column[ paddingXY ( round mainScreenWidth // 50 ) 10
                        , spacing 3 ][
                        row[ Font.size ( videoTitleFontSize mainScreenWidth ) ][
                              Element.text title
                        ]
                        , row[ width <| px ( videoWindowWidth mainScreenWidth )
                              , height  <| px ( videoWindowHeight mainScreenHeight )
                              , Background.color ( rgb255 128 128 128 )
                              , Font.color ( rgb255 0 0 0 )
                              , Font.size ( videoTitleFontSize mainScreenWidth )
                              , centerX
                              , centerY
                        ][
                              Element.text video
                        ]
                  ]
                       
      in
      column[ scrollbarY
            , width fill
            , height  <| px ( CP.contentHeight mainScreenHeight ) ][
            row [ width fill ][
                  assumption "TITLE" "VIDEO"
                  , assumption "TITLE" "VIDEO"
                  , assumption "TITLE" "VIDEO"
            ]
            , row [ width fill ][
                  assumption "TITLE" "VIDEO"
                  , assumption "TITLE" "VIDEO"
                  , assumption "TITLE" "VIDEO"
            ]
            , row [ width fill ][
                  assumption "TITLE" "VIDEO"
                  , assumption "TITLE" "VIDEO"
                  , assumption "TITLE" "VIDEO"
            ]
      ]
