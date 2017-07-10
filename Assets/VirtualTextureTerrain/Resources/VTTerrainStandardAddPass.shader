Shader "Nature/Terrain/VTStandardAddPass" {
	Properties {
		// set by terrain engine
		//[HideInInspector] _Control ("Control (RGBA)", 2D) = "red" {}
		//[HideInInspector] _Splat3 ("Layer 3 (A)", 2D) = "white" {}
		//[HideInInspector] _Splat2 ("Layer 2 (B)", 2D) = "white" {}
		//[HideInInspector] _Splat1 ("Layer 1 (G)", 2D) = "white" {}
		//[HideInInspector] _Splat0 ("Layer 0 (R)", 2D) = "white" {}
		//[HideInInspector] _Normal3 ("Normal 3 (A)", 2D) = "bump" {}
		//[HideInInspector] _Normal2 ("Normal 2 (B)", 2D) = "bump" {}
		//[HideInInspector] _Normal1 ("Normal 1 (G)", 2D) = "bump" {}
		//[HideInInspector] _Normal0 ("Normal 0 (R)", 2D) = "bump" {}
		//[HideInInspector] [Gamma] _Metallic0 ("Metallic 0", Range(0.0, 1.0)) = 0.0	
		//[HideInInspector] [Gamma] _Metallic1 ("Metallic 1", Range(0.0, 1.0)) = 0.0	
		//[HideInInspector] [Gamma] _Metallic2 ("Metallic 2", Range(0.0, 1.0)) = 0.0	
		//[HideInInspector] [Gamma] _Metallic3 ("Metallic 3", Range(0.0, 1.0)) = 0.0
		//[HideInInspector] _Smoothness0 ("Smoothness 0", Range(0.0, 1.0)) = 1.0	
		//[HideInInspector] _Smoothness1 ("Smoothness 1", Range(0.0, 1.0)) = 1.0	
		//[HideInInspector] _Smoothness2 ("Smoothness 2", Range(0.0, 1.0)) = 1.0	
		//[HideInInspector] _Smoothness3 ("Smoothness 3", Range(0.0, 1.0)) = 1.0
	}

	SubShader {
		Tags {
			"Queue" = "Geometry-99"
			"IgnoreProjector"="True"
			"RenderType" = "Opaque"
		}

		Cull Front	//防止画出来
		ZTest Less	//防止画出来

		CGPROGRAM
		#pragma surface surf Standard decal:add vertex:SplatmapVert finalcolor:SplatmapFinalColor finalgbuffer:SplatmapFinalGBuffer fullforwardshadows
		#pragma multi_compile_fog
		#pragma target 3.0
		// needs more than 8 texcoords
		#pragma exclude_renderers gles
		#include "UnityPBSLighting.cginc"

		#pragma multi_compile __ _TERRAIN_NORMAL_MAP

		#define TERRAIN_SPLAT_ADDPASS
		#define TERRAIN_STANDARD_SHADER
		#define TERRAIN_SURFACE_OUTPUT SurfaceOutputStandard
		#include "TerrainSplatmapCommon.cginc"

		void surf (Input IN, inout SurfaceOutputStandard o) {
			o.Albedo = fixed3(0,0,0);
			o.Alpha = 0;
			o.Smoothness = 0;
			o.Metallic = 0;
		}
		ENDCG
	}

	Fallback "Hidden/TerrainEngine/Splatmap/Diffuse-AddPass"
}
