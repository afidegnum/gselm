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


type ApiEndpoint
    = ProjectsEndpoint
    | TypesEndpoint
    | StagesEndpoint


endpointToUrl : ApiEndpoint -> String
endpointToUrl endpoint =
    let
        baseUrl =
            "http://gsam.ga:9191/projects/api/"
    in
        baseUrl
            ++ case endpoint of
                ProjectsEndpoint ->
                    "projects"

                TypesEndpoint ->
                    "types"

                StagesEndpoint ->
                    "stages"


type Msg
    = LoadProjects
    | LoadStages
    | LoadPTypes
    | LoadFailure Http.Error
    | LoadPSuccess (Dict String Project)
    | LoadTSuccess (Dict String Ptype)
    | LoadSSuccess (Dict String Stage)


type alias Model =
    { projects : Dict String Project
    , ptypes : Dict String Project
    , stages : Dict String Project
    }


init : ( Model, Cmd Msg )
init =
    { projects = Dict.empty, ptypes = Dict.empty, stages = Dict.empty } ! [ fetchProjects LoadPSuccess, fetchPtypes LoadTSuccess, fetchStages LoadSSuccess ]



-- { ptypes = Dict.empty } ! [ fetchPtypes LoadSuccess ]
--{ stages = Dict.empty } ! [ fetchStages LoadSuccess ]


fetchProjects : (Dict String Project -> Msg) -> Cmd Msg
fetchProjects msg =
    Task.perform LoadFailure msg <|
        Http.get Project.decodeDict (endpointToUrl ProjectsEndpoint)


fetchPtypes : (Dict String Ptype -> Msg) -> Cmd Msg
fetchPtypes msg =
    Task.perform LoadFailure msg <|
        Http.get Project.decodePtypeDict (endpointToUrl TypesEndpoint)


fetchStages : (Dict String Stage -> Msg) -> Cmd Msg
fetchStages msg =
    Task.perform LoadFailure msg <|
        Http.get Project.decodeStageDict (endpointToUrl StagesEndpoint)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadPSuccess data ->
            ( { model | projects = data }, Cmd.none )

        LoadTSuccess data ->
            ( { model | ptypes = data }, Cmd.none )

        LoadSSuccess data ->
            ( { model | stages = data }, Cmd.none )

        LoadFailure httpError ->
            Debug.crash <| toString httpError

        LoadProjects ->
            model ! [ fetchProjects LoadPSuccess ]

        LoadStages ->
            model ! [ fetchStages LoadTSuccess ]

        LoadPTypes ->
            model ! [ fetchPtypes LoadSSuccess ]


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


renderStagesList : Dict String Stage -> Html Msg
renderStagesList stages =
    div [] <|
        List.map renderStageItem (Dict.values stages)


renderStageItem : Project -> Html Msg
renderStageItem stages =
    p [] [ text stages.name ]


view : Model -> Html Msg
view model =
    div []
        [ div [ class "blended_grid" ] [ renderProjList model.projects ]
        , div [ class "blended_grid" ] [ renderPtypeList model.ptypes ]
        , div [ class "blended_grid" ] [ renderStagesList model.stages ]
        ]
