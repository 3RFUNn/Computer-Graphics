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

// Function to convert fragment depth to scene depth
float scene_depth(float frag_z)
{
    float ndc_z = 2.0*frag_z - 1.0;
    return (2.0*near*far) / (far + near - ndc_z*(far-near));
}

void main()
{   
    // Get the scene depth from gl_FragCoord.z
    float z = scene_depth(gl_FragCoord.z);
    
    // Linear transformation to map depth to color intensity
    // When z = near, result should be 1.0 (white)
    // When z = far, result should be 0.0 (black)
    float intensity = (far - z) / (far - near);
    
    // Output final color based on depth
    gl_FragColor = vec4(vec3(intensity), 1.0);
}