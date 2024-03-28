module Page.Wireframe.UserPageAcount.TopPage.TestPage.TestMainarea_2 exposing (..)

import Color as Color255
import Task
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (stopPropagationOn)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
import Style.Background as Background
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Html exposing (Html)
import Json.Decode as D
import Style.Border as Border

type Styles
    = None
    | Header
    | Logo
    | LogoImage
    | BKImage
    | Button1
    | Button2
    | TextPt_1
    | TextAreaPt_1

type Variation
    = Disabled

stylesheet : Model -> StyleSheet Styles variation
stylesheet model =
    Style.styleSheet
        [ style None
            [] -- It's handy to have a blank style
        , style Header
            [ Color.background Color255.darkGray ]
        , style Logo
            [ Font.size ( model.width / 40 )
            ]

        , style LogoImage
            [ Border.rounded 20
            ]
        
        , style BKImage
            [ Background.imageWith
                { src = "unsplash_JdoofvUDUwc.png"
                , position = ( ( model.width - model.height*1.618 ), 0.0 )
                , repeat = Background.noRepeat
                , size = Background.size
                    { height = ( px ( model.height - 84 ) ) --header分の84pxマイナス
                    , width = ( px ( model.height*1.618 ) )
                    }
                }
            ]
        , style Button1
            [ Color.text Color255.black
            , Font.size ( model.width / 40 )
            , Border.left 2
            ]
        , style Button2
            [ Color.text Color255.black
            , Font.size ( model.width / 40 )
            , Border.left 2
            , Border.right 2
            ]
        
        , style TextPt_1
            [ Font.size ( model.width / 20 )
            , Color.text Color255.black
            , Color.border Color255.black
            ]
        , style TextAreaPt_1
            [ Color.border Color255.black
            , Color.background Color255.white
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
            [yScrollbar][
                headerLayout model
                , el None
                    [] <|
                    column None
                        [](
                            mainArea model
                        )
            ]
    
headerLayout : Model -> Element Styles variation Msg
headerLayout model =
    row Header
        [ spread
        , paddingXY 48 20 --左右に48pxの空白。上下に20pxの空白。
        --, height ( px ( model.height / 10 ) )
        , height ( px ( 84 ) ) --高さ84px。
        , width fill
        ][
        el Logo
            [ verticalCenter ] (
                image LogoImage 
                    [ width (px ( model.width / 25 ) )
                    , height ( px ( model.width / 25 ) )
                    ]{
                        src = "/assets/icon/VITORIA_logo.jpg"
                        , caption = "VITORIA_logo"
                    }
            )
        , row None
            [ spacing 5
            , verticalCenter ][
                el Button1
                    [](
                    button Header
                        [ paddingXY 20 2.5 ](
                            Element.text "top"
                        )
                    )
                , el Button1
                    [](
                    button Header
                        [ paddingXY 20 2.5 ](
                            Element.text "service"
                        )
                    )
                , el Button2
                    [](
                    button Header
                        [ paddingXY 20 2.5 ](
                            Element.text "login"
                        )
                    )
            ]
        ]

mainArea : Model -> List (Element Styles variation Msg)
mainArea model =
    [row None
        [][
        column None
            [][
            textLayout BKImage
                [ height ( px ( model.height - 84 ) )
                , width ( px ( model.width ) )
                ][
                row None
                    [ verticalCenter
                    ][
                    column None
                        [ height ( px ( model.height - 84 ) )
                        , paddingLeft 80
                        , paddingTop 120 
                        ][
                        column TextAreaPt_1
                            [ paddingXY 20 0
                            ][
                            row TextPt_1
                                [][
                                    Element.text "text text text"
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]

onClickStopPropagation : a -> Attribute variation a
onClickStopPropagation msg =
    stopPropagationOn "click" <| D.succeed ( msg, True )