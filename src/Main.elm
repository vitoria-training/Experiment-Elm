port module Main exposing (main)

import Animator exposing (Animator)
import Browser
import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onResize)
import Browser.Navigation as Nav
import Element exposing (classifyDevice)
import ScrollTo
import Task
import Types exposing (..)
import Url
import Url.Parser
import View exposing (..)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- PORT


port receiveScroll : (Int -> msg) -> Sub msg



-- INIT


animator : Animator Model
animator =
    Animator.animator
        |> Animator.watchingWith
            .transition
            (\newState model -> { model | transition = newState })
            (\state -> state == Wrapped)
        |> Animator.watching
            .page
            (\newPage model -> { model | page = newPage })
        |> Animator.watchingWith
            .headerVisibility
            (\newState model -> { model | headerVisibility = newState })
            (\state -> state == False)


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        initialPage =
            Url.Parser.parse urlParser url
                |> Maybe.withDefault NotFound

        device =
            classifyDevice { width = 0, height = 0 }

        vp =
            { scene = { width = 0, height = 0 }
            , viewport = { x = 0, y = 0, width = 0, height = 0 }
            }

        handleResult v =
            case v of
                Err _ ->
                    DeviceClassified device vp

                Ok vp_ ->
                    GotInitialViewport vp_
    in
    ( { device = device
      , viewport_ = vp
      , menu = Wrapped
      , transition = Animator.init Wrapped
      , page = Animator.init initialPage
      , scrollTo = ScrollTo.init
      , scrollY = 0
      , navKey = key
      , headerVisibility = Animator.init True
      , throttleCounter = 0
      }
    , Task.attempt handleResult getViewport
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        scrollMove =
            if model.throttleCounter == 0 then
                receiveScroll ChangeHeaderVisibilityByScroll

            else
                Sub.none

        newViewport width_ height_ =
            { scene = model.viewport_.scene
            , viewport =
                { x = model.viewport_.viewport.x
                , y = model.viewport_.viewport.y
                , width = toFloat width_
                , height = toFloat height_
                }
            }
    in
    Sub.batch
        [ onResize <|
            \width height ->
                Resize
                    (classifyDevice { width = width, height = height })
                    (newViewport width height)
                    Wrapped
                    (Animator.init Wrapped)
        , Sub.map ScrollToMsg <|
            ScrollTo.subscriptions model.scrollTo
        , Animator.toSubscription Tick model animator
        , scrollMove
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        duration =
            Animator.millis 400
    in
    case msg of
        DeviceClassified device vp ->
            ( { model
                | device = device
                , viewport_ = vp
              }
            , Cmd.none
            )

        GotInitialViewport vp ->
            ( { model
                | device =
                    classifyDevice
                        { width = round vp.viewport.width
                        , height = round vp.viewport.height
                        }
                , viewport_ = vp
              }
            , Cmd.none
            )

        Resize device vp menuState state ->
            ( { model
                | device = device
                , viewport_ = vp
                , menu = menuState
                , transition = state
              }
            , Cmd.none
            )

        ScrollToMsg scrollToMsg ->
            let
                ( scrollToModel, scrollToCmds ) =
                    ScrollTo.update
                        scrollToMsg
                        model.scrollTo
            in
            ( { model | scrollTo = scrollToModel }
            , Cmd.map ScrollToMsg scrollToCmds
            )

        ScrollToId id ->
            ( model
            , Cmd.map ScrollToMsg <|
                ScrollTo.scrollTo id
            )

        UserPressedMenu menuState ->
            ( { model
                | menu = menuState
                , transition =
                    model.transition |> Animator.go duration menuState
              }
            , Cmd.none
            )

        ChangeHeaderVisibility state ->
            ( { model
                | headerVisibility =
                    model.headerVisibility |> Animator.go duration state
              }
            , Cmd.none
            )

        ChangeHeaderVisibilityByScroll posY ->
            let
                msg_ =
                    if posY == model.scrollY then
                        NoOp

                    else if posY > model.scrollY && posY > 500 then
                        ChangeHeaderVisibility False

                    else
                        ChangeHeaderVisibility True
            in
            ( { model | scrollY = posY }
            , Task.perform (always msg_) (Task.succeed ())
            )

        Tick newTime ->
            let
                newModel =
                    Animator.update newTime animator model

                count =
                    if model.throttleCounter == 10 then
                        0

                    else
                        model.throttleCounter + 1
            in
            ( { newModel | throttleCounter = count }, Cmd.none )

        LinkClicked request ->
            case request of
                Browser.Internal url ->
                    ( toNewPage url model
                    , Nav.pushUrl model.navKey (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            -- This should be te only place we need to use `toNewPage`
            ( toNewPage url model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
