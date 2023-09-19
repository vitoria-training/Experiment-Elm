module Page.Parts_elm_ui.VideoList exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Font as Font

videoListElement : Element msg
videoListElement =
      let  
            assumption =
                  row [width fill][
                        column[paddingXY 60 10
                              , spacing 10][
                              row[][Element.text "TITLE"]
                              , row[width <| px 510
                                    , height  <| px 300
                                    , Background.color (rgb255 211 211 211)
                                    , Font.color (rgb255 0 0 0)
                                    , Font.size 30
                                    , centerX
                                    , centerY
                              ][Element.text "VIDEO"]
                        ]
                        , column[paddingXY 60 10
                              , spacing 10][
                              row[][Element.text "TITLE"]
                              , row[width <| px 510
                                    , height  <| px 300
                                    , Background.color (rgb255 211 211 211)
                                    , Font.color (rgb255 0 0 0)
                                    , Font.size 30
                                    , centerX
                                    , centerY
                              ][Element.text "VIDEO"]
                        ]
                        , column[paddingXY 60 10
                              , spacing 10][
                              row[][Element.text "TITLE"]
                              , row[width <| px 510
                                    , height  <| px 300
                                    , Background.color (rgb255 211 211 211)
                                    , Font.color (rgb255 0 0 0)
                                    , Font.size 30
                                    , centerX
                                    , centerY
                              ][Element.text "VIDEO"]
                        ]
                  ]
      in
      column[scrollbarY
            , width fill
            , height  <| px 840][
            assumption
            , assumption
            , assumption
            , assumption
      ]

main = 
    Element.layout [height
        (fill
            |> minimum 300
            |> maximum 300
        )]
        videoListElement