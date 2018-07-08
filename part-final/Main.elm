module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Random


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
    | Guessing Card
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
    | Shuffle (List Int)


-- MODEL


cards : List String
cards =
    List.range 1 10
        |> List.map toString


init : ( Model, Cmd Msg )
init =
    ( {state = Playing, deck = deck}, randomList Shuffle (List.length deck) )


initCard : Group -> String -> Card
initCard group id =
    { id = id
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

randomList : (List Int -> Msg) -> Int -> Cmd Msg
randomList msg len =
    Random.int 0 100
        |> Random.list len
        |> Random.generate msg

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
                
        Shuffle listOfInts ->
            ({model | deck = shuffleDeck model.deck listOfInts }, Cmd.none)

        
        Reset -> init


shuffleDeck : Deck -> List Int -> Deck
shuffleDeck deck randomInts =
    List.map2 (,) deck randomInts
        |> List.sortBy Tuple.second
        |> List.map Tuple.first

isGameOver : Deck -> Bool
isGameOver =
    List.all (\c -> c.state == Matched ) 

setCard : CardState -> Card -> Card
setCard state card =
    { card | state = state }

setCardInDeck :  CardState -> Card -> Deck -> Deck
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
        Win ->
            div [ class "gameover"] 
                [ span [class "you-won"] [text "You Won!"]
                , gameContainer model ]
        _ ->
            gameContainer model
