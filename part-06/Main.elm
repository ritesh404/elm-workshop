module Main exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)

{-
TODOS: 
Add import Html.Events exposing (..)

Add an onClick attribute on closed cards. This should send a CardClick message.
The compiler will now complain about some type signatures. Read the messages and fix accordingly.

Create a helper function setCard : CardState -> Card -> Card.
As you may have guessed, this function should return a new card with the state of the passed card set to the passed CardState.

See the docs on how to update a record.
Create update : Msg -> Model -> Model

Use pattern matching and open the clicked card

Change main to be Html.beginnerProgram { ... }
Read the docs to see what parameters it accepts!
-}

type alias Model =
    { cards : List Card
    }


type Msg
    = CardClicked Card

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


viewCard : Card -> Html Msg
viewCard card =
    case card.state of
        Open ->
            div [ class "card-container open" ]
                [ img [ class "card", src ("/assets/closed.png")] [] 
                , img [ class "card front" , src ("/assets/" ++ card.id ++ ".jpeg")] [] 
                ]

        Closed ->
            div [ class "card-container closed" ]
                [ img [ class "card", src ("/assets/closed.png")] [] 
                , img [ class "card front" , src ("/assets/" ++ card.id ++ ".jpeg")] [] 
                ]

        Matched ->
            div [ class "card-container matched" ]
                [ img [ class "card", src ("/assets/closed.png")] [] 
                , img [ class "card front" , src ("/assets/" ++ card.id ++ ".jpeg")] [] 
                ]



viewCards : List Card -> Html Msg
viewCards cards =
    div [] (List.map viewCard cards)


main : Html Msg
main =
    div [ class "center" ]
        [ h1 [] [ text "Memory Game Of Thrones!"]
        , div [ id "container" ]
            [ viewCards [ openCard, closedCard, matchedCard ]
            ]
        ]
    
