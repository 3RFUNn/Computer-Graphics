// GLSL VERTEX SHADER

// 4x4 matrices
uniform mat4 pre_scale, pre_rotate, rotate, shear, projective;

uniform vec3 rgb;

// A2 -- DECLARE UNIFORM TRANSLATION MATRIX HERE

uniform mat4 translate;

// xy coordinates are attributes -- different for each vertex
attribute vec4 vertex;

// colour for fragment shader
varying vec4 colour;

void main()
{
    // homogeneous cordinates [x,y,z,w]
    vec4 point =  vec4(vertex.x, vertex.y, 0.0, 1.0);

    // A3 -- DEFINE translate_inv HERE

    mat4 translate_inv = translate;

   
    translate_inv[3][0] = -translate[3][0];
    translate_inv[3][1] = -translate[3][1];



    // A1 -- ADD CODE HERE

    point = pre_rotate * pre_scale * point;

    // A1, A2, A3, A4, A5 -- MODIFY HERE

   // gl_Position = translate * rotate * point;

   // gl_Position =  translate * translate_inv * point;

   gl_Position =  translate * rotate * translate_inv * point;

    //gl_Position = point;

    // pass uniform colour to fragment shader varying
    // A5 -- MODIFY HERE
    colour = vec4(rgb, 1.0);
}
