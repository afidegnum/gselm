module Project exposing (..)

import Json.Encode
import Json.Decode exposing ((:=))
import Json.Decode.Extra exposing ((|:))


type alias Project =
    { key : String
    , name : String
    }


decodeList : Json.Decode.Decoder (List Project)
decodeList =
    Json.Decode.list decodeProject


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
