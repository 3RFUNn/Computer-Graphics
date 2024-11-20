// Per-vertex lighting implementation
precision mediump float;

// Transformation matrices
uniform mat4 modelview, projection;

// Light data structure
uniform struct {
    mediump vec4 position, ambient, diffuse, specular;
} light;

// Material data structure (moved from fragment shader)
uniform struct {
    vec4 ambient, diffuse, specular;
    float shininess;
} material;

// Input attributes
attribute vec3 vertex, normal;

// Output varying color for fragment shader
varying vec4 colour;

void main()
{
    // Transform vertex to camera coordinates
    vec4 p = modelview * vec4(vertex, 1.0);

    // Transform normal to camera coordinates
    vec3 n = normalize(modelview * vec4(normal, 0.0)).xyz;

    // Calculate light direction (in camera coordinates)
    vec3 s = normalize(light.position.xyz - p.xyz);

    // Calculate view direction (camera at origin)
    vec3 t = normalize(-p.xyz);

    // Calculate halfway vector for Blinn-Phong
    vec3 h = normalize(s + t);

    // Calculate lighting components
    vec4 ambient = material.ambient * light.ambient;
    
    vec4 diffuse = material.diffuse * 
                   max(dot(s,n), 0.0) * 
                   light.diffuse;

    vec4 specular = material.specular * 
                    pow(max(dot(h,n), 0.0), material.shininess * 4.0) *
                    light.specular;

    // Set the output varying color with all components
    colour = vec4((ambient + diffuse + specular).rgb, 1.0);

    // Set the final vertex position
    gl_Position = projection * p;
}