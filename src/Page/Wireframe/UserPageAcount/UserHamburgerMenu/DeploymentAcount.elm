module Page.Wireframe.UserPageAcount.UserHamburgerMenu.DeploymentAcount exposing (..)

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
    | TextIDBox
    | TextIDInputBox
    | ModalContentStyle
    | ModalBK
    | ButtonBK
    | ButtonWH
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
            , Font.size ( model.width / 50 )
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
        , style TextIDBox
            [ Color.border Color255.darkGray
            , Font.lineHeight 2
            , Font.bold
            , Border.all 2
            ]
        , style TextIDInputBox
            [ Color.border Color255.darkGray
            , Font.lineHeight 2
            , Font.bold
            , Border.all 2
            , Border.rounded 10.0
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
        , style ButtonWH
            [ Color.text Color255.black
            , Color.background Color255.white
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
        , view = nameElement
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
    , contentsStatus : OPStatus }

type OPStatus
    = Open
    | Close

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , menuStatus = Close
    , contentsStatus = Close }

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | MenuModalOpen
    | MenuModalClose
    | ContentsListChenge

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

nameElement : Model -> Html Msg
nameElement model=
    Element.layout (stylesheet model) <|
        column None
            [yScrollbar][
                headerLayout model
                , el None
                    [] <|
                    column Main
                        [ width fill
                        , height ( px ( model.height - model.height / 10 - model.height / 5 ) )
                        , center
                        , verticalCenter
                        , paddingXY 0 20
                        ](
                            namePageLayout1 model
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

namePageLayout1 : Model -> List (Element Styles variation Msg)
namePageLayout1 model=
    [ column None
        [ height ( px ( model.height / 1.6 ) )
        , width fill ][
            row None
                [][
                textLayout None
                    [ spacingXY 25 25 ][
                    h1 Title
                        [](
                            Element.text "会員情報"
                        )
                    ]
                ]
            , row TextBox
                [ paddingXY 10 10
                , height fill
                , center ][
                column TextIDBox
                    [ padding 20
                    , width ( px ( model.width / 2.5 ) ) 
                    , center ][
                    column None
                        [ width ( px ( model.width / 3 ) )
                        , paddingBottom 10 ][
                        button None
                            [](
                            column None
                                [ width fill ][
                                row None
                                    [][
                                    column None
                                        [ width (px ( model.width / 3.5 ) )
                                        , alignLeft ][
                                            Element.text "ユーザー名/ID"
                                        ]
                                    , column None
                                        [][
                                            Element.text "変更"
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
                                , row None
                                    [][
                                    column None
                                        [][
                                            Element.text "NAME0120"
                                        ]
                                    ]
                                ]
                            )
                        ]
                    , column None
                        [ width ( px ( model.width / 3 ) )
                        , paddingBottom 10 ][
                        button None
                            [](
                            column None
                                [ width fill ][
                                row None
                                    [][
                                    column None
                                        [ width (px ( model.width / 3.5 ) )
                                        , alignLeft ][
                                            Element.text "メールアドレス"
                                        ]
                                    , column None
                                        [][
                                            Element.text "変更"
                                        ]
                                    , column None
                                        [ alignRight ][
                                        image None 
                                            [ width ( px ( model.width / 40 ) )
                                            , height ( px ( model.width / 40 ) )
                                            ]{
                                                src = "/src/Picture/rightArrow.png"
                                                , caption = "RightArrow"
                                            }
                                        ]
                                    ]
                                , row None
                                    [][
                                    column None
                                        [][
                                            Element.text "@gmail.com"
                                        ]
                                    ]
                                ]
                            )
                        ]
                    , column None
                        [ width ( px ( model.width / 3 ) )
                        , paddingBottom 10 ][
                        button None
                            [](
                            column None
                                [ width fill ][
                                row None
                                    [ width fill ][
                                    column None
                                        [ width (px ( model.width / 3.5 ) )
                                        , alignLeft ][
                                            Element.text "パスワード"
                                        ]
                                    , column None
                                        [][
                                            Element.text "変更"
                                        ]
                                    , column None
                                        [ alignRight ][
                                        image None
                                            [ width ( px ( model.width / 40 ) )
                                            , height ( px ( model.width / 40 ) )
                                            ]{
                                                src = "/src/Picture/rightArrow.png"
                                                , caption = "RightArrow"
                                            }
                                        ]
                                    ]
                                , row None
                                    [][
                                    column None
                                        [][
                                            Element.text "パスワード"
                                        ]
                                    ]
                                ]
                            )
                        ]
                    , column None
                        [ width ( px ( model.width / 3 ) )
                        , paddingBottom 10 ][
                        button None
                            [ width fill ](
                            row None
                                [][
                                column None
                                    [ width (px ( model.width / 3.22 ) )
                                        , alignLeft ][
                                        Element.text "アカウントの削除"
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
                    ]
                ]
            , if model.menuStatus == Open then
                menuModal model
            else
                textLayout None [][]
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

