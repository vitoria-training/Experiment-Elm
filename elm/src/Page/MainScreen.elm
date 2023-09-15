module Page.MainScreen exposing (..)

import Task
import Html exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Events as E
import Page.Parts_elm_ui.List as List
import Page.Parts_elm_ui.VideoList as VideoList
import Page.Parts_elm_ui.ContactForm as ContactForm
import Page.Parts_elm_ui.CompanyProfile as CompanyProfile
import Page.Parts_elm_ui.Footer as Footer

main : Program () Model Msg
main =
    let
        handleResult v =
            case v of
                Err err ->
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
            , listStatus = status}

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


headerElement : Model -> Html Msg
headerElement model =
    let
        contentsList =
            case model.listStatus of
              Open ->
                column [ width <| px 350] [
                    Input.button
                      [ paddingXY 100 (round model.height // 60)
                      , spacing (round model.height // 60)
                      , width <| px (round model.width // 6)
                      , height fill
                      , Background.color (rgb255 211 211 211)
                      , Font.color (rgb255 0 0 0)
                      , Font.size (round model.width // 60)
                      , centerX
                      , centerY
                      , below List.videolink
                      ]
                  { label = Element.text <| "Contents"
                      , onPress = Just ChangeClose
                  }
                ]

              Close ->
                column [ width <| px 350] [
                    Input.button
                      [ paddingXY 100 (round model.height // 60)
                      , spacing (round model.height // 60)
                      , width <| px (round model.width // 6)
                      , height fill
                      , Background.color (rgb255 211 211 211)
                      , Font.color (rgb255 0 0 0)
                      , Font.size (round model.width // 60)
                      , centerX
                      , centerY
                      ]
                  { label = Element.text <| "Contents"
                      , onPress = Just ChangeOpen
                  }
                ]
        test = 
          case model.screenTitle of
            Top -> 
              column [width fill] [
                row [width fill][
                  column [ width fill
                    , height  <| px 840] []
                    , column[][
                      Input.button[paddingXY (round model.width // 70) (round model.height // 60)
                        , spacing (round model.height // 60)
                        , width <| px (round model.width // 7)
                        , Background.color (rgb255 211 211 211)
                        , Font.color (rgb255 0 0 0)
                        , Font.size (round model.width // 60)
                        , centerX
                        , centerY
                        ]
                        { label = Element.text <| "Play Contents!"
                          , onPress = Just ChangeContents
                          }
                    ]
                  , column [ width fill] []
                ]
              ]
            Contents -> 
              column [width fill] [VideoList.videoListElement]
            About -> 
              column [width fill] [CompanyProfile.companyElement]
            Contact ->
              column [width fill] [ContactForm.contactElement]

    in
      Element.layout [height
        (fill
            |> minimum 300
            |> maximum 300
        )](
          column[width fill][
            row [ width fill
              , height <| px 60
              ]
            [ column [ width <| px 60] [ 
              Element.image [width <| px 50
                , height <| px 50
                , centerX
                , centerY]
                { src = "../page/Parts_elm_ui/elm_logo.png"
                  , description = "elm_logo"}
                  ]
                  , column [ width fill] []
                  , column [ width <| px 180] [
                    Input.button[ paddingXY 50 (round model.height // 60)
                      , spacing (round model.height // 60)
                      , width <| px (round model.width // 12)
                      , height fill
                      , Background.color (rgb255 211 211 211)
                      , Font.color (rgb255 0 0 0)
                      , Font.size (round model.width // 60)
                      , centerX
                      , centerY
                    ]
                    { label = Element.text <| "Top"
                      , onPress = Just ChangeTop
                    }
                    ]
                    , column [ width <| px 180] [
                      Input.button[ paddingXY 35 (round model.height // 60)
                        , spacing (round model.height // 60)
                        , width <| px (round model.width // 12)
                        , height fill
                        , Background.color (rgb255 211 211 211)
                        , Font.color (rgb255 0 0 0)
                        , Font.size (round model.width // 60)
                        , centerX
                        , centerY
                        ]
                        { label = Element.text <| "About"
                          , onPress = Just ChangeAbout
                        }
                        ]
                    , contentsList
                    , column [ width <| px 180] [
                      Input.button[ paddingXY 25 (round model.height // 60)
                        , spacing (round model.height // 60)
                        , width <| px (round model.width // 12)
                        , height fill
                        , Background.color (rgb255 211 211 211)
                        , Font.color (rgb255 0 0 0)
                        , Font.size (round model.width // 60)
                        , centerX
                        , centerY
                        ]
                        { label = Element.text <| "Contact"
                        , onPress = Just ChangeContact
                        }
                    ]
                , column [ width <| px (round model.height // 20)] [ ]
             ]
             , row[width fill][
                test
             ]
             , row[width fill][
                column [width fill] [Footer.footerElement]
             ]
          ]
      )