module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

{-
Lets play!
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


type GameState 
    = Playing
    | Guessing Card
    | Win

type Group
    = A
    | B


type alias Model = 
    { state : GameState
    , deck : List Card
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
            case model.state of
                Playing ->
                    ({ model 
                        | deck =
                            setCardInDeck Open clickedCard model.deck
                        , state = Guessing clickedCard
                    }, Cmd.none)

                Guessing card ->
                    if card.id == clickedCard.id && card.group /= clickedCard.group then
                        let
                            newDeck = setCardInDeck Matched clickedCard model.deck
                                    |> setCardInDeck Matched card
                        in
                            
                        ({ model 
                            | deck = newDeck    
                            , state = 
                                case isGameOver newDeck of
                                    True -> Win
                                    _ -> Playing 
                        }, Cmd.none)
                    else
                        ({ model 
                            | deck =
                                setCardInDeck Closed card model.deck
                            , state = Playing
                        }, Cmd.none)
                
                Win ->
                    (model, Cmd.none)

        
        Reset -> init


isGameOver : List Card -> Bool
isGameOver =
    List.all (\c -> c.state == Matched ) 

setCard : CardState -> Card -> Card
setCard state card =
    { card | state = state }

setCardInDeck :  CardState -> Card -> List Card -> List Card
setCardInDeck state card deck =
    List.map
        (\c ->
            if c.id == card.id && c.group == card.group then
                (setCard state card)
            else
                c
        )
        deck

-- VIEW STUFF


viewCard : Card -> Html Msg
viewCard card =
    case card.state of
        Open ->
            img
                [ class "open"
                , src ("/assets/" ++ card.id ++ ".jpeg")
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
                , src ("/assets/" ++ card.id ++ ".jpeg")
                ]
                []


viewCards : List Card -> Html Msg
viewCards cards =
    div [] (List.map viewCard cards)


gameContainer : Model -> Html Msg
gameContainer model =
    div [ class "center" ]
                [ h1 [] [ text "Memory of Thrones!"]
                , div [ id "container" ]
                    [ viewCards model.deck
                    ]
                ]

view : Model -> Html Msg
view model =
    case model.state of
        Win ->
            div [ class "gameover"] 
                [ span [class "you-won"] [text "You Won!"]
                , gameContainer model ]
        _ ->
            gameContainer model
