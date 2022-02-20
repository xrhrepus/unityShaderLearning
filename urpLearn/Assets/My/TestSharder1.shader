//tutorial
//https://docs.unity3d.com/Manual/ShadersOverview.html
Shader "Unlit/TestSharder1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
		//https://docs.unity3d.com/Manual/ShadersOverview.html
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		//https://docs.unity3d.com/Manual/SL-ShaderLOD.html
        LOD 100

		//https://docs.unity3d.com/Manual/SL-Pass.html
        Pass
        {
			ZTEST GREATER
			CULL FRONT
            CGPROGRAM
			//https://docs.unity3d.com/Manual/SL-ShaderPrograms.html
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
			//https://docs.unity3d.com/Manual/SL-MultipleProgramVariants.html
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
