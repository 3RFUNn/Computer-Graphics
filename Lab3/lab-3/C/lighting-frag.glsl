// ECS610U -- Miles Hansard 2020

precision mediump float;

// light data
uniform struct {
    vec4 position, ambient, diffuse, specular;  
} light;

// material data
uniform struct {
    vec4 ambient, diffuse, specular;
    float shininess;
} material;

// clipping plane depths
uniform float near, far;

// normal, source and target -- interpolated across all triangles
varying vec3 m, s, t;

// Define PI constant
const float PI = 3.14159265359;

// HSV to RGB conversion function
vec3 hsv_to_rgb(vec3 c) {
    vec4 k = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
    vec3 p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
    return c.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), c.y);
}

void main()
{   
    // renormalize interpolated normal
    vec3 n = normalize(m);
    
    // Calculate hue from x,y components of normal using atan
    // atan(y,x) returns angle in range [-π, π], so we need to map to [0,1]
    float hue = atan(n.y, n.x) / (2.0 * PI) + 0.5;
    
    // Calculate saturation based on z component
    // When normal points up (z=1), saturation should be 0 (white)
    // When normal is horizontal (z=0), saturation should be 1 (full color)
    float saturation = sqrt(1.0 - abs(n.z));  // Using pow(saturation,0.5) as suggested
    
    // Create HSV color with value=1.0
    vec3 hsv = vec3(hue, saturation, 1.0);
    
    // Convert HSV to RGB
    vec3 rgb = hsv_to_rgb(hsv);
    
    // Output final color
    gl_FragColor = vec4(rgb, 1.0);
}