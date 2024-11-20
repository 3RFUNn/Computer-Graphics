// Pass-through fragment shader
precision mediump float;

// Incoming interpolated color from vertex shader
varying vec4 colour;

void main()
{
    gl_FragColor = colour;
}