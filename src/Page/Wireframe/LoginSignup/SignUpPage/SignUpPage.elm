module Page.Wireframe.LoginSignup.SignUpPage.SignUpPage exposing (..)

import Color as Color255
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
    | Button
    | ModalContentStyle
    | TextBox
    | TextBoxRD
    | TextRD
    | Title
    | Link
    | ErrorMessage

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
    , name : String
    , password : String
    , passwordConfirmation : String
    , termsOfServiceStatus : Bool
    , signUpStatus : Bool }

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , name = ""
    , password = ""
    , passwordConfirmation = ""
    , termsOfServiceStatus = False
    , signUpStatus = False }

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | SignUpErrorOpen
    | InputName String
    | InputPassword String
    | InputPasswordConfirmation String
    | ChengetermsOfServiceStatus Bool

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

        SignUpErrorOpen ->
            ( { model |signUpStatus = True }, Cmd.none )

        InputName s ->
            ( { model | name = s }, Cmd.none )
        
        InputPassword s ->
            ( { model | password = s }, Cmd.none )
        
        InputPasswordConfirmation s ->
            ( { model | passwordConfirmation = s }, Cmd.none )
        
        ChengetermsOfServiceStatus bool ->
            ( { model |termsOfServiceStatus = 
                if bool then
                    False
                else
                    True }, Cmd.none )

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
            signUp model
        ]
    ]

signUp : Model -> Element Styles variation Msg
signUp model =
    modal None
       [height ( px ( model.height ) )
        , width ( px ( model.width ) )
        , paddingTop ( model.height / 30 )
        , paddingLeft ( model.width / 4 )
        ] (
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
                            ]
                        )
                    , if model.signUpStatus == True then
                        row ErrorMessage
                            [ width ( px ( model.width / 2.01 ) )
                            , paddingXY 0 ( model.height / 40 )
                            , center
                            ][
                                Element.text "入力内容に不備があります"
                            ]
                    else
                        row None [][]
                    , textLayout None
                        [ paddingTop ( model.height / 40 ) 
                        , center ][
                            Input.text TextBox
                            [ padding ( model.height / 50 )
                            , width ( px ( model.width / 2.5 ) ) ]{
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
                                    , text = "氏名を入力してください"
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
                                                Element.text "パスワード"
                                            )
                                        )
                                        , text = "パスワードを入力してください"
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
                        , textLayout None
                        [ paddingTop ( model.height / 40 )
                        , width ( px ( model.width / 2.5 ) )
                        , center ][
                            row None [][
                                column None [][
                                    Input.checkbox None
                                    []{
                                    onChange = ChengetermsOfServiceStatus
                                    , checked = model.termsOfServiceStatus
                                    , label =
                                        el None [] ( 
                                            link "http://zombo.com"
                                            <| el Link 
                                            [] (
                                                Element.text "利用規約"
                                            )
                                        )
                                    , options =[]
                                    }
                                ]
                                , column None [][
                                    Element.text "に同意します。"
                                ]
                            ]
                        ]
                    , if model.name == "" 
                        || model.password == ""
                        || model.passwordConfirmation == ""
                        || model.password /= model.passwordConfirmation
                        || model.termsOfServiceStatus == False then
                        textLayout None
                            [ padding ( model.height / 50 )
                            , paddingTop ( model.height / 10 )
                            , center ][ 
                            button ButtonGR
                                [ width ( px ( model.width / 2.5 ) )
                                , paddingXY 20 5
                                , onClick(
                                    Nothing --TODO
                                )](
                                    Element.text "新規会員登録"
                                )
                            ]
                    else
                        textLayout None
                            [ padding ( model.height / 50 )
                            , paddingTop ( model.height / 10 )
                            , center ][ 
                            button ButtonBK
                                [ width ( px ( model.width / 2.5 ) )
                                , paddingXY 20 5
                                , onClick(
                                    SignUpErrorOpen --TODO
                                )](
                                    Element.text "新規会員登録"
                                )
                            ]
                ]
        )

onClickStopPropagation : a -> Attribute variation a
onClickStopPropagation msg =
    stopPropagationOn "click" <| D.succeed ( msg, True )

