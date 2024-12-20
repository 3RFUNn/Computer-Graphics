// ECS610U -- Miles Hansard

precision highp float;

uniform mat4 modelview, modelview_inv, projection, view_inv;

uniform struct {
    vec4 position, ambient, diffuse, specular;  
} light;

uniform bool render_skybox, render_texture;
uniform samplerCube cubemap;
uniform sampler2D texture;


uniform bool wireframe_mode;

uniform vec2 screenSize;

varying vec2 map;
varying vec3 d, m;
varying vec4 p, q;


float vignette(vec2 coord, vec2 resolution) {
  // Calculate the distance of the fragment from the center of the image
  vec2 center = resolution / 2.0;
  float dist = distance(coord, center);


  float vignetteFactor = 1.0 - dist / length(resolution);
  vignetteFactor = clamp(vignetteFactor, 0.6, 0.95);
  return vignetteFactor;
}



vec4 gamma_transform(vec4 colour, float gamma)
{
    return vec4(pow(colour.rgb, vec3(gamma)), colour.a);
}


void main()
{ 
    if(render_skybox) {
        gl_FragColor = textureCube(cubemap,vec3(-d.x,d.y,d.z));
    }
    else {
        // Check wireframe mode first
        if(wireframe_mode) {
            gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0);
            // Apply vignette and return early
            vec2 resolution = vec2(850,850);
            gl_FragColor.rgb *= vignette(gl_FragCoord.xy, resolution);
            return;
        }

        // Rest of the existing lighting/material code...
        vec3 n = normalize(m);

        // object colour
        vec4 material_colour = texture2D(texture, map);

        // Measure darkness
        float darkness = length(material_colour.rgb);

        // // Set alpha based on darkness
        // if (darkness < 0.5) { // Adjust the threshold as needed
        //     material_colour.a = 0.0; // Fully transparent
        // } else {
        //     material_colour.a = 1.0; // Fully opaque
        // }

        // sources and target directions 
        vec3 s = normalize(q.xyz - p.xyz);
        vec3 t = normalize(-p.xyz);

        // reflection vector in world coordinates
        vec3 r = (view_inv * vec4(reflect(-t,n),0.0)).xyz;

        // reflected background colour
        vec4 reflection_colour = textureCube(cubemap,vec3(-r.x,r.y,r.z));

        // blinn-phong lighting

        vec4 ambient = material_colour * light.ambient;
        vec4 diffuse = material_colour * max(dot(s,n),0.0) * light.diffuse;

        // halfway vector
        vec3 h = normalize(s + t);
        vec4 specular = pow(max(dot(h,n), 0.0), 4.0) * light.specular;       

        // combined colour
        if(render_texture) {
            gl_FragColor = vec4((0.5 * ambient + 
                                 0.5 * diffuse + 
                                 0.01 * specular + 
                                 0.1 * reflection_colour).rgb, material_colour.a);
        }
        else {
            if(wireframe_mode) {
                gl_FragColor = vec4(0.5, 0.5, 0.5, 1.0); // Grey color for wireframe
            } else {
                // reflection only 
                gl_FragColor = reflection_colour;
            }
        }

        gl_FragColor = gamma_transform(material_colour+reflection_colour*0.15,2.0);

        // if(render_texture) {
        //     vec4 combined_color = 0.5 * ambient + 
        //                  0.5 * diffuse + 
        //                  0.01 * specular + 
        //                  0.1 * gamma_transform(reflection_colour, 2.2);
        //     gl_FragColor = vec4(combined_color.rgb, material_colour.a);
        // }
        // else {
        //     // reflection only - apply gamma correction
        //     gl_FragColor = gamma_transform(reflection_colour, 2.2);
        // }

        

        // if(gl_FragCoord.x > 425.0) {

        //     gl_FragColor = gamma_transform(material_colour+reflection_colour*0.1,2.0);   
        // }


        


        

    }

    // vignette effect
    vec2 resolution = vec2(850,850);
    //gl_FragColor = vec4(1.0);

    // scale the final fragment rgb by vignette value
    gl_FragColor.rgb *= vignette(gl_FragCoord.xy, resolution);


}

