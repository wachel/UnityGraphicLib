Shader "Nature/Terrain/VTDiffuse" {
	Properties {
		[HideInInspector] _Control ("Control (RGBA)", 2D) = "red" {}	  //不
		[HideInInspector] _Splat3 ("Layer 3 (A)", 2D) = "white" {}		  //能
		[HideInInspector] _Splat2 ("Layer 2 (B)", 2D) = "white" {}		  //注
		[HideInInspector] _Splat1 ("Layer 1 (G)", 2D) = "white" {}		  //掉
		[HideInInspector] _Splat0 ("Layer 0 (R)", 2D) = "white" {}		  //否
		[HideInInspector] _Normal3 ("Normal 3 (A)", 2D) = "bump" {}		  //则
		[HideInInspector] _Normal2 ("Normal 2 (B)", 2D) = "bump" {}		  //法
		[HideInInspector] _Normal1 ("Normal 1 (G)", 2D) = "bump" {}		  //线
		[HideInInspector] _Normal0 ("Normal 0 (R)", 2D) = "bump" {}		  //错
		// used in fallback on old cards & base map
		[HideInInspector] _MainTex ("BaseMap (RGB)", 2D) = "white" {}
		[HideInInspector] _Color ("Main Color", Color) = (1,1,1,1)

		_PhysicalTex("Physical Texture", 2D) = "black" {}
		_IndirectiveTex("Indirective Texture", 2D) = "black"{}
	}

	CGINCLUDE
		#pragma surface surf M1Lightmap vertex:SplatmapVert finalcolor:SplatmapFinalColor finalprepass:SplatmapFinalPrepass finalgbuffer:SplatmapFinalGBuffer
		#pragma multi_compile_fog
		#include "TerrainSplatmapCommon.cginc"

		sampler2D _IndirectiveTex;
		sampler2D _PhysicalTex;
		sampler2D _PhysicalNormal;
		float _TileSize;	//物理纹理每个tile占的uv比例
		float4 _PhysicalTex_TexelSize;
		float4 _IndirectiveTex_TexelSize;

		half4 LightingM1Lightmap(SurfaceOutput s, half3 lightDir, half atten)
		{
			return half4(1, 1, 1, 1);
		}

		float2 GetPhysicalUV(float2 mainUV) {
			fixed4 t = tex2D(_IndirectiveTex, mainUV);//间接纹理颜色，xy为物理纹理的tile索引，2^z为格子大小
			half size = pow(2, round(t.z * 255.0));//间接纹理上当前格子的大小像素大小，最小为1，最大为_MainTex_TexelSize.zw
			float2 uv = frac(mainUV * (_IndirectiveTex_TexelSize.zw / size));//计算在间接纹理格子内的uv，范围0~1
			uv.y = 1 - uv.y;//反转y，试出来的
			float border = 4 / (_TileSize * _PhysicalTex_TexelSize.z);
			uv = lerp(float2(border, border), float2(1 - border, 1 - border), uv);//border，返回值类似于0.05~0.95

			float2 puv = round(t.xy * 255) * _TileSize;
			return puv + uv * _TileSize;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			float2 puv = GetPhysicalUV(IN.tc_Control);
			fixed4 mixedDiffuse = tex2D(_PhysicalTex, puv);
			fixed3 mixedNormal = tex2D(_PhysicalNormal, puv).rgb * 2 - 1;
			o.Albedo = mixedDiffuse.rgb;
			o.Normal = mixedNormal;
			o.Alpha = 1;
		}

	ENDCG

	Category {
		Tags {
			"Queue" = "Geometry-99"
			"RenderType" = "Opaque"
		}
		SubShader { // for sm3.0+ targets
			CGPROGRAM
				#pragma target 3.0
				#pragma multi_compile __ _TERRAIN_NORMAL_MAP
			ENDCG
		}
		SubShader { // for sm2.0 targets
			CGPROGRAM
			ENDCG
		}
	}

	Dependency "AddPassShader" = "Nature/Terrain/VTDiffuseAddPass"
	Dependency "BaseMapShader" = "Diffuse"
	Dependency "Details0"      = "Hidden/TerrainEngine/Details/Vertexlit"
	Dependency "Details1"      = "Hidden/TerrainEngine/Details/WavingDoublePass"
	Dependency "Details2"      = "Hidden/TerrainEngine/Details/BillboardWavingDoublePass"
	Dependency "Tree0"         = "Hidden/TerrainEngine/BillboardTree"

	Fallback "Diffuse"
}
