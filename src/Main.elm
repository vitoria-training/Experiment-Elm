module Main exposing (..)

import Task
import Html exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Page.Contents.PullDownList as PullDownList
import Page.VideoList.VideoList as VideoList
import Page.Contact.ContactForm as ContactForm
import Page.CompanyProfile.CompanyProfile as CompanyProfile
import Page.Footer as Footer
import Page.CommonParts as CP

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
        , view = headerElement
        , update = update
        , subscriptions = subscriptions
        }
        

-- MODEL

type alias Model =
    { width : Float
    , height : Float
    , screenTitle : Screen
    , listStatus : Status }

type Status
    = Open
    | Close

type Screen
    = Top
    | Contents
    | About
    | Contact

initialModel : Model
initialModel =
    { width = 0
    , height = 0
    , screenTitle = Top
    , listStatus = Close }

type Msg
    = NoOp
    | GotInitialViewport Viewport
    | Resize ( Float, Float )
    | ChangeOpen
    | ChangeClose
    | ChangeTop
    | ChangeContents
    | ChangeAbout
    | ChangeContact

subscriptions : model -> Sub Msg
subscriptions _ =
    E.onResize (\w h -> Resize ( toFloat w, toFloat h ))

-- UPDATE
setCurrentDimensions : { a | width : b, height : c } -> ( b, c ) -> { a | width : b, height : c }
setCurrentDimensions model ( w, h ) =
    { model | width = w, height = h }

setChangeListStatus : { a | listStatus : b } -> b -> { a | listStatus : b }
setChangeListStatus model ( status ) =
    { model | listStatus = status }

setChangeScreenAndListStatus : { a | screenTitle : b, listStatus : c } -> ( b, c ) -> { a | screenTitle : b, listStatus : c }
setChangeScreenAndListStatus model ( page, status ) =
    { model | screenTitle = page
            , listStatus = status }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotInitialViewport vp ->
            ( setCurrentDimensions model ( vp.scene.width, vp.scene.height ), Cmd.none )

        Resize ( w, h ) ->
            ( setCurrentDimensions model ( w, h ), Cmd.none )

        NoOp ->
            ( model, Cmd.none )
        
        ChangeOpen ->
            ( setChangeListStatus model ( Open ), Cmd.none )

        ChangeClose ->
            ( setChangeListStatus model ( Close ), Cmd.none )

        ChangeTop ->
            ( setChangeScreenAndListStatus model ( Top, Close ), Cmd.none )

        ChangeContents ->
            ( setChangeScreenAndListStatus model ( Contents, Close ), Cmd.none )

        ChangeAbout ->
            ( setChangeScreenAndListStatus model ( About, Close ), Cmd.none )

        ChangeContact ->
            ( setChangeScreenAndListStatus model ( Contact, Close ), Cmd.none )

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

headerButoon : { a | width : Float, height : Float } -> { b | x : Int, y : Int } -> String -> d -> Element d
headerButoon model paddingXYValue label onPress=
  column [ width <| px ( round model.width // 10 )] [
    Input.button[ paddingXY ( round model.width // paddingXYValue.x ) ( round model.height // paddingXYValue.y )
      , spacing ( round model.height // 60 )
      , width <| px ( round model.width // 12 )
      , height fill
      , Background.color ( CP.rgbLightgray )
      , Font.color ( CP.rgbBlack )
      , Font.size ( butoonFontSize model.width )
      , centerX
      , centerY
    ]
    { label = Element.text <| label
      , onPress = Just onPress
    }
  ]

-- View
headerElement : Model -> Html Msg
headerElement model =
    let
        contentsList =
            case model.listStatus of
              Open ->
                column [ width <| px ( round model.width // 6 ) ] [
                    Input.button[ paddingXY ( round model.width // contentsPaddingXY.x ) ( round model.height // contentsPaddingXY.y )
                      , spacing ( round model.height // 60 )
                      , width <| px ( round model.width // 6 )
                      , height fill
                      , Background.color ( CP.rgbLightgray )
                      , Font.color ( CP.rgbBlack )
                      , Font.size ( butoonFontSize model.width )
                      , centerX
                      , centerY
                      , below ( PullDownList.videolink model.width model.height )
                      ]
                  { label = Element.text <| "Contents"
                      , onPress = Just ChangeClose
                  }
                ]

              Close ->
                column [ width <| px ( round model.width // 6 ) ] [
                    Input.button[ paddingXY ( round model.width // contentsPaddingXY.x ) ( round model.height // contentsPaddingXY.y )
                      , spacing ( round model.height // 60 )
                      , width <| px ( round model.width // 6 )
                      , height fill
                      , Background.color ( CP.rgbLightgray )
                      , Font.color ( CP.rgbBlack )
                      , Font.size ( butoonFontSize model.width )
                      , centerX
                      , centerY
                      ]
                  { label = Element.text <| "Contents"
                      , onPress = Just ChangeOpen
                  }
                ]
        playContents = 
          case model.screenTitle of
            Top -> 
              column [ width fill
                , height <| px ( CP.contentHeight model.height ) ] [
                row [ width fill ][
                  column [ width fill
                    , height  <| px ( round model.height - round model.height // 7 ) ] []
                  , column[][
                    Input.button[ paddingXY ( round model.width // 40 ) ( round model.height // 70 )
                      , spacing ( round model.height // 60 )
                      , width <| px ( round model.width // 7 )
                      , Background.color ( CP.rgbLightgray )
                      , Font.color ( CP.rgbBlack )
                      , Font.size ( butoonFontSize model.width )
                      , centerX
                      , centerY
                    ]
                    { label = Element.text <| "Play Contents!"
                    , onPress = Just ChangeContents
                    }
                  ]
                  , column [ width fill ] []
                ]
              ]
            Contents -> 
              column [ width fill ] [
                VideoList.videoListElement model.width model.height
              ]
            About -> 
              column [ width fill ] [
                CompanyProfile.companyElement model.width model.height
              ]
            Contact ->
              column [ width fill ] [
                ContactForm.contactElement model.width model.height
              ]

    in
      Element.layout [ width fill
                      , height fill ](
          column[ width fill ][
            row [ width fill
              , height <| px ( round model.height // 15 )
              ][
              column [ width <| px ( round model.width // 30 ) ] [ 
              -- Since I want it to be square, I use "height" and "width".
              Element.image [ width <| px ( round model.width // 40 )
                , height <| px ( round model.width // 40 )
                , centerX
                , centerY ]
                { src = "Picture/elm_logo.png"
                  , description = "elm_logo" }
              ]
              , column [ width fill] []
              , headerButoon model topPaddingXY "Top" ChangeTop
              , headerButoon model aboutPaddingXY "About" ChangeAbout
              , contentsList
              , headerButoon model contactPaddingXY "Contact" ChangeContact
              , column [ width <| px ( round model.width // 100 ) ] [ ]
             ]
             , row[ width fill ][
                playContents
             ]
             , row[ width fill ][
                column [ width fill ] [
                  Footer.footerElement model.width model.height
                ]
             ]
          ]
      )
