module Page.MovieList.MovieList exposing (..)

import Page.Color as Color255
import Task
import Element exposing (..)
import Element.Attributes as EA exposing (..)
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color
import Style.Font as Font
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Html exposing (..)
import Html.Attributes as HA exposing (..)
import Element.Events exposing (onClick)

type Styles
    = None
    | Header
    | Footer
    | Title
    | Main
    | Logo
    | Button
    | ListTitle
    | MovieRow
    | MovieButton
    | MovieStyle

type Variation
    = Disabled

stylesheet : { a | width : Float } -> StyleSheet Styles variation
stylesheet model =
    Style.styleSheet
        [ Style.style None
            [] -- It's handy to have a blank style
        , Style.style Header
            [ Color.background Color255.darkGray ]
        , Style.style Footer
            [ Color.background Color255.darkGray
            , Font.size ( model.width / 100 )
            ]
        , Style.style Title
            [ Font.bold
            , Font.size ( model.width / 40 )
            ]
        , Style.style Main
            [ Border.all 1
            , Color.text Color255.darkCharcoal
            , Color.background Color255.white
            , Color.border Color255.grey
            , Font.size ( model.width / 80 )
            , Font.lineHeight 1.3
            ]
        , Style.style Logo
            [ Font.size ( model.width / 40 )
            ]
        , Style.style Button
            [ Color.text Color255.black
            , Color.background Color255.white
            , Color.border Color255.black
            , hover
                [ Color.background Color255.gray
                ]
            , Font.size ( model.width / 40 )
            , Border.all 2
            ]
        , Style.style ListTitle
            [ Font.size ( model.width / 50 )
            , Font.bold
            ]
        , Style.style MovieRow
            [ Font.size ( model.width / 50 )
            ]
        , Style.style MovieButton
            [ Color.background Color255.white
            , Font.size ( model.width / 50 )
            , Font.bold
            ]
        , Style.style MovieStyle
            [ Color.background Color255.darkGray
            , Font.size ( model.width / 100 )
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
        , view = movieListElement
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
    , movieList : List MovieList
    }

type alias MovieList =
    { listSortNo : Int
    , listTitle : String
    , startingPosition : Int
    , movieData : List Movie
    }

type alias Movie =
    { videoTitle : String
    , videoUrl : String
    }

type StartNo =
    Int

type alias Cramp =
    { minPos : Int
    , maxPos : Int }

-- MovieData

list1_Movies : MovieList
list1_Movies =
    { listSortNo = 0
    , listTitle = "git講習"
    , startingPosition = initStartNo
    , movieData = [
        {videoTitle = "基本コマンド1" 
            , videoUrl = "Js_8xBDhhwE"}
        , {videoTitle = "基本コマンド2"
            , videoUrl = "eZ9M16REQiQ"}
        , {videoTitle = "GitHub_1"
            , videoUrl = "laz2u--LoTg"}
        , {videoTitle = "GitHub_2"
            , videoUrl = "tHZ9yR8I81w"}
        , {videoTitle = "git内部の仕組み"
            , videoUrl = "qLyUayBh-T8"}
        ]
    }

list2_Movies : MovieList
list2_Movies =
    { listSortNo = 1
    , listTitle = "プログラミングパラダイム講習"
    , startingPosition = initStartNo
    , movieData = [
        {videoTitle = "古代ギリシャ-中世編" 
            , videoUrl = "kvOPZVjBsNA"}
        , {videoTitle = "OOP-論理は物質の手足" 
            , videoUrl = "B3mgmghlEKY"}
       , {videoTitle = "論理世界への一元化" 
            , videoUrl = "ClyBlJ8LCQg"}
        , {videoTitle = "論理のみの世界 関数型パラダイム" 
            , videoUrl = "NGrLa92DHlc"}
        ]
    }

list3_Movies : MovieList
list3_Movies =
    { listSortNo = 2
    , listTitle = "ゲーム講習"
    , startingPosition = initStartNo
    , movieData = [
        {videoTitle = "【初歩編】第1回" 
            , videoUrl = "Ht6R3OosXDk"}
       , {videoTitle = "【初歩編】第2回" 
            , videoUrl = "9g-NnkrScng"}
        , {videoTitle = "【初歩編】第3回" 
            , videoUrl = "f2SZjtkPF2Q"}
        , {videoTitle = "【初歩編】第4回" 
            , videoUrl = "x4wB8ET-57Y"}
        , {videoTitle = "番外編 プランナー編"
            , videoUrl = "7OvNuawE9ys"}
        , {videoTitle = "番外編 インストラクター編"
            , videoUrl = "ZN9ywfx6XS4"}
        ]
    }

list4_Movies : MovieList
list4_Movies =
    { listSortNo = 3
    , listTitle = "System Design講習"
    , startingPosition = initStartNo
    , movieData = [
        {videoTitle = "part1"
            , videoUrl = "CVHci7zRaw4"}
        , {videoTitle = "part2"
            , videoUrl = "62x0qPk7W24"}
        , {videoTitle = "part3"
            , videoUrl = "Nixcc9fmTqQ"}
        ]
    }

-- Initialize
initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , movieList = [
        list1_Movies
        , list2_Movies
        , list3_Movies
        , list4_Movies
        ]
    }
initStartNo : Int
initStartNo =
    0

type Direction
    = MoveRight
    | MoveLeft

type Msg
    = NoOp
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | Schroll ( Int, Direction)

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

        NoOp ->
            ( model, Cmd.none )

        Schroll ( targetListNo, direction ) ->
            ( setSchroll model ( targetListNo, direction ), Cmd.none )

setSchroll : Model -> ( Int, Direction ) -> Model
setSchroll model ( targetListNo, direction ) =
    let
        setMovieList =
            List.map ( checkTargetList ( targetListNo, direction ) ) model.movieList
    in
        { model | movieList = setMovieList }

checkTargetList : ( Int, Direction ) -> MovieList -> MovieList
checkTargetList ( targetListNo, direction ) movie =
    if movie.listSortNo == targetListNo then
        setStartingPosition ( direction ) movie
    else
        movie

setStartingPosition : ( Direction ) -> MovieList -> MovieList
setStartingPosition ( direction ) movie =
    let
        nextStartingPosition = 
            directionSelecter movie.startingPosition direction
        
        maxPos =
            List.length(movie.movieData)
    in
    
    if nextPositionChecker nextStartingPosition maxPos then
        { movie | startingPosition = nextStartingPosition } 
    else
        movie

directionSelecter : Int -> Direction -> Int
directionSelecter startingPosition direction =
    case direction of
        MoveRight ->
            startingPosition + 1
        MoveLeft ->
            startingPosition - 1

nextPositionChecker : Int -> Int -> Bool
nextPositionChecker nextStartingPosition maxLength =
    let
        toDOPos : Int -> Int -> Cramp
        toDOPos min max =
            { minPos = min
            , maxPos = max }
        cramp = toDOPos 0 maxLength
    in
    
    (cramp.minPos <= nextStartingPosition) && ( nextStartingPosition < cramp.maxPos )

movieListElement : Model -> Html Msg
movieListElement model=
    Element.layout ( stylesheet model ) <|
        column None
            [] [
                headerLayout model
                , el None
                    [ EA.height ( px ( model.height - ( model.height / 10 ) *2 ))
                    , EA.width ( px model.width )
                    , yScrollbar
                    ] <|
                    column Main
                        []
                        ( List.concat
                            [ movieListLayout model ]
                        )
                , footerwLayout model
            ]

headerLayout : Model -> Element Styles variation msg
headerLayout model =
    row Header
        [ spread
        , paddingXY 30 20 
        , EA.height ( px ( model.height / 10 ) )
        , EA.width ( px ( model.width ) )
        ][
            el Logo
                [verticalCenter](
                    image None
                        [ EA.width ( px ( model.width / 25 ) )
                        , EA.height ( px ( model.width / 25 ) )
                        ]{
                            src = "../../Picture/VITORIA_logo.jpg"
                            , caption = "VITORIA_logo"
                        }
                )
            , row None
                [ spacing 5
                , verticalCenter ][
                    Element.button Button
                        [ paddingXY 20 0 ] (
                            Element.text "Top"
                        )
                    , Element.button Button
                        [ paddingXY 20 0 ] (
                            Element.text "About"
                        )
                    , Element.button Button
                        [ paddingXY 20 0 ] (
                            Element.text "Contents"
                        )
                    , Element.button Button
                        [ paddingXY 20 0] (
                            Element.text "Contact"
                        )
                ] 
        ]
movieListLayout : Model -> List (Element Styles variation Msg)
movieListLayout model=
    [ column None
        [][
            column None [][
                Element.text ( "Width : " ++ String.fromFloat ( model.width ) ++ " Height : " ++ String.fromFloat ( model.height ) )
                -- This is for sample purposes only and will be deleted later.
                , column None
                    []
                    ( List.map ( movieListSetting model.width model.height ) model.movieList )
            ]
        ]
    ]

movieListSetting : Float -> Float -> MovieList -> Element Styles variation Msg
movieListSetting modelWidth modelHeight movies = 
    column None
        [ paddingBottom 30 ][
            column ListTitle
                [ paddingTop 30
                , paddingBottom 0
                , paddingRight 0
                , paddingLeft 50 ][
                    Element.text ( movies.listTitle )
                    , Element.text ( "Sort : " ++ String.fromInt ( movies.listSortNo ) ++ " start : " ++ String.fromInt ( movies.startingPosition ) )
                    -- This is for sample purposes only and will be deleted later.
                ]
            , row None
                [ EA.width fill ][
                row None
                    [ paddingXY 15 0 ][
                        Element.button MovieButton
                            [ EA.width <| px ( modelWidth / 40 )
                            , EA.height <| px ( modelWidth / 40 ) 
                            , EA.verticalCenter
                            , onClick (
                                Schroll (
                                    movies.listSortNo
                                    , MoveLeft)
                            )
                        ]
                        ( image None
                            [ EA.center
                            , EA.width <| px ( modelWidth / 40 )
                            , EA.height <| px ( modelWidth / 40 ) 
                            ]{ 
                                src = "../../Picture/Left.png"
                                , caption = "button_left"
                            }
                        )
                    ]
                , row None
                    [ EA.alignLeft
                    , clipX](
                        List.map (
                            videoSettings modelWidth modelHeight (toFloat movies.startingPosition )
                        ) movies.movieData
                    )
                , row None
                    [ paddingXY 15 0 ][
                        Element.button MovieButton [ 
                            EA.width <| px ( modelWidth / 40 )
                            , EA.height <| px ( modelWidth / 40 )
                            , EA.verticalCenter
                            , onClick (
                                Schroll (
                                    movies.listSortNo
                                    , MoveRight
                                )
                            )
                        ]
                        ( image None
                            [ EA.center
                            , EA.width <| px ( modelWidth / 40 )
                            , EA.height <| px ( modelWidth / 40 ) 
                            ]{
                                src = "../../Picture/Right.png"
                                , caption = "button_right" 
                            }
                        )
                    ]
                ]
        ]

videoSettings : Float -> Float -> Float -> Movie -> Element Styles variation msg
videoSettings modelWidth modeiHeight startingPosition movie =
    row None 
        [ EA.moveLeft ( ( modelWidth - modelWidth / 10 ) /3 * ( startingPosition ) ) ][
        column None
            [ spacing 3
            , paddingXY ( modelWidth / 130 ) ( modeiHeight / 30 )
            , EA.center ][
            row MovieRow
                [ ][
                    Element.text movie.videoTitle
                ]
            , row MovieRow
                [][
                    chabgeToElement( videoframe movie.videoUrl modelWidth modeiHeight )
                ]
            ]
        ]

videoframe : String -> Float -> Float -> Html msg
videoframe url mainScreenWidth mainScreenheight=
    iframe
        [ HA.width ( videoframeWidth mainScreenWidth )
        , HA.height ( videoframeHeight mainScreenheight )
        , HA.src ("https://www.youtube.com/embed/" ++ url)
        , HA.attribute "frameborder" "0"
        , HA.attribute "allowfullscreen" "True"
        ][]

videoframeWidth : Float -> Int
videoframeWidth mainScreenWidth=
    ( round mainScreenWidth - round mainScreenWidth // 7 ) // 3

videoframeHeight : Float -> Int
videoframeHeight mainScreenHeight=
    round mainScreenHeight // 2

chabgeToElement : Html msg -> Element style variation msg
chabgeToElement msg =
    -- Change from Html to Element
    html msg

footerwLayout : Model -> Element Styles variation msg
footerwLayout model =
    row Footer
        [ paddingLeft  (model.width / 50)
        , EA.height (px (model.height / 10) )
        , EA.width (px (model.width) ) ][
            paragraph None
                [] [
                    Element.text "© 2023 React Inc. All Rights Reserved.I'm happy! thank you!"
                ]
        ]
