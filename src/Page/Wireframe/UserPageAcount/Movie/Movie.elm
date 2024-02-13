module Page.Wireframe.UserPageAcount.Movie.Movie exposing (..)

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
import Element.Events exposing (onClick, stopPropagationOn)
import Json.Decode as D

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
    | Contents
    | ModalContentStyle
    | ModalBK
    | ButtonBK
    | MenuModalButton
    | BKWH
    | UnderLine
    | SelectMovieColor

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
        , Style.style Contents
            [ Font.size ( model.width / 100 )
            ]
        , Style.style ModalContentStyle
            [ Color.background Color255.white
            , Color.border Color255.gray
            , Border.all 1.5
            , Border.solid
            , Border.rounded 10.0
            ]
        , Style.style ModalBK
            [ Color.background Color255.translucentGray
            ]
        , Style.style ButtonBK
            [ Color.text Color255.white
            , Color.background Color255.black
            , Color.border Color255.black
            , Font.size ( model.width / 40 )
            , Border.all 2
            , Border.rounded 10.0
            ]
        , Style.style MenuModalButton
            [ Border.bottom 3
            , Font.lineHeight 2
            , Font.size 20
            , Color.background Color255.white
            ]
        , Style.style BKWH
            [ Color.background Color255.white
            ]
        , Style.style UnderLine
            [ Border.bottom 5
            ]
        , Style.style SelectMovieColor
            [ Color.background Color255.clearBlue
            , Border.rounded 10.0
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
        , view = movieElement
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
    , selectMajorItem : Int      --Index selected in "Movie-contents"
    , selectMovie : String       --url selected in "Movie-contents"
    , playlists : List Playlist
    , menuStatus : OPStatus      --menu modal status
    , contentsStatus : OPStatus  --Status of contents in menu modal
    }

type OPStatus
    = Open
    | Close

type alias Playlist =
    { index : Int
    , title : String
    , scrollMovieContentsPosition : Int --"Movie-contents" playlist position
    , scrollAllMoviePosition : Int      --"All-Movie-contents" playlist position
    , videos : List Video
    }

type alias Video =
    { videoTitle : String
    , videoUrl : String
    , thumbnail : String
    , position : Int
    }

type ScrollAllMoviePosition =
    Int

type alias Cramp =
    { minPos : Int
    , maxPos : Int }

-- VideoData

list1_Videos : Playlist
list1_Videos =
    { index = 0
    , title = "git講習"
    , scrollMovieContentsPosition = initScrollMovieContentsPosition
    , scrollAllMoviePosition = initScrollAllMoviePosition
    , videos = [
        {videoTitle = "基本コマンド1" 
            , videoUrl = "Js_8xBDhhwE"
            , thumbnail = "/src/Picture/MovieThumbnail/GitCourse/GitCourse_1.jpg"
            , position = 0 }
        , {videoTitle = "基本コマンド2"
            , videoUrl = "eZ9M16REQiQ"
            , thumbnail = "/src/Picture/MovieThumbnail/GitCourse/GitCourse_2.jpg"
            , position = 1 }
        , {videoTitle = "GitHub_1"
            , videoUrl = "laz2u--LoTg"
            , thumbnail = "/src/Picture/MovieThumbnail/GitCourse/GitCourse_3.jpg"
            , position = 2 }
        , {videoTitle = "GitHub_2"
            , videoUrl = "tHZ9yR8I81w"
            , thumbnail = "/src/Picture/MovieThumbnail/GitCourse/GitCourse_4.jpg"
            , position = 3 }
        , {videoTitle = "git内部の仕組み"
            , videoUrl = "qLyUayBh-T8"
            , thumbnail = "/src/Picture/MovieThumbnail/GitCourse/GitCourse_5.jpg"
            , position = 4 }
        ]
    }

list2_Videos : Playlist
list2_Videos =
    { index = 1
    , title = "プログラミングパラダイム講習"
    , scrollMovieContentsPosition = initScrollMovieContentsPosition
    , scrollAllMoviePosition = initScrollAllMoviePosition
    , videos = [
        {videoTitle = "古代ギリシャ-中世編" 
            , videoUrl = "kvOPZVjBsNA"
            , thumbnail = "/src/Picture/MovieThumbnail/ProgrammingParadigmCourse/ProgrammingParadigmCourse_1.jpg"
            , position = 0 }
        , {videoTitle = "OOP-論理は物質の手足" 
            , videoUrl = "B3mgmghlEKY"
            , thumbnail = "/src/Picture/MovieThumbnail/ProgrammingParadigmCourse/ProgrammingParadigmCourse_2.jpg"
            , position = 1 }
       , {videoTitle = "論理世界への一元化" 
            , videoUrl = "ClyBlJ8LCQg"
            , thumbnail = "/src/Picture/MovieThumbnail/ProgrammingParadigmCourse/ProgrammingParadigmCourse_3.jpg"
            , position = 2 }
        , {videoTitle = "論理のみの世界 関数型パラダイム" 
            , videoUrl = "NGrLa92DHlc"
            , thumbnail = "/src/Picture/MovieThumbnail/ProgrammingParadigmCourse/ProgrammingParadigmCourse_4.jpg"
            , position = 3 }
        ]
    }

list3_Videos : Playlist
list3_Videos =
    { index = 2
    , title = "ゲーム講習"
    , scrollMovieContentsPosition = initScrollMovieContentsPosition
    , scrollAllMoviePosition = initScrollAllMoviePosition
    , videos = [
        {videoTitle = "【初歩編】第1回" 
            , videoUrl = "Ht6R3OosXDk"
            , thumbnail = "/src/Picture/MovieThumbnail/GameCourse/GameCourse_1.jpg"
            , position = 0 }
       , {videoTitle = "【初歩編】第2回" 
            , videoUrl = "9g-NnkrScng"
            , thumbnail = "/src/Picture/MovieThumbnail/GameCourse/GameCourse_2.jpg"
            , position = 1 }
        , {videoTitle = "【初歩編】第3回" 
            , videoUrl = "f2SZjtkPF2Q"
            , thumbnail = "/src/Picture/MovieThumbnail/GameCourse/GameCourse_3.jpg"
            , position = 2 }
        , {videoTitle = "【初歩編】第4回" 
            , videoUrl = "x4wB8ET-57Y"
            , thumbnail = "/src/Picture/MovieThumbnail/GameCourse/GameCourse_4.jpg"
            , position = 3 }
        , {videoTitle = "番外編 プランナー編"
            , videoUrl = "7OvNuawE9ys"
            , thumbnail = "/src/Picture/MovieThumbnail/GameCourse/GameCourseEx_1.jpg"
            , position = 4 }
        , {videoTitle = "番外編 インストラクター編"
            , videoUrl = "ZN9ywfx6XS4"
            , thumbnail = "/src/Picture/MovieThumbnail/GameCourse/GameCourseEx_2.jpg"
            , position = 5 }
        ]
    }

list4_Videos : Playlist
list4_Videos =
    { index = 3
    , title = "System Design講習"
    , scrollMovieContentsPosition = initScrollMovieContentsPosition
    , scrollAllMoviePosition = initScrollAllMoviePosition
    , videos = [
        {videoTitle = "part1"
            , videoUrl = "CVHci7zRaw4"
            , thumbnail = "/src/Picture/MovieThumbnail/SystemDesignCourse/SystemDesignCourse_1.jpg"
            , position = 0 }
        , {videoTitle = "part2"
            , videoUrl = "62x0qPk7W24"
            , thumbnail = "/src/Picture/MovieThumbnail/SystemDesignCourse/SystemDesignCourse_2.jpg"
            , position = 1 }
        , {videoTitle = "part3"
            , videoUrl = "Nixcc9fmTqQ"
            , thumbnail = "/src/Picture/MovieThumbnail/SystemDesignCourse/SystemDesignCourse_3.jpg"
            , position = 2 }
        ]
    }

-- Initialize
initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , selectMajorItem = initSelectMajorItem
    , selectMovie = "Js_8xBDhhwE" --TODO 初期表示ここをどうするか
    , menuStatus = Close
    , contentsStatus = Close
    , playlists = [
        list1_Videos
        , list2_Videos
        , list3_Videos
        , list4_Videos
        ]
    }

initSelectMajorItem : Int
initSelectMajorItem =
    0

initScrollAllMoviePosition : Int
initScrollAllMoviePosition =
    0

initScrollMovieContentsPosition : Int
initScrollMovieContentsPosition =
    0

type Direction
    = MoveRight
    | MoveLeft
    | MoveUp
    | MoveDown

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | Scroll ( Int, Direction)
    | MenuModalOpen
    | MenuModalClose
    | ContentsListChenge
    | ChengeMovie ( Int, String, Int )

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
        
        MenuModalOpen ->
            ( { model | menuStatus = Open }, Cmd.none )
        
        MenuModalClose ->
            ( { model | menuStatus = Close
                , contentsStatus = Close }, Cmd.none )

        ContentsListChenge ->
            ( { model | contentsStatus = 
                if model.contentsStatus == Close then
                    Open
                else
                    Close }, Cmd.none )
        
        ChengeMovie ( newMajorItem, url, newMinorItem) ->
            ( chengeMovie model ( newMajorItem, url, newMinorItem), Cmd.none  )

chengeMovie : Model -> ( Int, String, Int ) -> Model 
chengeMovie model ( newMajorItem, url, newMinorItem) =
    let
        newPlaylist = 
            List.map ( setNewPlaylist ( newMajorItem, newMinorItem ) ) model.playlists
    in
        { model | selectMajorItem = newMajorItem
        , selectMovie = url
        , playlists = newPlaylist }

setNewPlaylist : ( Int, Int ) -> Playlist -> Playlist
setNewPlaylist ( newMajorItem, newMinorItem ) playlist =
    let
        maxPos =
            List.length(playlist.videos) - 1 --"MovieContents" scroll maximum value
    in
    if playlist.index == newMajorItem then
        { playlist | scrollMovieContentsPosition = 
            if maxPos == newMinorItem then
                newMinorItem - 1
            else
                newMinorItem }
    else
        playlist

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
            shiftPosition playlist.scrollMovieContentsPosition playlist.scrollAllMoviePosition direction
        
        maxPos =
            List.length(playlist.videos)

        isTarget = playlist.index == targetPlaylistIndex

        validTarget = isTarget && isInRange newScrollViewPosition maxPos
    in
    
    if validTarget then
        if direction == MoveRight
            || direction == MoveLeft then
            { playlist | scrollAllMoviePosition = newScrollViewPosition } 
        else
            { playlist | scrollMovieContentsPosition = newScrollViewPosition } 
    else
        playlist

shiftPosition : Int -> Int -> Direction -> Int
shiftPosition scrollMovieContentsPosition scrollAllMoviePosition direction =
    case direction of
        MoveRight ->
            scrollAllMoviePosition + 1
        MoveLeft ->
            scrollAllMoviePosition - 1
        MoveUp ->
            scrollMovieContentsPosition - 1
        MoveDown ->
            scrollMovieContentsPosition + 1

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

movieElement : Model -> Html Msg
movieElement model=
    Element.layout ( stylesheet model ) <|
        column None
            {- TODO headerfooter固定の場合
            [yScrollbar] [
                headerLayout model
                , el None
                    [ EA.height ( px ( model.height - ( model.height / 10 ) *2 ))
                    , EA.width ( px model.width )
                    , yScrollbar
                    ] <|
                    column Main
                        []
                        ( List.concat
                            [ movieLayout model
                            , allMovieLayout model ]
                        )
                , footerLayout model
            ] -}
            [][
            if model.menuStatus == Open then
                column None
                    [](
                        menuModal model
                    )
            else
                textLayout None 
                    [][]
             
            , headerLayout model
            , el None
                [ yScrollbar ] <|
                column Main
                    [ EA.width fill
                    , center
                    , verticalCenter
                    , paddingXY 0 20
                    ](
                    List.concat
                        [ movieContentsLayout model
                        , allMovieContentsLayout model
                        ]
                    )
            , footerLayout model
            ]

headerLayout : Model -> Element Styles variation Msg
headerLayout model =
    row Header
        [ spread
        , paddingXY 30 20 
        , EA.height ( px ( model.height / 10 ) )
        , EA.width fill
        ][
        el Logo
            [ verticalCenter ] (
            image None 
                [ EA.width (px ( model.width / 25 ) )
                , EA.height ( px ( model.width / 25 ) )
                ]{
                    src = "/src/Picture/VITORIA_logo.jpg"
                    , caption = "VITORIA_logo"
                }
            )
        , row None
            [ spacing 5
            , verticalCenter ][
            Element.button Button
                [ paddingXY 20 0 ](
                    Element.text "TOP"
                )
            , if model.menuStatus == Open then
                image None
                    [ EA.width ( px ( model.width / 30 ) )
                    , EA.height ( px ( model.width / 30 ) )
                    , onClick(
                        MenuModalClose
                        )
                    ]{
                        src = "/src/Picture/CloseButton.png"
                        , caption = "MenuButton"
                    }
            else
                image None 
                    [ EA.width ( px ( model.width / 30 ) )
                    , EA.height ( px ( model.width / 30 ) )
                    , onClick(
                        MenuModalOpen
                        )
                    ]{
                        src = "/src/Picture/hamburger.png"
                        , caption = "MenuButton"
                    }
            ]
        ]

-- movieContents
movieContentsLayout : Model -> List (Element Styles variation Msg)
movieContentsLayout model=
    [ row None
        [ center ][
        Element.h1 Title
            [](
                column None [][
                Element.text "movie-contents"
                ]
            )
        ]
    , row None
        [][
        column None
            [ EA.width (px ( model.width / 1.7 ) ) ][
            column None
                [][
                Element.text ( "Width : " ++ String.fromFloat ( model.width ) ++ " Height : " ++ String.fromFloat ( model.height ) )
                -- This is for sample purposes only and will be deleted later.
                , column None
                    [] (
                        List.map ( selectMovieSet model.width model.height model.selectMovie ) model.playlists
                    )
                ]
            ]
        , column None
            [ EA.width (px ( model.width / 2.5 ) ) ][
            column None
                [](
                    List.map ( movieContentsSet model.selectMajorItem
                     model.width model.height model.selectMovie ) model.playlists
                )
            ]
        ]
    ]

movieContentsSet : Int -> Float -> Float -> String -> Playlist -> Element Styles variation Msg
movieContentsSet selectMajorItem modelWidth modelHeight selectMovie movies = 
    if movies.index == selectMajorItem then
        column None
            [ paddingBottom 30
            , EA.center ][
            if (List.length(movies.videos) // 3 ) >= 1 --"list length ÷ 3" : 3 or more images exist
                && movies.scrollMovieContentsPosition > 0 then 
                Element.button VideoButton
                    [ EA.width ( px ( modelWidth / 40 ) )
                    , EA.height ( px ( modelWidth / 40 ) ) 
                    , EA.verticalCenter
                    , onClick (
                        Scroll (
                            movies.index
                            , MoveUp
                        )
                    )
                ]
                ( image None
                    [ EA.width ( px ( modelWidth / 40 ) )
                    , EA.height ( px ( modelWidth / 40 ) )
                    ]{ 
                        src = "/src/Picture/UpButton.png"
                        , caption = "UpButton"
                    }
                )
            else
                textLayout None
                    [ EA.width ( px ( modelWidth / 40 ) )
                    , EA.height ( px ( modelWidth / 40 ) ) ][]
            , column None
                [ EA.alignLeft
                , EA.height (px ( modelHeight / 1.5 ) ) 
                , clipY](
                    List.map (
                        movieContentsSettings modelWidth modelHeight
                            movies.scrollMovieContentsPosition movies.index selectMovie
                    ) movies.videos
                )
            , if List.length(movies.videos) > 2 
                -- "Current display position < ( list length - 2 )" : "2" is because there are 2 images initially displayed.
                && movies.scrollMovieContentsPosition < ( List.length(movies.videos) - 2 )then
                Element.button VideoButton [ 
                    EA.width <| px ( modelWidth / 40 )
                    , EA.height <| px ( modelWidth / 40 )
                    , EA.verticalCenter
                    , onClick (
                        Scroll (
                            movies.index
                            , MoveDown
                        )
                    )
                ]
                ( image None
                    [ EA.center
                    , EA.width <| px ( modelWidth / 40 )
                    , EA.height <| px ( modelWidth / 40 ) 
                    ]{
                        src = "/src/Picture/DownButton.png"
                        , caption = "DownButton" 
                    }
                )
            else
                textLayout None
                    [ paddingBottom (modelWidth / 40) ][]
            ]
    else
        column None
            [][]
movieContentsSettings : Float -> Float -> Int -> Int -> String -> Video -> Element Styles variation Msg
movieContentsSettings modelWidth modelHeight scrollMovieContentsPosition index selectMovie video =
    row None 
        [ EA.moveUp ( ( modelHeight - modelHeight / 10 ) / 2.63 * ( toFloat scrollMovieContentsPosition ) ) ][
        column None
            [ spacing 3
            , paddingXY ( modelWidth / 170 ) ( modelHeight / 30 )
            , EA.center ][
            Element.button VideoButton
                [ EA.verticalCenter
                , onClick (
                    ChengeMovie (
                        index
                        , video.videoUrl
                        , video.position
                    )
                ) 
                 ](
                if selectMovie == video.videoUrl then
                    column SelectMovieColor 
                        [][
                        row None
                            [ paddingXY 15 13 ](
                                thumbnailframe video.thumbnail modelWidth modelHeight
                            )
                        , row Contents
                            [ EA.center ][
                                Element.text video.videoTitle
                            ]
                        ]
                else
                    column None
                        [][
                        row None
                            [ paddingXY 15 13 ](
                                thumbnailframe video.thumbnail modelWidth modelHeight
                            )
                        , row Contents
                            [ EA.center ][
                                Element.text video.videoTitle
                            ]
                        ]
                )
            ]
        ]
selectMovieSet : Float -> Float -> String -> Playlist -> Element Styles variation Msg
selectMovieSet modelWidth modelHeight selectMovie movies = 
    column None
        [ paddingBottom 30 ][
        row None
            [ EA.width (px ( modelWidth / 1.7 ) )
            , EA.center ](
                List.map (
                    movieSetting modelWidth modelHeight selectMovie
                ) movies.videos
            )
        ]
movieSetting : Float -> Float -> String -> Video -> Element Styles variation msg
movieSetting modelWidth modeiHeight selectMovie video =
    if video.videoUrl == selectMovie then --TODO初期表示追記
        column None
            [][
            row VideoRow
                [][
                    Element.text video.videoTitle
                ]
            , row VideoRow
                [ EA.center ][
                    changeToElement( movieframe video.videoUrl modelWidth modeiHeight )
                ]
            ]
    else
        column None
            [][]
movieframe : String -> Float -> Float -> Html msg
movieframe url mainScreenWidth mainScreenheight=
    iframe
        [ HA.width ( movieframeWidth mainScreenWidth )
        , HA.height ( movieframeHeight mainScreenheight )
        , HA.src ("https://www.youtube.com/embed/" ++ url)
        , HA.attribute "frameborder" "0"
        , HA.attribute "allowfullscreen" "True"
        ][]

movieframeWidth : Float -> Int
movieframeWidth mainScreenWidth=
    round mainScreenWidth // 3

movieframeHeight : Float -> Int
movieframeHeight mainScreenHeight=
    round mainScreenHeight // 2

changeToElement : Html msg -> Element style variation msg
changeToElement msg =
    -- Change from Html to Element
    html msg

-- allMovieContents
allMovieContentsLayout : Model -> List (Element Styles variation Msg)
allMovieContentsLayout model=
    [ row None
        [ EA.width fill
        , center
        , paddingTop 10 ][
        Element.h1 Title
            [](
                Element.text "all-movie-contents"
            )
        ]
    , row None
        [][
        column None
            [][
            column None
                [ EA.width (px ( model.width - (model.width/100))) ]
                (
                    List.map ( allMovieContentsSet model.selectMajorItem model.width model.height ) model.playlists
                )
            ]
        ]
    ]

allMovieContentsSet : Int -> Float -> Float -> Playlist -> Element Styles variation Msg
allMovieContentsSet selectMajorItem modelWidth modelHeight movies = 
    if movies.index == selectMajorItem then
        textLayout None
            [][]
    else
        column None
            [ paddingBottom 30 ][
            column ListTitle
                [ paddingTop 30
                , paddingBottom 0
                , paddingRight 0
                , paddingLeft 50 ][
                    Element.text ( movies.title )
                ]
            , row None
                [ EA.width fill ][
                row None
                    [ paddingXY 15 0 ][
                    -- When there are 4 or more images and the scroll position is greater than 0
                    if List.length(movies.videos) > 4
                        && movies.scrollAllMoviePosition > 0 then
                        Element.button VideoButton
                            [ EA.width <| px ( modelWidth / 40 )
                            , EA.height <| px ( modelWidth / 40 ) 
                            , EA.verticalCenter
                            , onClick (
                                Scroll (
                                    movies.index
                                    , MoveLeft
                                )
                            )
                        ]
                        ( image None
                            [ EA.center
                            , EA.width <| px ( modelWidth / 40 )
                            , EA.height <| px ( modelWidth / 40 ) 
                            ]{ 
                                src = "/src/Picture/Left.png"
                                , caption = "button_left"
                            }
                        )
                    else
                        textLayout None
                            [ EA.width ( px ( modelWidth / 40 ) ) ][]
                    ]
                , row UnderLine
                    [ EA.alignLeft
                    , EA.width fill
                    , clipX ](
                        List.map (
                            allMoviecontentsSettings modelWidth modelHeight movies.index (toFloat movies.scrollAllMoviePosition )
                        ) movies.videos
                    )
                , row None
                    [ paddingXY 15 0 ][
                    -- "list length ÷ 5" : There are 5 or more images
                    if (List.length(movies.videos) // 5 ) >= 1
                        --"Current display position < ( list length - 4 )" : "4" is because there are 4 images initially displayed.
                        && movies.scrollAllMoviePosition < (List.length(movies.videos) - 4) then 
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
                                src = "/src/Picture/Right.png"
                                , caption = "button_right" 
                            }
                        )
                    else
                        textLayout None
                            [ EA.width ( px ( modelWidth / 40 ) ) ][]
                    ]
                ]
            ]

allMoviecontentsSettings : Float -> Float -> Int -> Float -> Video -> Element Styles variation Msg
allMoviecontentsSettings modelWidth modelHeight index scrollAllMoviePosition video =
    row None 
        [ EA.moveLeft ( ( modelWidth - modelWidth / 10 ) /4 * ( scrollAllMoviePosition ) ) ][
        column None
            [ spacing 3
            , paddingXY ( modelWidth / 170 ) ( modelHeight / 30 )
            , EA.center
             ][
            Element.button VideoButton
                [ EA.verticalCenter
                , onClick (
                    ChengeMovie (
                        index
                        , video.videoUrl
                        , video.position
                    )
                ) ](
                column None[][
                    row None
                        [](
                            thumbnailframe video.thumbnail modelWidth modelHeight
                        )
                    , row Contents
                        [][
                            Element.text video.videoTitle
                        ]
                    ]
                )
            ]
        ]

-- common
thumbnailframe : String -> Float -> Float -> List (Element Styles variation msg)
thumbnailframe thumbnail mainScreenWidth mainScreenheight=
    [ row None [][
        image None
            [ EA.center
            , EA.width ( px ( ( mainScreenWidth - ( mainScreenWidth / 7 ) ) / 4 ) )
            , EA.height ( px ( mainScreenheight / 4.5 ) ) ]{
                src = thumbnail
                , caption = thumbnail
            }
        ]
    ]

footerLayout : Model -> Element Styles variation msg
footerLayout model =
    let
        footerInnerWidth = 
             model.width - ( ( model.width / 50 ) * 2 )
    in

    row Footer
        [ paddingLeft  ( model.width / 50 )
        , paddingRight  ( model.width / 50 )
        , EA.height ( px ( model.height / 5 ) )
        , EA.width fill ][
        column None
            [][
            row None
                [ paddingTop 10 ][
                column None
                    [ EA.width ( px (footerInnerWidth / 2 ) ) ] [
                    image None 
                        [ paddingTop 10
                        , EA.width (px ( model.width / 20 ) )
                        , EA.height ( px ( model.width / 20 ) )
                        ]{
                            src = "/src/Picture/VITORIA_logo.jpg"
                            , caption = "VITORIA_logo"
                        }
                    ]
                , column None
                    [ EA.width ( px (footerInnerWidth / 2 ) ) ][
                    row None
                        [] [
                            Element.newTab 
                                "https://vitoria.co.jp/contact/"
                            <| el None [](Element.text "会社概要")
                        ]
                    , row None
                        [] [
                            Element.newTab 
                                "https://vitoria.co.jp/contact/"
                            <| el None [](Element.text "利用規約")
                        ]
                    , row None
                        [] [
                            Element.newTab 
                                "https://vitoria.co.jp/contact/"
                            <| el None [](Element.text "お問い合わせ")
                        ]
                    , row None
                        [] [
                            Element.newTab 
                                "https://vitoria.co.jp/contact/"
                            <| el None [](Element.text "プライバシーポリシー")
                        ]
                    ]
                ]
            , row None
                [ paddingTop 10
                , center ][
                    Element.text "©VITORIA"
                ]
            ]
        ]

menuModal : Model-> List (Element Styles variation Msg)
menuModal model =
    [ modal ModalBK
       [ EA.height ( px ( model.height ) )
        , EA.width ( px ( model.width ) )
        , paddingTop ( model.height / 10 )
        , paddingLeft ( model.width / 1.3 )
        , onClick(
            MenuModalClose
        )] (
        column ModalContentStyle
            [ EA.height fill
            , EA.width ( px ( model.width / 4.6 ) ) 
            , yScrollbar
            , onClickStopPropagation Nothing
            ][
            column None
                [ paddingXY ( model.width / 100 ) ( model.height / 100 ) ][
                Element.button BKWH
                    [ paddingTop ( model.height / 50 )
                    , EA.width fill
                    , onClick (
                        ContentsListChenge
                        )
                    ] (
                    column None
                        [][
                        row MenuModalButton
                            [][
                            column None
                                [ EA.width ( px ( model.width / 6 ) )
                                , alignLeft ][
                                    Element.text "CONTENTS"
                                ]
                            , if model.contentsStatus == Open then
                                column None
                                    [][
                                    image None 
                                        [ EA.width ( px ( model.width / 40 ) )
                                        , EA.height ( px ( model.width / 40 ) )
                                        ]{
                                            src = "/src/Picture/minusButton.png"
                                            , caption = "MinusButton"
                                        }
                                    ]
                            else
                                column None
                                    [][
                                    image None 
                                        [ EA.width ( px ( model.width / 40 ) )
                                        , EA.height ( px ( model.width / 40 ) )
                                        ]{
                                            src = "/src/Picture/plusButton.png"
                                            , caption = "PlusButton"
                                        }
                                    ]
                            ]
                        , if model.contentsStatus == Open then
                            contentsMenu
                        else
                            textLayout None [][] 
                        ]
                    )
                , Element.button MenuModalButton
                    [ paddingTop ( model.height / 50 )
                    , EA.width fill ](
                        row None
                            [][
                            column None
                                [EA.width ( px ( model.width / 6 ) )
                                , alignLeft ][
                                    Element.text "会員情報"
                                ]
                            , column None
                                [][
                                image None 
                                    [ EA.width ( px ( model.width / 40 ) )
                                    , EA.height ( px ( model.width / 40 ) )
                                    ]{
                                        src = "/src/Picture/rightArrow.png"
                                        , caption = "RightArrow"
                                    }
                                ]
                            ]
                    )
                , Element.button MenuModalButton
                    [ paddingTop ( model.height / 50 )
                    , EA.width fill ](
                    row None
                        [][
                        column None
                            [ EA.width ( px ( model.width / 6 ) )
                            , alignLeft ][
                                Element.text "CONTACT"
                            ]
                        , column None
                            [][
                            image None 
                                [ EA.width ( px ( model.width / 40 ) )
                                , EA.height ( px ( model.width / 40 ) )
                                ]{
                                    src = "/src/Picture/rightArrow.png"
                                    , caption = "RightArrow"
                                }
                            ]
                        ]
                    )
                ]
            , row None
                [ center
                , paddingTop ( model.height / 5 ) ][
                Element.button ButtonBK
                    [ paddingXY 20 0 ](
                        Element.text "LOGOUT"
                    )
                ]
            ]
        )
    ]

contentsMenu : Element Styles variation msg
contentsMenu = 
    row MenuModalButton
        [][
        column None
            [][
            row None
                [][
                    Element.text "CONTENTS_01"
                ]
            , row None
                [][
                    Element.text "CONTENTS_02"
                ]
            , row None
                [][
                    Element.text "CONTENTS_03"
                ]
            ]
        ]

onClickStopPropagation : a -> Element.Attribute variation a
onClickStopPropagation msg =
    stopPropagationOn "click" <| D.succeed ( msg, True )

