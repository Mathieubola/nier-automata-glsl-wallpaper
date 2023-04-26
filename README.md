# nier-automata-glsl-wallpaper

GLSL Shader made for wallpapers inspired by nier automata

Depending on what you run this on, you may need to change some constants in the shader to get it to look right.

The circles and lines moves independently from each other in a floating-like manner using a perlin noise.

## Preview

![Light Theme](https://media.discordapp.net/attachments/457596429196591106/1100869141545623663/Screenshot_20230426_113742_Nova7.jpg?width=313&height=660)

![Dark Theme](https://media.discordapp.net/attachments/457596429196591106/1100869141851799612/Screenshot_20230426_113704_Nova7.jpg?width=313&height=660)

![Oled Theme](https://media.discordapp.net/attachments/457596429196591106/1100869141272997918/Screenshot_20230426_113834_Nova7.jpg?width=313&height=660)

## How to install

### Android

On phone, you can use the app [Shader Editor](https://play.google.com/store/apps/details?id=de.markusfisch.android.shadereditor)

You will have then to copy the code from the file `wallpaper.glsl` in this repo and paste it in the app.

You will then have to change
```glsl
uniform float u_time;
uniform vec2 u_resolution;
```
with
```glsl
uniform float time;
```
and
```glsl
vec2 screen_size = u_resolution; // vec2(931.0, 914.0);
```
with
```glsl
vec2 screen_size = vec2(931.0, 914.0);
```
And use the resolution of your phone screen.

You can tune it by showing the frame by setting the `show_frame` variable to `true`.

For oled screens, you can set the `darkColor` variable to `vec3(0.0, 0.0, 0.0)` to have a black background and the `showGrid` variable to `false` to hide the grid.
