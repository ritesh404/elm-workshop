module Main exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

{-
TODOS: 
Create a type alias for our deck of cards.
Create a union type for representing the group of a card.
Add group as a field in our Card type
-}

{-
TODOS: 
Move all types and type aliases to the file Model.elm
A module's name must match it's file name, so in our case Model.elm should start with module Model exposing (..)
To use our types in Main.elm we also need to import them. 
This is done in the same way as we import the Html module; import Html exposing (..)
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
            img
                [ class "open"
                , src ("/assets/" ++ card.id)
                ]
                []

        Closed ->
            img
                [ class "closed"
                , onClick (CardClicked card)
                , src ("/assets/closed.png")
                ]
                []

        Matched ->
            img
                [ class "matched"
                , src ("/assets/" ++ card.id)
                ]
                []


viewCards : List Card -> Html Msg
viewCards cards =
    div [] (List.map viewCard cards)


view : Model -> Html Msg
view model =
    div [ class "center" ]
        [ h1 [] [ text "Memory of Thrones!"]
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
