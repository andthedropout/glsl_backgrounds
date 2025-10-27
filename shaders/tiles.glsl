// WebGL 1.0 compatible hash functions (no uint support)
float hash21(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

vec2 hash22(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)));
    return fract(sin(p) * 43758.5453123);
}

float hashContinuous21(vec2 p){
    vec2 u = fract(p);
    u = u*u*(3. - 2.*u);

    vec2 q = floor(p);

    float p00 = hash21(q);
    float p01 = hash21(vec2(q.x, q.y+1.));
    float p10 = hash21(vec2(q.x+1., q.y));
    float p11 = hash21(vec2(q.x+1., q.y+1.));

    return mix(mix(p00, p01, u.y), mix(p10, p11, u.y), u.x);
}

vec2 rectFract(vec2 p, float g) {
    return vec2(fract(p.x), p.y - floor(p.y / g) * g);
}

vec2 rectFloor(vec2 p, float g) {
    return vec2(floor(p.x), floor(p.y / g) * g);
}

vec3 gridStripe(vec2 p) {
    const float G = 0.5;
    vec2 r_p = rectFract(p, G);
    vec2 l_p = rectFloor(p, G);

    for (float i = -2.0; i <= 2.0; i += 1.0) {
        for (float j = -5.0 * G; j <= 5.0 * G; j += G) {
            vec2 diff = vec2(i, j);
            vec2 pos = hash22(diff + l_p) * vec2(1.0, G) + diff;

            float gray = hash21(diff + l_p);
            float ang = 2.3*hashContinuous21((diff + l_p)*.15 + iTime * 0.5) - .7;
            float c = cos(ang), s = sin(ang);
            mat2 rot = mat2(c, -s, s, c);
            vec2 rela = rot * (r_p - pos);

            const float lineWid = 0.03;
            const float wid_2 = 0.45;
            const float len_2 = 1.2;
            
            if (abs(rela.x) <= len_2 && abs(rela.y) <= wid_2) {
                if (abs(rela.x) >= len_2 - lineWid || abs(rela.y) >= wid_2 - lineWid) {
                    return vec3(0.0);
                } else return vec3(gray * 0.7 + 0.3);
            }
        }
    }
    return vec3(1.0);
}

void mainImage(out vec4 FragColor, in vec2 FragCoord){
    vec2 uv = (FragCoord.xy*2.0 - iResolution.xy) / iResolution.y;

    vec3 color = vec3(0.);
    color = gridStripe(uv * 6.0);

    FragColor = vec4(color, 1.);
}