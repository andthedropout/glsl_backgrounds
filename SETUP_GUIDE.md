# Complete Setup Guide - GLSL Desktop Background

This guide contains everything you need to get your GLSL shader running as your macOS desktop background.

## What We Built

A simple system with 2 files:
- **shader.html** - HTML file with WebGL that renders your GLSL shader
- **README.md** - Quick reference guide

## How It Works

1. **shader.html** runs a GLSL fragment shader using WebGL in a browser
2. You run a local web server to serve the HTML file (using Python)
3. **Plash** (a free Mac app) displays the webpage as your desktop wallpaper
4. You edit the GLSL code in shader.html, save, and reload in Plash to see changes

## Complete Step-by-Step Setup

### Step 1: Install Plash

1. Open the Mac App Store
2. Search for "Plash"
3. Download and install (it's free)
4. Link: https://apps.apple.com/us/app/plash/id1494023538

### Step 2: Start the Web Server

1. Open Terminal
2. Navigate to this folder:
   ```bash
   cd ~/Github/glsl_desktop
   ```
3. Start the server:
   ```bash
   python3 -m http.server 8000
   ```
4. You should see: `Serving HTTP on :: port 8000 (http://[::]:8000/) ...`
5. **Keep this Terminal window open** - don't close it while you want the wallpaper running

### Step 3: Test in Browser (Optional but Recommended)

1. Open Safari or Chrome
2. Go to: `http://localhost:8000/shader.html`
3. You should see animated colorful gradient waves
4. This confirms it's working before setting as wallpaper

### Step 4: Set as Wallpaper in Plash

1. Open Plash (it appears in your menu bar at the top)
2. Click the Plash icon in the menu bar
3. Click "Open Plash"
4. Click the "+" button or "Add Website..."
5. Enter the URL: `http://localhost:8000/shader.html`
6. Click "Add"
7. The shader should now appear as your desktop background!

### Step 5: Adjust Plash Settings (Optional)

In the Plash window you can:
- Adjust **opacity** (how transparent the shader is over your wallpaper)
- Set **reload interval** (auto-refresh)
- Enable **browsing mode** (if you want mouse interaction)

## How to Edit Your Shader

### Finding the Shader Code

1. Open `shader.html` in any text editor (TextEdit, VS Code, etc.)
2. Find this section (around line 40):

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Your shader code goes here!
}
```

### Available Uniforms (Variables)

Your shader has access to:
- `iResolution` (vec2) - Screen width and height in pixels
- `iTime` (float) - Seconds since the shader started
- `iMouse` (vec2) - Mouse X and Y position

### Example Edit

Replace the code inside `mainImage()` with this simple example:

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Normalize coordinates to 0.0 - 1.0
    vec2 uv = fragCoord / iResolution.xy;

    // Create a simple gradient
    vec3 color = vec3(uv.x, uv.y, 0.5);

    fragColor = vec4(color, 1.0);
}
```

### After Editing

1. Save `shader.html`
2. Click the Plash icon in your menu bar
3. Click "Reload"
4. Your changes appear instantly!

## Example Shaders to Try

### 1. Simple Time-Based Color Shift

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    vec3 color = vec3(
        sin(iTime) * 0.5 + 0.5,
        cos(iTime) * 0.5 + 0.5,
        sin(iTime + 1.0) * 0.5 + 0.5
    );

    fragColor = vec4(color, 1.0);
}
```

### 2. Animated Circle

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    uv = uv * 2.0 - 1.0; // Center coordinates
    uv.x *= iResolution.x / iResolution.y; // Fix aspect ratio

    float dist = length(uv);
    float pulse = sin(iTime * 2.0) * 0.5 + 0.5;
    float circle = smoothstep(0.5, 0.3, dist) * pulse;

    vec3 color = vec3(circle * 0.3, circle * 0.6, circle);
    fragColor = vec4(color, 1.0);
}
```

### 3. Plasma Effect

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    float c1 = sin(uv.x * 10.0 + iTime);
    float c2 = sin(uv.y * 10.0 + iTime);
    float c3 = sin((uv.x + uv.y) * 10.0 + iTime);

    float plasma = (c1 + c2 + c3) / 3.0;

    vec3 color = vec3(
        sin(plasma * 3.14159 + 0.0) * 0.5 + 0.5,
        sin(plasma * 3.14159 + 2.0) * 0.5 + 0.5,
        sin(plasma * 3.14159 + 4.0) * 0.5 + 0.5
    );

    fragColor = vec4(color, 1.0);
}
```

### 4. Matrix Rain

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    float columns = 50.0;
    float col = floor(uv.x * columns);
    float speed = fract(sin(col) * 43758.5453);

    float y = fract(uv.y - iTime * speed);
    float rain = step(0.95, fract(sin(col + y * 100.0) * 43758.5453));

    vec3 color = vec3(0.0, rain, 0.0);
    fragColor = vec4(color, 1.0);
}
```

### 5. Wavy Lines

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    float lines = sin(uv.y * 20.0 + sin(uv.x * 10.0 + iTime) * 2.0);
    lines = smoothstep(0.0, 0.1, lines);

    vec3 color = vec3(0.2, 0.5, 0.8) * lines;
    fragColor = vec4(color, 1.0);
}
```

## Using Shadertoy Shaders

You can copy shaders from https://www.shadertoy.com/

1. Browse Shadertoy and find a shader you like
2. Click on the shader to open it
3. Look for the code in the editor
4. Copy everything inside the `void mainImage(...)` function
5. Paste it into `shader.html` (replacing the existing `mainImage` code)
6. Save and reload in Plash

**Note:** Simple shaders work best. Some Shadertoy shaders use:
- Multiple buffers (won't work)
- Texture inputs (won't work)
- Sound input (won't work)

Stick to shaders that only use `iTime`, `iResolution`, and `iMouse` for best results.

## Daily Workflow

Once everything is set up:

1. **Starting**: Run `python3 -m http.server 8000` in Terminal
2. **Editing**: Open `shader.html`, edit the GLSL code, save
3. **Reload**: Click Plash menu bar icon → "Reload"
4. **Stopping**: Close Plash or pause it, then `Ctrl+C` in Terminal

## Troubleshooting

### "Connection refused" or blank screen
- Make sure the web server is running (`python3 -m http.server 8000`)
- Check you're using the correct URL: `http://localhost:8000/shader.html`

### Black screen
- Open `http://localhost:8000/shader.html` in Chrome or Safari
- Open browser console (Cmd+Option+I)
- Look for GLSL compile errors in red
- Check your shader syntax

### Performance issues / lag
- Your shader might be too complex
- Simplify calculations in the fragment shader
- Reduce the number of for-loops
- Lower Plash opacity to reduce rendering load

### Port 8000 already in use
- Try a different port: `python3 -m http.server 8080`
- Update the URL in Plash to: `http://localhost:8080/shader.html`

### Shader doesn't animate
- Make sure you're using `iTime` somewhere in your shader
- Check that the browser isn't paused (click on the Plash window)

### Server stops when I close Terminal
- Keep the Terminal window open while using the wallpaper
- Or run it in the background: `python3 -m http.server 8000 &`

## Understanding the Code

### WebGL Basics

- **Vertex Shader**: Positions the geometry (we use a full-screen quad)
- **Fragment Shader**: Runs once for every pixel on screen
- Your GLSL code runs in the fragment shader

### Coordinate System

```glsl
vec2 fragCoord  // Pixel position (0,0) = bottom-left
vec2 iResolution // Screen size in pixels
vec2 uv = fragCoord / iResolution.xy // Normalized coords (0.0 to 1.0)
```

### Common GLSL Functions

- `sin()`, `cos()`, `tan()` - Trigonometric functions
- `length()` - Distance from origin
- `smoothstep()` - Smooth interpolation
- `mix()` - Linear interpolation between two values
- `fract()` - Fractional part of a number
- `step()` - Step function (0 or 1)

### Color Output

```glsl
fragColor = vec4(red, green, blue, alpha);
// Each value is 0.0 to 1.0
```

## Advanced Tips

### Auto-reload on file change

Install `browser-sync` for auto-reload:
```bash
npx browser-sync start --server --files "shader.html" --port 8000
```

### Better editing experience

Use VS Code with the "Shader languages support" extension for:
- Syntax highlighting
- Error detection
- Auto-completion

### Performance monitoring

In Plash preferences, you can see:
- FPS (frames per second)
- Memory usage

Aim for 60 FPS for smooth animation.

## Quick Reference

### File Locations
```
~/Github/glsl_desktop/
├── shader.html     # Edit your GLSL code here
├── README.md       # Quick reference
└── SETUP_GUIDE.md  # This file
```

### Key Commands
```bash
# Start server
python3 -m http.server 8000

# Stop server
Ctrl+C

# Navigate to folder
cd ~/Github/glsl_desktop
```

### URLs
- **Local shader**: http://localhost:8000/shader.html
- **Plash download**: https://apps.apple.com/us/app/plash/id1494023538
- **Shadertoy**: https://www.shadertoy.com/

## That's It!

You now have a lightweight, simple GLSL shader system for your desktop background. Edit the shader, save, reload, and enjoy!

Have fun creating!
