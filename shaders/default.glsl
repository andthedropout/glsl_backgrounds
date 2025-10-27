void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalize coordinates to 0.0 - 1.0
    vec2 uv = fragCoord / iResolution.xy;

    // Create animated gradient waves
    float wave1 = sin(uv.x * 10.0 + iTime) * 0.5 + 0.5;
    float wave2 = cos(uv.y * 10.0 + iTime * 0.7) * 0.5 + 0.5;
    float wave3 = sin((uv.x + uv.y) * 5.0 - iTime * 1.5) * 0.5 + 0.5;

    // Mix colors
    vec3 color1 = vec3(0.5, 0.2, 0.8); // Purple
    vec3 color2 = vec3(0.2, 0.6, 0.9); // Blue
    vec3 color3 = vec3(0.9, 0.3, 0.5); // Pink

    vec3 finalColor = mix(color1, color2, wave1);
    finalColor = mix(finalColor, color3, wave2 * wave3);

    // Add some brightness variation
    finalColor *= 0.7 + 0.3 * wave3;

    fragColor = vec4(finalColor, 1.0);
}
