// CC0: Trailing the Twinkling Tunnelwisp
//  A bit of Saturday coding (also Norway’s Constitution Day).
//  Some artifacts remain, but it’s good enough for my standards.

//  Music by Pestis created for Cassini's Cosmic Conclusion
//   https://demozoo.org/productions/367582/

// For those that like it as a twigl: https://twigl.app?ol=true&ss=-ORG5pd0bS422mTQQZzt

// Note: WebGL 2.0 has tanh built-in

// Distance field for gyroid, adapted from Paul Karlik's "Gyroid Travel" in KodeLife
//  Tweaked slightly for this effect
float g(vec4 p,float s) {
  // Makes it nicer (IMO) but costs bytes!
  // p.x=-abs(p.x);
  return abs(dot(sin(p*=s),cos(p.zxwy))-1.)/s;
}

void mainImage(out vec4 O,vec2 C) {
  // FYI: This code is intended to be as small as possible.
  //  As a consequence even harder to read than usual.

  float d = 0., z = 0., s, T = iTime;
  vec4 o = vec4(0), q, p, U=vec4(2,1,0,3);
  vec2 r = iResolution.xy;

  for (int i = 0; i < 79; i++) {
    // Compute ray direction, scaled by distance
    q = vec4(normalize(vec3(C-.5*r, r.y)) * z, .2);
    // Traverse through the cave
    q.z += T/3E1;
    // Save sign before mirroring
    s = q.y + .1;
    // Creates the water reflection effect
    q.y = abs(s);
    p = q;
    p.y -= .11;
    // Twist cave walls based on depth
    p.xy *= mat2(cos(11.*U.zywz - 2. * p.z ));
    p.y -= .2;
    // Combine gyroid fields at two scales for more detail
    d = abs(g(p,8.) - g(p,24.)) / 4.;
    // Base glow color varies with distance from center
    p = 1. + cos(.7 * U + 5. * q.z);
    // Accumulate glow — brighter and sharper if not mirrored (above axis)
    o += (s > 0. ? 1. : .1) * p.w * p / max(s > 0. ? d : d*d*d, 5E-4);
    // Advance along the ray by current distance estimate (+ epsilon)
    z += d + 5E-4;
  }

  // Add pulsing glow for the “tunnelwisp”
  o += (1.4 + sin(T) * sin(1.7 * T) * sin(2.3 * T))
       * 1E3 * U / length(q.xy);

  // Apply tanh for soft tone mapping
  O = tanh(o / 1E5);
}
