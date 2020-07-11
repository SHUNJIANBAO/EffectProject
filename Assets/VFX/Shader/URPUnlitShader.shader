Shader "WX/URP/URPUnlitShader"
{
    Properties
    {
        _MainTex("MainTex",2D)="white"{}
        _BaseColor("BaseColor",Color)=(1,1,1,1)
    }
    SubShader
    {
        Tags{
        "RenderPipeline"="UniversalRenderPipeline"
        }
        HLSLINCLUDE
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        //#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        //#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        //#pragma  shader_feature_local _ADDLIGHT_ON 
        //#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        //#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        //#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        //#pragma multi_compile _ _SHADOWS_SOFT
        CBUFFER_START(UnityPerMaterial)
        float4 _MainTex_ST;
        half4 _BaseColor;
        CBUFFER_END
        TEXTURE2D( _MainTex);
        SAMPLER(sampler_MainTex);
         struct a2v
         {
             float4 positionOS:POSITION;
             float4 normalOS:NORMAL;
             float2 texcoord:TEXCOORD;
         };
         struct v2f
         {
             float4 positionCS:SV_POSITION;
             float2 texcoord:TEXCOORD;
         };
        ENDHLSL

        pass
        {
        Tags{
         "LightMode"="UniversalForward"
         "RenderType"="Opaque"
        }
            HLSLPROGRAM
            #pragma vertex VERT
            #pragma fragment FRAG
            v2f VERT(a2v i)
            {
                v2f o;
                o.positionCS=TransformObjectToHClip(i.positionOS.xyz);
                o.texcoord=TRANSFORM_TEX(i.texcoord,_MainTex);
                return o;
            }
            half4 FRAG(v2f i):SV_TARGET
            {
                half4 tex=SAMPLE_TEXTURE2D(_MainTex,sampler_MainTex,i.texcoord)*_BaseColor;
                return tex;
            }
            ENDHLSL
        }

    }

        
}
