<VERTEX>
	#version 330 core
	in vec2 position;
	in vec2 texcoord;
	out vec2 Texcoord;
	void main()
	{
		Texcoord = texcoord;
		gl_Position = vec4(position, 0.0, 1.0);
	}
</VERTEX>
<FRAGMENT>
	#version 330 core
	in vec2 Texcoord;
	
	layout (location = 0) out vec4 outColor;
	layout (location = 1) out vec4 brightColor;
	
	uniform sampler2D texPosition;
	uniform sampler2D texNormal;
	uniform sampler2D texDiffuse;
	uniform sampler2D texSpecular;
	
	struct PointLight 
	{
		vec3 Position;
		vec3 Color;
		
		float Linear;
		float Quadratic;
	};
	struct DirectionalLight
	{
		vec3 Direction;
		vec3 Color;
	};
	const int NR_POINT_LIGHTS = 50;
	uniform PointLight pointLights[NR_POINT_LIGHTS];
	const int NR_DIR_LIGHTS = 1;
	uniform DirectionalLight dirLights[NR_DIR_LIGHTS];
	
	uniform vec3 camPos;
	const float maxExposure = 5000;
		
	uniform vec3 ambientColor;
	
	float Lambert(vec3 norm, vec3 lightDir)
	{
		return max(dot(norm, -lightDir), 0);
	}
	float Blinn(vec3 norm, vec3 lightDir, vec3 viewDir, float specPow)
	{
		vec3 halfVec = -normalize(viewDir + lightDir);
		return pow(max(dot(halfVec, norm), 0.0), specPow);
	}
	
	vec3 DirLighting(DirectionalLight light, vec3 dif, vec3 spec, float specPow, vec3 norm, vec3 viewDir)
	{
		vec3 diffuse = (dif * light.Color) * Lambert(norm, light.Direction);
		vec3 specular = (spec * light.Color) * Blinn(norm, light.Direction, viewDir, specPow);
		return diffuse + specular;
	}
	vec3 PointLighting(PointLight light, vec3 dif, vec3 spec, float specPow, vec3 pos, vec3 norm, vec3 viewDir)
	{
		vec3 lightDir = -normalize(light.Position - pos);
		float dist = -length(light.Position - pos);
		float attenuation = 1.0f / ( 1 + light.Linear * dist + light.Quadratic * (dist * dist));
	
		vec3 diffuse = (dif * light.Color) * Lambert(norm, lightDir);
		vec3 specular = (spec * light.Color) * Blinn(norm, lightDir, viewDir, specPow);
		
		return (diffuse + specular) * attenuation;
	}
	
	void main()
	{
		float alpha = texture(texPosition, Texcoord).a;
		vec3 position = texture(texPosition, Texcoord).rgb;
		vec3 norm = texture(texNormal, Texcoord).rgb;
		vec3 diffuse = texture(texDiffuse, Texcoord).rgb;
		vec3 specular = texture(texSpecular, Texcoord).rgb;
		float specPow = texture(texSpecular, Texcoord).a;
		
		vec3 viewDir = normalize(position - camPos);
		
		vec3 finalCol = ambientColor;
		
		for(int i = 0; i < NR_POINT_LIGHTS; i++)
		{
			finalCol += PointLighting(pointLights[i], diffuse, specular, specPow, position, norm, viewDir); 
		}
		for(int i = 0; i < NR_DIR_LIGHTS; i++)
		{
			finalCol += DirLighting(dirLights[i], diffuse, specular, specPow, norm, viewDir);
		}
			
		finalCol = max(finalCol, 0.0);		
		
		outColor = vec4(finalCol, alpha);
		
		float brightness = dot(outColor.rgb, vec3(0.2126, 0.7152, 0.0722));
		if(brightness > 1.0) brightColor = vec4(outColor.rgb, 1.0);
	}
</FRAGMENT>