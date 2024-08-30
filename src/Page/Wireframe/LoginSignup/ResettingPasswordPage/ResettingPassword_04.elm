module Page.Wireframe.LoginSignup.ResettingPasswordPage.ResettingPassword_04 exposing (..)

import Color as Color255
import Task
import Element exposing (..)
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
    | ButtonBK
    | ButtonWH
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
                            [ resettingPassword_04Layout model ]
                        )
            ]

resettingPassword_04Layout : Model -> List (Element Styles variation Msg)
resettingPassword_04Layout model =
    [ h1 Title
        [ paddingBottom ( model.height / 10 ) ](
            Element.text "下のボタンをクリックして、VITアカウントのパスワードを再設定してください。"
        )
    , textLayout None
        [ padding ( model.height / 50 ) ][
        button ButtonBK
            [ paddingXY (model.width / 40 ) 0
            , width ( px ( model.width / 3 ) )
            , onClick(
                Nothing
            )](
                Element.text "パスワードを再設定"
            )
        ]
    , row None 
        [ padding ( model.height / 50 ) ][
        button ButtonWH
            [ center
            , onClick(
                Nothing
            )](
                Element.text "キャンセル"
            )
        ]
    ]
