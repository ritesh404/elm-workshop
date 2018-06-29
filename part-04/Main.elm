module Main exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)

{-
TODO 1: Create a union type called CardState that can be either Open, Closed or Matched 
(constructor functions are always capitalized).
Enrich our previous card record with a field called state that carries a CardState value. 
You will also have to update the signature of viewCard.
-}

{-
TODO 2: Create a type alias called Card that describes our card record.
Use this new type in the signatures of viewCard and card.
-}

{-
TODO 3: Update viewCard to display differently based on the card's state
Create cards : List Card
Create viewCards : List Card -> Html a - the cards should be placed in a div with the class cards
Call viewCards from main
-}

card : { id : String }
card =
    { id = "1.jpeg"
    }


viewCard : { id : String } -> Html a
viewCard card =
    div []
        [ img [ src "/assets/closed.png" ] []
        ]

main : Html msg
main =
    div [ class "center" ]
        [ h1 [] [ text "Memory of Thrones!"]
        , div [ id "container" ]
            [ viewCard card ]
        ]
    
