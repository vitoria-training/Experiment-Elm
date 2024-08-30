module Color exposing (..)

import Element exposing (Color, rgb255, rgba)


transparent : Color
transparent =
    rgba 0 0 0 0


black : Color
black =
    rgb255 12 15 25


white : Color
white =
    rgb255 242 245 254


gray : Color
gray =
    rgb255 211 215 207


primary : Color
primary =
    rgb255 126 155 254


secondary : Color
secondary =
    rgb255 129 204 228


accent : Color
accent =
    rgb255 254 126 156


bgPrimary : Color
bgPrimary =
    rgb255 242 245 254


loginBg : Color
loginBg =
    rgb255 238 242 109

