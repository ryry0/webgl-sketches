import Color exposing (..) -- colors
import Graphics.Element exposing (..)
import Math.Vector3 exposing (..)
import Math.Matrix4 exposing (..)
import Time exposing (..) --to get fps
import WebGL exposing (..)

-- Main

main : Signal Element -- A changing drawable element over time.
main = -- map our scene onto webgl
         Signal.map view (Signal.foldp (+) 0 (fps 30))

-- Model

type alias Vertex =
  { a_position : Vec3
  , color : Vec3
  }

rectangle : Drawable Vertex
rectangle =
  let
      bot_left = vec3 0 0 0
      top_left = vec3 0 1 0
      bot_right = vec3 1 0 0
      top_right = vec3 1 1 0
  in
  Triangle
  [ triangle blue bot_left top_left top_right
  , triangle red  bot_left top_right bot_right
  ]

mesh : Drawable Vertex
mesh = Triangle
  [ ( Vertex (vec3 0 0 0) (vec3 1 0 0)
    , Vertex (vec3 1 1 0) (vec3 0 1 0)
    , Vertex (vec3 1 -1 0) (vec3 0 0 1)
    )
  ]

triangle : Color -> Vec3 -> Vec3 -> Vec3 -> (Vertex, Vertex, Vertex)
triangle rawColor a b c =
  let
    color =
      let c = toRgb rawColor in
      vec3
          (toFloat c.red /255)
          (toFloat c.green /255)
          (toFloat c.blue /255)

    vertex position =
      Vertex position color
  in
     (vertex a, vertex b, vertex c)

perspective : Float -> Mat4
perspective _ =
  mul (makePerspective 45 1 0.01 100)
      (makeLookAt (vec3 0 0 1) (vec3 0 0 0) (vec3 0 1 0))

-- Update

-- View

view : Float -> Element
view t =
  webgl (400, 400)
    [ render vertexShader fragmentShader rectangle { perspective = perspective (t / 1000)} ]

-- Shaders
vertexShader : Shader { attr | a_position:Vec3, color:Vec3 }
  { unif | perspective:Mat4 }
  { vcolor:Vec3 }
vertexShader = [glsl|

attribute vec3 a_position;
attribute vec3 color;
uniform mat4 perspective;
varying vec3 vcolor;

void main () {
  gl_Position = perspective * vec4(a_position, 1.0);
  vcolor = color;
}

|]

fragmentShader : Shader {} a { vcolor:Vec3 }
fragmentShader = [glsl|

precision mediump float;
varying vec3 vcolor;

void main () {
  gl_FragColor = vec4(vcolor, 1.0);
}

|]
