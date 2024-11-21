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

void main()
{   
    // renormalize interpolated normal
    vec3 n = normalize(m);

    // reflection vector
    vec3 r = -normalize(reflect(s,n));

    // Initialize base color with ambient and diffuse
    vec3 fragment_rgb = material.ambient.rgb + material.diffuse.rgb;
    
    // Get the dot product between light source and normal
    float light_normal_dot = dot(s,n);
    
    // Add specular based on light angle thresholds
    if (light_normal_dot > 0.9) {
        fragment_rgb += material.specular.rgb;
    } else if (light_normal_dot > 0.75) {
        fragment_rgb += 0.2 * material.specular.rgb;
    }
    
    // Check view angle for outline effect
    float view_normal_dot = dot(t,n);
    if (view_normal_dot < 0.4) {
        fragment_rgb = 0.3 * material.diffuse.rgb;
    }

    // Set final color
    gl_FragColor = vec4(fragment_rgb, 1.0);
}