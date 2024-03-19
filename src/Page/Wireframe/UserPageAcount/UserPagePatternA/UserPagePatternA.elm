module Page.Wireframe.UserPageAcount.UserPagePatternA.UserPagePatternA exposing (..)

import Page.Color as Color255
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
    | MenuModalButton
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
                { src = "/src/Picture/Spacecat.png"
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
        , style MenuModalButton
            [ Border.bottom 3
            , Font.lineHeight 2
            , Font.size 20
            , Color.background Color255.white
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
        , view = userPagePatternAElement
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
    , menuStatus : OPStatus
    , contentsStatus : OPStatus
    , movueContentsStatus : OPStatus
    , otherContentsStatus : OPStatus }

type OPStatus
    = Open
    | Close

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , menuStatus = Close
    , contentsStatus = Close
    , movueContentsStatus = Close
    , otherContentsStatus = Close }

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | MenuModalOpen
    | MenuModalClose
    | ContentsListChenge
    | MovieModalOpen
    | MovieModalClose
    | OtherModalOpen
    | OtherModalClose

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

        MenuModalOpen ->
            ( { model | menuStatus = Open }, Cmd.none )
        
        MenuModalClose ->
            ( { model | menuStatus = Close
                , contentsStatus = Close }, Cmd.none )

        ContentsListChenge ->
            ( { model | contentsStatus = 
                if model.contentsStatus == Close then
                    Open
                else
                    Close }, Cmd.none )
        
        MovieModalOpen ->
            ( { model | movueContentsStatus = Open }, Cmd.none )
        
        MovieModalClose ->
            ( { model | movueContentsStatus = Close }, Cmd.none )

        OtherModalOpen ->
            ( { model | otherContentsStatus = Open }, Cmd.none )
        
        OtherModalClose ->
            ( { model | otherContentsStatus = Close }, Cmd.none )

userPagePatternAElement : Model -> Html Msg
userPagePatternAElement model=
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
                                userPagePatternAPageLayout1 model
                                , userPagePatternAPageLayout2 model
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
                    src = "/src/Picture/VITORIA_logo.jpg"
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
            , if model.menuStatus == Open then
                image None 
                    [ width ( px ( model.width / 30 ) )
                    , height ( px ( model.width / 30 ) )
                    , onClick(
                        MenuModalClose
                        )
                    ]{
                        src = "/src/Picture/CloseButton.png"
                        , caption = "MenuButton"
                    }
            else
                image None 
                    [ width ( px ( model.width / 30 ) )
                    , height ( px ( model.width / 30 ) )
                    , onClick(
                        MenuModalOpen
                        )
                    ]{
                        src = "/src/Picture/hamburger.png"
                        , caption = "MenuButton"
                    }
            ]
        ]

userPagePatternAPageLayout1 : Model -> List (Element Styles variation Msg)
userPagePatternAPageLayout1 model=
    [ column None
        [][
        textLayout None
            [ spacingXY 25 25
            , center ][
            h1 Title
                [](
                    Element.text "movie-contents"
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
                                src = "/src/Picture/VITORIA_logo.jpg"
                                , caption = "VITORIA_logo"
                            }
                        ]
                    , row None
                        [][
                            Element.text "git講習\nここに動画配置予定"
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
                                src = "/src/Picture/VITORIA_logo.jpg"
                                , caption = "VITORIA_logo"
                            }
                        ]
                    , row None
                        [][
                            Element.text "systemdesign講習\nここに動画配置予定"
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
                                src = "/src/Picture/VITORIA_logo.jpg"
                                , caption = "VITORIA_logo"
                            }
                        ]
                    , row None
                        [][
                            Element.text "ゲーム開発ってどんな感じ?\nここに動画配置予定"
                        ]
                    ]
                ]
            , if model.movueContentsStatus == Close then
                textLayout None
                    [ paddingXY 10 10 ][
                    row TextBox
                        [ width ( px ( model.width / 1.2) )
                        , center
                        , paddingTop 100 ][
                        column None
                            [ width ( px ( model.width / 3.5 ) )
                            , center ][
                            row None
                                [][
                                image None 
                                    [ width ( px ( model.width / 10 ) )
                                    , height ( px ( model.width / 10 ) )
                                    ]{
                                    src = "/src/Picture/VITORIA_logo.jpg"
                                    , caption = "VITORIA_logo"
                                    }
                                ]
                            , column None
                                [ verticalCenter ][
                                    Element.text "ゲーム開発って?\nここに動画配置予定"
                                ]
                            ]
                        , column None
                            [ width ( px ( model.width / 3.5 ) )
                            , center ][
                            row None
                                [][
                                image None
                                    [ width ( px ( model.width / 10 ) )
                                    , height ( px ( model.width / 10 ) )
                                    ]{
                                    src = "/src/Picture/VITORIA_logo.jpg"
                                    , caption = "VITORIA_logo"
                                    }
                                ]
                            , column None
                                [ verticalCenter ][
                                    Element.text "ゲーム業界ってどんな感じ?\nここに動画配置予定"
                                ]
                            ]
                        ]
                    , row TextBox
                        [ width ( px ( model.width / 1.2) )
                        , alignRight ][
                            image None 
                            [ width ( px ( model.width / 30 ) )
                            , height ( px ( model.width / 30 ) )
                            , onClick(
                                MovieModalOpen
                            )
                            ]{
                                src = "/src/Picture/plusButton.png"
                                , caption = "PlusButton"
                            }
                        ]
                    ]
            else
                textLayout None
                    [ paddingXY 10 10 ][
                    moviecontentson model
                    , moviecontentson model
                    , row TextBox
                        [ width ( px ( model.width / 1.2) )
                        , alignRight ][
                            image None
                            [ width ( px ( model.width / 30 ) )
                            , height ( px ( model.width / 30 ) )
                            , onClick(
                                MovieModalClose
                            )
                            ]{
                                src = "/src/Picture/minusButton.png"
                                , caption = "MinusButton"
                            }
                        ]
                    ]
            ]
        , if model.menuStatus == Open then
            menuModal model
        else
            textLayout None [][]
        ]
    ]

moviecontentson : Model -> Element Styles variation msg
moviecontentson model =
    row TextBox
        [ paddingTop 100 ][
        column None
            [ width ( px ( model.width / 3.5 ) )
            , center ][
            row None
                [][
                image None 
                    [ width (px ( model.width / 10 ) )
                    , height ( px ( model.width / 10 ) )
                    ]{
                        src = "/src/Picture/VITORIA_logo.jpg"
                        , caption = "VITORIA_logo"
                    }
                ]
            , row None
                [][
                    Element.text "git講習\nここに動画配置予定"
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
                        src = "/src/Picture/VITORIA_logo.jpg"
                        , caption = "VITORIA_logo"
                    }
                ]
            , row None
                [][
                    Element.text "systemdesign講習\nここに動画配置予定"
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
                        src = "/src/Picture/VITORIA_logo.jpg"
                        , caption = "VITORIA_logo"
                    }
                ]
            , row None
                [][
                    Element.text "ゲーム開発ってどんな感じ?\nここに動画配置予定"
                ]
            ]
        ]

userPagePatternAPageLayout2 : Model -> List (Element Styles variation Msg)
userPagePatternAPageLayout2 model=
    [ column None
        [][
        textLayout None
            [ spacingXY 25 25
            , center ][
                h1 Title
                    [](
                        Element.text "other-contents"
                    )
            ]
        , textLayout None
            [ paddingXY 10 10 ][
                otherContents model
            ]
        , if model.otherContentsStatus == Close then
            textLayout None
                [ paddingXY 10 10 ][
                row TextBox
                    [ width ( px ( model.width / 1.2) )
                    , alignRight ][
                    image None
                        [ width ( px ( model.width / 30 ) )
                        , height ( px ( model.width / 30 ) )
                        , onClick(
                            OtherModalOpen
                        )
                        ]{
                        src = "/src/Picture/plusButton.png"
                        , caption = "PlusButton"
                        }
                    ]
                ]
        else
            textLayout None
                [ paddingXY 10 10 ][
                otherContents model
                , otherContents model
                , row TextBox
                    [ width ( px ( model.width / 1.2) )
                    , alignRight ][
                    image None
                        [ width ( px ( model.width / 30 ) )
                        , height ( px ( model.width / 30 ) )
                        , onClick(
                            OtherModalClose
                        )
                        ]{
                        src = "/src/Picture/minusButton.png"
                        , caption = "MinusButton"
                        }
                    ]
                ]
        ]
    ]

otherContents : Model -> Element Styles variation msg
otherContents model =
    row TextBox
        [ paddingTop 100 ][
        column None
            [ width ( px ( model.width / 3.5 ) )
            , center ][
            row None
                [][
                image None 
                    [ width (px ( model.width / 10 ) )
                    , height ( px ( model.width / 10 ) )
                    ]{
                    src = "/src/Picture/VITORIA_logo.jpg"
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
                    src = "/src/Picture/VITORIA_logo.jpg"
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
                    src = "/src/Picture/VITORIA_logo.jpg"
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
                            src = "/src/Picture/VITORIA_logo.jpg"
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


menuModal : Model-> Element Styles variation Msg
menuModal model =
    modal ModalBK
       [ height ( px ( model.height ) )
        , width ( px ( model.width ) )
        , paddingTop ( model.height / 10 )
        , paddingLeft ( model.width / 1.3 )
        , onClick(
            MenuModalClose
        )] (
        column ModalContentStyle
            [ height fill
            , width ( px ( model.width / 4.6 ) ) 
            , yScrollbar
            , onClickStopPropagation Nothing
            ][
            column None
                [ paddingXY ( model.width / 100 ) ( model.height / 100 ) ][
                button BKWH
                    [ paddingTop ( model.height / 50 )
                    , width fill
                    , onClick (
                        ContentsListChenge
                        )
                    ] (
                    column None --TODO 画像を右寄り、文字は左寄り
                        [][
                        row MenuModalButton
                            [][
                            column None
                                [][
                                el None
                                    [](
                                        Element.text "CONTENTS"
                                    )
                                ]
                            , if model.contentsStatus == Open then
                                column None
                                    [][
                                    image None 
                                        [ width ( px ( model.width / 40 ) )
                                        , height ( px ( model.width / 40 ) )
                                        ]{
                                            src = "/src/Picture/minusButton.png"
                                            , caption = "MinusButton"
                                        }
                                    ]
                            else
                                column None
                                    [][
                                    image None 
                                        [ width ( px ( model.width / 40 ) )
                                        , height ( px ( model.width / 40 ) )
                                        ]{
                                            src = "/src/Picture/plusButton.png"
                                            , caption = "PlusButton"
                                        }
                                    ]
                            ]
                        , if model.contentsStatus == Open then
                            row MenuModalButton
                                [][
                                column None
                                    [][
                                    row None
                                        [][
                                        el None
                                            [](
                                                Element.text "CONTENTS_01"
                                            )
                                        ]
                                    , row None
                                        [][
                                        el None
                                            [](
                                                Element.text "CONTENTS_02"
                                            )
                                        ]
                                    , row None
                                        [][
                                        el None
                                            [](
                                                Element.text "CONTENTS_03"
                                            )
                                        ]
                                    ]
                                ]
                        else
                            textLayout None [][] 
                        ]
                    )
                , button MenuModalButton
                    [ paddingTop ( model.height / 50 )
                    , width fill ](
                        row None
                            [][
                            column None
                                [][
                                el None
                                    [](
                                        Element.text "会員情報"
                                    )
                                ]
                            , column None
                                [][
                                image None 
                                    [ width ( px ( model.width / 40 ) )
                                    , height ( px ( model.width / 40 ) )
                                    ]{
                                        src = "/src/Picture/rightArrow.png"
                                        , caption = "RightArrow"
                                    }
                                ]
                            ]
                    )
                , button MenuModalButton
                    [ paddingTop ( model.height / 50 )
                    , width fill ](
                    row None
                        [][
                        column None
                            [][
                            el None
                                [](
                                    Element.text "CONTACT"
                                )
                            ]
                        , column None
                                [][
                                image None 
                                [ width ( px ( model.width / 40 ) )
                                , height ( px ( model.width / 40 ) )
                                ]{
                                    src = "/src/Picture/rightArrow.png"
                                    , caption = "RightArrow"
                                }
                            ]
                        ]
                    )
                ]
            , row None
                [ center
                , paddingTop ( model.height / 5 ) ][
                button ButtonBK
                    [ paddingXY 20 0 ](
                        Element.text "LOGOUT"
                    )
                ]
            ]
        )

onClickStopPropagation : a -> Attribute variation a
onClickStopPropagation msg =
    stopPropagationOn "click" <| D.succeed ( msg, True )

