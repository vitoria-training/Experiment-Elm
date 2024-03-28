module Page.Wireframe.UserPageAcount.TopPage.TestPage.TestButton exposing (..)

import Color as Color255
import Page.Wireframe.UserPageAcount.TopPage.TestPage.TestColor as TestColor
import Task
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (stopPropagationOn)
import Style exposing (..)
import Style.Color as Color
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Html exposing (Html)
import Json.Decode as D
import Style.Border as Border


type Styles
    = None
    | Button
    | ButoonEnable
    | ButtonHover
    | ButtonFocus
    | ButtonPless
    | ButtonDisable
    | Button2
    | ButoonEnable2
    | ButtonHover2
    | ButtonFocus2
    | ButtonPless2
    | ButtonDisable2

type Variation
    = Disabled

stylesheet : Model -> StyleSheet Styles variation
stylesheet model =
    Style.styleSheet
        [ style None
            [] -- It's handy to have a blank style
        , style Button
            [ Color.text Color255.white
            , Color.background TestColor.buttonColorEnable
            , Border.rounded 20
            , hover [
                Color.background TestColor.buttonColorHovered
                ]
            , focus [
                Color.background TestColor.buttonColorFocusedAndPlessed
                ]
            ]
        , style ButoonEnable
            [ Color.text Color255.white
            , Color.background TestColor.buttonColorEnable
            , Border.rounded 20
            ]
        , style ButtonHover
            [ Color.text Color255.white
            , Color.background TestColor.buttonColorHovered
            , Border.rounded 20
            ]
        , style ButtonFocus
            [ Color.text Color255.white
            , Color.background TestColor.buttonColorFocusedAndPlessed
            , Border.rounded 20
            ]
        , style ButtonPless
            [ Color.text Color255.white
            , Color.background TestColor.buttonColorFocusedAndPlessed
            , Border.rounded 20
            ]
        , style ButtonDisable
            [ Color.text TestColor.buttonColorDisableFont
            , Color.background TestColor.buttonColorDisable
            , Border.rounded 20
            ]
        
        , style Button2
            [ Color.text TestColor.button2font
            , Color.background Color255.white
            , Border.rounded 20
            , hover [
                Color.background TestColor.button2ColorHovered
                ]
            , focus [
                Color.background TestColor.button2ColorFocusedAndPlessed
                ]
            , Border.all 1
            , Color.border TestColor.button2border
            ]
        , style ButoonEnable2
            [ Color.text TestColor.button2font
            , Color.background Color255.white
            , Border.rounded 20
            , Border.all 1
            , Color.border TestColor.button2border
            ]
        , style ButtonHover2
            [ Color.text TestColor.button2font
            , Color.background TestColor.button2ColorHovered
            , Border.rounded 20
            , Border.all 1
            , Color.border TestColor.button2border
            ]
        , style ButtonFocus2
            [ Color.text TestColor.button2font
            , Color.background TestColor.button2ColorFocusedAndPlessed
            , Border.rounded 20
            , Border.all 1
            , Color.border TestColor.button2border2
            ]
        , style ButtonPless2
            [ Color.text TestColor.button2font
            , Color.background TestColor.button2ColorFocusedAndPlessed
            , Border.rounded 20
            , Border.all 1
            , Color.border TestColor.button2border
            ]
        , style ButtonDisable2
            [ Color.text TestColor.button2font2
            , Color.background Color255.white
            , Border.rounded 20
            , Border.all 1
            , Color.border TestColor.button2border3
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
    , height : Float }

initialModel : Model
initialModel =
    { width = 0
    , height = 0 }

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )

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

topPatternAPageElement : Model -> Html Msg
topPatternAPageElement model=
    Element.layout (stylesheet model) <|
        column None
            [yScrollbar
            , width ( px ( model.width ) ) ][
                row None
                [](
                    buttonLayout_1
                )
                , row None
                [](
                    buttonLayout_2
                )
            ]

buttonLayout_1 : List(Element Styles variation Msg)
buttonLayout_1 =
    [row None
        [ spread
        , paddingXY 62 20
        ][
        row None
            [][
            column None
                [ paddingXY 30 0
                ][
                row None
                    [ center ][
                        Element.text "enable"
                    ]
                , row None
                    [][
                    button ButoonEnable
                        [ paddingXY 20 0
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            , column None
                [ paddingXY 30 0
                ][
                row None
                    [ center ][
                        Element.text "hovered"
                    ]
                , row None
                    [][
                    button ButtonHover
                        [ paddingXY 20 0
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            , column None
                [ paddingXY 30 0
                ][
                row None
                    [ center ][
                        Element.text "focused"
                    ]
                , row None
                    [][
                    button ButtonFocus
                        [ paddingXY 20 0 
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            , column None
                [ paddingXY 30 0
                ][
                row None
                    [ center ][
                        Element.text "plessed"
                    ]
                , row None
                    [][
                    button ButtonPless
                        [ paddingXY 20 0 
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            , column None
                [ paddingXY 30 0
                ][
                row None
                    [ center ][
                        Element.text "disable"
                    ]
                , row None
                    [][
                    button ButtonDisable
                        [ paddingXY 20 0 
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            , column None
                [ paddingXY 30 20
                ][
                row None
                    [][
                    button Button
                        [ paddingXY 20 0 
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            ]
        ]
    ]

buttonLayout_2 : List(Element Styles variation Msg)
buttonLayout_2 =
    [row None
        [ spread
        , paddingXY 62 20
        ][
        row None
            [][
            column None
                [ paddingXY 30 0
                ][
                row None
                    [ center ][
                        Element.text "enable"
                    ]
                , row None
                    [][
                    button ButoonEnable2
                        [ paddingXY 10 0
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            , column None
                [ paddingXY 30 0
                ][
                row None
                    [ center ][
                        Element.text "hovered"
                    ]
                , row None
                    [][
                    button ButtonHover2
                        [ paddingXY 10 0
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            , column None
                [ paddingXY 30 0
                ][
                row None
                    [ center ][
                        Element.text "focused"
                    ]
                , row None
                    [][
                    button ButtonFocus2
                        [ paddingXY 10 0 
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            , column None
                [ paddingXY 30 0
                ][
                row None
                    [ center ][
                        Element.text "plessed"
                    ]
                , row None
                    [][
                    button ButtonPless2
                        [ paddingXY 10 0 
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            , column None
                [ paddingXY 30 0
                ][
                row None
                    [ center ][
                        Element.text "disable"
                    ]
                , row None
                    [][
                    button ButtonDisable2
                        [ paddingXY 10 0 
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            , column None
                [ paddingXY 30 20
                ][
                row None
                    [][
                    button Button2
                        [ paddingXY 10 0 
                        , width ( px ( 83 ) )
                        , height ( px ( 40 ) )
                        ](
                            Element.text "Label"
                        )
                    ]
                ]
            ]
        ]
    ]

onClickStopPropagation : a -> Attribute variation a
onClickStopPropagation msg =
    stopPropagationOn "click" <| D.succeed ( msg, True )
