module Page.Wireframe.UserPageAcount.TopPage.TestPage.TestColor
    exposing
        ( Color
        , rgb
        , rgba
        , greenPt1
        , greenPt2
        , greenPt3
        , greenPt4
        , greenPt5
        , greenPt6
        , clear
        )

{-| -}

import Style exposing (Color)


type alias Color =
    Style.Color


{-| Create RGB colors with an alpha component for transparency.
The alpha component is specified with numbers between 0 and 1.
-}
rgba : Int -> Int -> Int -> Float -> Color
rgba r g b a =
    Style.rgba
        (toFloat r / 255)
        (toFloat g / 255)
        (toFloat b / 255)
        a


{-| Create RGB colors from numbers between 0 and 255 inclusive.
-}
rgb : Int -> Int -> Int -> Color
rgb r g b =
    Style.rgb
        (toFloat r / 255)
        (toFloat g / 255)
        (toFloat b / 255)



-- {-| Extract the components of a color in the RGB format.
-- -}
-- toRgb : Color -> { red : Int, green : Int, blue : Int, alpha : Float }
-- toRgb color =
--     case color of
--         RGBA r g b a ->
--             { red = r, green = g, blue = b, alpha = a }
-- BUILT-IN COLORS


{-| -}
greenPt1 : Color
greenPt1 =
    rgba 181 217 175 1


{-| -}
greenPt2 : Color
greenPt2 =
    rgba 208 244 202 1

{-| -}
greenPt3 : Color
greenPt3 =
    rgba 208 244 202 0.5

{-| -}
greenPt4 : Color
greenPt4 =
    rgba 208 244 202 0.0

{-| -}
greenPt5 : Color
greenPt5 =
    rgba 138 226 52 0.8

{-| -}
greenPt6 : Color
greenPt6 =
    rgba 138 226 52 1.0

{-| -}
clear : Color
clear =
    rgba 255 255 255 0.7