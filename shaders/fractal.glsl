/* This animation is the material of my first youtube tutorial about creative 
   coding, which is a video in which I try to introduce programmers to GLSL 
   and to the wonderful world of shaders, while also trying to share my recent 
   passion for this community.
                                       Video URL: https://youtu.be/f4s1h2YETNY
*/

//https://iquilezles.org/articles/palettes/
vec3 palette( float t, float shift ) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.263,0.416,0.557) + shift * 0.1;

    return a + b*cos( 6.28318*(c*t+d) );
}

//https://www.shadertoy.com/view/mtyGWy
void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = (fragCoord * 2.0 - iResolution.xy) / iResolution.y;
    vec2 uv0 = uv;

    // Automatic slow drift in a circular pattern
    vec2 drift = vec2(sin(iTime * 0.08), cos(iTime * 0.05)) * 0.3;
    uv0 += drift;

    // Smooth mouse offset (will lag behind in shader.html)
    vec2 mouse = (iMouse.xy / iResolution.xy - 0.5) * 2.0;
    uv0 += mouse * 0.4;

    // Slow color palette shift over time
    float colorShift = sin(iTime * 0.08) + cos(iTime * 0.05) * 0.5;

    // Breathing effect - subtle variation in fractal complexity
    float breath = 1.0 + 0.15 * sin(iTime * 0.1);

    vec3 finalColor = vec3(0.0);

    for (float i = 0.0; i < 4.0; i++) {
        uv = fract(uv * 1.5 * breath) - 0.5;

        float d = length(uv) * exp(-length(uv0));

        vec3 col = palette(length(uv0) + i*.4 + iTime*.1, colorShift);

        d = sin(d*8. + iTime*.15)/8.;
        d = abs(d);

        d = pow(0.01 / d, 1.2);

        finalColor += col * d;
    }
        
    fragColor = vec4(finalColor, 1.0);
}