void mainImage( out vec4 o, vec2 U )
{
float i,s,t=iTime;
vec3 p,r=vec3(iResolution,0);p.z=t;
vec3 d=normalize(vec3(2.*U,0.)-r.xyy);
for(o*=i;i++<50.;p+=d*s){s=.01+abs(.1-length(cos(p)-abs(sin(p.z+t))))*.35;o+=vec4(2,1,0,1)/s;}
o=tanh(o*o/4e6);
}
// Twigl: Super Geek 142 Char
// V3 d=Ne(V3(2.*U,0)-r.xyy),p;p.z=t;Fl i,s;Fr(o*=i;i++<50.;p+=d*s){s=.01+As(.1-Lh(Cs(p.xyz)-As(Sn(p.z+t))))*.35;o+=V4(2,1,0,1)/s;}o=Th(o*o/4e6);

// https://rostamimagic.com/twig?mode=12&ol=true&ss=-OcRQSZu69FCAma6fxwA
// Twitter
// https://x.com/Frostbyte_Vis/status/1982144990277992551
