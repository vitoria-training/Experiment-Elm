module Page.Wireframe.UserPageAcount.UserPageOtherPattern.UserPage_01 exposing (..)

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
    | CenterPosition
    | OtherPosition
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
        , style CenterPosition
            [ Font.size 20
            , Border.all 2
            , Color.background Color255.white
            ]
        , style OtherPosition
            [ Font.size 15
            , Border.all 2
            , Color.background Color255.white
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
        , view = userPage_01Element
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
    , movieContentsList : List Contentson
    , movieContentsPosition : Int --現在のmovieContents表示位置
    , otherContentsList :  List Contentson
    , otherContentsPosition : Int --現在のotherContents表示位置
    }

type alias Contentson =
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
    | Other

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
    , otherContentsList = 
        [ other_01
        , other_02
        , other_03
        , other_04 ]
    , otherContentsPosition = initPosition }

initPosition : Int
initPosition =
    0

movie_01 : Contentson
movie_01 =
    { index = 0
    , title = "GitCourse"
    , src = "/assets/image/MovieThumbnail/GitCourse/GitCourse_1.jpg"
    , text = "Git講習についての説明文をここに表示。\nテスト用の文言" }

movie_02 : Contentson
movie_02 =
    { index = 1
    , title = "ProgrammingParadigmCourse"
    , src = "/assets/image/MovieThumbnail/ProgrammingParadigmCourse/ProgrammingParadigmCourse_1.jpg"
    , text = "プログラミングパラダイム講習\nについての説明文をここに表示。\nテスト用の文言" }

movie_03 : Contentson
movie_03 =
    { index = 2
    , title = "GameCourse"
    , src = "/assets/image/MovieThumbnail/GameCourse/GameCourse_1.jpg"
    , text = "ゲーム講習についての説明文をここに表示。\nテスト用の文言" }

movie_04 : Contentson
movie_04 =
    { index = 3
    , title = "SystemDesignCourse"
    , src = "/assets/image/MovieThumbnail/SystemDesignCourse/SystemDesignCourse_1.jpg"
    , text = "システムデザイン講習\nについての説明文をここに表示。\nテスト用の文言" }

other_01 : Contentson
other_01 =
    { index = 0
    , title = "GitCourse"
    , src = "/assets/image/MovieThumbnail/GitCourse/GitCourse_1.jpg"
    , text = "String" }

other_02 : Contentson
other_02 =
    { index = 1
    , title = "ProgrammingParadigmCourse"
    , src = "/assets/image/MovieThumbnail/ProgrammingParadigmCourse/ProgrammingParadigmCourse_1.jpg"
    , text = "String" }

other_03 : Contentson
other_03 =
    { index = 2
    , title = "GameCourse"
    , src = "/assets/image/MovieThumbnail/GameCourse/GameCourse_1.jpg"
    , text = "String" }

other_04 : Contentson
other_04 =
    { index = 3
    , title = "SystemDesignCourse"
    , src = "/assets/image/MovieThumbnail/SystemDesignCourse/SystemDesignCourse_1.jpg"
    , text = "String" }

type Msg
    = Nothing
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | MenuModalOpen
    | MenuModalClose
    | ContentsListChenge
    | Scroll ( TypeOfContents, Direction, Int )

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
        
        Scroll ( typeOfContents, direction, contentsPosition ) ->
            ( scroll model ( typeOfContents, direction, contentsPosition ) , Cmd.none )

scroll : Model -> ( TypeOfContents, Direction, Int ) -> Model
scroll model ( typeOfContents, direction, contentsPosition ) =
    case typeOfContents of
        Movie ->
            case direction of
                Left ->
                    if contentsPosition == 0 then
                        { model | movieContentsPosition = List.length( model.movieContentsList ) - 1 }
                    else
                        { model | movieContentsPosition = contentsPosition - 1 }
                Right ->
                    if contentsPosition == ( List.length( model.movieContentsList ) - 1 ) then
                        { model | movieContentsPosition = 0 }
                    else
                        { model | movieContentsPosition = contentsPosition + 1 }
        Other ->
            case direction of
                Left ->
                   if contentsPosition == 0 then
                        { model | otherContentsPosition = List.length( model.otherContentsList ) - 1 }
                    else
                        { model | otherContentsPosition = contentsPosition - 1 }
                Right ->
                     if contentsPosition == ( List.length( model.otherContentsList ) - 1 ) then
                        { model | otherContentsPosition = 0 }
                    else
                        { model | otherContentsPosition = contentsPosition + 1 }
                    
userPage_01Element : Model -> Html Msg
userPage_01Element model=
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
                                moviecontents model
                                , optioncontents model
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

moviecontents : Model -> List (Element Styles variation Msg)
moviecontents model=
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
                setMoviecontents model
            ]
        , row None
            [ center ](
                List.map ( setPosition model.movieContentsPosition model.width ) model.movieContentsList
            )
        ]
    ]

setMoviecontents : Model -> Element Styles variation Msg
setMoviecontents model =
    let
        leftIndex =
            if ( model.movieContentsPosition - 1 ) < 0 then
                List.length(model.movieContentsList) - 1 --TODO リストの最後を取得（リスト長-1が最後：最大値）
            else
                model.movieContentsPosition - 1 --TODO ひとつ前のリスト取得
        centerIndex =
            model.movieContentsPosition

        rightIndex =
            if ( model.movieContentsPosition + 1 ) == List.length(model.movieContentsList) then
                0 --TODO リストの先頭を取得
            else
                model.movieContentsPosition + 1 --TODO ひとつ後のリスト取得
    in
    row TextBox
        [ paddingTop 50 ][
        Element.button ChengeButton
            [ verticalCenter ](
            image None 
                [ width ( px ( model.width / 40 ) )
                , height ( px ( model.width / 40 ) )
                , onClick (
                    Scroll (
                        Movie
                        , Left
                        , centerIndex
                    )
                )
                ]{ 
                src = "/assets/image/Button/Left.png"
                , caption = "button_left"
                }
            )
        , column None
            [](
                List.map ( setLeft model.width model.height leftIndex ) model.movieContentsList
            )
        , column None
            [](
                List.map ( setCenter model.width model.height centerIndex ) model.movieContentsList
            )
        , column None
            [](
                List.map ( setRight model.width model.height rightIndex ) model.movieContentsList
            )
        , Element.button ChengeButton
            [ verticalCenter ](
            image None 
                [ width ( px ( model.width / 40 ) )
                , height ( px ( model.width / 40 ) )
                , onClick (
                    Scroll (
                        Movie
                        , Right
                        , centerIndex
                    )
                )
                ]{ 
                src = "/assets/image/Button/Right.png"
                , caption = "button_right"
                }
            )
        ]

optioncontents : Model -> List (Element Styles variation Msg)
optioncontents model=
    [ column None
        [][
        textLayout None
            [ spacingXY 25 25
            , center ][
                h1 Title
                    [](
                        Element.text "other-contents"
                    )
            ]
        , row None
            [ paddingXY 10 10 ][
                otherContents model
            ]
        , row None
            [ center ](
                List.map ( setPosition model.otherContentsPosition model.width ) model.otherContentsList
            )
        ]
    ]

otherContents : Model -> Element Styles variation Msg
otherContents model =
    let
        leftIndex =
            if ( model.otherContentsPosition - 1 ) < 0 then
                List.length(model.otherContentsList) - 1 --TODO リストの最後を取得（リスト長-1が最後：最大値）
            else
                model.otherContentsPosition - 1 --TODO ひとつ前のリスト取得
        centerIndex =
            model.otherContentsPosition

        rightIndex =
            if ( model.otherContentsPosition + 1 ) == List.length(model.otherContentsList) then
                0 --TODO リストの先頭を取得
            else
                model.otherContentsPosition + 1 --TODO ひとつ後のリスト取得
    in
        row TextBox
            [ paddingTop 50 ][
            Element.button ChengeButton
                [ verticalCenter ](
                image None 
                    [ width ( px ( model.width / 40 ) )
                    , height ( px ( model.width / 40 ) )
                    , onClick (
                        Scroll (
                            Other
                            , Left
                            , centerIndex
                        )
                    )
                    ]{ 
                    src = "/assets/image/Button/Left.png"
                    , caption = "button_left"
                    }
                )
            , column None
                [](
                    List.map ( setLeft model.width model.height leftIndex ) model.otherContentsList
                )
            , column None
                [](
                    List.map ( setCenter model.width model.height centerIndex ) model.otherContentsList
                )
            , column None
                [](
                    List.map ( setRight model.width model.height rightIndex ) model.otherContentsList
                )
            , Element.button ChengeButton
                [ verticalCenter ](
                image None 
                    [ width ( px ( model.width / 40 ) )
                    , height ( px ( model.width / 40 ) )
                    , onClick (
                        Scroll (
                            Other
                            , Right
                            , centerIndex
                        )
                    )
                    ]{
                    src = "/assets/image/Button/Right.png"
                    , caption = "button_right"
                    }
                )
            ]

setLeft : Float -> Float -> Int -> Contentson -> Element Styles variation Msg
setLeft modelWidth modelHeight leftIndex movieContentsList =
    if movieContentsList.index == leftIndex then
        column None
            [ paddingXY 30 50 ][
            Element.button OtherPosition
                [ width ( px ( modelWidth / 5 ) ) ](
                column None
                    [ width ( px ( modelWidth / 5 ) )
                    , center ][
                    row ContentsTitle
                        [][
                        Element.text movieContentsList.title
                        ]
                    , row None
                        [][
                        image None 
                            [ width (px ( modelWidth / 6 ) )
                            , height ( px ( modelHeight / 5 ) )
                            ]{
                            src = movieContentsList.src
                            , caption = movieContentsList.src
                            }
                        ]
                    , row None
                        [ height ( px ( modelHeight / 5 ) ) ][
                        Element.text movieContentsList.text
                        ]
                    ]
                )
            ]
    else
        textLayout None
            [][]
setCenter : Float -> Float -> Int -> Contentson -> Element Styles variation Msg
setCenter modelWidth modelHeight centerIndex movieContentsList =
    if movieContentsList.index == centerIndex then
        column None
            [ paddingXY 20 10 ][
            Element.button CenterPosition
                [ width ( px ( modelWidth / 3 ) ) ](
                column None
                    [ width ( px ( modelWidth / 3 ) )
                    , center ][
                    row ContentsTitle
                        [][
                        Element.text movieContentsList.title
                        ]
                    , row None
                        [][
                        image None
                            [ width (px ( modelWidth / 4 ) )
                            , height ( px ( modelHeight / 3 ) )
                            ]{
                            src = movieContentsList.src
                            , caption = movieContentsList.src
                            }
                        ]
                    , row None
                        [ height ( px ( modelHeight / 5 ) ) ][
                        Element.text movieContentsList.text
                        ]
                    ]
                )
            ]
        else
            textLayout None
                [][]
setRight : Float -> Float -> Int -> Contentson -> Element Styles variation Msg
setRight modelWidth modelHeight rightIndex movieContentsList =
    if movieContentsList.index == rightIndex then
        column None
            [ paddingXY 30 50 ][
            Element.button OtherPosition
                [ width ( px ( modelWidth / 5 ) ) ](
                column None
                    [ width ( px ( modelWidth / 5 ) )
                    , center ][
                    row ContentsTitle
                        [][
                        Element.text movieContentsList.title
                        ]
                    , row None
                        [][
                        image None 
                            [ width (px ( modelWidth / 6 ) )
                            , height ( px ( modelHeight / 5 ) )
                            ]{
                            src = movieContentsList.src
                            , caption = movieContentsList.src
                            }
                        ]
                    , row None
                        [ height ( px ( modelHeight / 5 ) ) ][
                        Element.text movieContentsList.text
                        ]
                    ]
                )
            ]
        else
            textLayout None
                [][]

setPosition : Int -> Float -> Contentson -> Element Styles variation Msg
setPosition position modelWidth contentsList =
    if contentsList.index == position then
        image None 
            [ width ( px ( modelWidth / 40 ) )
            , height ( px ( modelWidth / 40 ) )
            ]{ 
            src = "/assets/image/Button/UserPageOtherPattern/Black.png"
            , caption = "Black"
            }
    else
        image None 
            [ width ( px ( modelWidth / 40 ) )
            , height ( px ( modelWidth / 40 ) )
            ]{ 
            src = "/assets/image/Button/UserPageOtherPattern/Gray.png"
            , caption = "Gray"
            }

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

