module Page.About.About exposing (..)

import Page.Color as Color255
import Task
import Element exposing (..)
import Element.Attributes exposing (..)
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color
import Style.Font as Font
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Html exposing (Html)

type Styles
    = None
    | Header
    | Footer
    | Title
    | Main
    | Logo
    | Button
    | TextBox

type Variation
    = Disabled

stylesheet : Model -> StyleSheet Styles variation
stylesheet model =
    Style.styleSheet
        [ style None
            [] -- It's handy to have a blank style
        , style Header
            [ Color.background Color255.darkGray ]
        , style Footer
            [ Color.background Color255.darkGray
            , Font.size ( model.width / 100 )
            ]
        , style Title
            [ Font.bold
            , Font.size ( model.width / 40 )
            ]
        , style Main
            [ Border.all 1
            , Color.text Color255.darkCharcoal
            , Color.background Color255.white
            , Color.border Color255.grey
            , Font.size ( model.width / 80 )
            , Font.lineHeight 1.3
            ]
        , style Logo
            [ Font.size ( model.width / 40 )
            ]
        , style Button
            [ Color.text Color255.black
            , Color.background Color255.white
            , Color.border Color255.black
            , hover
                [ Color.background Color255.gray
                ]
            , Font.size ( model.width / 40 )
            , Border.all 2
            ]
        , style TextBox
            [ Border.top 3
            , Font.lineHeight 2
            ]
        ]

main : Program () Model Msg
main =
    let
        handleResult v =
            case v of
                Err _ ->
                    NoOp

                Ok vp ->
                    GotInitialViewport vp
    in
    Browser.element
        { init = \_ -> ( initialModel, Task.attempt handleResult Browser.Dom.getViewport )
        , view = aboutElement
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : model -> Sub Msg
subscriptions _ =
    E.onResize (\w h -> Resize ( toFloat w, toFloat h ))

-- MODEL
type alias Model =
    { width : Float
    , height : Float }

initialModel : Model
initialModel =
    { width = 0
    , height = 0 }

type Msg
    = NoOp
    | GotInitialViewport Viewport
    | Resize ( Float, Float )

-- UPDATE
setCurrentDimensions : { a | width : b, height : c } -> ( b, c ) -> { a | width : b, height : c }
setCurrentDimensions model ( w, h ) =
    { model | width = w, height = h }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotInitialViewport vp ->
            ( setCurrentDimensions model ( vp.scene.width, vp.scene.height ), Cmd.none )

        Resize ( w, h ) ->
            ( setCurrentDimensions model ( w, h ), Cmd.none )

        NoOp ->
            ( model, Cmd.none )

aboutElement : Model -> Html msg
aboutElement model=
    Element.layout (stylesheet model) <|
        column None
            [][
                headerLayout model
                , el None
                    [ height ( px ( model.height - ( model.height / 10 ) *2 ) )
                        , yScrollbar
                    ] <|
                    column Main
                        [ width fill
                        , center
                        , verticalCenter
                        , paddingXY 0 20 
                        ](
                            List.concat [ aboutLayout model ]
                        )
                , footerwLayout model
            ]


headerLayout : Model -> Element Styles variation msg
headerLayout model =
    row Header
        [ spread
            , paddingXY 30 20 
            , height ( px ( model.height / 10 ) )
            , width ( px ( model.width ) )
        ][
            el Logo
                [ verticalCenter ] (
                    image None 
                        [ width (px ( model.width / 25 ) )
                        , height ( px ( model.width / 25 ) )
                        ]{
                            src = "../../Picture/VITORIA_logo.jpg"
                            , caption = "VITORIA_logo"
                        }
                )
            , row None
                [ spacing 5
                , verticalCenter ][
                    button Button
                        [ paddingXY 20 0 ](
                            Element.text "Top"
                        )
                    , button Button
                        [ paddingXY 20 0 ](
                            Element.text "About"
                        )
                    , button Button
                        [ paddingXY 20 0 ](
                            Element.text "Contents"
                        )
                    , button Button
                        [ paddingXY 20 0 ](
                            Element.text "Contact"
                        )
                ]
        ]

aboutLayout : Model -> List (Element Styles variation msg)
aboutLayout model=
    [ image None
        [ width ( px ( model.width / 1.5 ) )
        , height ( px ( model.height / 2.5 ) )
        ]{
            src = "../../Picture/Spacecat.png"
            , caption = "Spacecat"
        }
    , textLayout None
        [ spacingXY 25 25 ][
            h1 Title
                [](
                    Element.text "会社概要"
                )
            , h3 Title
                [](
                    Element.text "ABOUT"
                )
        ]
    , textLayout None
        [ paddingXY 10 10 ][
            row TextBox
                [][
                    column None 
                        [ verticalCenter
                        , width ( px ( model.width / 3 ) ) ][
                            Element.text "会社名"
                        ]
                    , column None
                        [ verticalCenter 
                        , width ( px ( model.width / 3 ) ) ][
                            Element.text "株式会社XXXX"
                        ]
                ]
            , row TextBox
                [][
                    column None
                        [ verticalCenter
                        , width ( px ( model.width / 3 ) ) ][
                            Element.text "設立"
                        ]
                    , column None
                        [ verticalCenter 
                        , width ( px ( model.width / 3 ) ) ][
                            Element.text "YYYY年MM月DD日"
                        ]
                ]
            , row TextBox
                [][
                    column None
                        [ verticalCenter
                        , width ( px ( model.width / 3 ) ) ][
                            Element.text "資本金"
                        ]
                    , column None
                        [ verticalCenter 
                        , width ( px ( model.width / 3 ) ) ][
                            Element.text "X,XXX万円"
                        ]
                ]
            , row TextBox
                [ paddingBottom 10 ][
                    column None
                        [ verticalCenter
                        , width ( px ( model.width / 3 ) ) ][
                            Element.text "事業内容"
                        ]
                    , column None
                        [ verticalCenter 
                        , width ( px ( model.width / 3 ) ) ][
                            Element.text 
                            """PlayStation・Nintendo Switch向けコンシューマゲーム、
                            \nソーシャルゲームの企画・開発
                            \n・VR、AR、3Dコンテンツの開発
                            \n・システムエンジニアリングサービス事業
                            \n・ドローンメディア運営事業
                            \n・IT関連事業の統合的ソリューションの展開"""
                        ]
                ]
            , row TextBox
                [ paddingBottom 10 ][
                    column None
                        [ verticalCenter
                        , width ( px ( model.width / 3 ) ) ][
                            row None
                                [][
                                    Element.text "所在地"
                                ]
                            , row None
                                [][
                                    image None [ width ( px ( model.width / 3.5 ) ) ]{
                                        src = "../../Picture/TokyoStation.png"
                                        , caption = "TokyoStation"
                                    }
                                ]
                        ]
                    , column None 
                        [ verticalCenter
                        , width ( px ( model.width / 3 ) ) ][
                            Element.text 
                            """〒100-0005 東京都千代田区丸の内１丁目
                            \n東京メトロXX線「東京駅」XX出口から徒歩X分
                            \nJRYY線「YY堀駅」YY出口から徒歩Y分
                            \n都営ZZ線「ZZ駅」ZZ出口から徒歩Z分"""
                        ]
                ]
        ]
    ]

footerwLayout : Model -> Element Styles variation msg
footerwLayout model =
    row Footer
        [ paddingLeft  ( model.width / 50 )
        , height ( px ( model.height / 10 ) )
        , width ( px ( model.width ) ) ][
            paragraph None
                [] [
                    Element.text "© 2023 React Inc. All Rights Reserved.I'm happy! thank you!"
                ]
        ]
