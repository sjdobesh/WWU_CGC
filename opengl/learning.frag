#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

uniform vec2    u_resolution;
uniform vec2    u_mouse;
uniform float   u_time;


float map(float value,
          float min1, float max1,
          float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

float plot(vec2 st, float pct) {
  return smoothstep(pct-0.02, pct, st.y) -
         smoothstep(pct, pct+0.02, st.y);
}

vec3 makeRect(vec2 st, vec2 bl_pos, vec2 tr_pos, vec3 color) {
  vec2 bl = step(bl_pos, st);
  vec2 tr = step(vec2(1.0) - tr_pos, 1.0-st);
  vec3 rect = vec3(bl.x * bl.y * tr.x * tr.y);
  rect.x = map(rect.x, 0, 1, 1, color.x);
  rect.y = map(rect.y, 0, 1, 1, color.y);
  rect.z = map(rect.z, 0, 1, 1, color.z);
  return rect;
}

mat2 rotate2d(float _angle) {
  return mat2(cos(_angle), -sin(_angle),
              sin(_angle), cos(_angle));
}

float box(in vec2 _st, in vec2 _size) {
  _size = vec2(0.5) - _size*0.5;
  vec2 uv = smoothstep(_size,
                       _size+vec2(0.001),
                       _st);
  uv *= smoothstep(_size,
                   _size+vec2(0.001),
                   vec2(1.0)-_st);
  return uv.x * uv.y;
}

float cross(in vec2 _st, float _size) {
  return box(_st, vec2(_size, _size/4.0)) +
         box(_st, vec2(_size/4.0, _size));
}

void main() {

  vec2 st = gl_FragCoord.xy/u_resolution.xy;
  vec3 color = vec3(0.0);

  vec2 translate = vec2(cos(u_time), sin(u_time));
  st += translate*0.35;

  color += vec3(cross(st,0.25));

  gl_FragColor = vec4(color, 1.0);
}
