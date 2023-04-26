precision highp float;

uniform float u_time;
uniform vec2 u_resolution;

vec2 screen_size = u_resolution; // vec2(931.0, 914.0);
vec2 screen_border = vec2(50.0, 50.0);
float scale = 1.;

float g_noise_scale = .2;
float g_noise_size = 10.;

bool darkMode = true;
vec3 brightColor = vec3(0.86, 0.85, 0.75);
vec3 darkColor = vec3(0.1333, 0.1216, 0.1059);
bool showGrid = true;
bool showFrame = false;

vec2 pixToFac(vec2 pixPos) {
	return vec2(pixPos.x / screen_size.x, pixPos.y / screen_size.y);
}

vec2 FacToPix(vec2 FacPos) {
	return vec2(FacPos.x * screen_size.x, FacPos.y * screen_size.y);
}

float hash(int n) {
    return fract(sin(float(n)) * 43758.5453123);
}

float perlin(float pos, float scale, int seed) {
    float x = pos * scale;
    int xi = int(x);
    float xf = x - float(xi);
    float u = xf * xf * (3.0 - 2.0 * xf);
    
    int n1 = xi * seed;
    int n2 = (xi + 1) * seed;
    float a = mix(float(hash(n1)), float(hash(n2)), u);
    
    return a * 2.0 - 1.0;
}

vec2 perlin2D(vec2 pos, float scale, int seed) {
	return vec2(perlin(pos.x, scale, seed), perlin(pos.y+4343., scale, seed));
}

float circle(vec2 pos, vec2 center, float radius, float width) {
	float dist = distance(pos, center);
	dist -= radius;
	dist = abs(dist);
	dist -= width/20.;
	dist = dist < 0. ? 0. : dist;

	return 1. - dist;
}

float line(vec2 pos, vec2 pos1, vec2 pos2, float width) {
	vec2 pa = pos - pos1;
    vec2 ba = pos2 - pos1;

    float h = clamp( dot(pa,ba)/dot(ba,ba), 0., 1. );
    float idk = length(pa - ba*h);

	float out_col = smoothstep(0., width, idk);
	out_col = out_col < 0. ? 0. : out_col;
	out_col *= 16.;
	out_col = out_col > 1. ? 1. : out_col;

    return 1. - out_col;
}

float gizmo(vec2 pos, vec2 center, float radius, float width, float spacing, float line_len) {
	float out_color = 0.;

	out_color = max(circle(pos+perlin2D(center+u_time, g_noise_scale, 1)*g_noise_size, center, radius-spacing, width), out_color);
	out_color = max(circle(pos+perlin2D(center+u_time, g_noise_scale, 5)*g_noise_size, center, radius+spacing, width), out_color);

	radius *= line_len;

	out_color = max(line(pos+perlin2D(center+u_time, g_noise_scale, 10)*g_noise_size, center+vec2(radius*1.07, radius*1.07), center-vec2(radius*1.07, radius*1.07), width), out_color);
	out_color = max(line(pos+perlin2D(center+u_time, g_noise_scale, 15)*g_noise_size, center+vec2(radius+spacing, radius-spacing), center-vec2(radius-spacing, radius+spacing), width), out_color);
	out_color = max(line(pos+perlin2D(center+u_time, g_noise_scale, 20)*g_noise_size, center+vec2(radius-spacing, radius+spacing), center-vec2(radius+spacing, radius-spacing), width), out_color);

	return out_color;
}

void main( void ) {
	vec2 posPix = gl_FragCoord.xy;
	vec2 PosFac = pixToFac(posPix);

	float scale_loc = scale * (screen_size.x + screen_size.y) / 2.;

	vec3 backgroundColor = darkMode ? darkColor : brightColor;
	vec3 TextColor = darkMode ? brightColor : darkColor;

	// start factor
	float fac = 0.;

	// Border
	if ( showFrame && ( ( posPix.x < 2. ) || ( posPix.x > screen_size.x-2. ) || ( posPix.y < 2. ) || ( posPix.y > screen_size.y-2. ) ) ) {
		fac = max(fac, 1.);
	}

	// Guizmos
	fac = max(fac, gizmo(posPix, vec2(screen_border.x,screen_border.y), scale_loc*.3, scale_loc*.01, 14., 1.3));
	fac = max(fac, gizmo(posPix, vec2(screen_size.x-screen_border.x, screen_size.y-screen_border.y), scale_loc*.3, scale_loc*.01, 14., 1.3));

	// Set color
	vec3 color = mix(backgroundColor, TextColor, fac);

	// Overlay
	if ( showGrid && ( ( mod(posPix.x, 10.) < 6. ) && ( mod(posPix.y, 10.) < 6. ) ) ) {
		color += .05;
	}

	gl_FragColor = vec4(color, 1.0 );
}