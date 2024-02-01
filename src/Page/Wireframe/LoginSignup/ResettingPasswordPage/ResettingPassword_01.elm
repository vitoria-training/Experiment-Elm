module Page.Wireframe.LoginSignup.ResettingPasswordPage.ResettingPassword_01 exposing (..)

import Page.Color as Color255
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
    | TextBox
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
        , style TextBox
            [ Border.all 1
            , Border.solid
            , Border.rounded 10.0
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
        , view = sendResetEmailElement
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
    , mailstatus : Bool }

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , mail = ""
    , mailstatus = False }

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | InputMail String
    | ChengeMailStatus
    | ChengeMailStatusAndMail

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
        
        ChengeMailStatus ->
            ( { model | mailstatus = 
                if model.mailstatus == False then
                    True
                else
                    False }, Cmd.none )
        
        ChengeMailStatusAndMail->
            ( { model | mailstatus = 
                if model.mailstatus == False then
                    True
                else
                    False 
                , mail = "" },  Cmd.none )

sendResetEmailElement : Model -> Html Msg
sendResetEmailElement model=
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
                            [ if model.mailstatus == False then
                                resettingPassword_01Layout model
                            else
                                resettingPassword_02Layout model
                            ]
                        )
            ]

resettingPassword_01Layout : Model -> List (Element Styles variation Msg)
resettingPassword_01Layout model =
    [ h1 Title
        [ paddingBottom ( model.height / 10 ) ](
            Element.text "パスワードを再設定します。メールアドレスを入力してください。"
        )
    , textLayout None
        [ paddingBottom ( model.height / 5 ) ][
            Input.text TextBox
            [ padding ( model.height / 50 )
            , width ( px ( model.width / 3 ) ) ]{
                onChange = InputMail
                , value = model.mail
                , label =
                    Input.placeholder
                    { label = Input.labelAbove (
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
    , row None 
        [ padding ( model.height / 50 ) ][
        if model.mail == "" then 
            button ButtonGR
                [ paddingXY (model.width / 50 ) 0
                , width ( px ( model.width / 3 ) )
                , onClick(
                    Nothing
                )](
                    Element.text "パスワードを再設定"
                )
        else
            button ButtonBK
                [ paddingXY (model.width / 50 ) 0
                , width ( px ( model.width / 3 ) )
                , onClick(
                    ChengeMailStatus
                )](
                    Element.text "パスワードを再設定"
                )
            ]
    , row None 
        [ padding ( model.height / 50 ) ][
        button ButtonWH
            [ center
            , onClick(
                Nothing--ChengeToppage
            )](
                Element.text "キャンセル"
            )
        ]
    ]

resettingPassword_02Layout : Model -> List (Element Styles variation Msg)
resettingPassword_02Layout model =
    [ h1 Title
        [ paddingBottom ( model.height / 10 ) ](
            Element.text "メールをご確認ください。"
        )
    , el None
        [ verticalCenter ] (
            Element.text ( "パスワード再設定メールを "++ model.mail ++" 宛にお送りしました。" )
        )
    , el None
        [ verticalCenter ] (
            Element.text "お送りしたメールの内容に従ってパスワードを再設定してください。"
        )
    , row None 
        [ padding ( model.height / 50 ) ][
        button ButtonWH
            [ center
            , onClick(
                ChengeMailStatusAndMail -- Where are we going back?
            )](
                Element.text "戻る"
            )
        ]
    ]