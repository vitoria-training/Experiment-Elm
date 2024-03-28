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
        , buttonColorEnable
        , buttonColorHovered
        , buttonColorFocusedAndPlessed
        , buttonColorDisable
        , buttonColorDisableFont
        , button2font
        , button2font2
        , button2border
        , button2border2
        , button2border3
        , button2ColorHovered
        , button2ColorFocusedAndPlessed
        , button2ColorDisable
        , button2ColorDisableFont
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

{-| -}
buttonColorEnable : Color
buttonColorEnable =
    rgba 80 164 98 1.0

{-| -}
buttonColorHovered : Color
buttonColorHovered =
    rgba 94 171 111 1.0

{-| -}
buttonColorFocusedAndPlessed : Color
buttonColorFocusedAndPlessed =
    rgba 101 175 117 1.0

{-| -}
buttonColorDisable : Color
buttonColorDisable =
    rgba 227 227 228 1.0

{-| -}
buttonColorDisableFont : Color
buttonColorDisableFont =
    rgba 152 151 154 1.0

{-| -}
button2font : Color
button2font =
    rgba 124 187 137 1.0

{-| -}
button2font2 : Color
button2font2 =
    rgba 180 179 181 1.0

{-| -}
button2border : Color
button2border =
    rgba 121 116 126 1.0

{-| -}
button2border2 : Color
button2border2 =
    rgba 118 184 132 1.0

{-| -}
button2border3 : Color
button2border3 =
    rgba 235 235 235 1.0

{-| -}
button2ColorHovered : Color
button2ColorHovered =
    rgba 241 248 243 1.0

{-| -}
button2ColorFocusedAndPlessed : Color
button2ColorFocusedAndPlessed =
    rgba 234 244 236 1.0

{-| -}
button2ColorDisable : Color
button2ColorDisable =
    rgba 227 227 228 1.0

{-| -}
button2ColorDisableFont : Color
button2ColorDisableFont =
    rgba 152 151 154 1.0








