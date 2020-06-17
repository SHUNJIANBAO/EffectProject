Shader "_VFX/Default/DoubleFaceBicolor"
{
	Properties
	{
		[HDR]_FrontColor("FrontColor",Color) = (1,1,1,1)
		[HDR]_BackColor("BackColor",Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Pass
		{
			Tags{"Queue" = "Transparent" "RanderType" = "Transparent" "IgnoreProjuector" = "True"}
			Cull Front
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _BackColor;

			struct a2v 
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
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
				fixed4 colorTex = tex2D(_MainTex,i.uv);
				fixed3 albedo = colorTex.rgb * _BackColor.rgb * i.colorV.rgb;
				fixed alpha = colorTex.a * _BackColor.a * i.colorV.a;
				return fixed4(albedo, alpha);
			}
				ENDCG
	}
		Pass
			{
				Tags{"RanderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjuector" = "True"}
				Cull Back
				ZWrite Off
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				sampler2D _MainTex;
				float4 _MainTex_ST;
				fixed4 _FrontColor;
				struct a2v
				{
					float4 vertex : POSITION;
					float2 texcoord :TEXCOORD0;
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
					fixed4 texColor = tex2D(_MainTex,i.uv);
					fixed3 albedo = texColor.rgb * i.colorV.rgb * _FrontColor.rgb;
					fixed alpha = texColor.a * i.colorV.a * _FrontColor.a;
					return fixed4(albedo, alpha);
				}
				ENDCG
		}
	}
}
