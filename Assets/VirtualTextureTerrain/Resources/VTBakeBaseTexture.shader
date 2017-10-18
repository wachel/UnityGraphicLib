// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/VTBakeBaseTexture"
{
	Properties
	{
		_VTMainTex0 ("Texture", 2D) = "black" {}
		_VTMainTex1 ("Texture", 2D) = "black" {}
		_VTMainTex2 ("Texture", 2D) = "black" {}
		_VTMainTex3 ("Texture", 2D) = "black" {}
		_VTMainTex4 ("Texture", 2D) = "black" {}
		_VTMainTex5 ("Texture", 2D) = "black" {}
		_VTMainTex6 ("Texture", 2D) = "black" {}
		_VTMainTex7 ("Texture", 2D) = "black" {}
		[Gamma]_VTSplatAlpha0("Splat Alpha",2D) = "black"{}
		[Gamma]_VTSplatAlpha1("Splat Alpha",2D) = "black"{}
		//_SplatIndex("SplatIndex",float) = 0
	}

	CGINCLUDE
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"

		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float2 uv : TEXCOORD0;
			float2 uv2: TEXCOORD2;
			float2 uv3: TEXCOORD3;
			float4 vertex : SV_POSITION;
		};

		float _VTSmoothness0;
		float _VTSmoothness1;
		float _VTSmoothness2;
		float _VTSmoothness3;
		float _VTSmoothness4;
		float _VTSmoothness5;
		float _VTSmoothness6;
		float _VTSmoothness7;
		sampler2D _VTMainTex0;
		sampler2D _VTMainTex1;
		sampler2D _VTMainTex2;
		sampler2D _VTMainTex3;
		sampler2D _VTMainTex4;
		sampler2D _VTMainTex5;
		sampler2D _VTMainTex6;
		sampler2D _VTMainTex7;
		sampler2D _VTSplatAlpha0;
		sampler2D _VTSplatAlpha1;
		float4 _VTSplatAlpha0_ST;
		float4 _VTSplatAlpha1_ST;
		float4 _VTMainTexST;
		float4 _VTSrcRectST;

		v2f vert(appdata v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv = v.uv * _VTSrcRectST.xy + _VTSrcRectST.zw;
			o.uv = o.uv * _VTMainTexST.xy + _VTMainTexST.zw;

			o.uv2 = TRANSFORM_TEX(v.uv, _VTSplatAlpha0);
			o.uv2 = o.uv2 * _VTSrcRectST.xy + _VTSrcRectST.zw;

			o.uv3 = TRANSFORM_TEX(v.uv, _VTSplatAlpha1);
			o.uv3 = o.uv3 * _VTSrcRectST.xy + _VTSrcRectST.zw;
			return o;
		}


	ENDCG

	SubShader
	{
		Cull Off ZWrite Off ZTest Always
		Pass//draw texture
		{
			//Blend One One
			CGPROGRAM
			fixed4 frag(v2f i) : SV_Target
			{
				half4 col0 = tex2D(_VTMainTex0, i.uv);
				half4 col1 = tex2D(_VTMainTex1, i.uv);
				half4 col2 = tex2D(_VTMainTex2, i.uv);
				half4 col3 = tex2D(_VTMainTex3, i.uv);
				half4 col4 = tex2D(_VTMainTex4, i.uv);
				half4 col5 = tex2D(_VTMainTex5, i.uv);
				half4 col6 = tex2D(_VTMainTex6, i.uv);
				half4 col7 = tex2D(_VTMainTex7, i.uv);

				half4 alpha0 = tex2D(_VTSplatAlpha0, i.uv2);
				half4 alpha1 = tex2D(_VTSplatAlpha1, i.uv3);

				half4 result = half4(0, 0, 0, 0);
				result += col0.rgba * half4(1, 1, 1, _VTSmoothness0) * alpha0.r;
				result += col1.rgba * half4(1, 1, 1, _VTSmoothness1) * alpha0.g;
				result += col2.rgba * half4(1, 1, 1, _VTSmoothness2) * alpha0.b;
				result += col3.rgba * half4(1, 1, 1, _VTSmoothness3) * alpha0.a;
				result += col4.rgba * half4(1, 1, 1, _VTSmoothness4) * alpha1.r;
				result += col5.rgba * half4(1, 1, 1, _VTSmoothness5) * alpha1.g;
				result += col6.rgba * half4(1, 1, 1, _VTSmoothness6) * alpha1.b;
				result += col7.rgba * half4(1, 1, 1, _VTSmoothness7) * alpha1.a;
				return result;
			}
			ENDCG
		}
		Pass//draw normal
		{
			//Blend One One
			CGPROGRAM
			fixed4 frag(v2f i) : SV_Target
			{
				half3 col0 = UnpackNormal(tex2D(_VTMainTex0, i.uv)) * 0.5 + 0.5;
				half3 col1 = UnpackNormal(tex2D(_VTMainTex1, i.uv)) * 0.5 + 0.5;
				half3 col2 = UnpackNormal(tex2D(_VTMainTex2, i.uv)) * 0.5 + 0.5;
				half3 col3 = UnpackNormal(tex2D(_VTMainTex3, i.uv)) * 0.5 + 0.5;
				half3 col4 = UnpackNormal(tex2D(_VTMainTex4, i.uv)) * 0.5 + 0.5;
				half3 col5 = UnpackNormal(tex2D(_VTMainTex5, i.uv)) * 0.5 + 0.5;
				half3 col6 = UnpackNormal(tex2D(_VTMainTex6, i.uv)) * 0.5 + 0.5;
				half3 col7 = UnpackNormal(tex2D(_VTMainTex7, i.uv)) * 0.5 + 0.5;

				half4 alpha0 = tex2D(_VTSplatAlpha0, i.uv2);
				half4 alpha1 = tex2D(_VTSplatAlpha1, i.uv3);

				half3 result = half3(0, 0, 0);
				result += col0.rgb * alpha0.r;
				result += col1.rgb * alpha0.g;
				result += col2.rgb * alpha0.b;
				result += col3.rgb * alpha0.a;
				result += col4.rgb * alpha1.r;
				result += col5.rgb * alpha1.g;
				result += col6.rgb * alpha1.b;
				result += col7.rgb * alpha1.a;
				return fixed4(result,1);
			}
			ENDCG
		}
	}
}
