Shader "Unlit/NxTerrain"
{
	Properties
	{
		sam_other0("sam_other0", 2D) = "white" {}
		sam_lightmap("sam_lightmap", 2D) = "white" {}
		sam_other1("sam_other1", 2D) = "white" {}
		sam_other2("sam_other2", 2D) = "white" {}
		sam_other3("sam_other3", 2D) = "white" {}
		sam_other4("sam_other4", 2D) = "white" {}
		sam_other5("sam_other5", 2D) = "white" {}
		sam_other6("sam_other6", 2D) = "white" {}
		sam_other7("sam_other7", 2D) = "white" {}
		//sam_fog_texture("sam_fog_texture", 2D) = "white" {}
		//sam_shadow("sam_shadow", 2D) = "white" {}
		//sam_light_buffer("sam_light_buffer", 2D) = "white" {}
		//sam_normal("sam_normal", 2D) = "white" {}
		//sam_metallic("sam_metallic", 2D) = "white" {}
		//sam_other1("sam_other1", 2D) = "white" {}
		//sam_environment_reflect("sam_environment_reflect", 2D) = "white" {}
		weather_intensity("weather_intensity",Vector) = (0,0,0,0)

			
		//lightmap_weight("lightmap_weight",Vector) = (1,0,0,0)
		//shadow_color("shadow_color",Color) = (0,0,0,0)
		//lightmap_scale("lightmap_scale",Vector) = (1,1,1,1)
		normalmap_scale("normalmap_scale",float) = 1
		ShadowLightAttr0("ShadowLightAttr0",Vector) = (0,0,0,0)
		//ShadowLightAttr1("ShadowLightAttr1",Vector) = (2, 1.890196, 1.733333,3)
		ShadowLightAttr2("ShadowLightAttr2",Vector) = (0,0,0,0)

		[Toggle(NEOX_DEBUG_DEFERED_STATIC_LIGHT)] NEOX_DEBUG_DEFERED_STATIC_LIGHT("NEOX_DEBUG_DEFERED_STATIC_LIGHT", float) = 0
		[Toggle(LIGHT_MAP_ENABLE)] LIGHT_MAP_ENABLE("LIGHT_MAP_ENABLE", float) = 1
		[Toggle(SHADOW_MAP_ENABLE)] SHADOW_MAP_ENABLE("SHADOW_MAP_ENABLE", float) = 0
		[Toggle(SPECULAR_ENABLE)] SPECULAR_ENABLE("SPECULAR_ENABLE", float) = 1
		[Toggle(RAIN_ENABLE)] RAIN_ENABLE("RAIN_ENABLE", float) = 0
		[Toggle(SNOW_ENABLE)] SNOW_ENABLE("SNOW_ENABLE", float) = 0
		[Toggle(SPECULAR_TEST)] SPECULAR_TEST("SPECULAR_TEST", float) = 0

		[KeywordEnum(NONE,LINEAR,HEIGHT)] _FOG_TYPE("FOG_TYPE",float) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#pragma shader_feature LIGHT_MAP_ENABLE
			#pragma shader_feature SHADOW_MAP_ENABLE
			#pragma shader_feature NEOX_DEBUG_DEFERED_STATIC_LIGHT
			#pragma multi_compile _FOG_TYPE_NONE _FOG_TYPE_LINEAR _FOG_TYPE_HEIGHT
			#pragma shader_feature GPU_SKIN_ENABLE
			#pragma shader_feature RAIN_ENABLE
			#pragma shader_feature SNOW_ENABLE
			#pragma shader_feature SPECULAR_ENABLE
			#pragma shader_feature SPECULAR_TEST
			#include "UnityCG.cginc"

			#include "NxDefine.cginc"
			#define _LIGHT_ATTR_ITEM_NUM_5
			#define _LIGHT_NUM_4

			#include "NxTerrainVS.cginc"
			#include "NxTerrainPS.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				//float2 uv2 : TEXCOORD2;
				//float2 uv3 : TEXCOORD3;
				float4 normal:NORMAL;
				float4 tangent:TANGENT;
			};

			#include "NxFunc.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			PS_INPUT vert (appdata v)
			{
				VS_INPUT vi;

				vi.pos_local = v.vertex;
				vi.a_texture0 = float4(v.uv, 0, 0);
				vi.a_texture1 = float4(v.uv1, 0, 0);
				vi.nor_local = v.normal;
				vi.a_tangent = v.tangent;

				uv_transform = float4(4, 8, 8, 1);
				InitVSVariables();

				return vs_main(vi);
			}

			
			fixed4 frag (PS_INPUT i) : SV_Target
			{
				InitPSVariables();
				FrameTime = _Time.y;
				return ps_main(i);

			}
			ENDCG
		}
	}
}
