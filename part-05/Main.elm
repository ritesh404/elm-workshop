module Main exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)

{-
TODO: 
Create a type alias Model that has the following type: { cards : List Card }
Create a value init : Model
Create the union type Msg with only one constructor: CardClick Card
Create a function view : Model -> Html a that renders a div with our list of cards.
-}


type CardState
    = Open
    | Closed
    | Matched


type alias Card =
    { id : String
    , state : CardState
    }


openCard : Card
openCard =
    { id = "1.jpeg"
    , state = Open
    }


closedCard : Card
closedCard =
    { id = "1.jpeg"
    , state = Closed
    }


matchedCard : Card
matchedCard =
    { id = "1.jpeg"
    , state = Matched
    }


viewCard : Card -> Html a
viewCard card =
    case card.state of
        Open ->
            img
                [ class "open"
                , src ("/assets/" ++ card.id)
                ]
                []

        Closed ->
            img
                [ class "closed"
                , src ("/assets/closed.png")
                ]
                []

        Matched ->
            img
                [ class "matched"
                , src ("/assets/" ++ card.id )
                ]
                []


viewCards : List Card -> Html a
viewCards cards =
    div [] (List.map viewCard cards)


main : Html msg
main =
    div [ class "center" ]
        [ h1 [] [ text "Memory of Thrones!"]
        , div [ id "container" ]
            [ viewCards [ openCard, closedCard, matchedCard ]
            ]
        ]
    
