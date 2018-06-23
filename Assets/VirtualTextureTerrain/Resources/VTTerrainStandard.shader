

Shader "Nature/Terrain/VTStandard" {
	Properties {
		// set by terrain engine
		[HideInInspector] _Control ("Control (RGBA)", 2D) = "red" {}	   //不
		[HideInInspector] _Splat3 ("Layer 3 (A)", 2D) = "white" {}		   //能
		[HideInInspector] _Splat2 ("Layer 2 (B)", 2D) = "white" {}		   //注
		[HideInInspector] _Splat1 ("Layer 1 (G)", 2D) = "white" {}		   //掉
		[HideInInspector] _Splat0 ("Layer 0 (R)", 2D) = "white" {}		   //否
		[HideInInspector] _Normal3 ("Normal 3 (A)", 2D) = "bump" {}		   //则
		[HideInInspector] _Normal2 ("Normal 2 (B)", 2D) = "bump" {}		   //法
		[HideInInspector] _Normal1 ("Normal 1 (G)", 2D) = "bump" {}		   //线
		[HideInInspector] _Normal0 ("Normal 0 (R)", 2D) = "bump" {}		   //错
		[HideInInspector] [Gamma] _Metallic0 ("Metallic 0", Range(0.0, 1.0)) = 0.0	
		[HideInInspector] [Gamma] _Metallic1 ("Metallic 1", Range(0.0, 1.0)) = 0.0	
		[HideInInspector] [Gamma] _Metallic2 ("Metallic 2", Range(0.0, 1.0)) = 0.0	
		[HideInInspector] [Gamma] _Metallic3 ("Metallic 3", Range(0.0, 1.0)) = 0.0
		[HideInInspector] _Smoothness0 ("Smoothness 0", Range(0.0, 1.0)) = 1.0	
		[HideInInspector] _Smoothness1 ("Smoothness 1", Range(0.0, 1.0)) = 1.0	
		[HideInInspector] _Smoothness2 ("Smoothness 2", Range(0.0, 1.0)) = 1.0	
		[HideInInspector] _Smoothness3 ("Smoothness 3", Range(0.0, 1.0)) = 1.0

		// used in fallback on old cards & base map
		[HideInInspector] _MainTex ("BaseMap (RGB)", 2D) = "white" {}
		[HideInInspector] _Color ("Main Color", Color) = (1,1,1,1)

		_PhysicalTex("Physical Texture", 2D) = "black" {}
		_IndirectiveTex("Indirective Texture", 2D) = "black"{}
	}

	SubShader {
		Tags {
			"Queue" = "Geometry-100"
			"RenderType" = "Opaque"
		}

		CGPROGRAM
		#pragma surface surf Standard vertex:SplatmapVert finalcolor:SplatmapFinalColor finalgbuffer:SplatmapFinalGBuffer fullforwardshadows
		#pragma multi_compile_fog
		#pragma target 3.0
		// needs more than 8 texcoords
		#pragma exclude_renderers gles
		#include "UnityPBSLighting.cginc"

		#pragma multi_compile __ _TERRAIN_NORMAL_MAP

		#define TERRAIN_STANDARD_SHADER
		#define TERRAIN_SURFACE_OUTPUT SurfaceOutputStandard
		#include "TerrainSplatmapCommon.cginc"

		half _Metallic0;
		half _Metallic1;
		half _Metallic2;
		half _Metallic3;
		
		half _Smoothness0;
		half _Smoothness1;
		half _Smoothness2;
		half _Smoothness3;

		sampler2D _IndirectiveTex;
		sampler2D _PhysicalTex;
		sampler2D _PhysicalNormal;
		float _TileSize;	//物理纹理每个tile占的uv比例
		float4 _PhysicalTex_TexelSize;
		float4 _IndirectiveTex_TexelSize;
		
		float2 GetPhysicalUV(float2 mainUV) {
			fixed4 t = tex2D(_IndirectiveTex, mainUV);//间接纹理颜色，xy为物理纹理的tile索引，2^z为格子大小
			float size = pow(2, round(t.z * 255.0));//间接纹理上当前格子的大小像素大小，最小为1，最大为_MainTex_TexelSize.zw
			float2 uv = frac(mainUV * (_IndirectiveTex_TexelSize.zw / size));//计算在间接纹理格子内的uv，范围0~1
			uv = float2(uv.x, 1 - uv.y);//反转y，试出来的
			float border = 4 / (_TileSize * _PhysicalTex_TexelSize.z);
			uv = lerp(float2(border, border), float2(1 - border, 1 - border), uv);//border，返回值类似于0.05~0.95
		
			float2 puv = round(t.xy * 255) * _TileSize;
			return puv + uv * _TileSize;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float2 puv = GetPhysicalUV(IN.tc_Control);
			fixed3 mixedNormal = tex2D(_PhysicalNormal, puv).rgb * 2 - 1;

			fixed4 mixedDiffuse = tex2D(_PhysicalTex, puv);
			o.Albedo = mixedDiffuse.rgb;
			o.Alpha = 1;
			o.Smoothness = 0;// mixedDiffuse.a;
			//o.Normal = mixedNormal;
			o.Metallic = 0;
		}
		ENDCG
	}

	Dependency "AddPassShader" = "Nature/Terrain/VTStandardAddPass"
	Dependency "BaseMapShader" = "Hidden/TerrainEngine/Splatmap/Standard-Base"

	Fallback "Nature/Terrain/Diffuse"
}
