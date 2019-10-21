module Main exposing (main)

import Axis2d
import Browser
import Circle2d
import Color
import Direction2d
import Filter
import Geometry
import Geometry.Svg as Svg
import Html exposing (Html)
import Html.Events.Extra.Mouse as Mouse
import Pixels exposing (Pixels, pixels)
import Point2d exposing (Point2d)
import TypedSvg exposing (g, svg)
import TypedSvg.Attributes as SvgAttr
import TypedSvg.Core exposing (Attribute, Svg)
import TypedSvg.Types as SvgType



---- MODEL ----


type alias Model =
    ( Float, Float )


init : ( Model, Cmd Msg )
init =
    ( ( 0, 0 ), Cmd.none )



---- UPDATE ----


type Msg
    = MouseMove Model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMove clientPosition ->
            ( clientPosition, Cmd.none )


rootAttributes : List (Attribute Msg)
rootAttributes =
    [ SvgAttr.height <| SvgType.px 1000
    , SvgAttr.width <| SvgType.px 1000
    , Mouse.onMove (\event -> MouseMove event.clientPos)
    ]



---- VIEW ----


view : Model -> Html Msg
view ( x, y ) =
    let
        blurLeft =
            Filter.blurA (x / 50)

        blurRight =
            Filter.blurB (y / 50)
    in
    svg rootAttributes <|
        [ blurLeft.svg
        , blurRight.svg
        , Geometry.circles Geometry.pointsLeft [ Filter.use blurLeft.id ]
        , Geometry.circles Geometry.pointsRight [ Filter.use blurRight.id ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
