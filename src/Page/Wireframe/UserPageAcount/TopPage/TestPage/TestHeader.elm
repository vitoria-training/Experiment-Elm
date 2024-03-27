module Page.Wireframe.UserPageAcount.TopPage.TestPage.TestHeader exposing (..)

import Color as Color255
import Page.Wireframe.UserPageAcount.TopPage.TestPage.TestColor as TestColor
import Task
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (stopPropagationOn)
import Style exposing (..)
import Style.Color as Color
import Style.Font as Font
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
    | Button_pt1
    | Button_pt2_1
    | Button_pt2_2
    | Button_pt3_1
    | Button_pt3_2
    | Header_pt4
    | Button_pt4

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
        , style Button_pt1
            [ Color.text Color255.black
            , Color.background Color255.white
            , Color.border Color255.black
            , hover
                [ Color.background Color255.gray
                ]
            , Font.size ( model.width / 40 )
            , Border.all 2
            , Border.rounded 20
            ]

        , style Button_pt2_1
            [ Color.text Color255.black
            , Color.background Color255.white
            , Color.border Color255.black
            , hover
                [ Color.background Color255.gray
                ]
            , Font.size ( model.width / 40 )
            , Border.all 2
            , Border.rounded 20
            ]
        , style Button_pt2_2
            [ Color.text Color255.black
            , Color.background TestColor.greenPt1
            , Color.border Color255.black
            , hover
                [ Color.background Color255.gray
                ]
            , Font.size ( model.width / 40 )
            , Border.all 2
            , Border.rounded 20
            ]

        , style Button_pt3_1
            [ Color.text Color255.black
            , Font.size ( model.width / 40 )
            , Border.left 2
            ]
        , style Button_pt3_2
            [ Color.text Color255.black
            , Font.size ( model.width / 40 )
            , Border.left 2
            , Border.right 2
            ]
        
        , style Header_pt4
            [ Color.background TestColor.greenPt2
            , Border.all 1
            , Border.rounded 40
            ]
        , style Button_pt4
            [ Color.text Color255.black
            , Font.size ( model.width / 40 )
            , Color.background TestColor.greenPt2
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
                [][
                    headerLayoutPt1 model
                ]
                , row None
                [ paddingTop 40 ][
                    headerLayoutPt2 model
                ]
                , row None
                [ paddingTop 40 ][
                    headerLayoutPt3 model
                ]
                , row None
                [ paddingTop 40
                , center ][
                    headerLayoutPt4 model
                ]
            ]

headerLayoutPt1 : Model -> Element Styles variation Msg
headerLayoutPt1 model =
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
                el None
                    [ paddingLeft 15
                    , paddingRight 15 ](
                    button Button_pt1
                        [ paddingXY 20 2.5 ](
                            Element.text "top"
                        )
                    )
                , el None
                    [ paddingLeft 15
                    , paddingRight 15 ](
                    button Button_pt1
                        [ paddingXY 20 2.5 ](
                            Element.text "service"
                        )
                    )
                , el None
                    [ paddingLeft 15
                    , paddingRight 0 ](
                    button Button_pt1
                        [ paddingXY 20 2.5 ](
                            Element.text "login"
                        )
                    )
            ]
        ]

headerLayoutPt2 : Model -> Element Styles variation Msg
headerLayoutPt2 model =
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
                el None
                    [ paddingLeft 15
                    , paddingRight 15 ](
                    button Button_pt2_1
                        [ paddingXY 20 2.5 ](
                            Element.text "top"
                        )
                    )
                , el None
                    [ paddingLeft 15
                    , paddingRight 15 ](
                    button Button_pt2_1
                        [ paddingXY 20 2.5 ](
                            Element.text "service"
                        )
                    )
                , el None
                    [ paddingLeft 15
                    , paddingRight 0 ](
                    button Button_pt2_2
                        [ paddingXY 20 2.5 ](
                            Element.text "login"
                        )
                    )
            ]
        ]
    
headerLayoutPt3 : Model -> Element Styles variation Msg
headerLayoutPt3 model =
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
                el Button_pt3_1
                    [](
                    button Header
                        [ paddingXY 20 2.5 ](
                            Element.text "top"
                        )
                    )
                , el Button_pt3_1
                    [](
                    button Header
                        [ paddingXY 20 2.5 ](
                            Element.text "service"
                        )
                    )
                , el Button_pt3_2
                    [](
                    button Header
                        [ paddingXY 20 2.5 ](
                            Element.text "login"
                        )
                    )
            ]
        ]
    
headerLayoutPt4 : Model -> Element Styles variation Msg
headerLayoutPt4 model =
    row Header_pt4
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
                    button Button_pt4
                        [ paddingXY 20 0 ](
                            Element.text "top"
                        )
                    )
                , el None
                    [](
                    button Button_pt4
                        [ paddingXY 20 0 ](
                            Element.text "service"
                        )
                    )
                , el None
                    [](
                    button Button_pt4
                        [ paddingXY 20 0 ](
                            Element.text "login"
                        )
                    )
            ]
        ]

onClickStopPropagation : a -> Attribute variation a
onClickStopPropagation msg =
    stopPropagationOn "click" <| D.succeed ( msg, True )

