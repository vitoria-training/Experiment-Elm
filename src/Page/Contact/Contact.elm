module Page.Contact.Contact exposing (..)

import Page.Color as Color255
import Task
import Element exposing (..)
import Element.Input as Input exposing (..)
import Element.Attributes exposing (..)
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
    | Header
    | Footer
    | Title
    | Main
    | Logo
    | Button
    | TextBox

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
            [ Border.all 1
            ]
        ]

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
        , view = contactElement
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
    , name : String
    , address : String
    , title : String
    , message : String }

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , name = ""
    , address = ""
    , title = ""
    , message = "" }

type Msg
    = NoOp
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | InputName String
    | InputAddress String
    | InputTitle String
    | InputMessage String

-- UPDATE
setCurrentDimensions : { a | width : b, height : c } -> ( b, c ) -> { a | width : b, height : c }
setCurrentDimensions model ( w, h ) =
    { model | width = w, height = h }
setName : { a | name : b } -> b -> { a | name : b }
setName model ( s ) =
    { model | name = s }
setAddress : { a | address : b } -> b -> { a | address : b }
setAddress model ( s ) =
    { model | address = s }
setTitle : { a | title : b } -> b -> { a | title : b }
setTitle model ( s ) =
    { model | title = s }
setMessage : { a | message : b } -> b -> { a | message : b }
setMessage model ( s ) =
    { model | message = s }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotInitialViewport vp ->
            ( setCurrentDimensions model ( vp.scene.width, vp.scene.height ), Cmd.none )

        Resize ( w, h ) ->
            ( setCurrentDimensions model ( w, h ), Cmd.none )

        NoOp ->
            ( model, Cmd.none )
        
        InputName s ->
            ( setName model ( s ), Cmd.none )
        
        InputAddress s ->
            ( setAddress model ( s ), Cmd.none )
        
        InputTitle s ->
            ( setTitle model ( s ), Cmd.none )
        
        InputMessage s ->
            ( setMessage model ( s ), Cmd.none )

contactElement : Model -> Html Msg
contactElement model=
    Element.layout (stylesheet model)  <|
        column None
            [] [
                headerLayout model
                , el None
                    [ height ( px ( model.height - ( model.height / 10 ) *2 ) )
                    , yScrollbar
                    ] <|
                    column Main
                        [ width fill
                        , center
                        , verticalCenter
                        , yScrollbar
                        , paddingTop ( model.height / 10 )
                        ] (
                            List.concat [ contactLayout model ]
                        )
                , footerwLayout model
            ]

headerLayout : Model -> Element Styles variation msg
headerLayout model =
    row Header
        [ spread
        , paddingXY 30 20 
        , height ( px ( model.height / 10 ) )
        , width ( px ( model.width ) )
        ][
            el Logo
                [ verticalCenter ] (
                    image None 
                        [ width (px ( model.width / 25 ) )
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
                    , button Button
                        [ paddingXY 20 0 ](
                            Element.text "Contents"
                        )
                    , button Button
                        [ paddingXY 20 0 ](
                            Element.text "Contact"
                        )
                ]
        ]

contactLayout : Model -> List (Element Styles variation Msg)
contactLayout model=
    [ textLayout None
        [ spacingXY 25 25 ][
            h1 Title
                [ padding 10 ](
                    Element.text "CONTACT"
                )
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
                                    Element.text "氏名"
                                )
                        )
                        , text = ""
                    }
                , options =[]
                }
        ]
    , textLayout None
        [ spacingXY 25 25
        , paddingTop 10 ][
            Input.email TextBox
                [ padding 10
                , width ( px ( model.width / 3 ) ) ]
                { onChange = InputAddress
                , value = model.address
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
        [ spacingXY 25 25
        , paddingTop 10 ][
            Input.text TextBox
                [ padding 10
                , width ( px ( model.width / 3 ) ) ]
                { onChange = InputTitle
                , value = model.title
                , label =
                    Input.placeholder{
                        label = Input.labelAbove (
                            el None
                                [ verticalCenter ] (
                                    Element.text "題名"
                                )
                        )
                        , text = ""
                    }
                , options =[]
                }
        ]
    , textLayout None
        [ spacingXY 25 25
        , paddingTop 10 ][
            Input.multiline TextBox
                [ padding 10
                , width ( px ( model.width / 3 ) )
                , height ( px ( model.height / 5 ) ) ] {
                onChange = InputMessage
                , value = model.message
                , label =
                    Input.placeholder { 
                        label = Input.labelAbove (
                            el None
                                [ verticalCenter ] (
                                    Element.text "メッセージ本文 (任意)"
                                )
                        )
                        , text = ""
                    }
                , options =[]
                }
        ]
    , textLayout None
        [ spacingXY 25 25
        , paddingTop 10
        , paddingBottom 10 ][
            button Button
                [ paddingXY 20 0 ] (
                    Element.text "送信"
                )
        ]
    ]

footerwLayout : Model -> Element Styles variation msg
footerwLayout model =
    row Footer
        [ paddingLeft  ( model.width / 50 )
        , height ( px ( model.height / 10 ) )
        , width ( px ( model.width ) ) ][
            paragraph None
                [] [
                    Element.text "© 2023 React Inc. All Rights Reserved.I'm happy! thank you!"
                ]
        ]