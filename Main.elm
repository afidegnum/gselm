module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App
import Task exposing (..)
import Http exposing (..)
import Project exposing (Project)
import Dict exposing (Dict)


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
    "http://gsam.ga:9191/projects/api/projects"


type Msg
    = LoadProjects
    | LoadFailure Http.Error
    | LoadSuccess (Dict String Project)


type alias Model =
    { projects : Dict String Project
    }


init : ( Model, Cmd Msg )
init =
    { projects = Dict.empty } ! [ fetchProjects LoadSuccess ]


fetchProjects : (Dict String Project -> Msg) -> Cmd Msg
fetchProjects msg =
    Task.perform LoadFailure msg <|
        Http.get Project.decodeDict sourceUrl


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadSuccess data ->
            ( { model | projects = data }, Cmd.none )

        LoadFailure httpError ->
            Debug.crash <| toString httpError

        LoadProjects ->
            model ! [ fetchProjects LoadSuccess ]


renderMenu : Dict String Project -> Html Msg
renderMenu projects =
    div [] <|
        List.map renderMenuItem (Dict.values projects)


renderMenuItem : Project -> Html Msg
renderMenuItem project =
    p [] [ text project.name ]


view : Model -> Html Msg
view model =
    div [ class "blended_grid" ] [ renderMenu model.projects ]
