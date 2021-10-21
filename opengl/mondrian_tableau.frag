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
  rect.x = map(rect.x, 0.0, 1.0, 1.0, color.x);
  rect.y = map(rect.y, 0.0, 1.0, 1.0, color.y);
  rect.z = map(rect.z, 0.0, 1.0, 1.0, color.z);
  return rect;
}

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution;
  vec3 color = vec3(0.85, 0.85, 0.75);

  // red
  vec3 rect = makeRect(st,
                       vec2(0.0, 0.68),
                       vec2(0.22, 1.0),
                       vec3(0.7, 0.0, 0.0));

  // yellow
  rect *= makeRect(st,
                   vec2(0.92, 0.68),
                   vec2(1.0, 1.0),
                   vec3(1.0, 0.85, 0.3));

  // blue
  rect *= makeRect(st,
                   vec2(0.77, 0.0),
                   vec2(1.0, 0.1),
                   vec3(0.2, 0.2, 0.9));

  rect *= makeRect(st, vec2(0.2, 0.0),  vec2(0.22, 1.0), vec3(0.0));
  rect *= makeRect(st, vec2(0.92, 0.0), vec2(0.94, 1.0), vec3(0.0));
  rect *= makeRect(st, vec2(0.0, 0.8),  vec2(1.0, 0.82), vec3(0.0));
  rect *= makeRect(st, vec2(0.0, 0.68), vec2(1.0, 0.7),  vec3(0.0));
  rect *= makeRect(st, vec2(0.2, 0.1),  vec2(1.0, 0.12), vec3(0.0));
  rect *= makeRect(st, vec2(0.75, 0.0), vec2(0.77, 1.0), vec3(0.0));
  rect *= makeRect(st, vec2(0.1, 0.68), vec2(0.12, 1.0), vec3(0.0));
  // logical and
  color *= rect;

  gl_FragColor = vec4(color, 1.0);
}
