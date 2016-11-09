module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App
import Task exposing (..)
import Http exposing (..)
import Project exposing (Project, Ptype, Stage)
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
    | LoadStages
    | LoadPTypes
    | LoadFailure Http.Error
    | LoadSuccess (Dict String Project)


type alias Model =
    { projects : Dict String Project
    }


init : ( Model, Cmd Msg )
init =
    { projects = Dict.empty } ! [ fetchProjects LoadSuccess ]



-- { ptypes = Dict.empty } ! [ fetchPtypes LoadSuccess ]
--{ stages = Dict.empty } ! [ fetchStages LoadSuccess ]


fetchProjects : (Dict String Project -> Msg) -> Cmd Msg
fetchProjects msg =
    Task.perform LoadFailure msg <|
        Http.get Project.decodeDict sourceUrl


fetchPtypes : (Dict String Project -> Msg) -> Cmd Msg
fetchPtypes msg =
    Task.perform LoadFailure msg <|
        Http.get Project.decodePtypeDict sourceUrl


fetchStages : (Dict String Project -> Msg) -> Cmd Msg
fetchStages msg =
    Task.perform LoadFailure msg <|
        Http.get Project.decodeStageDict sourceUrl


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadSuccess data ->
            ( { model | projects = data }, Cmd.none )

        LoadFailure httpError ->
            Debug.crash <| toString httpError

        LoadProjects ->
            model ! [ fetchProjects LoadSuccess ]

        LoadStages ->
            model ! [ fetchProjects LoadSuccess ]

        LoadPTypes ->
            model ! [ fetchProjects LoadSuccess ]


renderProjList : Dict String Project -> Html Msg
renderProjList projects =
    div [] <|
        List.map renderProjItem (Dict.values projects)


renderProjItem : Project -> Html Msg
renderProjItem project =
    p [] [ text project.name ]


renderPtypeList : Dict String Ptype -> Html Msg
renderPtypeList ptypes =
    div [] <|
        List.map renderPtypeItem (Dict.values ptypes)


renderPtypeItem : Ptype -> Html Msg
renderPtypeItem ptype =
    p [] [ text ptype.name ]


renderStagesList : Dict String Project -> Html Msg
renderStagesList stages =
    div [] <|
        List.map renderStageItem (Dict.values stages)


renderStageItem : Project -> Html Msg
renderStageItem stages =
    p [] [ text stages.name ]


view : Model -> List (Html Msg)
view model =
  div [][
    div [ class "blended_grid" ] [ renderProjList model.projects ]
div [ class "blended_grid" ] [ renderProjList model.projects ]]
