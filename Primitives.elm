module Primitives where

import Color exposing (..) -- colors
import Math.Vector3 exposing (..)
import Math.Vector2 exposing (..)
import Math.Matrix4 exposing (..)
import WebGL exposing (..)

type alias Vertex =
  { a_position : Vec3
  , color : Vec3
  }


cube : Drawable Vertex
cube =
  let
    rft = vec3  1  1  1   -- right, front, top
    lft = vec3 -1  1  1   -- left,  front, top
    lbt = vec3 -1 -1  1
    rbt = vec3  1 -1  1
    rbb = vec3  1 -1 -1
    rfb = vec3  1  1 -1
    lfb = vec3 -1  1 -1
    lbb = vec3 -1 -1 -1
  in
    Triangle
      [ triangle green rft lft lbt--top face
      , triangle green rft lbt rbt
      , triangle blue rfb lbb lfb--bottom face
      , triangle blue rfb rbb lbb
      , triangle orange lbt lft lfb --north face
      , triangle orange lbt lfb lbb
      , triangle purple rbb rbt lbt --east face
      , triangle purple rbb lbt lbb
      , triangle yellow rft rfb lfb --west face
      , triangle yellow rft lfb lft
      , triangle red rfb rft rbt --south face
      , triangle red rfb rbt rbb
      ]

rectangle : Drawable Vertex
rectangle =
  let
      bot_left = vec3 0 0 0
      top_left = vec3 0 0.1 0
      bot_right = vec3 0.1 0 0
      top_right = vec3 0.1 0.1 0
  in
  Triangle
  [ triangle blue bot_left top_left top_right
  , triangle red  bot_left top_right bot_right
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

