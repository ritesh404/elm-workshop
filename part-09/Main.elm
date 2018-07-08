module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

{-
TODOS:

Complete the Game!
All thats left now is to add in the basic logic.
Hint: the flow is as follows
Player opens one card
Player opens second card
if both cards match then both stay open
Player has won when all cards are open. Display a friendly message!

Bonus Points:
Right now the game is quite easy. Add in an element of randomization to spice things up!

-}

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- TYPES


type alias Card =
    { id : String
    , group : Group
    , state : CardState
    }

type alias Deck = List Card

type CardState
    = Open
    | Closed
    | Matched


type GameState 
    = Playing
    | Guessing
    | Win

type Group
    = A
    | B


type alias Model = 
    { state : GameState
    , deck : Deck
    }

type Msg
    = CardClicked Card
    | Reset



-- MODEL


cards : List String
cards =
    List.range 1 10
        |> List.map toString


init : ( Model, Cmd Msg )
init =
    ( {state = Playing, deck = deck}, Cmd.none )


initCard : Group -> String -> Card
initCard group name =
    { id = name
    , group = group
    , state = Closed
    }


deck : Deck
deck =
    let
        groupA =
            List.map (initCard A) cards

        groupB =
            List.map (initCard B) cards
    in
        List.concat [ groupA, groupB ]


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        CardClicked clickedCard ->
            ({ model 
                | deck =
                    List.map
                        (\c ->
                            if c.id == clickedCard.id && c.group == clickedCard.group then
                                (setCard Open clickedCard)
                            else
                                c
                        )
                        model.deck
            }, Cmd.none)
        
        Reset -> init

setCard : CardState -> Card -> Card
setCard state card =
    { card | state = state }



-- VIEW STUFF


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



viewCards : Deck -> Html Msg
viewCards cards =
    div [] (List.map viewCard cards)


gameContainer : Model -> Html Msg
gameContainer model =
    div [ class "center" ]
                [ h1 [] [ text "Memory Game Of Thrones!"]
                , div [ id "container" ]
                    [ viewCards model.deck
                    ]
                ]

view : Model -> Html Msg
view model =
    case model.state of
        Playing ->
            gameContainer model
        Guessing ->
            gameContainer model
        Win ->
            gameContainer model
