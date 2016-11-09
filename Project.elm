module Project exposing (..)

import Json.Encode
import Json.Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))
import Dict


type alias Project =
    { key : String
    , name : String
    }


type alias Ptype =
    { key : String
    , name : String
    }


type alias Stage =
    { key : String
    , name : String
    }



-- Projects


type alias ProjectDict =
    Dict.Dict String Project


decodeDict : Json.Decode.Decoder ProjectDict
decodeDict =
    decodeList
        |> Json.Decode.map (List.map (\p -> ( p.key, p )))
        |> Json.Decode.map Dict.fromList


decodeList : Json.Decode.Decoder (List Project)
decodeList =
    "projects" := Json.Decode.list decodeProject


decodeProject : Json.Decode.Decoder Project
decodeProject =
    Json.Decode.succeed Project
        |: ("key" := Json.Decode.string)
        |: ("name" := Json.Decode.string)


encodeProject : Project -> Json.Encode.Value
encodeProject record =
    Json.Encode.object
        [ ( "key", Json.Encode.string <| record.key )
        , ( "name", Json.Encode.string <| record.name )
        ]



-- Project types


type alias PtypeDict =
    Dict.Dict String Ptype


decodePtypeDict : Json.Decode.Decoder PtypeDict
decodePtypeDict =
    decodePtypeList
        |> Json.Decode.map (List.map (\p -> ( p.key, p )))
        |> Json.Decode.map Dict.fromList


decodePtypeList : Json.Decode.Decoder (List Ptype)
decodePtypeList =
    "projects" := Json.Decode.list decodeProject


decodePtype : Json.Decode.Decoder Ptype
decodePtype =
    Json.Decode.succeed Ptype
        |: ("key" := Json.Decode.string)
        |: ("name" := Json.Decode.string)


encodePtype : Project -> Json.Encode.Value
encodePtype record =
    Json.Encode.object
        [ ( "key", Json.Encode.string <| record.key )
        , ( "name", Json.Encode.string <| record.name )
        ]



-- Stages


type alias StageDict =
    Dict.Dict String Project


decodeStageDict : Json.Decode.Decoder StageDict
decodeStageDict =
    decodeList
        |> Json.Decode.map (List.map (\p -> ( p.key, p )))
        |> Json.Decode.map Dict.fromList


decodeStageList : Json.Decode.Decoder (List Stage)
decodeStageList =
    "projects" := Json.Decode.list decodeProject


decodeStage : Json.Decode.Decoder Stage
decodeStage =
    Json.Decode.succeed Project
        |: ("key" := Json.Decode.string)
        |: ("name" := Json.Decode.string)


encodeStage : Project -> Json.Encode.Value
encodeStage record =
    Json.Encode.object
        [ ( "key", Json.Encode.string <| record.key )
        , ( "name", Json.Encode.string <| record.name )
        ]
