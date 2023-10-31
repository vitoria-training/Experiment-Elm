module Page.Top.Top exposing (..)

import Page.Color as Color255
import Task
import Element exposing (..)
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
    | Main
    | Logo
    | Button

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

topPageElement : Model -> Html msg
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
                            [ topPageLayout ]
                        )
                , footerLayout model
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

topPageLayout : List (Element Styles variation msg)
topPageLayout =
    [ textLayout None
        [ spacingXY 25 25 ][
            button Button
                [paddingXY 20 0] (
                    text "Play Contents!"
                )
        ]
    ]

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
