module Main exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

{-
TODOS: 
Create a union type for representing the group of a card.

Add group as a field in our Card type

Create a function `cards` that will hold all the cards

Create a function `deck` that will create our playing deck
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

setCard : CardState -> Card -> Card
setCard state card =
    { card | state = state }


update : Msg -> Model -> Model
update msg model =
    case msg of
        CardClicked clickedCard ->
            { cards =
                List.map
                    (\c ->
                        if c.id == clickedCard.id then
                            (setCard Open clickedCard)
                        else
                            c
                    )
                    model.cards
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
            div [ class "card-container closed", onClick (CardClicked card) ]
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


view : Model -> Html Msg
view model =
    div [ class "center" ]
        [ h1 [] [ text "Memory Game Of Thrones!"]
        , div [ id "container" ]
            [ viewCards model.cards
            ]
        ]
    

main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = { cards = [ openCard, closedCard, matchedCard ] }
        , view = view
        , update = update
        }
