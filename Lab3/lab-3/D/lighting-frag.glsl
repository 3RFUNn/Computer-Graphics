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

// Add time uniform for animating the glitch
uniform float time;

// normal, source and target -- interpolated across all triangles
varying vec3 m, s, t;

// Function to generate pseudo-random value
float random(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// Function to create glitch blocks
float glitchBlock(vec2 uv, float threshold) {
    float noise = random(uv + time);
    return step(threshold, noise);
}

void main() {   
    // renormalize interpolated normal
    vec3 n = normalize(m);

    // reflection vector
    vec3 r = -normalize(reflect(s,n));

    // Basic Phong shading components
    vec4 ambient = material.ambient * light.ambient;
    vec4 diffuse = material.diffuse * max(dot(s,n),0.0) * light.diffuse;
    vec4 specular = material.specular * pow(max(dot(r,t),0.0), material.shininess) * light.specular;
    
    // Calculate base color
    vec4 baseColor = vec4((ambient + diffuse + specular).rgb, 1.0);
    
    // Create glitch effect
    float glitchStrength = 0.5; // Adjust this value to control glitch intensity
    
    // Create time-based displacement
    vec2 displacement = vec2(
        glitchBlock(vec2(time * 0.1, 0.0), 0.975) * glitchStrength * sin(time * 10.0),
        glitchBlock(vec2(0.0, time * 0.1), 0.975) * glitchStrength * cos(time * 10.0)
    );
    
    // Color channel splitting
    vec4 glitchColor = vec4(
        baseColor.r + glitchBlock(vec2(time * 0.1), 0.9) * displacement.x,
        baseColor.g + glitchBlock(vec2(time * 0.2), 0.9) * displacement.y,
        baseColor.b + glitchBlock(vec2(time * 0.3), 0.9) * (displacement.x - displacement.y),
        baseColor.a
    );
    
    // Add scan lines
    float scanline = sin(gl_FragCoord.y * 0.1 + time * 2.0) * 0.1 + 0.9;
    
    // Random vertical displacement
    float verticalShift = step(0.99, random(vec2(time * 0.1, 0.0))) * 
                         step(0.2, random(vec2(gl_FragCoord.y * 0.1)));
                         
    // Combine effects
    vec4 finalColor = mix(glitchColor, vec4(1.0), verticalShift) * scanline;
    
    // Output final color with glitch effect
    gl_FragColor = finalColor;
}