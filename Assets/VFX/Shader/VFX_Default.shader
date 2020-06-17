Shader "_VFX/Default/OneFace_Alpha"
{
	Properties
	{
		[HDR]_Color("MainColor",Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Pass
		{
			Tags { "RenderType" = "Transparent"  "Queue" = "Transparent"  "IgnoreProjuector " = "True"}
			Cull Back
			Zwrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed4 _Color;
			fixed4 _MainTex_ST;
			struct a2v
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
				float4 color:COLOR;
			};
			struct v2f
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float4 colorV : COLOR0;
			};
			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.colorV = v.color;
				return o;
			}
			fixed4 frag(v2f i):SV_Target
			{
				fixed4 texColor = tex2D(_MainTex, i.uv);
				fixed3 albedo = texColor.rgb * _Color.rgb * i.colorV.rgb;
				return fixed4(albedo, _Color.a * texColor.a * i.colorV.a);
			}
			ENDCG
		}
	}
}
