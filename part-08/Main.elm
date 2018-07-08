module Main exposing(..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

{-
TODOS: 

Create a type alias called deck that represents our list of playing cards

Create a union type that describes the current gamestate. For example the current state of the game
can be one of Playing (Player have selected no cards), 
Guessing (Player has selected one card and is guessing the second one) or Won (When all cards are open)!

Update the model to hold the current deck and the gamestate
and create a function init that will hold the initial model or state of the game

Add a Reset message which when received on update should reset the game state


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

type CardState
    = Open
    | Closed
    | Matched


type Group
    = A
    | B


type alias Model =
    { cards : List Card
    }

type Msg
    = CardClicked Card



-- MODEL

cards : List String
cards =
    List.range 1 10
        |> List.map toString


init : ( Model, Cmd Msg )
init =
    ( {cards = deck}, Cmd.none )


initCard : Group -> String -> Card
initCard group name =
    { id = name
    , group = group
    , state = Closed
    }


deck : List Card
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
                | cards =
                    List.map
                        (\c ->
                            if c.id == clickedCard.id && c.group == clickedCard.group then
                                (setCard Open clickedCard)
                            else
                                c
                        )
                        model.cards
            }, Cmd.none)

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
