# How to Add New Shaders

## Quick Start

1. **Copy a shader from Shadertoy**
   - Go to https://www.shadertoy.com/
   - Find a shader you like
   - Copy the entire `mainImage` function (including helper functions above it)

2. **Create a new file in the `shaders/` folder**
   - Name it something like `my_shader.glsl`
   - Paste the code from Shadertoy

3. **Switch to the new shader**
   - Open `shader.html`
   - Find line 66: `const CURRENT_SHADER = 'hexagon_x5';`
   - Change it to: `const CURRENT_SHADER = 'my_shader';`
   - Save the file

4. **Reload in Plash**
   - Click Plash menu bar icon → "Reload"
   - Your new shader appears!

## Example

**From Shadertoy:**
```glsl
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
    fragColor = vec4(col,1.0);
}
```

**Save to:** `shaders/rainbow.glsl`

**In shader.html:**
```javascript
const CURRENT_SHADER = 'rainbow';
```

## Available Shaders

- `default.glsl` - Original gradient waves
- `hexagon_x5.glsl` - Hexagon pattern (from Shadertoy)

## Important Notes

- Only paste the `mainImage()` function and any helper functions
- Don't include the Shadertoy UI code
- Shaders using textures (iChannel0, iChannel1, etc.) need modification
- Keep shaders simple for best performance
- The file extension must be `.glsl`
- Don't include the `.glsl` extension in `CURRENT_SHADER`

## Troubleshooting

**Black screen after adding shader:**
- Open browser console (Cmd+Option+I in Chrome/Safari)
- Look for GLSL compile errors
- Check that the shader only uses `iTime`, `iResolution`, and `iMouse`

**Shader not found error:**
- Make sure the file is in the `shaders/` folder
- Check the filename matches `CURRENT_SHADER` exactly (case-sensitive)
- Don't include `.glsl` in the `CURRENT_SHADER` variable
