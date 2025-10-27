// The Universe Within - by Martijn Steinrucken aka BigWings 2018
// Email:countfrolic@gmail.com Twitter:@The_ArtOfCode
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// After listening to an interview with Michael Pollan on the Joe Rogan
// podcast I got interested in mystic experiences that people seem to
// have when using certain psycoactive substances. 
//
// For best results, watch fullscreen, with music, in a dark room.
// 
// I had an unused 'blockchain effect' lying around and used it as
// a base for this effect. Uncomment the SIMPLE define to see where
// this came from.
// 
// Use the mouse to get some 3d parallax.

// Music - Terrence McKenna Mashup - Jason Burruss Remixes
// https://soundcloud.com/jason-burruss-remixes/terrence-mckenna-mashup
//
// YouTube video of this effect:
// https://youtu.be/GAhu4ngQa48
//
// YouTube Tutorial for this effect:
// https://youtu.be/3CycKKJiwis


#define S(a, b, t) smoothstep(a, b, t)
#define NUM_LAYERS 4.

//#define SIMPLE


float N21(vec2 p) {
	vec3 a = fract(vec3(p.xyx) * vec3(213.897, 653.453, 253.098));
    a += dot(a, a.yzx + 79.76);
    return fract((a.x + a.y) * a.z);
}

vec2 GetPos(vec2 id, vec2 offs, float t) {
    float n = N21(id+offs);
    float n1 = fract(n*10.);
    float n2 = fract(n*100.);
    float a = t+n;
    return offs + vec2(sin(a*n1), cos(a*n2))*.4;
}

float GetT(vec2 ro, vec2 rd, vec2 p) {
	return dot(p-ro, rd); 
}

float LineDist(vec3 a, vec3 b, vec3 p) {
	return length(cross(b-a, p-a))/length(p-a);
}

float df_line( in vec2 a, in vec2 b, in vec2 p)
{
    vec2 pa = p - a, ba = b - a;
	float h = clamp(dot(pa,ba) / dot(ba,ba), 0., 1.);	
	return length(pa - ba * h);
}

float line(vec2 a, vec2 b, vec2 uv) {
    float r1 = .04;
    float r2 = .01;
    
    float d = df_line(a, b, uv);
    float d2 = length(a-b);
    float fade = S(1.5, .5, d2);
    
    fade += S(.05, .02, abs(d2-.75));
    return S(r1, r2, d)*fade;
}

float NetLayer(vec2 st, float n, float t) {
    vec2 id = floor(st)+n;

    st = fract(st)-.5;

    vec2 p[9];
    // Manually fill array for WebGL 1.0 compatibility
    p[0] = GetPos(id, vec2(-1.,-1.), t);
    p[1] = GetPos(id, vec2( 0.,-1.), t);
    p[2] = GetPos(id, vec2( 1.,-1.), t);
    p[3] = GetPos(id, vec2(-1., 0.), t);
    p[4] = GetPos(id, vec2( 0., 0.), t);
    p[5] = GetPos(id, vec2( 1., 0.), t);
    p[6] = GetPos(id, vec2(-1., 1.), t);
    p[7] = GetPos(id, vec2( 0., 1.), t);
    p[8] = GetPos(id, vec2( 1., 1.), t);
    
    float m = 0.;
    float sparkle = 0.;

    // Unrolled loop for WebGL 1.0 compatibility (no dynamic array indexing)
    for(int i=0; i<9; i++) {
        vec2 pi = p[0];
        if(i==1) pi = p[1];
        if(i==2) pi = p[2];
        if(i==3) pi = p[3];
        if(i==4) pi = p[4];
        if(i==5) pi = p[5];
        if(i==6) pi = p[6];
        if(i==7) pi = p[7];
        if(i==8) pi = p[8];

        m += line(p[4], pi, st);

        float d = length(st-pi);

        float s = (.005/(d*d));
        s *= S(1., .7, d);
        float pulse = sin((fract(pi.x)+fract(pi.y)+t)*5.)*.4+.6;
        pulse = pow(pulse, 20.);

        s *= pulse;
        sparkle += s;
    }
    
    m += line(p[1], p[3], st);
	m += line(p[1], p[5], st);
    m += line(p[7], p[5], st);
    m += line(p[7], p[3], st);
    
    float sPhase = (sin(t+n)+sin(t*.1))*.25+.5;
    sPhase += pow(sin(t*.1)*.5+.5, 50.)*5.;
    m += sparkle*sPhase;//(*.5+.5);
    
    return m;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-iResolution.xy*.5)/iResolution.y;
	vec2 M = iMouse.xy/iResolution.xy-.5;
    
    float t = iTime*.1;
    
    float s = sin(t);
    float c = cos(t);
    mat2 rot = mat2(c, -s, s, c);
    vec2 st = uv*rot;  
	M *= rot*2.;
    
    float m = 0.;
    for(float i=0.; i<1.; i+=1./NUM_LAYERS) {
        float z = fract(t+i);
        float size = mix(15., 1., z);
        float fade = S(0., .6, z)*S(1., .8, z);
        
        m += fade * NetLayer(st*size-M*z, i, iTime);
    }
    
	// float fft  = texelFetch( iChannel0, ivec2(.7,0), 0 ).x; // No audio input
    float fft = 0.0;
    float glow = -uv.y*fft*2.;
   
    vec3 baseCol = vec3(s, cos(t*.4), -sin(t*.24))*.4+.6;
    vec3 col = baseCol*m;
    col += baseCol*glow;
    
    #ifdef SIMPLE
    uv *= 10.;
    col = vec3(1)*NetLayer(uv, 0., iTime);
    uv = fract(uv);
    //if(uv.x>.98 || uv.y>.98) col += 1.;
    #else
    col *= 1.-dot(uv,uv);
    t = mod(iTime, 230.);
    col *= S(0., 20., t)*S(224., 200., t);
    #endif
    
    fragColor = vec4(col,1);
}