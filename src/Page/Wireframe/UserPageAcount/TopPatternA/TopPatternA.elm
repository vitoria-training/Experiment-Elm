module Page.Wireframe.UserPageAcount.TopPatternA.TopPatternA exposing (..)

import Color as Color255
import Task
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, stopPropagationOn)
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color
import Style.Font as Font
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Html exposing (Html)
import Style.Background
import Style.Background exposing (noRepeat)
import Style.Background exposing (size)
import Json.Decode as D


type Styles
    = None
    | Header
    | Footer
    | Title
    | Main
    | Logo
    | Button
    | TextBox
    | TextUnderLine
    | BKImage
    | ModalContentStyle
    | ModalBK
    | ButtonBK
    | BKWH

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
            , Color.background Color255.white
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
            [ Font.lineHeight 2
            ]
        , style TextUnderLine
            [ Border.bottom 3
            , Font.lineHeight 2
            ]
        , style BKImage
            [ Style.Background.imageWith
                { src = "/assets/image/Spacecat.png"
                , position = ( 0.0, 0.0 )
                , repeat = noRepeat
                , size = size
                    { height = ( px ( model.height / 1.5 ) )
                    , width = ( px ( model.width / 2.2 ) )
                    }
                }
            ]
        , style ModalContentStyle
            [ Color.background Color255.white
            , Color.border Color255.gray
            , Border.all 1.5
            , Border.solid
            , Border.rounded 10.0
            ]
        , style ModalBK
            [ Color.background Color255.translucentGray

            ]
        , style ButtonBK
            [ Color.text Color255.white
            , Color.background Color255.black
            , Color.border Color255.black
            , Font.size ( model.width / 40 )
            , Border.all 2
            , Border.rounded 10.0
            ]
        , style BKWH
            [ Color.background Color255.white
            ]
        ]

main : Program () Model Msg
main =
    let
        handleResult v =
            case v of
                Err _ ->
                    Nothing

                Ok vp ->
                    GotInitialViewport vp
    in
    Browser.element
        { init = \_ -> ( initialModel, Task.attempt handleResult Browser.Dom.getViewport )
        , view = topPatternAPageElement
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : model -> Sub Msg
subscriptions _ =
    E.onResize (\w h -> Resize ( toFloat w, toFloat h ))

-- MODEL
type alias Model =
    { width : Float
    , height : Float
    , contentsStatus : OPStatus }

type OPStatus
    = Open
    | Close

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , contentsStatus = Close}

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | ContentsChenge

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

        Nothing ->
            ( model, Cmd.none )

        ContentsChenge ->
            ( { model | contentsStatus = 
                if model.contentsStatus == Close then
                    Open
                else
                    Close }, Cmd.none )

topPatternAPageElement : Model -> Html Msg
topPatternAPageElement model=
    Element.layout (stylesheet model) <|
        column None
            [yScrollbar][
                headerLayout model
                , el None
                    [] <|
                    column Main
                        [ width fill
                        , center
                        , verticalCenter
                        , paddingXY 0 20 
                        ](
                            List.concat [
                                topPatternAPageLayout1 model
                                , topPatternAPageLayout2 model
                                , topPatternAPageLayout3 model
                            ]
                        )
                , footerLayout model
            ]

headerLayout : Model -> Element Styles variation Msg
headerLayout model =
    row Header
        [ spread
            , paddingXY 30 20 
            , height ( px ( model.height / 10 ) )
            , width fill
        ][
        el Logo
            [ verticalCenter ] (
                image None 
                    [ width (px ( model.width / 25 ) )
                    , height ( px ( model.width / 25 ) )
                    ]{
                        src = "/assets/icon/VITORIA_logo.jpg"
                        , caption = "VITORIA_logo"
                    }
            )
        , row None
            [ spacing 5
            , verticalCenter ][
                button Button
                    [ paddingXY 20 0 ](
                        Element.text "TOP"
                    )
                , button Button
                    [ paddingXY 20 0 ](
                        Element.text "SERVICE"
                    )
                , button Button
                    [ paddingXY 20 0 ](
                        Element.text "LOGIN"
                    )
            ]
        ]

topPatternAPageLayout1 : Model -> List (Element Styles variation Msg)
topPatternAPageLayout1 model=
    [ row None
        [ paddingBottom 20
        , height ( px model.height ) ][
        textLayout None
            [ width ( px ( model.width / 2.1 ) )
            , paddingXY 10 100 ][
            column TextUnderLine
                [ center ][
                el None
                    [](
                        Element.text "text_1 text_1 text_1 text_1"
                    )
                ]
            , column TextUnderLine
                [ center ][
                el None
                    [](
                        Element.text "text_2 text_2 text_2 text_2"
                    )
                ]
            , column TextUnderLine
                [ center ][
                el None
                    [](
                        Element.text "text_3 text_3 text_3 text_3"
                    )
                ]
            ]
        , textLayout BKImage
            [ width ( px ( model.width / 2.1 ) )
            , height ( px ( model.height / 1.5 ) )
            , paddingLeft ( model.width / 6 )
            , paddingTop ( model.height / 1.8 )
            ][
            row None
                [ verticalCenter ][
                button Button
                    [ paddingXY 20 0 ](
                        Element.text "SIGN UP"
                    )
                ]
            ]
        ]
    ]

topPatternAPageLayout2 : Model -> List (Element Styles variation msg)
topPatternAPageLayout2 model=
    [ column None
        [ height ( px ( model.height / 2 ) ) ][
        textLayout None
            [ spacingXY 25 25
            , center ][
                h1 Title
                    [](
                        Element.text "SERVICE"
                    )
            ]
        , textLayout None
            [ paddingXY 10 10 ][
            row TextBox
                [][
                column None
                    [ width ( px ( model.width / 3.5 ) )
                    , center ][
                    row None
                        [][
                        image None 
                            [ width (px ( model.width / 10 ) )
                            , height ( px ( model.width / 10 ) )
                            ]{
                                src = "/assets/icon/VITORIA_logo.jpg"
                                , caption = "VITORIA_logo"
                            }
                        ]
                    , row None
                        [][
                            Element.text "movie contentsに関する説明を\nここに記載予定\n1234567890"
                        ]
                    ]
                , column None
                    [ width ( px ( model.width / 3.5 ) )
                    , center ][
                    row None
                        [][
                        image None 
                            [ width (px ( model.width / 10 ) )
                            , height ( px ( model.width / 10 ) )
                            ]{
                                src = "/assets/icon/VITORIA_logo.jpg"
                                , caption = "VITORIA_logo"
                            }
                        ]
                    , row None
                        [][
                            Element.text "document contentsに関する説明を\nここに記載予定\n1234567890"
                        ]
                    ]
                , column None
                    [ width ( px ( model.width / 3.5 ) )
                    , center ][
                    row None
                        [][
                        image None 
                            [ width (px ( model.width / 10 ) )
                            , height ( px ( model.width / 10 ) )
                            ]{
                                src = "/assets/icon/VITORIA_logo.jpg"
                                , caption = "VITORIA_logo"
                            }
                        ]
                    , row None
                        [][
                            Element.text "option contentsに関する説明を\nここに記載予定\n1234567890"
                        ]
                    ]
                ]
            ]
        ]
    ]

topPatternAPageLayout3 : Model -> List (Element Styles variation Msg)
topPatternAPageLayout3 model=
    [ column None
        [ height fill ][
            if model.contentsStatus == Close then
                textLayout None
                    [ paddingXY 10 10 ][
                    row TextBox
                        [ width ( px ( model.width / 1.28) )
                        , alignRight ][
                        column None
                            [][
                            image None 
                                [ width ( px ( model.width / 30 ) )
                                , height ( px ( model.width / 30 ) )
                                , onClick(
                                    ContentsChenge
                                )
                                ]{
                                src = "/assets/image/Button/plusButton.png"
                                , caption = "PlusButton"
                                }
                            ]
                        ]
                    , contentsStatusClose model
                    ]
            else
                textLayout None
                    [ paddingXY 10 10 ][
                    row TextBox
                        [ width ( px ( model.width / 1.2) )
                        , alignRight ][
                        column None
                            [][
                            image None 
                                [ width ( px ( model.width / 30 ) )
                                , height ( px ( model.width / 30 ) )
                                , onClick(
                                    ContentsChenge
                                )
                                ]{
                                src = "/assets/image/Button/minusButton.png"
                                , caption = "MinusButton"
                                }
                            ]
                        ]
                    , contentsStatusOpen model
                    ]
            ]
        ]

contentsStatusClose : Model -> Element Styles variation msg
contentsStatusClose model =
    row TextBox
        [ width fill
        , center
        , paddingTop 30 ][
        column None
            [][
            column None
                [ verticalCenter ][
                image None
                    [ width ( px ( model.width / 10 ) )
                    , height ( px ( model.width / 10 ) )
                    ]{
                        src = "/assets/icon/VITORIA_logo.jpg"
                        , caption = "VITORIA_logo"
                    }
                ]
            , column None
                [ verticalCenter ][
                    Element.text "movie contentsに関する説明を\nここに記載予定\n左に動画を一本埋め込み予定\n1234567890"
                ]
            ]
        ]

contentsStatusOpen : Model -> Element Styles variation msg
contentsStatusOpen model =
    row TextBox
        [ width fill
        , center
        , paddingTop 30 ][
        column None
            [ width ( px ( model.width / 3.4 ) )
            , center ][
            row None
                [][
                image None 
                    [ width (px ( model.width / 10 ) )
                    , height ( px ( model.width / 10 ) )
                    ]{
                        src = "/assets/icon/VITORIA_logo.jpg"
                        , caption = "VITORIA_logo"
                    }
                ]
            , row None
                [][
                    Element.text "movie contentsに関する説明を\nここに記載予定\n1234567890"
                ]
            ]
        , column None
            [ width ( px ( model.width / 3.4 ) )
            , center ][
            row None
                [][
                image None 
                    [ width (px ( model.width / 10 ) )
                    , height ( px ( model.width / 10 ) )
                    ]{
                        src = "/assets/icon/VITORIA_logo.jpg"
                        , caption = "VITORIA_logo"
                    }
                ]
            , row None
                [][
                    Element.text "document contentsに関する説明を\nここに記載予定\n1234567890"
                ]
            ]
        , column None
            [ width ( px ( model.width / 3.4 ) )
            , center ][
            row None
                [][
                image None 
                    [ width (px ( model.width / 10 ) )
                    , height ( px ( model.width / 10 ) )
                    ]{
                        src = "/assets/icon/VITORIA_logo.jpg"
                        , caption = "VITORIA_logo"
                    }
                ]
            , row None
                [][
                    Element.text "option contentsに関する説明を\nここに記載予定\n1234567890"
                ]
            ]
        ]

footerLayout : Model -> Element Styles variation msg
footerLayout model =
    let
        footerInnerWidth = 
             model.width - ( ( model.width / 50 ) * 2 )
    in

    row Footer
        [ paddingLeft  ( model.width / 50 )
        , paddingRight  ( model.width / 50 )
        , height ( px ( model.height / 5 ) )
        , width fill ][
        column None
            [][
            row None
                [ paddingTop 10 ][
                column None
                    [ width ( px (footerInnerWidth / 2 ) ) ] [
                    image None 
                        [ paddingTop 10
                        , width (px ( model.width / 20 ) )
                        , height ( px ( model.width / 20 ) )
                        ]{
                            src = "/assets/icon/VITORIA_logo.jpg"
                            , caption = "VITORIA_logo"
                        }
                    ]
                , column None
                    [ width ( px (footerInnerWidth / 2 ) ) ][
                    row None
                        [] [
                            Element.newTab 
                                "https://vitoria.co.jp/contact/"
                            <| el None [](Element.text "会社概要")
                        ]
                    , row None
                        [] [
                            Element.newTab 
                                "https://vitoria.co.jp/contact/"
                            <| el None [](Element.text "利用規約")
                        ]
                    , row None
                        [] [
                            Element.newTab 
                                "https://vitoria.co.jp/contact/"
                            <| el None [](Element.text "お問い合わせ")
                        ]
                    , row None
                        [] [
                            Element.newTab 
                                "https://vitoria.co.jp/contact/"
                            <| el None [](Element.text "プライバシーポリシー")
                        ]
                    ]
                ]
            , row None
                [ paddingTop 10
                , center ][
                    Element.text "©VITORIA"
                ]
            ]
        ]

onClickStopPropagation : a -> Attribute variation a
onClickStopPropagation msg =
    stopPropagationOn "click" <| D.succeed ( msg, True )

