module Page.Top.Top exposing (..)

import Page.Color as Color255
import Task
import Element exposing (..)
import Element.Input as Input exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
import Element.Events exposing (stopPropagationOn)
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
    | Main
    | Logo
    | Button
    | MajorItem
    | MinorItem
    | DialogContainerStyle
    | ModalContentStyle
    | TextBox

type Variation
    = Disabled

stylesheet : Model -> StyleSheet Styles variation
stylesheet model =
    Style.styleSheet
        [ style None [] -- It's handy to have a blank style
        , style Header
            [ Color.background Color255.darkGray ]
        , style Footer
            [ Color.background Color255.darkGray
            , Font.size ( model.width / 100 )
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
        , style MajorItem
            [ Color.text Color255.white
            , Color.background Color255.black
            , Color.border Color255.black
            , Font.size ( model.width / 40 )
            , Border.all 2]
        , style MinorItem
            [ Color.text Color255.black
            , Color.background Color255.white
            , Color.border Color255.black
            , Font.size ( model.width / 40 )
            , Border.all 2]
        , style DialogContainerStyle
            [ Color.background Color255.translucentGray
            ]
        , style ModalContentStyle
            [ Color.background Color255.white
            ]
        , style TextBox
            [ Border.all 1
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
        , view = topPageElement
        , update = update
        , subscriptions = subscriptions
        }

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [E.onResize (\w h -> Resize ( toFloat w, toFloat h ))
        , case model.dropdownStatus of
            Open -> 
                case model.contentsButtonStatus of
                    ButtonOn ->
                        E.onClick ( D.succeed DropDownAndButtonClose )
                    ButtonOff ->
                        E.onClick ( D.succeed DropDownClose )
            Close ->
                case model.contentsButtonStatus of
                    ButtonOn ->
                        E.onClick ( D.succeed DropDownOpen )
                    ButtonOff ->
                        Sub.none
        ]

-- MODEL
type alias Model =
    { width : Float
    , height : Float
    , name : String
    , contentsButtonStatus : ButtonStatus
    , dropdownStatus : Status
    , modalStatus : Status}

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , name = ""
    , contentsButtonStatus = ButtonOff
    , dropdownStatus = Close
    , modalStatus = Close }

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | DropDownButtonOn
    | DropDownButtonOff
    | DropDownAndButtonClose
    | DropDownOpen
    | DropDownClose
    | ModalOpen
    | ModalClose
    | InputName String

type Status
    = Open
    | Close

type ButtonStatus
    = ButtonOn
    | ButtonOff

-- UPDATE
setCurrentDimensions : { a | width : b, height : c } -> ( b, c ) -> { a | width : b, height : c }
setCurrentDimensions model ( w, h ) =
    { model | width = w, height = h }
setName : { a | name : b } -> b -> { a | name : b }
setName model ( s ) =
    { model | name = s }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotInitialViewport vp ->
            ( setCurrentDimensions model ( vp.scene.width, vp.scene.height ), Cmd.none )

        Resize ( w, h ) ->
            ( setCurrentDimensions model ( w, h ), Cmd.none )

        Nothing ->
            ( model, Cmd.none )

        DropDownButtonOn ->
            ( { model |contentsButtonStatus = ButtonOn }, Cmd.none )

        DropDownButtonOff ->
            ( { model |contentsButtonStatus = ButtonOff }, Cmd.none )

        DropDownAndButtonClose ->
            ( { model |dropdownStatus = Close
                , contentsButtonStatus = ButtonOff }, Cmd.none )

        DropDownOpen ->
            ( { model |dropdownStatus = Open }, Cmd.none )

        DropDownClose ->
            ( { model |dropdownStatus = Close }, Cmd.none )

        ModalOpen ->
            ( { model |modalStatus = Open }, Cmd.none )

        ModalClose ->
            ( { model |modalStatus = Close }, Cmd.none )

        InputName s ->
            ( setName model ( s ), Cmd.none )

topPageElement : Model -> Html Msg
topPageElement model=
    Element.layout ( stylesheet model ) <|
        column None
            [][
                headerLayout model
                , el None
                    [ height ( px ( model.height - ( model.height / 10 ) *2 ))
                    , yScrollbar
                    ] <|
                    column Main
                        [ height fill
                        , width fill
                        , center
                        , verticalCenter
                        ]
                        (List.concat
                            [ topPageLayout model ]
                        )
                , footerLayout model
            ]

headerLayout : Model -> Element Styles variation Msg
headerLayout model =
    let 
        contentsButton =
            case model.dropdownStatus of
                Open ->
                    row None[][
                        Element.below [accordionVideolink model.width model.height] empty
                        , button Button
                            [ paddingXY 20 0 
                            , onClick (
                                    DropDownButtonOff
                                )
                            ](
                                Element.text "Contents"
                            )
                    ]
                Close ->
                    row None[][
                        button Button
                            [ paddingXY 20 0 
                            , onClick (
                                    DropDownButtonOn
                                )
                            ](
                                Element.text "Contents"
                            )
                    ]
    in 
    row Header
        [ spread
        , paddingXY 30 20 
        , height ( px ( model.height / 10 ) )
        , width ( px ( model.width ) )
        ][
            el Logo
                [ verticalCenter ] (
                    image None 
                        [ width ( px ( model.width / 25 ) )
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
                    , contentsButton
                    , button Button
                        [ paddingXY 20 0 ](
                            Element.text "Contact"
                        )
                ]
        ]

accordionVideolink : Float -> Float -> Element Styles variation msg
accordionVideolink modelWidth modelHeight=
    column None
        [ width (px (modelWidth/4.8))
        , height (px (modelHeight/4.8) )][
            majorItems "git講習"
            , minorItem "https://www.youtube.com/embed/Js_8xBDhhwE" "基本コマンド1"
            , minorItem "https://www.youtube.com/embed/eZ9M16REQiQ" "基本コマンド2"
            , majorItems "ゲーム講習"
            , minorItem "https://www.youtube.com/embed/Ht6R3OosXDk" "【初歩編】第1回"
            , minorItem "https://www.youtube.com/embed/9g-NnkrScng" "【初歩編】第2回"
        ]

majorItems : String -> Element Styles variation msg
majorItems title =
    el MajorItem 
        []( Element.text title )


minorItem : String -> String -> Element Styles variation msg
minorItem urlString titleString =
    el MinorItem
        []( newTab urlString ( Element.text titleString ) )

topPageLayout : Model -> List (Element Styles variation Msg)
topPageLayout model =
    [ button  Button
        [ paddingXY 20 0
        , onClick(
            ModalOpen
        )](
            Element.text "新規会員登録"
        )
    , if model.modalStatus == Open then
        topPageModal model
    else
        textLayout None [][]
    ]

topPageModal : Model -> Element Styles variation Msg
topPageModal model =
    modal DialogContainerStyle
       [height ( px ( model.height ) )
        , width ( px ( model.width ) )
        , paddingTop ( model.height / 20 )
        , paddingLeft ( model.width / 4 )
        , onClick(
            ModalClose
        )] (
            column ModalContentStyle
                [ height ( px ( model.height / 1.3 ) )
                , width ( px ( model.width / 2 ) ) 
                , center
                , yScrollbar
                , onClickStopPropagation Nothing
                ][
                    h1 None
                        [ paddingXY 0 10](
                        row None
                            [][
                            row None
                                [ width ( px ( model.width / 2 - ( model.width / 30 ) ) ) 
                                , center][
                                    Element.text "会員登録"
                                ]
                            , row None
                                [alignRight][
                                    image None 
                                    [ width ( px ( model.width / 50 ) )
                                    , height ( px ( model.width / 50 ) )
                                    , onClick(
                                        ModalClose
                                        )
                                    ]{
                                        src = "../../Picture/CloseButton.png"
                                        , caption = "CloseButton"
                                    }
                                ]
                            ]
                        )
                    , textLayout None
                        [ paddingTop 10 ][
                            Input.text TextBox
                            [ padding 10
                            , width ( px ( model.width / 3 ) ) ]{
                                onChange = InputName
                                , value = model.name
                                , label =
                                    Input.placeholder {
                                        label = Input.labelAbove (
                                        el None
                                            [ verticalCenter ] (
                                                Element.text "氏名"
                                            )
                                        )
                                    , text = ""
                                    }
                                , options =[]
                            }
                        ]
                    , textLayout None
                        [ paddingTop 10 ][
                            Input.text TextBox
                            [ padding 10
                            , width ( px ( model.width / 3 ) ) ]{
                                onChange = InputName
                                , value = model.name
                                , label =
                                    Input.placeholder {
                                        label = Input.labelAbove (
                                        el None
                                            [ verticalCenter ] (
                                                Element.text "メールアドレス"
                                            )
                                        )
                                    , text = ""
                                    }
                                , options =[]
                            }
                        ]
                    , textLayout None
                        [ paddingTop 10 ][
                            Input.newPassword TextBox
                            [ padding 10
                            , width ( px ( model.width / 3 ) ) ]{
                                onChange = InputName
                                , value = model.name
                                , label =
                                    Input.placeholder {
                                        label = Input.labelAbove (
                                        el None
                                            [ verticalCenter ] (
                                                Element.text "パスワード"
                                            )
                                        )
                                        , text = ""
                                    }
                                , options =[]
                            }
                        ]
                    , textLayout None
                        [ paddingTop 10 ][
                            Input.currentPassword TextBox
                            [ padding 10
                            , width ( px ( model.width / 3 ) ) ]{
                                onChange = InputName
                                , value = model.name
                                , label =
                                    Input.placeholder {
                                        label = Input.labelAbove (
                                        el None
                                            [ verticalCenter ] (
                                                Element.text "パスワード（確認）"
                                            )
                                        )
                                        , text = ""
                                    }
                                , options =[]
                            }
                        ]
                    , textLayout None
                        [ padding 10 ][ 
                        button Button
                            [ onClick(
                                ModalClose
                            )](
                                Element.text "送信"
                            )
                        ]
                ]
        )

onClickStopPropagation : a -> Attribute variation a
onClickStopPropagation msg =
    stopPropagationOn "click" <| D.succeed ( msg, True )

footerLayout : Model -> Element Styles variation msg
footerLayout model =
    row Footer
        [ paddingLeft  ( model.width / 50 )
        , height ( px ( model.height / 10 ) )
        , width ( px ( model.width ) ) ][
            paragraph None
                [] [
                    Element.text "© 2023 React Inc. All Rights Reserved.I'm happy! thank you!"
                ]
        ]
