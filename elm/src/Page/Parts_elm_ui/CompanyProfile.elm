module Page.Parts_elm_ui.CompanyProfile exposing (..)

import Element exposing (..)
import Element.Region as Region
import Element.Border as Border
import Element.Font as Font

main = 
    Element.layout []
        companyElement

companyElement : Element msg
companyElement =
        row[scrollbarY
            , width fill
            , height <| px 841][
            column[width <| px 50][]
            , column [width <| px 1145
                , centerX
                , centerY][
                row [ width fill
                    , padding 10][]
                , row [][column [ width fill
                    , height fill] [ 
                    Element.image [width <| px 1145
                        , height <| px 400
                        , centerX
                        , centerY]
                        { src = "../Page/Test_Parts/Spacecat.png"
                        , description = "Spacecat"}
                    ]
                ]
                , row [centerX
                    , centerY
                    , padding 5]
                    [column [ width fill
                        , height fill
                        , Region.heading 1
                        , Font.size 30
                        , Font.semiBold] [text <| String.toUpper "会社概要"]
                    ]
                , row [centerX
                    , centerY]
                    [ column [ width fill
                        , height fill
                        , Region.heading 2
                        , Font.size 25
                        , Font.semiBold] [text <| String.toUpper "ABOUT"]
                    ]
                , row [ width fill
                    , Border.widthEach{
                        bottom = 0
                        , left = 0
                        , right = 0
                        , top = 5
                    }
                    , Border.color (rgb255 125 125 125)
                    , padding 10]
                    [ column [width <| px 400
                        , Font.size 20
                        , Font.semiBold] [text <| String.toUpper "会社名"]
                    , column [ width fill
                        , Font.size 20
                        , Font.semiBold] [text <| String.toUpper "株式会社XXXX"]
                    ]
                , row [ width fill
                    , Border.widthEach{
                        bottom = 0
                        , left = 0
                        , right = 0
                        , top = 5
                    }
                    , Border.color (rgb255 125 125 125)
                    , padding 10]
                    [ column [width <| px 400
                        , height fill
                        , Font.size 20
                        , Font.semiBold] [text <| String.toUpper "設立"]
                    , column [  height fill
                        , Font.size 20
                        , Font.semiBold] [text <| String.toUpper "YYYY年MM月DD日"]
                    ]
                , row [ width fill
                    , Border.widthEach{
                        bottom = 0
                        , left = 0
                        , right = 0
                        , top = 5
                    }
                    , Border.color (rgb255 125 125 125)
                    , padding 10]
                    [ column [width <| px 400
                        , height fill
                        , Font.size 20
                        , Font.semiBold] [text <| String.toUpper "資本金"]
                    , column [ height fill
                        , Font.size 20
                        , Font.semiBold] [text <| String.toUpper "X,XXX万円"]
                    ]
                , row [ width fill
                    , Border.widthEach{
                        bottom = 0
                        , left = 0
                        , right = 0
                        , top = 5
                    }
                    , Border.color (rgb255 125 125 125)
                    , padding 10]
                    [ column [ width <| px 400
                        , height fill
                        , Font.size 20
                        , Font.semiBold] [text <| String.toUpper "事業内容"]
                    , column [ height fill
                        , Font.size 20
                        , Font.semiBold] [text <|
                         """PlayStation・Nintendo Switch向けコンシューマゲーム、
                        \nソーシャルゲームの企画・開発
                        \n・VR、AR、3Dコンテンツの開発
                        \n・システムエンジニアリングサービス事業
                        \n・ドローンメディア運営事業
                        \n・IT関連事業の統合的ソリューションの展開"""
                        ]
                    ]
                , row [ width fill
                    , Border.widthEach{
                        bottom = 0
                        , left = 0
                        , right = 0
                        , top = 5
                    }
                    , Border.color (rgb255 125 125 125)
                    , padding 10]
                    [ column [width <| px 400
                        , height fill
                        , Font.size 20
                        , Font.semiBold] [text <| String.toUpper "所在地"]
                    , column [ width fill
                        , height fill
                        , Font.size 20
                        , Font.semiBold] [text <| """〒100-0005 東京都千代田区丸の内１丁目"""
                        ]
                    ]
                , row [ width fill
                    , Border.widthEach{
                        bottom = 0
                        , left = 0
                        , right = 0
                        , top = 5
                    }
                    , Border.color (rgb255 125 125 125)
                    , padding 10]
                    [ column [ width <| px 400
                        , height fill] [ 
                        Element.image [width <| px 350
                            , height <| px 300
                            , paddingXY 10 0]
                        { src = "../Page/Test_Parts/TokyoStation.png"
                        , description = "TokyoStation"}
                        ]
                    , column [ width fill
                        , height fill
                        , Font.size 20
                        , Font.semiBold] [ text <|
                        """東京メトロXX線「東京駅」XX出口から徒歩X分
                        \nJRYY線「YY堀駅」YY出口から徒歩Y分
                        \n都営ZZ線「ZZ駅」ZZ出口から徒歩Z分"""
                        ]
                    ]
                ]
                , column[width <| px 50][]
            ]