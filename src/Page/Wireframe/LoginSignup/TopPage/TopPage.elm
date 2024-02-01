module Page.Wireframe.LoginSignup.TopPage.TopPage exposing (..)

import Page.Color as Color255
import Task
import Element exposing (..)
import Element.Input as Input exposing (..)
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
    | Link
    | ErrorMessage
    | BorderTop

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
            , Color.border Color255.gray
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
            , Color.border Color255.black
            , Font.size ( model.width / 40 )
            , Border.all 2
            , Border.rounded 10.0
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
            ]
        , style Link
            [ Border.bottom 1.0
            , Border.solid
            , Font.bold
            ]
        , style ErrorMessage
            [ Color.text Color255.lightRed
            , Color.background Color255.pink
            , Font.bold
            ]
        , style BorderTop
            [ Border.top 2
            , Border.solid
            , Color.border Color255.gray
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
    , loginStatus : Bool
    , loginMail : String
    , loginPassword : String
    , mail : String
    , loginModalStatus : Status
    , signUpModalStatus : Status }

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , loginStatus = False
    , loginMail = ""
    , loginPassword = ""
    , mail = ""
    , loginModalStatus = Close 
    , signUpModalStatus = Close }

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | LoginModalOpen
    | LoginModalClose
    | LoginModalCloseAndSignUpModalOpen
    | LoginErrorOpen
    | SignUpModalOpen
    | SignUpModalClose
    | InputLoginMail String
    | InputLoginPassword String
    | InputMail String

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
        
        LoginModalOpen ->
            ( { model |loginModalStatus = Open }, Cmd.none )

        LoginModalClose ->
            ( { model |loginModalStatus = Close
                , loginMail = ""
                , loginPassword = ""
                , loginStatus = False }, Cmd.none )

        LoginModalCloseAndSignUpModalOpen ->
            ( { model |loginModalStatus = Close
                , loginMail = ""
                , loginPassword = "" 
                , signUpModalStatus = Open
                , loginStatus = False }, Cmd.none )

        LoginErrorOpen ->
            ( { model |loginStatus = True }, Cmd.none )

        SignUpModalOpen ->
            ( { model |signUpModalStatus = Open }, Cmd.none )

        SignUpModalClose ->
            ( { model |signUpModalStatus = Close
                , mail = "" }, Cmd.none )

        InputLoginMail s ->
            ( { model | loginMail = s }, Cmd.none )
        
        InputLoginPassword s ->
            ( { model | loginPassword = s }, Cmd.none )
        
        InputMail s ->
            ( { model | mail = s }, Cmd.none )
        
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
                            [ topPageLayout model ]
                        )
            ]

topPageLayout : Model -> List (Element Styles variation Msg)
topPageLayout model =
    [ row None 
        [ paddingBottom 10 ][
        button ButtonBK
            [ paddingXY 20 0
            , width ( px ( model.width / 3 ) )
            , onClick(
                LoginModalOpen
            )](
                Element.text "ログイン"
            )
        ]
    , row None 
        [ paddingTop 10 ][
        button ButtonBK
            [ paddingXY 20 0
            , width ( px ( model.width / 3 ) )
            , onClick(
                SignUpModalOpen
            )](
                Element.text "新規会員登録"
            )
        ]
    , if model.loginModalStatus == Open then
        loginModal model
    else if model.signUpModalStatus == Open then
        signUpModal model
    else
        textLayout None [][]
    ]

loginModal : Model -> Element Styles variation Msg
loginModal model =
    modal None
       [height ( px ( model.height ) )
        , width ( px ( model.width ) )
        , paddingTop ( model.height / 20 )
        , paddingLeft ( model.width / 4 )
        , onClick(
            LoginModalClose
        )] (
            column ModalContentStyle
                [ height ( px ( model.height / 1.1 ) )
                , width ( px ( model.width / 2 ) ) 
                , center
                , yScrollbar
                , onClickStopPropagation Nothing
                ][
                    h1 None
                        [ paddingXY 0 10](
                        row None
                            [][
                            row Title
                                [ width ( px ( model.width / 2.15 ) )
                                , paddingLeft ( model.width / 40 ) 
                                ][
                                    Element.text "ログイン"
                                ]
                            , row None
                                [ alignRight ][
                                    image None 
                                    [ width ( px ( model.width / 50 ) )
                                    , height ( px ( model.width / 50 ) )
                                    , onClick(
                                        LoginModalClose
                                        )
                                    ]{
                                        src = "../../../Picture/CloseButton.png"
                                        , caption = "CloseButton"
                                    }
                                ]
                            ]
                        )
                    , if model.loginStatus == True then
                        row ErrorMessage
                            [ width ( px ( model.width / 2.01 ) )
                            , paddingXY 0 ( model.height / 40 )
                            , center
                            ][
                                Element.text "メールアドレスまたはパスワードに誤りがあります"
                            ]
                    else
                        row None [][]
                    , textLayout None
                        [ paddingTop ( model.height / 40 ) ][
                            Input.text TextBox
                            [ padding ( model.height / 50 )
                            , width ( px ( model.width / 2.5 ) ) ]{
                                onChange = InputLoginMail
                                , value = model.loginMail
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
                        [ paddingTop ( model.height / 40 ) ][
                            Input.currentPassword TextBox
                            [ padding ( model.height / 50 )
                            , width ( px ( model.width / 2.5 ) ) ]{
                                onChange = InputLoginPassword
                                , value = model.loginPassword
                                , label =
                                    Input.placeholder {
                                        label = Input.labelAbove (
                                        el None
                                            [ verticalCenter ] (
                                                Element.text "パスワード"
                                            )
                                        )
                                        , text = "パスワードを入力してください"
                                    }
                                , options =[]
                            }
                        ]
                    , textLayout None
                        [ paddingTop ( model.height / 40 ) ][
                            link "http://zombo.com"
                                <| el Link 
                                [ center ] (
                                    Element.text "パスワードを忘れた方はこちら"
                                )
                        ]
                    , textLayout None
                        [ padding ( model.height / 50 ) ][ 
                        button ButtonBK
                            [ width ( px ( model.width / 2.5 ) )
                            , paddingXY 20 5
                            , onClick(
                                LoginErrorOpen--TODO
                            )](
                                Element.text "ログイン"
                            )
                        ]
                    , column BorderTop [width ( px ( model.width / 2.01 ) )]
                        [ h1 Title
                            [ width ( px ( model.width / 2.5 ) )
                            , paddingTop ( model.height / 30 )
                            , paddingLeft ( model.width / 30 )
                            ](
                                Element.text "会員登録がまだの方はこちら"
                            )
                        , textLayout None
                            [ padding ( model.height / 50 )
                            , center ][ 
                                button ButtonWH
                                [ width ( px ( model.width / 2.5 ) )
                                , paddingXY 20 5
                                , onClick(
                                    LoginModalCloseAndSignUpModalOpen
                                )](
                                    Element.text "新規会員登録"
                                )
                            ]
                        ]
                ]
        )

signUpModal : Model -> Element Styles variation Msg
signUpModal model =
    modal None
       [height ( px ( model.height ) )
        , width ( px ( model.width ) )
        , paddingTop ( model.height / 30 )
        , paddingLeft ( model.width / 4 )
        , onClick(
            SignUpModalClose
        )] (
            column ModalContentStyle
                [ height ( px ( model.height / 1.05 ) )
                , width ( px ( model.width / 2 ) ) 
                , yScrollbar
                , onClickStopPropagation Nothing
                ][
                    h1 None
                        [ paddingXY 0 ( model.height / 100 )
                        , center ](
                        row None
                            [ paddingTop ( model.height / 100 ) ][
                            row Title
                                [ width ( px ( model.width / 2 - ( model.width / 30 ) ) ) 
                                ][
                                    Element.text "新規会員登録"
                                ]
                            , row None
                                [ alignRight ][
                                    image None 
                                    [ width ( px ( model.width / 50 ) )
                                    , height ( px ( model.width / 50 ) )
                                    , onClick(
                                        SignUpModalClose
                                        )
                                    ]{
                                        src = "../../../Picture/CloseButton.png"
                                        , caption = "CloseButton"
                                    }
                                ]
                            ]
                        )
                    , textLayout None
                        [ paddingTop ( model.height / 10 )
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
                    , if model.mail == "" then 
                        textLayout None
                            [ padding ( model.height / 50 )
                            , paddingTop ( model.height / 5 )
                            , center ][ 
                            button ButtonGR
                                [ width ( px ( model.width / 2.5 ) )
                                , paddingXY 20 5
                                , onClick(
                                    Nothing
                                )](
                                    Element.text "新規会員登録"
                                )
                            ]
                    else
                        textLayout None
                            [ padding ( model.height / 50 )
                            , paddingTop ( model.height / 5 )
                            , center ][ 
                            button ButtonBK
                                [ width ( px ( model.width / 2.5 ) )
                                , paddingXY 20 5
                                , onClick(
                                    SignUpModalClose
                                )](
                                    Element.text "新規会員登録"
                                )
                            ]
                ]
        )

onClickStopPropagation : a -> Attribute variation a
onClickStopPropagation msg =
    stopPropagationOn "click" <| D.succeed ( msg, True )

