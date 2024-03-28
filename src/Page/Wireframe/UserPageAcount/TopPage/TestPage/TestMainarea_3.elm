module Page.Wireframe.UserPageAcount.TopPage.TestPage.TestMainarea_3 exposing (..)

import Color as Color255
import Page.Wireframe.UserPageAcount.TopPage.TestPage.TestColor as TestColor
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
    | Button
    | BKImage
    | Text

type Variation
    = Disabled

stylesheet : Model -> StyleSheet Styles variation
stylesheet model =
    Style.styleSheet
        [ style None
            [] -- It's handy to have a blank style
        , style Header
            [ Color.background TestColor.greenPt3
            , Border.all 1
            , Border.rounded 40
            ]
        , style Logo
            [ Font.size ( model.width / 40 )
            ]
        , style LogoImage
            [ Border.rounded 20
            ]
        , style Button
            [ Color.text Color255.white
            , Font.size ( model.width / 40 )
            , Color.background TestColor.greenPt4
            ]
        , style BKImage
            [ Background.imageWith
                { src = "unsplash_lPKIb8dJ8kw.png"
                , position = ( 0.0, 0.0 )
                , repeat = Background.noRepeat
                , size = Background.size
                    { height = ( px ( model.height ) )
                    , width = ( px ( model.width ) )
                    }
                }
            ]
        , style Text
            [ Font.size ( model.width / 10 )
            , Color.text Color255.white
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
                row None
                [](
                    mainArea model
                )
            ]

headerLayout : Model -> Element Styles variation Msg
headerLayout model =
    row Header
        [ spread
        , paddingXY 62 20 --左右に62pxの空白。上下に20pxの空白。
        --, height ( px ( model.height / 10 ) )
        , height ( px ( 84 ) ) --高さ84px。
        , width ( px ( 1104 ) ) --幅1104px。
        ][
        el Logo
            [ verticalCenter ](
                image LogoImage 
                    [ width (px ( model.width / 25 ) )
                    , height ( px ( model.width / 25 ) )
                    ]{
                        src = "/assets/icon/VITORIA_logo.jpg"
                        , caption = "VITORIA_logo"
                    }
            )
        , row None
            [ height ( px ( 48 ) ) --高さ48px。
            , width ( px ( 357 ) ) --幅357px。
            , center
            ][
                el None
                    [](
                    button Button
                        [ paddingXY 20 0 ](
                            Element.text "top"
                        )
                    )
                , el None
                    [](
                    button Button
                        [ paddingXY 20 0 ](
                            Element.text "service"
                        )
                    )
                , el None
                    [](
                    button Button
                        [ paddingXY 20 0 ](
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
                [][
                row None
                    [ width ( px ( model.width ) )
                    , height ( px ( model.height ) )
                    , center
                    ][
                    column None
                        [ paddingTop 30
                        ][
                        column None
                            [][
                            row None
                                [ width ( px ( model.width ) )
                                , paddingLeft 20
                                , paddingRight 30
                                , center
                                , verticalCenter
                                ][
                                    headerLayout model
                                ]
                            , row Text
                                [ center
                                , verticalCenter
                                , paddingTop 50
                                ][
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
