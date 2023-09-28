module Page.About.About exposing (..)

import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Element exposing (..)
import Element.Input as Input
import Element.Region as Region
import Element.Font as Font
import Element.Background as Background
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Page.About.Parts.About_Parts as AP

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

-- HeaderButoon template
butoonFontSize : Float -> Int
butoonFontSize width=
  round width // 70

topPaddingXY : { x : number, y : number }
topPaddingXY =
  { x = 35
  , y = 70}

aboutPaddingXY : { x : number, y : number }
aboutPaddingXY =
  { x = 50
  , y = 70}

contentsPaddingXY : { x : number, y : number }
contentsPaddingXY =
  { x = 20
  , y = 70}

contactPaddingXY : { x : number, y : number }
contactPaddingXY =
  { x = 60
  , y = 70}

headerButoon : { a | width : Float, height : Float } -> { b | x : Int, y : Int } -> String -> Element d
headerButoon model paddingXYValue label=
  column [ Element.width <| px ( round model.width // 10 )] [
    Input.button[ paddingXY ( round model.width // paddingXYValue.x ) ( round model.height // paddingXYValue.y )
      , spacing ( round model.height // 60 )
      , Element.width <| px ( round model.width // 12 )
      , Element.height fill
      , Background.color ( rgb255 211 211 211 )
      , Font.color ( rgb255 0 0 0 )
      , Font.size ( butoonFontSize model.width )
      , centerX
      , centerY
    ]
    { label = Element.text <| label
      , onPress = Nothing
    }
  ]

-- Footer Fixed value
footerFontSize : Float -> Int
footerFontSize mainScreenWidth =
    round mainScreenWidth // 70

footerHeight : Float -> Int
footerHeight mainScreenHeight =
    round mainScreenHeight // 13

footerPadding : { top : number, left : number, right : number, bottom : number }
footerPadding =
    { top = 0
    , left = 10
    , right = 10
    , bottom = 30 }

aboutElement : Model -> Html msg
aboutElement model=
        let
            contentsList =
                column [ Element.width <| px ( round model.width // 6 ) ] [
                    Input.button[ paddingXY ( round model.width // contentsPaddingXY.x ) ( round model.height // contentsPaddingXY.y )
                      , spacing ( round model.height // 60 )
                      , Element.width <| px ( round model.width // 6 )
                      , Element.width fill
                      , Background.color ( rgb255 211 211 211 )
                      , Font.color ( rgb255 0 0 0 )
                      , Font.size ( butoonFontSize model.width )
                      , centerX
                      , centerY
                      ]
                    { label = Element.text <| "Contents"
                    , onPress = Nothing
                    }
                ]
        in
        layout [ Element.width fill
            , Element.height fill ] <|
            column[ Element.width fill
                , Element.height fill ][
                -- Header
                column [ Element.width fill][
                    row [ Element.width fill
                        , Element.height <| px ( round model.height // 15 )
                    ][
                        column [ Element.width <| px ( round model.width // 30 ) ] [ 
                        -- Since I want it to be square, I use "height" and "width".
                            Element.image [ Element.width <| px ( round model.width // 40 )
                            , Element.height <| px ( round model.width // 40 )
                            , centerX
                            , centerY ]
                            { src = "../../Picture/elm_logo.png"
                            , description = "elm_logo" }
                        ]
                        , column [ Element.width fill] []
                        , headerButoon model topPaddingXY "Top"
                        , headerButoon model aboutPaddingXY "About"
                        , contentsList
                        , headerButoon model contactPaddingXY "Contact"
                        , column [ Element.width <| px ( round model.width // 100 ) ] [ ]
                    ]
                ]
                -- About
                , column[ Element.width fill
                    , Element.height fill ][
                    column[ scrollbarY
                        , Element.width fill
                        , Element.height <| px 
                        (round model.height 
                        - round model.height // 15 
                        - round model.height // 13) ][
                    column[ Element.width <| px ( round model.width // 50 ) ][]
                    , column [ Element.width <| px ( round model.width - round model.width // 5 )
                        , centerX
                        , centerY ][
                        row [ Element.width fill ][
                            column [ Element.width fill ] [
                                Element.image [ Element.width fill
                                    , Element.height <| px ( round model.height // 2 )
                                    , centerX
                                    , centerY ]
                                { src = "../../Picture/Spacecat.png"
                                , description = "Spacecat" }
                            ]
                        ]
                        , row [centerX
                            , centerY
                            , Font.size ( round model.width // 50 )
                            , padding 5 ][
                            column [ Element.width fill
                                , Element.height fill
                                , Region.heading 1
                                , Font.semiBold ] [
                                Element.text <| String.toUpper "会社概要"
                            ]
                        ]
                        , row [ centerX
                            , centerY
                            , Font.size ( round model.width // 60 )][
                            column [ Element.width fill
                                , Element.height fill
                                , Region.heading 2
                                , Font.semiBold ] [
                                Element.text <| String.toUpper "ABOUT"
                            ]
                        ]
                        , AP.companyProfileItem model.width "会社名" "株式会社XXXX"
                        , AP.companyProfileItem model.width "設立" "YYYY年MM月DD日"
                        , AP.companyProfileItem model.width "資本金" "X,XXX万円"
                        , AP.companyProfileItem model.width "事業内容" 
                            """PlayStation・Nintendo Switch向けコンシューマゲーム、
                            \nソーシャルゲームの企画・開発
                            \n・VR、AR、3Dコンテンツの開発
                            \n・システムエンジニアリングサービス事業
                            \n・ドローンメディア運営事業
                            \n・IT関連事業の統合的ソリューションの展開"""
                        , AP.companyProfileItem model.width "所在地" 
                            """〒100-0005 東京都千代田区丸の内１丁目"""
                        , AP.companyProfileMap model.width model.height "../../Picture/TokyoStation.png" "TokyoStation"
                            """東京メトロXX線「東京駅」XX出口から徒歩X分
                            \nJRYY線「YY堀駅」YY出口から徒歩Y分
                            \n都営ZZ線「ZZ駅」ZZ出口から徒歩Z分"""
                        ]
                    ]
                ]
                -- Footer
                , column [Element.width fill][
                    row [Element.width fill][
                        el[ Background.color ( rgb255 128 128 128 )
                        , Font.color ( rgb255 0 0 0 )
                        , Font.size ( footerFontSize model.width )
                        , paddingEach footerPadding
                        , Element.width fill
                        , Element.height <| px ( footerHeight model.height )
                        ]
                        ( Element.text 
                        """© 2023 React Inc. All Rights Reserved.\nI'm happy! thank you!""")
                    ]
                ]
            ]