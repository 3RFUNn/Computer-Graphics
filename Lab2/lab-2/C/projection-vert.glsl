// GLSL VERTEX SHADER

uniform mat4 modelview, projection;
uniform mat4 translation;
uniform mat4 translation_inv;
uniform mat4 rotation;

uniform float alpha;
uniform bool use_colour;

attribute vec4 vertex;
attribute vec4 colour;

varying vec4 colour_var;

void main()
{
    // convert to homogeneous coordinates
    vec4 point = vec4(vertex.x, vertex.y, vertex.z, 1.0);

   // Apply the transformations
    vec4 transformed_point = translation * translation_inv * rotation * vertex;
    gl_Position = projection * modelview * transformed_point;

    if(use_colour) {
        // from attribute array
        colour_var = colour;
    }
    else {
        // monchrome controlled by uniform rgba
        colour_var = vec4(0.5, 0.5, 0.5, alpha);
    }
}

