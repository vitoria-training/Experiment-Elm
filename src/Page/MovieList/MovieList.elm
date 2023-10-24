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
        [ Style.style None [] -- It's handy to have a blank style
        , Style.style Header
            [ Color.background Color255.darkGray ]
        , Style.style Footer
            [ Color.background Color255.darkGray
            , Font.size (model.width / 100)
            ]
        , Style.style Title
            [ Font.bold
            , Font.size (model.width / 40)
            ]
        , Style.style Main
            [ Border.all 1
            , Color.text Color255.darkCharcoal
            , Color.background Color255.white
            , Color.border Color255.grey
            , Font.size (model.width / 80)
            , Font.lineHeight 1.3
            ]
        , Style.style Logo
            [ Font.size (model.width / 40)
            ]
        , Style.style Button
            [ Color.text Color255.black
            , Color.background Color255.white
            , Color.border Color255.black
            , hover
                [ Color.background Color255.gray
                ]
            , Font.size (model.width / 40)
            , Border.all 2
            ]
        , Style.style ListTitle
            [ Font.size (model.width / 50)
            , Font.bold
            ]
        , Style.style MovieRow
            [ Font.size (model.width / 50)
            ]
        , Style.style MovieButton
            [ Color.background Color255.white
            , Font.size (model.width / 50)
            , Font.bold
            ]
        , Style.style MovieStyle
            [ Color.background Color255.darkGray
            , Font.size (model.width / 100)
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
type alias Movie =
    { movieTitle : String
    , movieUrl : String
    }
type alias Movies =
    { listSortNo : Int
    , listTitle : String
    , startPosition : Int
    , movieData : List Movie
    }

type alias Model =
    { width : Float
    , height : Float
    , movieList : List Movies }

type StartNo =
    Int

type alias Cramp =
    { minPos : Int
    , maxPos : Int }

-- MovieData

list1_Movies : Movies
list1_Movies =
    { listSortNo = 0
    , listTitle = "git講習"
    , startPosition = initStartNo
    , movieData = [
        {movieTitle = "基本コマンド1" 
            , movieUrl = "Js_8xBDhhwE"}
        , {movieTitle = "基本コマンド2"
            , movieUrl = "eZ9M16REQiQ"}
        , {movieTitle = "GitHub_1"
            , movieUrl = "laz2u--LoTg"}
        , {movieTitle = "GitHub_2"
            , movieUrl = "tHZ9yR8I81w"}
        , {movieTitle = "git内部の仕組み"
            , movieUrl = "qLyUayBh-T8"}
        ]
    }

list2_Movies : Movies
list2_Movies =
    { listSortNo = 1
    , listTitle = "プログラミングパラダイム講習"
    , startPosition = initStartNo
    , movieData = [
        {movieTitle = "古代ギリシャ-中世編" 
            , movieUrl = "kvOPZVjBsNA"}
        , {movieTitle = "OOP-論理は物質の手足" 
            , movieUrl = "B3mgmghlEKY"}
       , {movieTitle = "論理世界への一元化" 
            , movieUrl = "ClyBlJ8LCQg"}
        , {movieTitle = "論理のみの世界 関数型パラダイム" 
            , movieUrl = "NGrLa92DHlc"}
        ]
    }

list3_Movies : Movies
list3_Movies =
    { listSortNo = 2
    , listTitle = "ゲーム講習"
    , startPosition = initStartNo
    , movieData = [
        {movieTitle = "【初歩編】第1回" 
            , movieUrl = "Ht6R3OosXDk"}
       , {movieTitle = "【初歩編】第2回" 
            , movieUrl = "9g-NnkrScng"}
        , {movieTitle = "【初歩編】第3回" 
            , movieUrl = "f2SZjtkPF2Q"}
        , {movieTitle = "【初歩編】第4回" 
            , movieUrl = "x4wB8ET-57Y"}
        , {movieTitle = "番外編 プランナー編"
            , movieUrl = "7OvNuawE9ys"}
        , {movieTitle = "番外編 インストラクター編"
            , movieUrl = "ZN9ywfx6XS4"}
        ]
    }

list4_Movies : Movies
list4_Movies =
    { listSortNo = 3
    , listTitle = "System Design講習"
    , startPosition = initStartNo
    , movieData = [
        {movieTitle = "part1"
            , movieUrl = "CVHci7zRaw4"}
        , {movieTitle = "part2"
            , movieUrl = "62x0qPk7W24"}
        , {movieTitle = "part3"
            , movieUrl = "Nixcc9fmTqQ"}
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

checkTargetList : ( Int, Direction ) -> Movies -> Movies
checkTargetList ( targetListNo, direction ) movie =
    if movie.listSortNo == targetListNo then
        setStartPosition ( direction ) movie
    else
        movie

setStartPosition : ( Direction ) -> Movies -> Movies
setStartPosition ( direction ) movie =
    let
        nextStartPosition = 
            selecter movie.startPosition direction
        
        maxPos =
            List.length(movie.movieData)
    in
    
    if checker nextStartPosition maxPos then
        { movie | startPosition = nextStartPosition } 
    else
        movie

selecter : Int -> Direction -> Int
selecter startPosition direction =
    case direction of
        MoveRight ->
            startPosition + 1
        MoveLeft ->
            startPosition - 1

checker : Int -> Int -> Bool
checker nextStartPosition maxLength =
    let
        toDOPos : Int -> Int -> Cramp
        toDOPos min max =
            { minPos = min
            , maxPos = max }
        cramp = toDOPos 0 maxLength
    in
    
    (cramp.minPos <= nextStartPosition) && ( nextStartPosition < cramp.maxPos )

movieListElement : Model -> Html Msg
movieListElement model=
    Element.layout (stylesheet model) <|
        column None
            []
            [ headerLayout model
            , el None [ EA.height (px (model.height - (model.height / 10)*2 ))
                , EA.width (px model.width)
                , yScrollbar
                ] <|
                column Main
                    []
                    (List.concat
                        [ movieListLayout model]
                    )
            , footerwLayout model
            ]

headerLayout : Model -> Element Styles variation msg
headerLayout model =
    row Header
        [ spread
            , paddingXY 30 20 
            , EA.height (px (model.height / 10) )
            , EA.width (px (model.width) )
        ]
        [ el Logo [verticalCenter]
            (image None[EA.width (px (model.width / 25) )
            , EA.height (px (model.width / 25) )]
                { src = "../../Picture/VITORIA_logo.jpg"
                , caption = "VITORIA_logo"
                }
            )
        , row None
            [ spacing 5
                , verticalCenter ]
            [ Element.button Button [paddingXY 20 0] (Element.text "Top")
                , Element.button Button [paddingXY 20 0] (Element.text "About")
                , Element.button Button [paddingXY 20 0] (Element.text "Contents")
                , Element.button Button [paddingXY 20 0] (Element.text "Contact")
            ] 
        ]
movieListLayout : Model -> List (Element Styles variation Msg)
movieListLayout model=
    [ column None [][
            column None [][
                Element.text ("Width : " ++ String.fromFloat(model.width) ++ " Height : " ++ String.fromFloat(model.height))
                ,column None []
                    (List.map (setMovie model.width model.height) model.movieList)
            ]
        ]
    ]
setMovie : Float -> Float -> Movies -> Element Styles variation Msg
setMovie modelWidth modelHeight movies = 
    column None [ paddingBottom 30][
        column ListTitle [ paddingTop 30
            , paddingBottom 0
            , paddingRight 0
            , paddingLeft 50][
            Element.text (movies.listTitle)
            , Element.text ("Sort : " ++ String.fromInt(movies.listSortNo) ++ " start : " ++ String.fromInt(movies.startPosition))
        ]
        , row None [ EA.width fill][
            row None [ paddingXY 15 0][
                Element.button MovieButton [ 
                    EA.width <| px ( modelWidth / 40 )
                    , EA.height <| px ( modelWidth / 40 ) 
                    , EA.verticalCenter
                    , onClick (Schroll (
                        movies.listSortNo
                        , MoveLeft)
                        )
                    ]
                (image None [ EA.center
                    , EA.width <| px ( modelWidth / 40 )
                    , EA.height <| px ( modelWidth / 40 ) ]
                    { src = "../../Picture/Left.png"
                        , caption = "button_left"
                    }
                )
            ]
            , row None [ EA.alignLeft
                , clipX](List.map (
                    assumption modelWidth modelHeight (toFloat movies.startPosition )
                    ) movies.movieData)
            , row None [ paddingXY 15 0][
                Element.button MovieButton [ 
                    EA.width <| px ( modelWidth / 40 )
                    , EA.height <| px ( modelWidth / 40 )
                    , EA.verticalCenter
                    , onClick (Schroll (
                        movies.listSortNo
                        , MoveRight)
                        )
                    ]
                (image None[ EA.center
                    , EA.width <| px ( modelWidth / 40 )
                    , EA.height <| px ( modelWidth / 40 ) ]
                    { src = "../../Picture/Right.png"
                        , caption = "button_right" 
                    }
                )
            ]
        ]
    ]

setCrampMaxPos : Cramp -> List Movie -> Cramp
setCrampMaxPos cramp movieDataLength =
    { cramp | maxPos = List.length movieDataLength }

assumption : Float -> Float -> Float -> Movie -> Element Styles variation msg
assumption modelWidth modeiHeight startPosition movie =
    row None [EA.moveLeft (( modelWidth - modelWidth / 10 ) /3 * (startPosition))][
        column None [ spacing 3
            , paddingXY ( modelWidth / 130 ) ( modeiHeight / 30 )
            , EA.center ][
            row MovieRow [ ][
                Element.text movie.movieTitle
            ]
            , row MovieRow [][
                chabgeToElement( videoframe movie.movieUrl modelWidth modeiHeight )
            ]
        ]
    ]
videoframe : String -> Float -> Float -> Html msg
videoframe url mainScreenWidth mainScreenheight=
    iframe
        [ HA.width ( videoWindowWidth mainScreenWidth )
        , HA.height ( videoWindowHeight mainScreenheight )
        , HA.src ("https://www.youtube.com/embed/" ++ url)
        , HA.attribute "frameborder" "0"
        , HA.attribute "allowfullscreen" "True"
        ][]
videoWindowWidth : Float -> Int
videoWindowWidth mainScreenWidth=
    ( round mainScreenWidth - round mainScreenWidth // 7 ) // 3

videoWindowHeight : Float -> Int
videoWindowHeight mainScreenHeight=
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
            , EA.width (px (model.width) )
        ]
        [ paragraph None [] [
            Element.text "© 2023 React Inc. All Rights Reserved.I'm happy! thank you!"
            ]
        ]
