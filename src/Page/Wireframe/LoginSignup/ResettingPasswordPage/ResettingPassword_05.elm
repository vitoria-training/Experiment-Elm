module Page.Wireframe.LoginSignup.ResettingPasswordPage.ResettingPassword_05 exposing (..)

import Color as Color255
import Task
import Element exposing (..)
import Element.Input as Input exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick)
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
    | Main
    | ButtonGR
    | ButtonBK
    | ButtonWH
    | Button
    | ModalContentStyle
    | TextBox
    | TextBoxRD
    | TextRD
    | Title

type Variation
    = Disabled

stylesheet : Model -> StyleSheet Styles variation
stylesheet model =
    Style.styleSheet
        [ style None [] -- It's handy to have a blank style
        , style Main
            [ Border.all 1
            , Color.text Color255.darkCharcoal
            , Color.background Color255.white
            , Color.border Color255.grey
            , Font.size ( model.width / 80 )
            , Font.lineHeight 1.3
            ]
        , style ButtonGR
            [ Color.text Color255.white
            , Color.background Color255.gray
            , Color.border Color255.gray
            , Font.size ( model.width / 40 )
            , Border.all 2
            , Border.rounded 10.0
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
            , Font.size ( model.width / 40 )
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
        , style ModalContentStyle
            [ Color.background Color255.white
            , Color.border Color255.gray
            , Border.all 1.5
            , Border.solid
            , Border.rounded 10.0
            ]
        , style TextBox
            [ Border.all 1
            , Border.solid
            , Border.rounded 10.0
            ]
        , style TextBoxRD
            [ Border.all 2
            , Border.rounded 10.0
            , Color.border Color255.lightRed
            ]
        , style TextRD
            [ Color.text Color255.lightRed
            ]
        , style Title
            [ Font.bold
            , Font.size ( model.width / 40)
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

subscriptions : model -> Sub Msg
subscriptions _ =
    Sub.batch
        [E.onResize (\w h -> Resize ( toFloat w, toFloat h ))
        ]

-- MODEL
type alias Model =
    { width : Float
    , height : Float
    , mail : String
    , password : String
    , passwordConfirmation : String
    , modalStatus : Status }

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , mail = ""
    , password = ""
    , passwordConfirmation = ""
    , modalStatus = Close }

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | InputMail String
    | InputPassword String
    | InputPasswordConfirmation String
    | LisetStatus

type Status
    = Open
    | Close

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
        
        InputMail s ->
            ( { model | mail = s }, Cmd.none )
        
        InputPassword s ->
            ( { model | password = s }, Cmd.none )
        
        InputPasswordConfirmation s ->
            ( { model | passwordConfirmation = s }, Cmd.none )
        
        LisetStatus ->
            ( { model | modalStatus = Close
                , mail = "" 
                , password = "" 
                , passwordConfirmation = "" }, Cmd.none )

topPageElement : Model -> Html Msg
topPageElement model=
    Element.layout ( stylesheet model ) <|
        column None
            [][
                el None
                    [ height ( px ( model.height ) )
                    , yScrollbar
                    ] <|
                    column Main
                        [ height fill
                        , width fill
                        , center
                        , verticalCenter
                        ]
                        (List.concat
                            [ resettingPassword_05Layout model ]
                        )
            ]

resettingPassword_05Layout : Model -> List (Element Styles variation Msg)
resettingPassword_05Layout model =
    [ modal None
       [height ( px ( model.height ) )
        , width ( px ( model.width ) )
        , paddingTop ( model.height / 30 )
        , paddingLeft ( model.width / 4 ) ] (
            column ModalContentStyle
                [ height ( px ( model.height / 1.05 ) )
                , width ( px ( model.width / 2 ) ) 
                , yScrollbar
                ][
                    h1 None
                        [](
                        row None
                            [ paddingTop ( model.height / 30 ) ][
                            row Title
                                [ width ( px ( model.width / 2 - ( model.width / 30 ) ) ) 
                                , center
                                ][
                                    Element.text "新しいパスワードの設定"
                                ]
                            ]
                        )
                    , textLayout None
                        [ paddingTop ( model.height / 40 )
                        , center ][
                            Input.text TextBox
                            [ padding ( model.height / 50 )
                            , width ( px ( model.width / 2.5 ) ) ]{
                                onChange = InputMail
                                , value = model.mail
                                , label =
                                    Input.placeholder {
                                        label = Input.labelAbove (
                                        el None
                                            [ verticalCenter ] (
                                                Element.text "メールアドレス"
                                            )
                                        )
                                    , text = "メールアドレスを入力してください"
                                    }
                                , options =[]
                            }
                        ]
                    , textLayout None
                        [ paddingTop ( model.height / 40 )
                        , center ][
                            Input.newPassword TextBox
                            [ padding ( model.height / 50 )
                            , width ( px ( model.width / 2.5 ) ) ]{
                                onChange = InputPassword
                                , value = model.password
                                , label =
                                    Input.placeholder {
                                        label = Input.labelAbove (
                                        el None
                                            [ verticalCenter ] (
                                                Element.text "新しいパスワード"
                                            )
                                        )
                                        , text = "新しいパスワードを入力してください"
                                    }
                                , options =[]
                            }
                        ]
                    , if model.password == model.passwordConfirmation then
                        textLayout None
                            [ paddingTop ( model.height / 40 )
                            , center ][
                                Input.currentPassword TextBox
                                [ padding ( model.height / 50 )
                                , width ( px ( model.width / 2.5 ) ) ]{
                                    onChange = InputPasswordConfirmation
                                    , value = model.passwordConfirmation
                                    , label =
                                        Input.placeholder {
                                            label = Input.labelAbove (
                                            el None
                                                [ verticalCenter ] (
                                                    Element.text "パスワード確認"
                                                )
                                            )
                                            , text = "パスワードを入力してください"
                                        }
                                    , options =[]
                                }
                            ]
                    else
                        textLayout None
                            [ paddingTop ( model.height / 40 )
                            , center ][
                                Input.currentPassword TextBoxRD
                                [ padding ( model.height / 50 )
                                , width ( px ( model.width / 2.5 ) ) ]{
                                    onChange = InputPasswordConfirmation
                                    , value = model.passwordConfirmation
                                    , label =
                                        Input.placeholder {
                                            label = Input.labelAbove (
                                            el None
                                                [ verticalCenter ] (
                                                    Element.text "パスワード確認"
                                                )
                                            )
                                            , text = "パスワードを入力してください"
                                        }
                                    , options =[]
                                }
                                , el TextRD 
                                [ paddingTop ( model.height / 50 ) ](
                                    Element.text "パスワードとパスワード確認の入力値が異なっています"
                                )
                            ]
                    , row None 
                        [ padding ( model.height / 50 )
                        , paddingTop ( model.height / 10 )
                        , center ][
                        if model.mail == ""
                            || model.password == ""
                            || model.passwordConfirmation == ""
                            || model.password /= model.passwordConfirmation then 
                            button ButtonGR
                                [ paddingXY (model.width / 40 ) 0
                                , width ( px ( model.width / 2.5 ) )
                                , onClick(
                                    Nothing
                                )](
                                    Element.text "パスワードを再設定"
                                )
                        else
                            button ButtonBK
                                [ paddingXY (model.width / 40 ) 0
                                , width ( px ( model.width / 2.5 ) )
                                , onClick(
                                    Nothing
                                )](
                                    Element.text "パスワードを再設定"
                                )
                        ]
                    , textLayout None 
                        [ padding ( model.height / 50 )
                        , center ][
                        button ButtonWH
                            [ onClick(
                                Nothing--ChengeToppage
                            )](
                                Element.text "キャンセル"
                            )
                        ]
                ]
        )
    ]