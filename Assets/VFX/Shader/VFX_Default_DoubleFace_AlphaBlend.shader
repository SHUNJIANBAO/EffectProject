// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "_VFX/Default/DoubleFace_AlphaBlend"
{
	Properties
	{
		[HDR]_Color("MainColor",Color) = (1,1,1,1)
		_MainTex("Texture2D", 2D) = "white"{}
	}
		SubShader
	{
		Pass
		{
			Tags{"Queue" = "Transparent" "IgnoreProjuector" = "True" "RenderType" = "Transparent" }
			//只渲染背面
			Cull Front
			//关闭深度写入
			ZWrite Off
			// 开启混合模式,并设置混合因之为SrcAlpha和OneMinusSrcAlpha
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;

			struct a2v
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				fixed4 colorV : COLOR;
			};
			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				fixed4 colorV : COLOR0;
			};
			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.colorV = v.colorV;
				return o;
			}
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 texColor = tex2D(_MainTex, i.uv);
				fixed3 albedo = texColor.rgb * _Color.rgb * i.colorV.rgb;
				return fixed4(albedo, texColor.a * _Color .a* i.colorV.a);
			}
			ENDCG
		}
		Pass
		{
			Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			//剔除背面
			Cull Back
			//关闭深度写入
			ZWrite Off

			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed4 _Color;
			float4 _MainTex_ST;
			struct a2v
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				fixed4 colorV : COLOR;
			};
			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOOR0;
				fixed4 colorV : COLOR0;
			};
			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.colorV = v.colorV;
				return o;
			}
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 TexColor = tex2D(_MainTex, i.uv);
				fixed3 albedo = TexColor.rgb * _Color.rgb * i.colorV.rgb;
				return fixed4(albedo, TexColor.a * _Color.a* i.colorV.a);
			}
			ENDCG
		}
	}
}
