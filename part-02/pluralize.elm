module Pluralize exposing (..)

import Html exposing (text)

pluralize singular plural quantity =
    if quantity == 1 then
        singular
    else
        plural

main =
    text (pluralize "Mango" "Mangoes" 3)
