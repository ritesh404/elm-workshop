module Main exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)

{- 
Lets show some cards on our page!
TODO1:  Create an Elm record "card" with the type { id : String }. Use id = "1" for the initial value. 
 This id string will refer to the file name of the image our card will be hiding.
-}
{-
TODO 2: Write the function viewCard: { id: String } -> Html a, which should output the HTML for a card
-}

main : Html msg
main =
    div [ class "center" ]
        [ h1 [] [ text "Memory Game Of Thrones!"]
        , div [ id "container" ]
            [ img [ src "assets/closed.jpeg" ] [] ]
        ]
    
