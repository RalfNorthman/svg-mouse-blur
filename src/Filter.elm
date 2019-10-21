module Filter exposing (blurA, blurB, use)

import Html.Attributes
import TypedSvg exposing (g, svg)
import TypedSvg.Attributes as SvgAttr
import TypedSvg.Core exposing (Attribute, Svg)
import TypedSvg.Filters as Filters
import TypedSvg.Filters.Attributes as FilterAttr
import TypedSvg.Types as SvgType


stdDev : Float -> Attribute msg
stdDev x =
    SvgAttr.stdDeviation <| String.fromFloat x


type alias Filter msg =
    { id : FilterId
    , svg : Svg msg
    }


type FilterId
    = FilterId String


asString : FilterId -> String
asString (FilterId filterId) =
    filterId


type Urlified
    = Urlified String


urlify : FilterId -> Urlified
urlify (FilterId str) =
    let
        s =
            "url(#" ++ str ++ ")"
    in
    Urlified s


use : FilterId -> Attribute msg
use filterId =
    let
        (Urlified url) =
            urlify filterId
    in
    SvgAttr.filter <| SvgType.Filter url


blur : String -> Float -> Filter msg
blur id dev =
    let
        myBlurId : FilterId
        myBlurId =
            FilterId id

        myBlurSvg : Svg msg
        myBlurSvg =
            TypedSvg.filter
                [ Html.Attributes.id <| asString myBlurId ]
                [ Filters.gaussianBlur
                    [ FilterAttr.in_ SvgType.InSourceGraphic
                    , stdDev dev
                    ]
                    []
                ]
    in
    Filter myBlurId myBlurSvg



---- Filters ----


blurA : Float -> Filter msg
blurA amount =
    blur "blurA" amount


blurB : Float -> Filter msg
blurB amount =
    blur "blurB" amount
