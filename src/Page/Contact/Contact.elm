module Page.Contact.Contact exposing (..)

import Task
import Html exposing (..)
import Html.Attributes exposing (..)
import Element exposing (..)
import Element.Input as Input
import Element.Region as Region
import Element.Font as Font
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
        , view = contactElement
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
    , name : String
    , address : String
    , title : String
    , message : String }

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , name = ""
    , address = ""
    , title = ""
    , message = "" }

type Msg
    = NoOp
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | InputName String
    | InputAddress String
    | InputTitle String
    | InputMessage String

-- UPDATE
setCurrentDimensions : { a | width : b, height : c } -> ( b, c ) -> { a | width : b, height : c }
setCurrentDimensions model ( w, h ) =
    { model | width = w, height = h }
setName : { a | name : b } -> b -> { a | name : b }
setName model ( s ) =
    { model | name = s }
setAddress : { a | address : b } -> b -> { a | address : b }
setAddress model ( s ) =
    { model | address = s }
setTitle : { a | title : b } -> b -> { a | title : b }
setTitle model ( s ) =
    { model | title = s }
setMessage : { a | message : b } -> b -> { a | message : b }
setMessage model ( s ) =
    { model | message = s }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotInitialViewport vp ->
            ( setCurrentDimensions model ( vp.scene.width, vp.scene.height ), Cmd.none )

        Resize ( w, h ) ->
            ( setCurrentDimensions model ( w, h ), Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        InputName s ->
            ( setName model ( s ), Cmd.none )
        
        InputAddress s ->
            ( setAddress model ( s ), Cmd.none )
        
        InputTitle s ->
            ( setTitle model ( s ), Cmd.none )
        
        InputMessage s ->
            ( setMessage model ( s ), Cmd.none )

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

headerButoon : { a | width : Float, height : Float } -> { b | x : Int, y : Int } -> String -> Element d
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

-- Contact value
contactFormWidth : Float -> Int
contactFormWidth mainScreenWidth=
    round mainScreenWidth // 12

contactElement : { a | width : Float, height : Float, name : String, address : String, title : String, message : String } -> Html Msg
contactElement model=
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
        in
        layout [ Element.width fill
            , Element.height fill ] <|
            column[ Element.width fill
                , Element.height fill ][
                -- Header
                column [ Element.width fill][
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
                -- Contact
                , column [ Element.width fill
                    , Element.height fill ][
                    row [ centerX
                        , centerY
                        , paddingXY 10 10
                        , Font.size (round model.width // 50)][
                        column [ Element.width fill
                            , Element.height fill
                            , Region.heading 1
                            , Font.semiBold ] [
                            Element.text <| String.toUpper "CONTACT"
                        ]
                    ]
                    , row [ centerX
                        , centerY
                        , paddingXY 10 10 ][
                        Input.text [ Element.width <| px (round model.width // 2)  ]{ 
                            onChange = InputName
                            , text = model.name
                            , placeholder = Nothing
                            , label = Input.labelAbove [] <| Element.text "氏名"
                        }
                    ]
                    , row [ centerX
                        , centerY
                        , paddingXY 10 10 ][
                        Input.text [ Element.width <| px (round model.width // 2) ]{
                            onChange = InputAddress
                            , text = model.address
                            , placeholder = Nothing
                            , label = Input.labelAbove [] <| Element.text "メールアドレス"
                        }
                    ]
                    , row [ centerX
                        , centerY
                        , paddingXY 10 10 ][
                        Input.text [ Element.width <| px (round model.width // 2)  ]{
                            onChange = InputTitle
                            , text = model.title
                            , placeholder = Nothing
                            , label = Input.labelAbove [] <| Element.text "題名"
                        }
                    ]
                    , row [ centerX
                        , centerY
                        , paddingXY 10 10 ][
                        Input.multiline [ Element.width <| px (round model.width // 2) 
                            , Element.height <| px (round model.height // 4)  ]{ 
                            onChange = InputMessage
                            , text = model.message
                            , placeholder = Nothing
                            , label = Input.labelAbove [] <| Element.text "メッセージ本文 (任意)"
                            , spellcheck = False
                        }
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