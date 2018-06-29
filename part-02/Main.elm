module Main exposing (..)

import Html exposing (text)

-- TODO: Add in function type signatures
-- TODO: Output text and quantity

pluralize singular plural quantity =
    if quantity == 1 then
        singular
    else
        plural

main =
    text (pluralize "Mango" "Mangoes" 3)
