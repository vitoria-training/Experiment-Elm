module Page.CompanyProfile.CompanyProfile exposing (..)

import Element exposing (..)
import Element.Region as Region
import Element.Font as Font
import Page.CompanyProfile.Parts.CompanyProfile_Parts as CPP
import Page.CommonParts as CP

companyElement : Float -> Float -> Element msg
companyElement mainScreenWidth mainScreenHeight=
        row[ scrollbarY
            , width fill
            , height <| px ( CP.contentHeight mainScreenHeight ) ][
            column[ width <| px ( round mainScreenWidth // 50 ) ][]
            , column [ width <| px ( round mainScreenWidth - round mainScreenWidth // 5 )
                , centerX
                , centerY ][
                row [ width fill ][
                    column [ width fill ] [
                        Element.image [ width fill
                            , height <| px ( round mainScreenHeight // 2 )
                            , centerX
                            , centerY ]
                            { src = "Picture/Spacecat.png"
                             , description = "Spacecat" }
                    ]
                ]
                , row [centerX
                    , centerY
                    , Font.size ( round mainScreenWidth // 50 )
                    , padding 5 ][
                    column [ width fill
                        , height fill
                        , Region.heading 1
                        , Font.semiBold ] [
                        text <| String.toUpper "会社概要"
                    ]
                ]
                , row [ centerX
                    , centerY
                    , Font.size ( round mainScreenWidth // 60 )][
                    column [ width fill
                        , height fill
                        , Region.heading 2
                        , Font.semiBold ] [
                        text <| String.toUpper "ABOUT"
                    ]
                ]
                , CPP.companyProfileItem mainScreenWidth "会社名" "株式会社XXXX"
                , CPP.companyProfileItem mainScreenWidth "設立" "YYYY年MM月DD日"
                , CPP.companyProfileItem mainScreenWidth "資本金" "X,XXX万円"
                , CPP.companyProfileItem mainScreenWidth "事業内容" 
                    """PlayStation・Nintendo Switch向けコンシューマゲーム、
                    \nソーシャルゲームの企画・開発
                    \n・VR、AR、3Dコンテンツの開発
                    \n・システムエンジニアリングサービス事業
                    \n・ドローンメディア運営事業
                    \n・IT関連事業の統合的ソリューションの展開"""
                , CPP.companyProfileItem mainScreenWidth "所在地" 
                    """〒100-0005 東京都千代田区丸の内１丁目"""
                , CPP.companyProfileMap mainScreenWidth mainScreenHeight "Picture/TokyoStation.png" "TokyoStation"
                    """東京メトロXX線「東京駅」XX出口から徒歩X分
                    \nJRYY線「YY堀駅」YY出口から徒歩Y分
                    \n都営ZZ線「ZZ駅」ZZ出口から徒歩Z分"""
            ]
        ]