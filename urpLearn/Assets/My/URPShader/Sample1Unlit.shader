﻿//https://docs.unity3d.com/Packages/com.unity.render-pipelines.universal@8.2/manual/writing-shaders-urp-basic-unlit-structure.html
// This shader fills the mesh shape with a color predefined in the code.
Shader "Example/URPUnlitShaderBasic"
{
	// The properties block of the Unity shader. In this example this block is empty
	// because the output color is predefined in the fragment shader code.
	//https://docs.unity3d.com/Manual/SL-Properties.html
	Properties
	{
		_BaseMap("Texturehaha", 2D) = "white"
	}
		// The SubShader block containing the Shader code. 
		SubShader
	{
		// SubShader Tags define when and under which conditions a SubShader block or
		// a pass is executed.
		//https://docs.unity3d.com/Manual/SL-SubShaderTags.html
		Tags { "RenderType" = "Opaque" "RenderPipeline" = "UniversalRenderPipeline" }

		Pass
		{
		// The HLSL code block. Unity SRP uses the HLSL language.
		HLSLPROGRAM
		// This line defines the name of the vertex shader. 
		#pragma vertex vert
		// This line defines the name of the fragment shader. 
		#pragma fragment frag

		// The Core.hlsl file contains definitions of frequently used HLSL
		// macros and functions, and also contains #include references to other
		// HLSL files (for example, Common.hlsl, SpaceTransforms.hlsl, etc.).
		#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            

		// The structure definition defines which variables it contains.
		// This example uses the Attributes structure as an input structure in
		// the vertex shader.
		struct Attributes
		{
		// The positionOS variable contains the vertex positions in object
		// space.
		float4 positionOS   : POSITION;
		float2 uv			: TEXCOORD0;
	};

	struct Varyings
	{
		// The positions in this struct must have the SV_POSITION semantic.
		float4 positionHCS  : SV_POSITION;
		float2 uv			: TEXCOORD0;
	};

	TEXTURE2D(_BaseMap);
	SAMPLER(sampler_BaseMap);

	CBUFFER_START(UnityPerMaterial)
		float4 _BaseMap_ST;
	CBUFFER_END

	// The vertex shader definition with properties defined in the Varyings 
	// structure. The type of the vert function must match the type (struct)
	// that it returns.
	Varyings vert(Attributes IN)
	{
		// Declaring the output object (OUT) with the Varyings struct.
		Varyings OUT;
		// The TransformObjectToHClip function transforms vertex positions
		// from object space to homogenous space
		OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
		OUT.uv = TRANSFORM_TEX(IN.uv, _BaseMap);
		// Returning the output.
		return OUT;
	}

	// The fragment shader definition.            
	half4 frag(Varyings IN) : SV_Target
	{
		half4 color = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv);
		return color; 
	}
	ENDHLSL
}
	}
}