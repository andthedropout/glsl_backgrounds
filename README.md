# GLSL Desktop Background for macOS

A simple, lightweight way to use GLSL shaders as your macOS desktop background.

## What You Need

1. **Plash** - Free app from the Mac App Store
   - Download: https://apps.apple.com/us/app/plash/id1494023538
   - Makes any website your desktop wallpaper

2. **Python 3** - Already installed on macOS
   - Used to run a simple local web server

## Quick Start

### 1. Install Plash

Download and install Plash from the Mac App Store (it's free):
https://apps.apple.com/us/app/plash/id1494023538

### 2. Start the Local Server

Open Terminal, navigate to this directory, and run:

```bash
python3 -m http.server 8000
```

Keep this terminal window open while using the shader wallpaper.

### 3. Set Up in Plash

1. Open Plash
2. Click the Plash icon in your menu bar
3. Click "Add Website..."
4. Enter one of these URLs:
   - `http://localhost:8000/sync.html` (recommended - auto-rotating shaders)
   - `http://localhost:8000/random.html` (random shader each reload)
   - `http://localhost:8000/shader.html` (single specific shader)
5. Click "Add"

Your shader should now be rendering as your desktop background!

**For multiple monitors:** Use multiple Plash instances (download from [GitHub issue](https://github.com/sindresorhus/Plash/issues/2)) and point each to `sync.html` so they stay synchronized.

## Available HTML Files

This project includes three different HTML files for different use cases:

### `shader.html` - Single Static Shader

Point Plash to a specific shader that you configure in the code.

```
http://localhost:8000/shader.html
```

Edit the `CURRENT_SHADER` variable in the file to change which shader loads.

### `random.html` - Random Shader on Each Load

Randomly picks a different shader every time the page loads or refreshes.

```
http://localhost:8000/random.html
```

Perfect for variety - each reload gives you a different shader!

### `sync.html` - Time-Synchronized Shader (Best for Multiple Monitors)

**Perfect for dual/multi-monitor setups!** All instances of this page show the same shader at the same time, automatically rotating at set intervals.

```
http://localhost:8000/sync.html
```

**URL Parameters:**

The page accepts two optional URL parameters to customize behavior:

#### `interval` - Change interval in minutes (default: 60)

How often the shader changes. Specified in minutes.

**Examples:**
- `http://localhost:8000/sync.html?interval=30` - Change every 30 minutes
- `http://localhost:8000/sync.html?interval=120` - Change every 2 hours
- `http://localhost:8000/sync.html?interval=15` - Change every 15 minutes

#### `mode` - Selection mode (default: random)

How shaders are selected.

- `random` - Randomly select shader (but synchronized across all instances)
- `sequential` - Cycle through all shaders in order

**Examples:**
- `http://localhost:8000/sync.html?mode=sequential` - Cycle through shaders in order every hour
- `http://localhost:8000/sync.html?mode=random` - Random shader every hour (default)

#### Combining Parameters

You can combine both parameters using `&`:

```
http://localhost:8000/sync.html?interval=30&mode=sequential
```

This will cycle through shaders in order, changing every 30 minutes.

**Why use sync.html for multiple monitors?**

When you have multiple Plash instances running (one per monitor), `random.html` would show different shaders on each screen. With `sync.html`, both monitors:
- Show the **same shader** at the same time
- Change to the **same new shader** at the same time
- Stay **synchronized** as long as they're viewing the same URL

The page automatically reloads itself at the next interval boundary, so you don't need to configure Plash's reload setting.

## Customizing Your Shader

### Edit the Shader Code

Open `shader.html` in any text editor and find this section:

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Your shader code goes here!
}
```

This is where you write your GLSL fragment shader code. The format is compatible with Shadertoy, so you can copy shaders from https://www.shadertoy.com/

### Available Uniforms

Your shader has access to these uniforms:

- `iResolution` (vec2) - Screen resolution in pixels
- `iTime` (float) - Time in seconds since start
- `iMouse` (vec2) - Mouse position in pixels

### Example: Simple Color Gradient

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    fragColor = vec4(uv.x, uv.y, 0.5, 1.0);
}
```

### Example: Animated Circle

```glsl
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec2 center = vec2(0.5, 0.5);

    float dist = length(uv - center);
    float pulse = sin(iTime * 2.0) * 0.5 + 0.5;
    float circle = smoothstep(0.3, 0.2, dist) * pulse;

    vec3 color = vec3(circle * 0.5, circle * 0.8, circle);
    fragColor = vec4(color, 1.0);
}
```

### After Editing

1. Save `shader.html`
2. In Plash menu bar icon, click "Reload"
3. Your changes will appear immediately!

## Using Shadertoy Shaders

You can copy shaders from https://www.shadertoy.com/

1. Find a shader you like on Shadertoy
2. Copy the code from the `mainImage()` function
3. Paste it into the `mainImage()` function in `shader.html`
4. Reload in Plash

**Note:** Some complex Shadertoy shaders use textures or multiple buffers which won't work out of the box. Stick to simple fragment shaders for best results.

## Tips

- **Performance**: Simple shaders run smoothly. Complex shaders may use more battery/CPU
- **Editing**: Use a code editor with GLSL syntax highlighting for easier editing
- **Testing**: Open `http://localhost:8000/shader.html` in your browser to test before setting as wallpaper
- **Debugging**: Check the browser console (Cmd+Option+I) for shader compile errors

## Plash Settings

In Plash preferences you can adjust:

- **Opacity**: Make the shader semi-transparent
- **Reload interval**: Auto-reload the page periodically
- **Browsing mode**: Interact with the shader (enable mouse interaction)

## Stopping the Wallpaper

1. Click Plash menu bar icon
2. Click "Pause" to temporarily stop
3. Or remove the website from Plash to stop completely

To stop the server, press `Ctrl+C` in the Terminal window.

## Troubleshooting

**Shader appears black:**
- Check browser console for GLSL errors
- Make sure your shader code is valid GLSL

**Performance issues:**
- Simplify your shader code
- Reduce calculations in the fragment shader
- Lower Plash opacity to reduce rendering load

**Server won't start:**
- Make sure port 8000 isn't already in use
- Try a different port: `python3 -m http.server 8080` and use `http://localhost:8080/shader.html`

## File Structure

```
glsl_desktop/
├── shader.html     # Single static shader (configurable in code)
├── random.html     # Random shader on each load
├── sync.html       # Time-synchronized shader (great for multi-monitor)
├── shaders/        # Directory containing all GLSL shader files
│   ├── default.glsl
│   ├── hexagon_x5.glsl
│   ├── subversion.glsl
│   └── ... (25+ shaders)
└── README.md       # This file
```

## Example Shaders to Try

### Plasma Effect

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

### Matrix Rain

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

Enjoy your custom GLSL shader desktop background!
# glsl_backgrounds
