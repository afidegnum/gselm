module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App
import Task exposing (..)
import Http exposing (..)
import Project exposing (Project, Ptype, Stage)
import Html.Events exposing (onClick)
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
    | SwitchTo
    | LoadPTypes
    | LoadFailure Http.Error
    | LoadPSuccess (Dict String Project)
    | LoadTSuccess (Dict String Ptype)
    | LoadSSuccess (Dict String Stage)


type alias Model =
    { projects : Dict String Project
    , ptypes : Dict String Ptype
    , stages : Dict String Stage
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


renderProjList : Project -> Dict String Ptype -> Html Msg
renderProjList projects ptypes =
    div [ buildStyle [ mainRow ] ] <|
        [ (renderProjItem projects ptypes) ]


renderProjItem : Project -> Dict String Ptype -> Html Msg
renderProjItem project ptypes =
    div []
        [ text project.name
        , (renderPtypeList ptypes)
        ]


type alias TypeKey =
    { key : String
    , name : String
    }


radio : msg -> String -> String -> Html msg
radio msg name key =
    label []
        [ input [ type' "radio", onClick msg, id key ] []
        , text name
        ]


renderPtypeList : Dict String Ptype -> Html Msg
renderPtypeList ptypes =
    fieldset [ buildStyle [ mainRow ] ] <|
        List.map renderPtypeItem (Dict.values ptypes)


renderPtypeItem : Ptype -> Html Msg
renderPtypeItem ptype =
    radio SwitchTo ptype.name ptype.key


renderStagesList : Dict String Stage -> Html Msg
renderStagesList stages =
    div [] <|
        List.map renderStageItem (Dict.values stages)


renderStageItem : Stage -> Html Msg
renderStageItem stage =
    p [] [ text stage.name ]


buildStyle : List (List ( String, String )) -> Attribute Msg
buildStyle styleLists =
    Html.Attributes.style <| List.concat styleLists


mainBlock : List ( String, String )
mainBlock =
    [ ( "width", "100%" )
    , ( "text-aligh", "center" )
    , ( "color", "#474F7C" )
    ]


mainRow : List ( String, String )
mainRow =
    [ ( "display", "inline-block" ) ]


view : Model -> Html Msg
view render model =
    div [ buildStyle [ mainBlock ] ]
        [ div [ buildStyle [ mainRow ] ] [ (renderProjList model.projects model.ptypes) ]
        , div [ buildStyle [ mainRow ] ] [ renderPtypeList model.ptypes ]
        , div [ buildStyle [ mainRow ] ] [ renderStagesList model.stages ]
        ]



-- let
--    children =
--        List.map (\elem -> div [class "blended_grid"] [ elem ])
--            [ renderProjList model.projects
--            , renderPtypeList model.ptypes
--            , renderStagesList model.stages
--            ]
-- in
--   div [] children
