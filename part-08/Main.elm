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

type GameState
    = Choosing Deck
    | Matching Deck Card
    | GameOver


type alias Model =
    { cards : List Card
    }


type Msg
    = CardClicked Card
    | DeckGenerated Deck
    | RestartGame

type CardState
    = Open
    | Closed
    | Matched

type Group
    = A
    | B

type alias Card =
    { id : String
    , group : Group
    , state : CardState
    }

type alias Deck =
    List Card

setCard : CardState -> Card -> Card
setCard state card =
    { card | state = state }


isMatching : Card -> Card -> Bool
isMatching c1 c2 =
    c1.id == c2.id && c1.group /= c2.group


closeUnmatched : Deck -> Deck
closeUnmatched deck =
    List.map
        (\c ->
            if c.state /= Matched then
                { c | state = Closed }
            else
                c
        )
        deck


allMatched : Deck -> Bool
allMatched deck =
    List.all (\c -> c.state == Matched) deck


updateCardClick : Card -> GameState -> GameState
updateCardClick clickedCard game =
    case game of
        Choosing deck ->
            let
                updatedDeck =
                    deck
                        |> closeUnmatched
                        |> setCard Open clickedCard
            in
                Matching updatedDeck clickedCard

        Matching deck openCard ->
            let
                updatedDeck =
                    if isMatching clickedCard openCard then
                        deck
                            |> setCard Matched clickedCard
                            |> setCard Matched openCard
                    else
                        setCard Open clickedCard deck
            in
                if allMatched updatedDeck then
                    GameOver
                else
                    Choosing updatedDeck

        GameOver ->
            game


update : Msg -> Model -> Model
update msg model =
    case msg of
        CardClicked card ->
            { model | game = updateCardClick card model.game }

        RestartGame ->
            init

init : Model
init =
    { game = Choosing GameGenerator.staticDeck }


viewCard : Card -> Html Msg
viewCard card =
    case card.state of
        Open ->
            img
                [ class "open"
                , src ("/assets/" ++ card.id )
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
                , src ("/assets/" ++ card.id )
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
