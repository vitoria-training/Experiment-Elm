module Page.Wireframe.UserPageAcount.UserPageOtherPattern.UserPage_02 exposing (..)

import Color as Color255
import Task
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (onClick, stopPropagationOn)
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color
import Style.Font as Font
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Html exposing (Html)
import Json.Decode as D

type Styles
    = None
    | Header
    | Footer
    | Title
    | Main
    | Logo
    | Button
    | TextBox
    | ModalContentStyle
    | ModalBK
    | ButtonBK
    | MenuModalButton
    | BKWH
    | ChengeButton
    | ContentsTitle

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
            , Color.background Color255.white
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
            [ Font.lineHeight 2
            ]
        , style ModalContentStyle
            [ Color.background Color255.white
            , Color.border Color255.gray
            , Border.all 1.5
            , Border.solid
            , Border.rounded 10.0
            ]
        , style ModalBK
            [ Color.background Color255.translucentGray
            ]
        , style ButtonBK
            [ Color.text Color255.white
            , Color.background Color255.black
            , Color.border Color255.black
            , Font.size ( model.width / 40 )
            , Border.all 2
            , Border.rounded 10.0
            ]
        , style MenuModalButton
            [ Border.bottom 3
            , Font.lineHeight 2
            , Font.size 20
            , Color.background Color255.white
            ]
        , style BKWH
            [ Color.background Color255.white
            ]
        , style ChengeButton
            [ Color.background Color255.white
            ]
        , Style.style ContentsTitle
            [ Font.bold
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
        , view = userPagePattern_02Element
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
    , menuStatus : OPStatus
    , contentsStatus : OPStatus
    , movieContentsList : List MovieContents
    , movieContentsPosition : Int --先頭のmovieContents表示位置
    , optionContentsList :  List OtherContents
    , optionContentsPosition : Int --先頭のoptionContents表示位置
    }

type alias MovieContents =
    { index : Int
    , title : String
    , src : String
    }

type alias OtherContents =
    { index : Int
    , title : String
    , src : String
    , text : String
    }

type OPStatus
    = Open
    | Close

type TypeOfContents
    = Movie
    | Option

type Direction
    = Left
    | Right

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , menuStatus = Close
    , contentsStatus = Close
    , movieContentsList = 
        [ movie_01
        , movie_02
        , movie_03
        , movie_04 ]
    , movieContentsPosition = initPosition
    , optionContentsList = 
        [ other_01
        , other_02
        , other_03
        , other_04 ]
    , optionContentsPosition = initPosition }

initPosition : Int
initPosition =
    0

movie_01 : MovieContents
movie_01 =
    { index = 0
    , title = "GitCourse"
    , src = "/assets/image/MovieThumbnail/GitCourse/GitCourse_1.jpg" }

movie_02 : MovieContents
movie_02 =
    { index = 1
    , title = "ProgrammingParadigmCourse"
    , src = "/assets/image/MovieThumbnail/ProgrammingParadigmCourse/ProgrammingParadigmCourse_1.jpg" }

movie_03 : MovieContents
movie_03 =
    { index = 2
    , title = "GameCourse"
    , src = "/assets/image/MovieThumbnail/GameCourse/GameCourse_1.jpg" }

movie_04 : MovieContents
movie_04 =
    { index = 3
    , title = "SystemDesignCourse"
    , src = "/assets/image/MovieThumbnail/SystemDesignCourse/SystemDesignCourse_1.jpg" }

other_01 : OtherContents
other_01 =
    { index = 0
    , title = "GitCourse"
    , src = "/assets/image/MovieThumbnail/GitCourse/GitCourse_1.jpg"
    , text = "Git講習についての説明文をここに表示。\nテスト用の文言" }

other_02 : OtherContents
other_02 =
    { index = 1
    , title = "ProgrammingParadigmCourse"
    , src = "/assets/image/MovieThumbnail/ProgrammingParadigmCourse/ProgrammingParadigmCourse_1.jpg"
    , text = "プログラミングパラダイム講習\nについての説明文をここに表示。\nテスト用の文言" }

other_03 : OtherContents
other_03 =
    { index = 2
    , title = "GameCourse"
    , src = "/assets/image/MovieThumbnail/GameCourse/GameCourse_1.jpg"
    , text = "ゲーム講習についての説明文をここに表示。\nテスト用の文言" }

other_04 : OtherContents
other_04 =
    { index = 3
    , title = "SystemDesignCourse"
    , src = "/assets/image/MovieThumbnail/SystemDesignCourse/SystemDesignCourse_1.jpg"
    , text = "システムデザイン講習\nについての説明文をここに表示。\nテスト用の文言" }

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | MenuModalOpen
    | MenuModalClose
    | ContentsListChenge
    | Scroll ( TypeOfContents, Direction )

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
        
        Scroll ( typeOfContents, direction ) ->
            ( schrollChenge model ( typeOfContents, direction ) , Cmd.none )

schrollChenge : Model -> ( TypeOfContents, Direction ) -> Model
schrollChenge model ( typeOfContents, direction ) =
    let
        position =
            case typeOfContents of
                Movie ->
                    chengePosition model.movieContentsPosition direction
                Option ->
                    chengePosition model.optionContentsPosition direction
    in
    case typeOfContents of
        Movie ->
            { model | movieContentsPosition = position }
        Option ->
            { model | optionContentsPosition = position }

chengePosition : Int -> Direction -> Int
chengePosition position direction =
    case direction of
        Right ->
            position + 1
        Left ->
            position - 1

userPagePattern_02Element : Model -> Html Msg
userPagePattern_02Element model=
    Element.layout (stylesheet model) <|
        column None
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
                    [] <|
                    column Main
                        [ width fill
                        , center
                        , verticalCenter
                        , paddingXY 0 20 
                        ](
                            List.concat [
                                movieContents model
                                , optionCntents model
                            ]
                        )
                , footerLayout model
            ]

headerLayout : Model -> Element Styles variation Msg
headerLayout model =
    row Header
        [ spread
        , paddingXY 30 20 
        , height ( px ( model.height / 10 ) )
        , width fill
        ][
        el Logo
            [ verticalCenter ] (
            image None 
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
            button Button
                [ paddingXY 20 0 ](
                    Element.text "TOP"
                )
            , if model.menuStatus == Open then
                image None 
                    [ width ( px ( model.width / 30 ) )
                    , height ( px ( model.width / 30 ) )
                    , onClick(
                        MenuModalClose
                        )
                    ]{
                        src = "/assets/image/Button/CloseButton.png"
                        , caption = "MenuButton"
                    }
            else
                image None 
                    [ width ( px ( model.width / 30 ) )
                    , height ( px ( model.width / 30 ) )
                    , onClick(
                        MenuModalOpen
                        )
                    ]{
                        src = "/assets/image/Button/hamburger.png"
                        , caption = "MenuButton"
                    }
            ]
        ]

movieContents : Model -> List (Element Styles variation Msg)
movieContents model=
    [ column None
        [ paddingBottom ( model.height / 10 ) ][
        textLayout None
            [ spacingXY 25 25
            , center ][
            h1 Title
                [](
                    Element.text "movie-contents"
                )
            ]
        , row None
            [ paddingXY 10 10 ][
                setMovieContents model
            ]
        ]
    ]

setMovieContents : Model -> Element Styles variation Msg
setMovieContents model =
    let
        listLength =
            List.length( model.movieContentsList ) - 1 
        maxPosition =
            listLength - 3 --TODO リスト長 - 初期表示の3件
        lastDisplayPosition =
            model.movieContentsPosition + 2
    in
    row TextBox
        [ paddingTop 50 ][
        if model.movieContentsPosition > 0 then
            Element.button ChengeButton
                [ verticalCenter ](
                image None 
                    [ width ( px ( model.width / 40 ) )
                    , height ( px ( model.width / 40 ) )
                    , onClick (
                        Scroll (
                            Movie
                            , Left
                        )
                    )
                    ]{ 
                    src = "/assets/image/Button/Left.png"
                    , caption = "button_left"
                    }
                )
        else
            textLayout None
                [ width ( px ( model.width / 40 ) ) ][]
        , row None
            [](
                List.map ( setMovie model.width model.height model.movieContentsPosition lastDisplayPosition ) model.movieContentsList
            )
        , if model.movieContentsPosition >= 0  
            && model.movieContentsPosition <= maxPosition then
            Element.button ChengeButton
                [ verticalCenter ](
                image None 
                    [ width ( px ( model.width / 40 ) )
                    , height ( px ( model.width / 40 ) )
                    , onClick (
                        Scroll (
                            Movie
                            , Right
                        )
                    )
                    ]{
                    src = "/assets/image/Button/Right.png"
                    , caption = "button_right"
                    }
                )
        else
            textLayout None
                [ width ( px ( model.width / 40 ) ) ][]
        ]

setMovie : Float -> Float -> Int -> Int -> MovieContents -> Element Styles variation Msg
setMovie modelWidth modelHeight movieContentsPosition lastDisplayPosition movieContentsList =
    if movieContentsList.index == movieContentsPosition
        || ( movieContentsList.index > movieContentsPosition 
            && movieContentsList.index <= lastDisplayPosition ) then
        column None
            [ paddingXY 20 10 ][
            Element.button None
                [ width ( px ( modelWidth / 4 ) )
                , height ( px ( modelHeight / 3 ) ) ](
                column None
                    [ width ( px ( modelWidth / 4 ) )
                    , center ][
                    row ContentsTitle
                        [][
                        Element.text movieContentsList.title
                        ]
                    , row None
                        [][
                        image None
                            [ width (px ( modelWidth / 5 ) )
                            , height ( px ( modelHeight / 4 ) )
                            ]{
                            src = movieContentsList.src
                            , caption = movieContentsList.src
                            }
                        ]
                    ]
                )
            ]
    else
        textLayout None
            [][]

optionCntents : Model -> List (Element Styles variation Msg)
optionCntents model=
    [ column None
        [ paddingBottom ( model.height / 10 ) ][
        textLayout None
            [ spacingXY 25 25
            , center ][
            h1 Title
                [](
                    Element.text "option-contents"
                )
            ]
        , row None
            [ paddingXY 10 10 ][
                setOptionContents model
            ]
        ]
    ]

setOptionContents : Model -> Element Styles variation Msg
setOptionContents model =
    let
        listLength =
            List.length( model.optionContentsList ) - 1 
        maxPosition =
            listLength - 3 --TODO リスト長 - 初期表示の3件
        lastDisplayPosition =
            model.optionContentsPosition + 2
    in
    row TextBox
        [ paddingTop 50 ][
        if model.optionContentsPosition > 0 then
            Element.button ChengeButton
                [ verticalCenter ](
                image None 
                    [ width ( px ( model.width / 40 ) )
                    , height ( px ( model.width / 40 ) )
                    , onClick (
                        Scroll (
                            Option
                            , Left
                        )
                    )
                    ]{ 
                    src = "/assets/image/Button/Left.png"
                    , caption = "button_left"
                    }
                )
        else
            textLayout None
                [ width ( px ( model.width / 40 ) ) ][]
        , row None
            [](
                List.map (
                    setOption model.width model.height model.optionContentsPosition lastDisplayPosition
                ) model.optionContentsList
            )
        , if model.optionContentsPosition >= 0  
            && model.optionContentsPosition <= maxPosition then
            Element.button ChengeButton
                [ verticalCenter ](
                image None 
                    [ width ( px ( model.width / 40 ) )
                    , height ( px ( model.width / 40 ) )
                    , onClick (
                        Scroll (
                            Option
                            , Right
                        )
                    )
                    ]{
                    src = "/assets/image/Button/Right.png"
                    , caption = "button_right"
                    }
                )
        else
            textLayout None
                [ width ( px ( model.width / 40 ) ) ][]
        ]

setOption : Float -> Float -> Int -> Int -> OtherContents -> Element Styles variation Msg
setOption modelWidth modelHeight optionContentsPosition lastDisplayPosition optionContentsList =
    if optionContentsList.index == optionContentsPosition
        || ( optionContentsList.index > optionContentsPosition 
            && optionContentsList.index <= lastDisplayPosition ) then
        column None
            [ paddingXY 20 10 ][
            Element.button None
                [ width ( px ( modelWidth / 4 ) )
                , height ( px ( modelHeight / 2 ) ) ](
                column None
                    [ width ( px ( modelWidth / 4 ) )
                    , center ][
                    row ContentsTitle
                        [][
                        Element.text optionContentsList.title
                        ]
                    , row None
                        [][
                        image None
                            [ width (px ( modelWidth / 5 ) )
                            , height ( px ( modelHeight / 4 ) )
                            ]{
                            src = optionContentsList.src
                            , caption = optionContentsList.src
                            }
                        ]
                    , row ContentsTitle
                        [ height ( px ( modelHeight / 5 ) ) ][
                        Element.text optionContentsList.text
                        ]
                    ]
                )
            ]
    else
        textLayout None
            [][]

footerLayout : Model -> Element Styles variation msg
footerLayout model =
    let
        footerInnerWidth = 
             model.width - ( ( model.width / 50 ) * 2 )
    in

    row Footer
        [ paddingLeft  ( model.width / 50 )
        , paddingRight  ( model.width / 50 )
        , height ( px ( model.height / 5 ) )
        , width fill ][
        column None
            [][
            row None
                [ paddingTop 10 ][
                column None
                    [ width ( px (footerInnerWidth / 2 ) ) ] [
                    image None 
                        [ paddingTop 10
                        , width (px ( model.width / 20 ) )
                        , height ( px ( model.width / 20 ) )
                        ]{
                            src = "/assets/icon/VITORIA_logo.jpg"
                            , caption = "VITORIA_logo"
                        }
                    ]
                , column None
                    [ width ( px (footerInnerWidth / 2 ) ) ][
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
       [ height ( px ( model.height ) )
        , width ( px ( model.width ) )
        , paddingTop ( model.height / 10 )
        , paddingLeft ( model.width / 1.3 )
        , onClick(
            MenuModalClose
        )] (
        column ModalContentStyle
            [ height fill
            , width ( px ( model.width / 4.6 ) ) 
            , yScrollbar
            , onClickStopPropagation Nothing
            ][
            column None
                [ paddingXY ( model.width / 100 ) ( model.height / 100 ) ][
                button BKWH
                    [ paddingTop ( model.height / 50 )
                    , width fill
                    , onClick (
                        ContentsListChenge
                        )
                    ] (
                    column None --TODO 画像を右寄り、文字は左寄り
                        [][
                        row MenuModalButton
                            [][
                            column None
                                [][
                                el None
                                    [](
                                        Element.text "CONTENTS"
                                    )
                                ]
                            , if model.contentsStatus == Open then
                                column None
                                    [][
                                    image None 
                                        [ width ( px ( model.width / 40 ) )
                                        , height ( px ( model.width / 40 ) )
                                        ]{
                                            src = "/assets/image/Button/minusButton.png"
                                            , caption = "MinusButton"
                                        }
                                    ]
                            else
                                column None
                                    [][
                                    image None 
                                        [ width ( px ( model.width / 40 ) )
                                        , height ( px ( model.width / 40 ) )
                                        ]{
                                            src = "/assets/image/Button/plusButton.png"
                                            , caption = "PlusButton"
                                        }
                                    ]
                            ]
                        , if model.contentsStatus == Open then
                            row MenuModalButton
                                [][
                                column None
                                    [][
                                    row None
                                        [][
                                        el None
                                            [](
                                                Element.text "CONTENTS_01"
                                            )
                                        ]
                                    , row None
                                        [][
                                        el None
                                            [](
                                                Element.text "CONTENTS_02"
                                            )
                                        ]
                                    , row None
                                        [][
                                        el None
                                            [](
                                                Element.text "CONTENTS_03"
                                            )
                                        ]
                                    ]
                                ]
                        else
                            textLayout None [][] 
                        ]
                    )
                , button MenuModalButton
                    [ paddingTop ( model.height / 50 )
                    , width fill ](
                        row None
                            [][
                            column None
                                [][
                                el None
                                    [](
                                        Element.text "会員情報"
                                    )
                                ]
                            , column None
                                [][
                                image None 
                                    [ width ( px ( model.width / 40 ) )
                                    , height ( px ( model.width / 40 ) )
                                    ]{
                                        src = "/assets/image/Button/rightArrow.png"
                                        , caption = "RightArrow"
                                    }
                                ]
                            ]
                    )
                , button MenuModalButton
                    [ paddingTop ( model.height / 50 )
                    , width fill ](
                    row None
                        [][
                        column None
                            [][
                            el None
                                [](
                                    Element.text "CONTACT"
                                )
                            ]
                        , column None
                                [][
                                image None 
                                [ width ( px ( model.width / 40 ) )
                                , height ( px ( model.width / 40 ) )
                                ]{
                                    src = "/assets/image/Button/rightArrow.png"
                                    , caption = "RightArrow"
                                }
                            ]
                        ]
                    )
                ]
            , row None
                [ center
                , paddingTop ( model.height / 5 ) ][
                button ButtonBK
                    [ paddingXY 20 0 ](
                        Element.text "LOGOUT"
                    )
                ]
            ]
        )
    ]

onClickStopPropagation : a -> Attribute variation a
onClickStopPropagation msg =
    stopPropagationOn "click" <| D.succeed ( msg, True )

