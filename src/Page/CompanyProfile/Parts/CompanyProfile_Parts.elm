module Page.CompanyProfile.Parts.CompanyProfile_Parts exposing (..)

import Element exposing (..)
import Element.Border as Border
import Element.Font as Font
import Page.CommonParts as CP

-- Fixed value
companyProfileBorder : { bottom : number, left : number, right : number, top : number }
companyProfileBorder =
    { bottom = 0
    , left = 0
    , right = 0
    , top = 5 }

-- Display item template
companyProfileItem : Float -> String -> String -> Element msg
companyProfileItem mainScreenWidth title displayContent= 
    row [ width fill
        , Font.size ( round mainScreenWidth // 60 )
        , Border.widthEach companyProfileBorder
        , Border.color ( CP.rgbGray )
    , padding 10 ][
        column [ width <| px ( round mainScreenWidth // 3 )
            , Font.semiBold ] [
                text <| String.toUpper title
        ]
        , column [ width fill
            , Font.semiBold ] [
                text <| String.toUpper displayContent
        ]
    ]

companyProfileMap : Float -> Float -> String -> String -> String -> Element msg
companyProfileMap mainScreenWidth mainScreenHeight path description displayContent= 
    row [ width fill
        , Font.size ( round mainScreenWidth // 60 )
        , Border.widthEach companyProfileBorder
        , Border.color ( CP.rgbGray )
        , padding 10][
            column [ width <| px ( round mainScreenWidth // 3 )
                , height fill ] [ 
                Element.image [ width <| px ( round mainScreenWidth // 4 )
                    , height <| px ( round mainScreenHeight // 2 )
                    , paddingXY 30 0 ]
                    { src = path
                    , description = description }
            ]
            , column [ width fill
                , height fill
                , Font.semiBold ] [
                    text <| displayContent
            ]
    ]