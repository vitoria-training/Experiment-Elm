module Types exposing (..)

import Animator
import Browser
import Browser.Dom exposing (Viewport)
import Browser.Navigation
import Element exposing (Device)
import ScrollTo
import Time
import Url
import Url.Builder
import Url.Parser


type Page
    = Home
    | Service
    | Contact
    | NotFound


urlParser : Url.Parser.Parser (Page -> a) a
urlParser =
    Url.Parser.oneOf
        [ Url.Parser.map Home Url.Parser.top
        , Url.Parser.map Service (Url.Parser.s "service")
        , Url.Parser.map Contact (Url.Parser.s "contact")
        ]


pageToUrl : Page -> String
pageToUrl page =
    case page of
        Home ->
            Url.Builder.absolute [] []

        Service ->
            Url.Builder.absolute [ "service" ] []

        Contact ->
            Url.Builder.absolute [ "contact" ] []

        NotFound ->
            Url.Builder.absolute [ "notfound" ] []


toNewPage : Url.Url -> Model -> Model
toNewPage url model =
    let
        newPage =
            Url.Parser.parse urlParser url
                |> Maybe.withDefault NotFound
    in
    { model
        | page =
            model.page
                -- full page animations involve moving some large stuff.
                -- in that case using a slower duration than normal is a good place to start.
                |> Animator.go Animator.verySlowly newPage
    }


type Https
    = Https String -- TODO replace with URL lib. https://package.elm-lang.org/packages/elm/url/latest/


type Path
    = Path String -- TODO replace with Path module. check examples/URLParser.elm


type Menu
    = Wrapped
    | Unwrapped


type alias Model =
    { device : Device
    , viewport_ : Viewport
    , menu : Menu
    , transition : Animator.Timeline Menu
    , page : Animator.Timeline Page
    , scrollTo : ScrollTo.State
    , scrollY : Int
    , navKey : Browser.Navigation.Key
    , headerVisibility : Animator.Timeline Bool
    , throttleCounter : Int
    }


type Msg
    = DeviceClassified Device Viewport
    | GotInitialViewport Viewport
    | Resize Device Viewport Menu (Animator.Timeline Menu)
    | ScrollToMsg ScrollTo.Msg
    | ScrollToId String
    | UserPressedMenu Menu
    | ChangeHeaderVisibility Bool
    | ChangeHeaderVisibilityByScroll Int
    | Tick Time.Posix
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOp
