<VERTEX>
	#version 330 core
	#include "Shaders/CommonSharedVars.glsl"
	
	in vec3 position;
	
	uniform mat4 model;
	
	void main()
	{
		vec4 pos = model*vec4(position, 1.0);
		gl_Position = viewProjection*pos;
	}
</VERTEX>
<FRAGMENT>
	#version 330 core

	layout (location = 0) out vec4 outColor;
	
	uniform vec4 uColor;
	
	void main()
	{
		outColor = uColor;
	}
</FRAGMENT>