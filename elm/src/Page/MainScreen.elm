module Page.MainScreen exposing (..)

import Html exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Browser
import Page.Parts_elm_ui.List as List
import Page.Parts_elm_ui.VideoList as VideoList
import Page.Parts_elm_ui.ContactForm as ContactForm
import Page.Parts_elm_ui.CompanyProfile as CompanyProfile
import Page.Parts_elm_ui.Footer as Footer

main : Program () Model Msg
main = 
    Browser.sandbox
        { init = initialModel
        , view = headerElement
        , update = update
        }
        

-- MODEL

type alias Model =
    {  screenTitle : Screen
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
    { screenTitle = Top
      , listStatus = Close }

type Msg
    = ChangeOpen
    | ChangeClose
    | ChangeTop
    | ChangeContents
    | ChangeAbout
    | ChangeContact

-- UPDATE
update : Msg -> Model -> Model
update msg model =
  case msg of
    ChangeOpen ->
      { model | listStatus = Open}
    ChangeClose ->
      { model | listStatus = Close}
    ChangeTop ->
      { model | screenTitle = Top
      , listStatus = Close}
    ChangeContents ->
      { model | screenTitle = Contents
      , listStatus = Close}
    ChangeAbout ->
      { model | screenTitle = About
      , listStatus = Close}
    ChangeContact ->
      { model | screenTitle = Contact
      , listStatus = Close}


headerElement : Model -> Html Msg
headerElement model =
    let
        contentsList =
            case model.listStatus of
              Open ->
                column [ width <| px 350] [
                    Input.button
                      [ paddingXY 100 10
                      , spacing 10
                      , width <| px 320
                      , height fill
                      , Background.color (rgb255 211 211 211)
                      , Font.color (rgb255 0 0 0)
                      , Font.size 30
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
                      [ paddingXY 100 10
                      , spacing 10
                      , width <| px 320
                      , height fill
                      , Background.color (rgb255 211 211 211)
                      , Font.color (rgb255 0 0 0)
                      , Font.size 30
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
                      Input.button[paddingXY 60 10
                        , spacing 10
                        , width <| px 320
                        , Background.color (rgb255 211 211 211)
                        , Font.color (rgb255 0 0 0)
                        , Font.size 30
                        , centerX
                        , centerY
                        ]
                        { label = Element.text <| "Play Contents"
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
                    Input.button[ paddingXY 50 10
                      , spacing 10
                      , width <| px 160
                      , height fill
                      , Background.color (rgb255 211 211 211)
                      , Font.color (rgb255 0 0 0)
                      , Font.size 30
                      , centerX
                      , centerY
                    ]
                    { label = Element.text <| "Top"
                      , onPress = Just ChangeTop
                    }
                    ]
                    , column [ width <| px 180] [
                      Input.button[ paddingXY 35 10
                        , spacing 10
                        , width <| px 160
                        , height fill
                        , Background.color (rgb255 211 211 211)
                        , Font.color (rgb255 0 0 0)
                        , Font.size 30
                        , centerX
                        , centerY
                        ]
                        { label = Element.text <| "About"
                          , onPress = Just ChangeAbout
                        }
                        ]
                    , contentsList
                    , column [ width <| px 180] [
                      Input.button[ paddingXY 25 10
                        , spacing 10
                        , width <| px 160
                        , height fill
                        , Background.color (rgb255 211 211 211)
                        , Font.color (rgb255 0 0 0)
                        , Font.size 30
                        , centerX
                        , centerY
                        ]
                        { label = Element.text <| "Contact"
                        , onPress = Just ChangeContact
                        }
                    ]
                , column [ width <| px 100] [ ]
             ]
             , row[width fill][
                test
             ]
             , row[width fill][
                column [width fill] [Footer.footerElement]
             ]
          ]
      )