#version 120

uniform sampler2D DiffuseSampler;
uniform sampler2D DarkBlurSampler;
uniform vec2 OutSize;
varying vec2 texCoord;

float toLum (vec4 color){
    return dot(color.rgb, vec3(.2125, .7154, .0721) );
}

vec4 toLinear (vec4 color){
    return pow(color,vec4(2.2));
}

float toLinear (float value){
    return pow(value,2.2);
}

vec4 toGamma (vec4 color){
    return pow(color,vec4(1.0/2.2));
}

float toGamma (float value){
    return pow(value,1.0/2.2);
}

vec4 toReinhard (vec4 color){
    float lum = toLum(color);
    float reinhardLum = lum/(1.0+lum);
    return color*(reinhardLum/lum);
}

void main() {
    vec4 color = toLinear(texture2D(DiffuseSampler, texCoord));
    vec4 bloom = toLinear(texture2D(DarkBlurSampler, texCoord)*2.0);

    vec4 bloomed = color + bloom;

    //vec4 reinhard = toReinhard( bloomed * 1.3 );

    //gl_FragColor = toGamma( mix( bloomed, reinhard, .4 ) );
    gl_FragColor = toGamma(bloomed);
}
