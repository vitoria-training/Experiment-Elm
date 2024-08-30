module View exposing (..)

import Animator
import Browser
import Color
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onMouseEnter)
import Element.Font as Font exposing (center)
import Element.Input as Input
import Element.Region as Region
import Graphics exposing (arrow, verticalBar)
import Html exposing (Html)
import Html.Attributes
import Types exposing (..)



--View


view : Model -> Browser.Document Msg
view model =
    let
        layout_ =
            case ( model.device.class, model.device.orientation ) of
                ( Phone, _ ) ->
                    phoneLayout model

                ( Desktop, Portrait ) ->
                    tabletLayout model

                ( Desktop, _ ) ->
                    desktopLayout model

                ( BigDesktop, _ ) ->
                    bigDesktopLayout model

                ( Tablet, _ ) ->
                    tabletLayout model
    in
    { title = "sprout", body = [ layout_ ] }



-- Layouts


phoneLayout : Model -> Html Msg
phoneLayout model =
    let
        viewportHeight =
            (px << round) model.viewport_.viewport.height

        arrow_ =
            arrow [ width <| px 46, height <| px 46, centerX ]

        descriptionLeft_ =
            description serviceDetailParagraphLeft [ centerY, width <| fillPortion 2, Font.size 14, Font.color Color.black ]

        descriptionRight_ =
            description serviceDetailParagraphRight [ centerY, width <| fillPortion 2, Font.size 14, Font.color Color.black ]   

        headerLeft_ =
            el [ centerX, centerY, Font.size 16, Font.color Color.black ] <| text "自分のペースで学べる実践的オンラインプログラム"

        headerRight_ =
            el [ centerX, centerY, Font.size 16 , Font.color Color.black] <| text "パーソナライズされた個別指導型プロジェクト"    
    in
    layout
        [ height fill
        , width fill
        , Font.family [ Font.typeface "Noto Sans JP" ]
        , inFront <| headerPhoneEl model []
        ]
    <|
        column
            [ height fill
            , width fill
            ]
            [ topTileEl (topContent 36 [ padding 20 ]) arrow_ [ height viewportHeight ]
            , serviceAbstructEl serviceAbstructPhone [ height viewportHeight, htmlAttribute (Html.Attributes.id "service") ]
            , phonePragraphEl headerLeft_ descriptionLeft_ [ height viewportHeight, Background.image "../image/background/service_details1.webp" ]
            , phonePragraphEl headerRight_ descriptionRight_ [ height viewportHeight, Background.image "../image/background/service_details2.webp" ]
            , footerEl [ htmlAttribute (Html.Attributes.id "contact"), Font.size 12 ]
            ]


phonePragraphEl : Element msg -> Element msg -> List (Attribute msg) -> Element msg
phonePragraphEl header_ description_ attr =
    column
        ([ width fill
         , padding 40
         , spacing 40
         , Region.mainContent
         ]
            ++ attr
        )
        [ header_, description_ ]


desktopLayout : Model -> Html Msg
desktopLayout model =
    let
        viewportHeight =
            (px << round) model.viewport_.viewport.height

        arrow_ =
            arrow [ width <| px 50, height <| px 50, centerX ]

        movement state =
            if state then
                Animator.at 1

            else
                Animator.at 0

        opacity_ =
            Animator.move model.headerVisibility movement

        descriptionLeft_ =
            description serviceDetailParagraphLeft [ centerY, width <| fillPortion 2, Font.size 20 ]

        descriptionRight_ =
            description serviceDetailParagraphRight [ centerY, width <| fillPortion 2, Font.size 20 ]    

        headerLeft_ =
            el [ center, centerX, centerY, Font.size 24 ] <| text "自分のペースで学べる実践的オンラインプログラム"

        headerRight_ =
            el [ center, centerX, centerY, Font.size 24 ] <| text "パーソナライズされた個別指導型プロジェクト"    
    in
    layout
        [ height fill
        , width fill
        , Font.family [ Font.typeface "Noto Sans JP" ]
        , inFront <| headerEl [ alpha opacity_ ]
        ]
    <|
        column
            [ height fill
            , width fill
            ]
            [ topTileEl (topContent 50 []) arrow_ [ height viewportHeight ]
            , serviceAbstructEl serviceAbstructDesktop [ height viewportHeight, htmlAttribute (Html.Attributes.id "service") ]
            , leftSideParagraphEl headerLeft_ descriptionLeft_ [ height viewportHeight ]
            , rightSideParagraphEl headerRight_ descriptionRight_ [ height viewportHeight ]
            , footerEl [ htmlAttribute (Html.Attributes.id "contact"), Font.size 14 ]
            ]


bigDesktopLayout : Model -> Html Msg
bigDesktopLayout model =
    desktopLayout model


tabletLayout : Model -> Html Msg
tabletLayout model =
    desktopLayout model



-- Elements


headerEl : List (Attribute Msg) -> Element Msg
headerEl attr =
    row
        ([ width fill
         , height <| px 65
         , onMouseEnter <| ChangeHeaderVisibility True
         , paddingXY 20 0
         , spacing 20
         , alignTop
         , Font.color Color.black
         , Background.color (rgba 255 255 255 0.3)
         ]
            ++ attr
        )
        [ logo
        , headerButton "TOP" "top" [ alignRight ]
        , headerButton "SERVICE" "service" [ alignRight ]
        , headerButton "CONTACT" "contact" [ alignRight ]
        ]


headerPhoneEl : Model -> List (Attribute Msg) -> Element Msg
headerPhoneEl _ attr =
    row
        ([ width fill
         , height <| px 64
         , padding 20
         , spacing 20
         , Font.color Color.black
         ]
            ++ attr
        )
        [ logo
        , headerButton "CONTACT" "contact" [ alignRight ]
        ]


topTileEl : Element msg -> Element msg -> List (Attribute msg) -> Element msg
topTileEl content arrow_ attr =
    column
        ([ width fill
         , height fill
         , Background.image "../image/background/top_image.webp"
         , Font.family [ Font.typeface "Francois One" ]
         , htmlAttribute (Html.Attributes.id "top")
         ]
            ++ attr
        )
        [ content
        , arrow_
        ]


topContent : Int -> List (Attribute msg) -> Element msg
topContent fontSize attr =
    el
        ([ centerX
         , centerY
         , Font.size fontSize
         , Font.glow Color.white 10
         , Font.color Color.black
         ]
            ++ attr
        )
    <|
        text "TOP CONTENT TEXT\nHERE."


serviceAbstructEl : Element msg -> List (Attribute msg) -> Element msg
serviceAbstructEl content attr =
    el
        ([ width fill
         , Background.image "../image/background/AdobeStock_01.webp"
         , Background.color Color.bgPrimary
         , Region.mainContent
         ]
            ++ attr
        )
    <|
        content


serviceAbstructDesktop : Element msg
serviceAbstructDesktop =
    let
        description_ =
            text "当社のサービスは、ビジネスプロフェッショナルのための革新的な非同期プラットフォームです。ITスキルと知識を、あなたのペースで習得し、ビジネスの次のステージへ進むためのサポートをします。"
    in
    
    column
        [ width (fill |> maximum 704), spacing 16, paddingEach { top = 16, right = 64, bottom = 32, left = 64 }, centerX, centerY, Font.color Color.black, Background.color (rgba 255 255 255 0.5) ]
        [ column [ width fill, height <| fillPortion 1, spacing 16 ]
            [ el [ centerX, padding 16, height <| px 65, Font.size 28 ] <| text "SERVICE"
            ,  description description_ [ width fill, Font.size 20 ] 
            ]
        , row
            [ width fill, height <| fillPortion 1, spacing 24 ]
            [ column
                [ width fill
                , height fill
                , spacing 16
                , padding 16
                , Background.color (rgba 242 245 254 0.8)
                ]
                [ icon_ { src = "../image/icon/play.png", description = "video icon." } []
                , description serviceParagraphFirst [ centerX, Font.size 20 ]
                ]
            , column
                [ width fill
                , height fill
                , spacing 16
                , padding 16
                , Background.color (rgba 242 245 254 0.8)
                ]
                [ icon_ { src = "../image/icon/people.png", description = "people icon." } []
                , description serviceParagraphSecond [ centerX, Font.size 20 ]
                ]
            ]
        ]


serviceAbstructPhone : Element msg
serviceAbstructPhone =
    let
        description_ =
            text "当社のサービスは、ビジネスプロフェッショナルのための革新的な非同期プラットフォームです。ITスキルと知識を、あなたのペースで習得し、ビジネスの次のステージへ進むためのサポートをします。"
    in
    column
        [ width (fill |> maximum 704), spacing 16, padding 16, centerX, centerY, Font.color Color.black ]
        [ column [ width fill,Background.color (rgba 255 255 255 0.5), height <| fillPortion 1, spacing 16, paddingXY 20 20 ]
            [ el [ centerX, padding 16, height <| px 65, Font.size 16 ] <| text "SERVICE"
            , el [ centerX, padding 16, Font.size 14 ] <| text "動画学習プラットフォームと個人プロジェクト"
            , description description_ [ width fill, Font.size 16 ]
            ]
        ]

leftSideParagraphEl : Element msg -> Element msg -> List (Attribute msg) -> Element msg
leftSideParagraphEl header_ description_ attr =
    el
        ([ width fill
         , Background.image "../image/background/service_details1.webp"
         ]
            ++ attr
        )
    <|
        row
            [ width (fill |> maximum 1400)
            , height fill
            , centerX
            ]
            [ column [ width <| fillPortion 2, height fill, spacing 40 , Font.color Color.black] [ header_, description_ ]
            , el [ width <| fillPortion 3 ] none
            ]


rightSideParagraphEl : Element msg -> Element msg -> List (Attribute msg) -> Element msg
rightSideParagraphEl header_ description_ attr =
    el
        ([ width fill
         , Background.image "../image/background/service_details2.webp"
         , Background.color Color.accent
         ]
            ++ attr
        )
    <|
        row
            [ width (fill |> maximum 1400)
            , height fill
            , centerX
            ]
            [ el [ width <| fillPortion 3 ] none
            , column [ width <| fillPortion 2, height fill, spacing 40, Font.color Color.black ] [ header_, description_ ]
            ]



description : Element msg -> List (Attribute msg) -> Element msg
description description_ attr =
    el
        ([]
            ++ attr
        )
    <|
        paragraph
            [ spacing 10 ]
            [ description_
            ]


footerEl : List (Attribute msg) -> Element msg
footerEl attr =
    column
        ([ width fill
         , height fill
         , padding 15
         , Background.color Color.black
         , width fill
         , height <| px 600
         , Region.footer
         , Font.color Color.white
         ]
            ++ attr
        )
        [ el [ height <| fillPortion 2, centerX ] <|
            verticalBar [ width <| px 50, height <| px 100, centerX, centerY ]
        , el [ height <| fillPortion 2, centerX ] <|
            mailToButton [ width <| px 200, height <| px 60 ]
        , row
            [ height <| fillPortion 1, centerX, centerY, spacing 10 ]
            [ 
             navLink
                { url = "https://www.lipsum.com/"
                , label = text "Placeholder"
                }
            ]
        ]


icon_ : { src : String, description : String } -> List (Attribute msg) -> Element msg
icon_ src attr =
    Element.image
        ([ centerX
         , centerY
         ]
            ++ attr
        )
        src


logo : Element msg
logo =
    el
        [ width <| px 80
        , height <| px 44
        , Border.width 2
        , Border.rounded 6
        ]
        -- TODO replace none with logo img
        none


headerButton : String -> String -> List (Attribute Msg) -> Element Msg
headerButton label_ id attr =
    Input.button
        ([ focused [] -- this can removed global blue shadow around on clock
         , width <| px 115
         , height <| px 40
         , padding 10
         , Font.family [ Font.typeface "Montserrat" ]
         , center
         , Border.widthEach { bottom = 2, left = 0, right = 0, top = 0 }
         , Border.color Color.transparent

         -- The order of mouseDown/mouseOver can be significant when changing
         -- the same attribute in both
         , mouseDown
            [ Border.color Color.transparent ]
         , mouseOver
            [ Border.color Color.black ]
         ]
            ++ attr
        )
        { onPress = Just (ScrollToId id), label = text label_ }


mailToButton : List (Attribute msg) -> Element msg
mailToButton attr =
    link
        ([ focused [] -- this can removed global blue shadow around on clock
         , paddingXY 0 20
         , center
         , Font.size 18
         , Border.width 2
         , Border.rounded 3

         -- The order of mouseDown/mouseOver can be significant when changing
         -- the same attribute in both
         , mouseDown
            [ Background.color Color.white, Font.color Color.black ]
         , mouseOver
            [ Background.color Color.white, Font.color Color.black ]
         ]
            ++ attr
        )
        { url = "mailto:placeholder@example.com?subject=Subject&body=Body"
        , label = text "CONTACT US"
        }


navLink : { url : String, label : Element msg } -> Element msg
navLink =
    newTabLink
        [ focused [] -- this can removed global blue shadow around on clock
        , padding 10

        -- The order of mouseDown/mouseOver can be significant when changing
        -- the same attribute in both
        , mouseDown
            [ Font.color Color.gray ]
        , mouseOver
            [ Font.color Color.gray ]
        ]


menuButton : String -> Menu -> List (Attribute Msg) -> Element Msg
menuButton label_ currentMenuState attr =
    let
        newMenuState =
            case currentMenuState of
                Wrapped ->
                    Unwrapped

                Unwrapped ->
                    Wrapped
    in
    Input.button
        ([ focused [] -- this can removed global blue shadow around on clock
         , width <| px 115
         , height <| px 40
         , padding 10
         , center
         , Border.widthEach { bottom = 2, left = 0, right = 0, top = 0 }
         , Border.color Color.transparent

         -- The order of mouseDown/mouseOver can be significant when changing
         -- the same attribute in both
         , mouseDown
            [ Background.color Color.secondary ]
         , mouseOver
            [ Background.color Color.white ]
         ]
            ++ attr
        )
        { onPress = Just (UserPressedMenu newMenuState), label = text label_ }


serviceDetailParagraphLeft : Element msg
serviceDetailParagraphLeft =
    text """このプログラムは、非同期動画講義と実践課題を通じて、理論的な知識と実践的なスキルを効果的に習得できる学習機会を提供します。まず、非同期動画講義により、24時間365日アクセス可能な学習環境が整っており、自分のペースで進められる柔軟なカリキュラムが特徴です。また、繰り返し視聴可能なため、深く理解することが可能です。 続いて、実践的な課題を通じて、動画で学んだ理論を実際のビジネスシーンを想定した問題設定の中で即座に実践できます。この課題を通じて、知識の定着と応用力を強化することができます。 さらに、経験豊富な講師が個別に丁寧なフィードバックを提供します。これにより、受講者は自身の強みと改善点を明確に把握でき、継続的な成長をサポートする建設的なアドバイスを受けることができます。 このプログラムは、柔軟な学習スタイルと実務に直結する内容で理論と実践の両方をカバーしており、キャリアアップを強力にサポートする最適な手段となります。"""

serviceDetailParagraphRight : Element msg
serviceDetailParagraphRight =
    text """個人プロジェクトは、専任講師によるマンツーマン指導を通じて、あなたの潜在能力を最大限に引き出し、実務で即戦力となるスキルを養成します。経験豊富な専門家が全プロセスをサポートし、あなたのビジョンと目標に合わせたカスタマイズされた指導を提供します。定期的な進捗確認と詳細なフィードバックにより、着実な成長を促進します。実際のビジネス環境に即したプロジェクト設計により、理論を実践に移す機会を提供します。失敗を恐れずに挑戦できる安全な学習環境の中で、実践的なプロジェクト体験を積むことができます。プロジェクト管理の基礎から応用まで体系的に学習し、問題分析、戦略立案、実行力を段階的に強化します。創造的思考と論理的思考のバランスを養成することで、幅広い視野を持ったビジネスリーダーを目指します。個人プロジェクトは、理論と実践の融合を通じて、次世代のビジネスリーダーを育成することを目的としています。あなたの可能性を最大限に引き出し、キャリアアップを強力にサポートします。"""

serviceParagraphFirst : Element msg
serviceParagraphFirst =
    text """非同期動画講義と研修課題で、知識とスキルを同時に習得できます。"""

serviceParagraphSecond : Element msg
serviceParagraphSecond =
    text """専任の講師からのフィードバックを受けながら、実践的なITスキルを向上させます。"""