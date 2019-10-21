module Geometry exposing (circles, pointsLeft, pointsRight)

import Axis2d
import Browser
import Circle2d
import Color
import Direction2d
import Filter
import Geometry.Svg as Svg
import Html exposing (Html)
import Pixels exposing (Pixels, pixels)
import Point2d exposing (Point2d)
import TypedSvg exposing (g, svg)
import TypedSvg.Attributes as SvgAttr
import TypedSvg.Core exposing (Attribute, Svg)
import TypedSvg.Types as SvgType


type YDown
    = YDown


myAttributes : List (Attribute msg)
myAttributes =
    [ SvgAttr.fill <| SvgType.Fill Color.darkRed ]


type alias MyPoint =
    Point2d Pixels YDown


type Points3
    = Points3 MyPoint MyPoint MyPoint


pointsLeft : Points3
pointsLeft =
    let
        p1 =
            Point2d.pixels 150 150

        p2 =
            Point2d.pixels 300 150

        p3 =
            Point2d.pixels 225 270
    in
    Points3 p1 p2 p3


circles : Points3 -> List (Attribute msg) -> Svg msg
circles (Points3 p1 p2 p3) attrs =
    let
        p4 =
            Point2d.midpoint p1 p3

        r =
            pixels 60.0

        c1 =
            Circle2d.withRadius r p1

        c2 =
            Circle2d.withRadius r p2

        c3 =
            Maybe.withDefault c1 <|
                Circle2d.throughPoints p1 p2 p3

        c4 =
            p1 |> Circle2d.sweptAround p4
    in
    g (myAttributes ++ attrs) <|
        List.map
            (\( color, circle ) ->
                Svg.circle2d [ SvgAttr.fill <| SvgType.Fill color ] circle
            )
            [ ( Color.darkBlue, c1 )
            , ( Color.darkBlue, c2 )
            , ( Color.darkPurple, c3 )
            , ( Color.darkRed, c4 )
            ]


pointsRight : Points3
pointsRight =
    let
        (Points3 p1 p2 p3) =
            pointsLeft

        pAxis =
            Point2d.pixels 370 0

        axis =
            Axis2d.through pAxis Direction2d.positiveY
    in
    case
        List.map
            (\p -> Point2d.mirrorAcross axis p)
            [ p1, p2, p3 ]
    of
        [ p4, p5, p6 ] ->
            Points3 p4 p5 p6

        _ ->
            pointsLeft
