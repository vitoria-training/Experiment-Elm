module Page.Playlist.Playlist exposing (..)

import Color as Color255
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
    | VideoRow
    | VideoButton
    | VideoStyle

type Variation
    = Disabled

stylesheet : Model -> StyleSheet Styles variation
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
        , Style.style VideoRow
            [ Font.size ( model.width / 50 )
            ]
        , Style.style VideoButton
            [ Color.background Color255.white
            , Font.size ( model.width / 50 )
            , Font.bold
            ]
        , Style.style VideoStyle
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
                    Nothing

                Ok vp ->
                    GotInitialViewport vp
    in
    Browser.element
        { init = \_ -> ( initialModel, Task.attempt handleResult Browser.Dom.getViewport )
        , view = playlistElement
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
    , playlists : List Playlist
    }

type alias Playlist =
    { index : Int
    , title : String
    , scrollViewPosition : Int
    , videos : List Video
    }

type alias Video =
    { videoTitle : String
    , videoUrl : String
    }

type ScrollViewPosition =
    Int

type alias Cramp =
    { minPos : Int
    , maxPos : Int }

-- VideoData

list1_Videos : Playlist
list1_Videos =
    { index = 0
    , title = "git講習"
    , scrollViewPosition = initScrollViewPosition
    , videos = [
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

list2_Videos : Playlist
list2_Videos =
    { index = 1
    , title = "プログラミングパラダイム講習"
    , scrollViewPosition = initScrollViewPosition
    , videos = [
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

list3_Videos : Playlist
list3_Videos =
    { index = 2
    , title = "ゲーム講習"
    , scrollViewPosition = initScrollViewPosition
    , videos = [
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

list4_Videos : Playlist
list4_Videos =
    { index = 3
    , title = "System Design講習"
    , scrollViewPosition = initScrollViewPosition
    , videos = [
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
    , playlists = [
        list1_Videos
        , list2_Videos
        , list3_Videos
        , list4_Videos
        ]
    }
initScrollViewPosition : Int
initScrollViewPosition =
    0

type Direction
    = MoveRight
    | MoveLeft

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | Scroll ( Int, Direction)

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

        Scroll ( targetPlaylistIndex, direction ) ->
            ( scroll model ( targetPlaylistIndex, direction ), Cmd.none )

scroll : Model -> ( Int, Direction ) -> Model
scroll model ( targetPlaylistIndex, direction ) =
    let
        setPlaylist =
            List.map ( slideView ( targetPlaylistIndex, direction ) ) model.playlists
    in
        { model | playlists = setPlaylist }


slideView : ( Int, Direction ) -> Playlist -> Playlist
slideView ( targetPlaylistIndex, direction ) playlist =
    let
        newScrollViewPosition = 
            shiftPosition playlist.scrollViewPosition direction
        
        maxPos =
            List.length(playlist.videos)

        isTarget = playlist.index == targetPlaylistIndex

        validTarget = isTarget && isInRange newScrollViewPosition maxPos
    in
    
    if validTarget then
        { playlist | scrollViewPosition = newScrollViewPosition } 
    else
        playlist

shiftPosition : Int -> Direction -> Int
shiftPosition scrollViewPosition direction =
    case direction of
        MoveRight ->
            scrollViewPosition + 1
        MoveLeft ->
            scrollViewPosition - 1

isInRange : Int -> Int -> Bool
isInRange newScrollViewPosition maxLength =
    let
        getRange : Int -> Int -> Cramp
        getRange min max =
            { minPos = min
            , maxPos = max }
        cramp = getRange 0 maxLength
    in
    
    (cramp.minPos <= newScrollViewPosition) && ( newScrollViewPosition < cramp.maxPos )

playlistElement : Model -> Html Msg
playlistElement model=
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
                            [ playlistLayout model ]
                        )
                , footerLayout model
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
playlistLayout : Model -> List (Element Styles variation Msg)
playlistLayout model=
    [ column None
        [][
            column None [][
                Element.text ( "Width : " ++ String.fromFloat ( model.width ) ++ " Height : " ++ String.fromFloat ( model.height ) )
                -- This is for sample purposes only and will be deleted later.
                , column None
                    []
                    ( List.map ( playlistSetting model.width model.height ) model.playlists )
            ]
        ]
    ]

playlistSetting : Float -> Float -> Playlist -> Element Styles variation Msg
playlistSetting modelWidth modelHeight movies = 
    column None
        [ paddingBottom 30 ][
            column ListTitle
                [ paddingTop 30
                , paddingBottom 0
                , paddingRight 0
                , paddingLeft 50 ][
                    Element.text ( movies.title )
                    , Element.text ( "Sort : " ++ String.fromInt ( movies.index ) ++ " start : " ++ String.fromInt ( movies.scrollViewPosition ) )
                    -- This is for sample purposes only and will be deleted later.
                ]
            , row None
                [ EA.width fill ][
                row None
                    [ paddingXY 15 0 ][
                        Element.button VideoButton
                            [ EA.width <| px ( modelWidth / 40 )
                            , EA.height <| px ( modelWidth / 40 ) 
                            , EA.verticalCenter
                            , onClick (
                                Scroll (
                                    movies.index
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
                            videoSettings modelWidth modelHeight (toFloat movies.scrollViewPosition )
                        ) movies.videos
                    )
                , row None
                    [ paddingXY 15 0 ][
                        Element.button VideoButton [ 
                            EA.width <| px ( modelWidth / 40 )
                            , EA.height <| px ( modelWidth / 40 )
                            , EA.verticalCenter
                            , onClick (
                                Scroll (
                                    movies.index
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

videoSettings : Float -> Float -> Float -> Video -> Element Styles variation msg
videoSettings modelWidth modeiHeight scrollViewPosition video =
    row None 
        [ EA.moveLeft ( ( modelWidth - modelWidth / 10 ) /3 * ( scrollViewPosition ) ) ][
        column None
            [ spacing 3
            , paddingXY ( modelWidth / 130 ) ( modeiHeight / 30 )
            , EA.center ][
            row VideoRow
                [ ][
                    Element.text video.videoTitle
                ]
            , row VideoRow
                [][
                    changeToElement( videoframe video.videoUrl modelWidth modeiHeight )
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

changeToElement : Html msg -> Element style variation msg
changeToElement msg =
    -- Change from Html to Element
    html msg

footerLayout : Model -> Element Styles variation msg
footerLayout model =
    row Footer
        [ paddingLeft  (model.width / 50)
        , EA.height (px (model.height / 10) )
        , EA.width (px (model.width) ) ][
            paragraph None
                [] [
                    Element.text "© 2023 React Inc. All Rights Reserved.I'm happy! thank you!"
                ]
        ]
