module Page.MovieList.MovieList exposing (..)

import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Element exposing (..)
import Element.Font as Font
import Element.Input as Input
import Element.Background as Background
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E

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
        , view = videoListElement
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
    List Movie
type alias MovieList =
    List Movies

type alias Model =
    { width : Float
    , height : Float
    , movieList : MovieList }

list1 : List { movieTitle : String, movieUrl : String }
list1 =
    [{movieTitle = "git講習 基本コマンド1" , movieUrl = "Js_8xBDhhwE"}
    , {movieTitle = "git講習 基本コマンド2" , movieUrl = "eZ9M16REQiQ"}
    , {movieTitle = "git講習 GitHub_1" , movieUrl = "laz2u--LoTg"}
    ]
list2 : List { movieTitle : String, movieUrl : String }
list2 =
    [ {movieTitle = "git講習 GitHub_2" , movieUrl = "tHZ9yR8I81w"}
    , {movieTitle = "git講習 git内部の仕組み" , movieUrl = "qLyUayBh-T8"}
    , {movieTitle = "ゲーム講習 【初歩編】第1回" , movieUrl = "Ht6R3OosXDk"}
    ]
list3 : List { movieTitle : String, movieUrl : String }
list3 =
    [ {movieTitle = "ゲーム講習 【初歩編】第2回" , movieUrl = "9g-NnkrScng"}
    , {movieTitle = "ゲーム講習 【初歩編】第3回" , movieUrl = "f2SZjtkPF2Q"}
    , {movieTitle = "ゲーム講習 【初歩編】第4回" , movieUrl = "x4wB8ET-57Y"}
    ]

initialModel : { width : number, height : number, movieList : List (List { movieTitle : String, movieUrl : String }) }
initialModel =
    { width = 0
    , height = 0
    , movieList = [ list1, list2, list3]
    }

type Msg
    = NoOp
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

        NoOp ->
            ( model, Cmd.none )

videoframe : String -> Float -> Float -> Html msg
videoframe url mainScreenWidth mainScreenheight=
    iframe
        [ Html.Attributes.width ( videoWindowWidth mainScreenWidth )--560
        , Html.Attributes.height ( videoWindowHeight mainScreenheight )--315
        , src ("https://www.youtube.com/embed/" ++ url)
        , attribute "frameborder" "0"
        , attribute "allowfullscreen" "True"
        ][]
    
chabgeToElement : Html msg -> Element msg
chabgeToElement msg =
    -- Change from Html to Element
    html msg

-- HeaderButoon template
butoonFontSize : Float -> Int
butoonFontSize width=
  round width // 70

topPaddingXY : { x : number, y : number }
topPaddingXY =
  { x = 35
  , y = 70}

aboutPaddingXY : { x : number, y : number }
aboutPaddingXY =
  { x = 50
  , y = 70}

contentsPaddingXY : { x : number, y : number }
contentsPaddingXY =
  { x = 20
  , y = 70}

contactPaddingXY : { x : number, y : number }
contactPaddingXY =
  { x = 60
  , y = 70}

headerButoon : { a | width : Float, height : Float } -> { b | x : Int, y : Int } -> String -> Element c
headerButoon model paddingXYValue label=
  column [ Element.width <| px ( round model.width // 10 )] [
    Input.button[ paddingXY ( round model.width // paddingXYValue.x ) ( round model.height // paddingXYValue.y )
      , spacing ( round model.height // 60 )
      , Element.width <| px ( round model.width // 12 )
      , Element.height fill
      , Background.color ( rgb255 211 211 211 )
      , Font.color ( rgb255 0 0 0 )
      , Font.size ( butoonFontSize model.width )
      , centerX
      , centerY
    ]
    { label = Element.text <| label
      , onPress = Nothing
    }
  ]

-- Video Fixed value
videoTitleFontSize : Float -> Int
videoTitleFontSize mainScreenWidth=
      round mainScreenWidth // 50

videoWindowWidth : Float -> Int
videoWindowWidth mainScreenWidth=
      ( round mainScreenWidth - round mainScreenWidth // 7 ) // 3

videoWindowHeight : Float -> Int
videoWindowHeight mainScreenHeight=
      round mainScreenHeight // 2

-- Footer Fixed value
footerFontSize : Float -> Int
footerFontSize mainScreenWidth =
    round mainScreenWidth // 70

footerHeight : Float -> Int
footerHeight mainScreenHeight =
    round mainScreenHeight // 13

footerPadding : { top : number, left : number, right : number, bottom : number }
footerPadding =
    { top = 0
    , left = 10
    , right = 10
    , bottom = 30 }


videoListElement : { a | width : Float, height : Float, movieList : List (List { b | movieTitle : String, movieUrl : String }) } -> Html msg
videoListElement model=
        let  
            contentsList =
                column [ Element.width <| px ( round model.width // 6 ) ] [
                    Input.button[ paddingXY ( round model.width // contentsPaddingXY.x ) ( round model.height // contentsPaddingXY.y )
                      , spacing ( round model.height // 60 )
                      , Element.width <| px ( round model.width // 6 )
                      , Element.width fill
                      , Background.color ( rgb255 211 211 211 )
                      , Font.color ( rgb255 0 0 0 )
                      , Font.size ( butoonFontSize model.width )
                      , centerX
                      , centerY
                      ]
                    { label = Element.text <| "Contents"
                    , onPress = Nothing
                    }
                ]
            inp movies = 
                column [ Element.width fill ]
                    (List.map assumption movies)
            assumption movieList =
                row [ Element.width fill ][
                    column[ paddingXY ( round model.width // 80 ) ( round model.height // 30 )
                        , spacing 3
                        , centerX
                        , centerY ][
                        row[ Font.size ( videoTitleFontSize model.width ) ][
                            Element.text movieList.movieTitle
                        ]
                        , row[ Background.color ( rgb255 128 128 128 )
                            , Font.color ( rgb255 0 0 0 )
                            , Font.size ( videoTitleFontSize model.width )
                        ][
                            chabgeToElement( videoframe movieList.movieUrl model.width model.height)
                        ]
                    ]
                ]
                       
        in
        layout [ Element.width fill
            , Element.height fill ] <|
            column[ Element.width fill
                , Element.height fill ][
                -- Header
                column[ Element.width fill ][
                    row [ Element.width fill
                        , Element.height <| px ( round model.height // 15 )
                    ][
                        column [ Element.width <| px ( round model.width // 30 ) ] [ 
                        -- Since I want it to be square, I use "height" and "width".
                            Element.image [ Element.width <| px ( round model.width // 40 )
                            , Element.height <| px ( round model.width // 40 )
                            , centerX
                            , centerY ]
                            { src = "../../Picture/elm_logo.png"
                            , description = "elm_logo" }
                        ]
                        , column [ Element.width fill] []
                        , headerButoon model topPaddingXY "Top"
                        , headerButoon model aboutPaddingXY "About"
                        , contentsList
                        , headerButoon model contactPaddingXY "Contact"
                        , column [ Element.width <| px ( round model.width // 100 ) ] [ ]
                    ]
                ]
                -- Video
                , column [ scrollbarY
                    , Element.width fill
                    , Element.height <| px 
                    (round model.height 
                    - round model.height // 15 
                    - round model.height // 13)][
                        column[Element.width fill][
                            row [ Element.width fill ]
                            (List.map inp model.movieList)
                        ]
                ]
                -- Footer
                , column [Element.width fill][
                    row [Element.width fill][
                        el[ Background.color ( rgb255 128 128 128 )
                        , Font.color ( rgb255 0 0 0 )
                        , Font.size ( footerFontSize model.width )
                        , paddingEach footerPadding
                        , Element.width fill
                        , Element.height <| px ( footerHeight model.height )
                        ]
                        ( Element.text 
                        """© 2023 React Inc. All Rights Reserved.\nI'm happy! thank you!""")
                    ]
                ]
            ]
