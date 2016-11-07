module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App
import Task exposing (..)
import Http exposing (..)
import Project exposing (Project)


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


sourceUrl : String
sourceUrl =
    "http://gsam.ga/projects/api/projects"


type Msg
    = LoadProjects
    | LoadFailure Http.Error
    | LoadSuccess (List Project)


type alias Model =
    { projects : List Project
    }


init : ( Model, Cmd Msg )
init =
    { projects = [] } ! [ fetchProjects LoadSuccess ]


fetchProjects : (List Project -> Msg) -> Cmd Msg
fetchProjects msg =
    Task.perform LoadFailure msg <|
        Http.get Project.decodeList sourceUrl


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadSuccess data ->
            ( { model | projects = data }, Cmd.none )

        LoadFailure httpError ->
            Debug.crash <| toString httpError

        LoadProjects ->
            model ! [ fetchProjects LoadSuccess ]


view : Model -> Html Msg
view model =
    div [ class "blended_grid" ] [ text <| toString model ]
