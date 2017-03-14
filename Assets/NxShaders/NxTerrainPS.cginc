#ifndef NEOX_DEBUG_DEFERED_STATIC_LIGHT
#define NEOX_DEBUG_DEFERED_STATIC_LIGHT 0
#endif

#ifndef RAIN_ENABLE
#define RAIN_ENABLE 0
#endif

#ifndef SNOW_ENABLE
#define SNOW_ENABLE 0
#endif

#ifndef FOG_TYPE_NONE
#define FOG_TYPE_NONE 0
#endif

#ifndef FOG_TYPE_LINEAR
#define FOG_TYPE_LINEAR 1
#endif

#ifndef FOG_TYPE_HEIGHT
#define FOG_TYPE_HEIGHT 2
#endif

#ifndef FOG_TYPE
#define FOG_TYPE FOG_TYPE_LINEAR
#endif

#ifndef LIGHT_ATTR_ITEM_NUM_1
#define LIGHT_ATTR_ITEM_NUM_1 1
#endif

#ifndef LIGHT_ATTR_ITEM_NUM_2
#define LIGHT_ATTR_ITEM_NUM_2 2
#endif

#ifndef LIGHT_ATTR_ITEM_NUM_3
#define LIGHT_ATTR_ITEM_NUM_3 3
#endif

#ifndef LIGHT_ATTR_ITEM_NUM_4
#define LIGHT_ATTR_ITEM_NUM_4 4
#endif

#ifndef LIGHT_ATTR_ITEM_NUM_5
#define LIGHT_ATTR_ITEM_NUM_5 5
#endif

#ifndef LIGHT_ATTR_ITEM_NUM_6
#define LIGHT_ATTR_ITEM_NUM_6 6
#endif

#ifndef LIGHT_ATTR_ITEM_NUM_7
#define LIGHT_ATTR_ITEM_NUM_7 7
#endif

#ifndef LIGHT_ATTR_ITEM_NUM_8
#define LIGHT_ATTR_ITEM_NUM_8 8
#endif

#ifndef LIGHT_ATTR_ITEM_NUM
#define LIGHT_ATTR_ITEM_NUM LIGHT_ATTR_ITEM_NUM_5
#endif

#ifndef LIGHT_NUM_1
#define LIGHT_NUM_1 1
#endif

#ifndef LIGHT_NUM_2
#define LIGHT_NUM_2 2
#endif

#ifndef LIGHT_NUM_3
#define LIGHT_NUM_3 3
#endif

#ifndef LIGHT_NUM_4
#define LIGHT_NUM_4 4
#endif

#ifndef LIGHT_NUM_5
#define LIGHT_NUM_5 5
#endif

#ifndef LIGHT_NUM_6
#define LIGHT_NUM_6 6
#endif

#ifndef LIGHT_NUM_7
#define LIGHT_NUM_7 7
#endif

#ifndef LIGHT_NUM_8
#define LIGHT_NUM_8 8
#endif

#ifndef LIGHT_NUM
#define LIGHT_NUM LIGHT_NUM_4
#endif

#ifndef LIGHT_ATTR_ITEM_TOTAL
#define LIGHT_ATTR_ITEM_TOTAL LIGHT_ATTR_ITEM_NUM*LIGHT_NUM
#endif

#ifndef SPECULAR_ENABLE
#define SPECULAR_ENABLE 0
#endif

//float4 camera_pos;
float4 weather_intensity;
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
float4x4 ViewProjection;
#endif
float FrameTime;
#if FOG_TYPE == FOG_TYPE_LINEAR || FOG_TYPE == FOG_TYPE_HEIGHT
float4 FogColor;
#endif
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
float AlphaMtl;
#endif
float normalmap_scale;
float4 lightmap_scale;
float4 lightmap_weight;
float4 shadow_color;
//float4 ShadowLightAttr[LIGHT_ATTR_ITEM_NUM];
//float4 PointLightAttrs[LIGHT_ATTR_ITEM_NUM*LIGHT_NUM];
sampler2D sam_other0: register(s0);
#if FOG_TYPE == FOG_TYPE_HEIGHT
sampler2D sam_fog_texture: register(s1);
#endif
sampler2D sam_other1: register(s2);
sampler2D sam_other2: register(s3);
sampler2D sam_other3: register(s4);
sampler2D sam_other4: register(s5);
sampler2D sam_lightmap: register(s6);
sampler2D sam_other5: register(s7);
sampler2D sam_other6: register(s8);
sampler2D sam_other7: register(s9);
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
sampler2D sam_light_buffer: register(s10);
#endif
//struct PS_INPUT
//{
//	float4 final_position: POSITION;
//	float2 uv0: TEXCOORD0;
//	float2 uv1: TEXCOORD1;
//	float2 terrain_uv0: TEXCOORD2;
//	float4 v_texture3: TEXCOORD3;
//	float4 v_texture4: TEXCOORD4;
//	float4 v_world_position: TEXCOORD5;
//	float3 v_world_normal: TEXCOORD6;
//	float3 v_world_tangent: TEXCOORD7;
//	float3 v_world_binormal: TEXCOORD8;
//	float4 v_texture5: TEXCOORD9;
//};

#include "NxCommon.cginc"

float4 ps_main(PS_INPUT psIN) : COLOR
{
	float4 final_color;
	float2 local_0 = psIN.v_texture3.xy;
	float2 local_1 = psIN.v_texture3.zw;
	float2 local_2 = psIN.v_texture4.xy;
	float2 local_3 = psIN.v_texture4.zw;
	float4 local_4 = { local_1.x, local_1.y, local_3.x, local_3.y };
	float4 local_5 = tex2D(sam_other1, psIN.terrain_uv0);
	float4 local_6 = tex2D(sam_other2, local_0);
	float4 local_7 = tex2D(sam_other3, local_2);
	float4 local_8 = tex2D(sam_other5, psIN.terrain_uv0);
	float4 local_9 = tex2D(sam_other6, local_0);
	float4 local_10 = tex2D(sam_other7, local_2);
	float4 local_11 = tex2D(sam_other4, psIN.uv0);
	float3 local_12 = local_5.xyz;
	float local_13 = local_5.w;
	float3 local_14 = local_6.xyz;
	float local_15 = local_6.w;
	float3 local_16 = local_7.xyz;
	float local_17 = local_7.w;
	float2 local_18 = local_11.xy;
	float2 local_19 = local_11.zw;
	float3 local_20;
	float3 local_21;
	float local_22;
	calc_world_info_terrain(psIN.v_world_binormal, psIN.v_world_tangent, psIN.v_world_normal, normalmap_scale, local_8, local_9, local_10, local_18, local_20, local_21, local_22);
	float3 local_54 = camera_pos.xyz;
	float local_55 = camera_pos.w;
	float3 local_56 = psIN.v_world_position.xyz;
	float local_57 = psIN.v_world_position.w;
	float3 local_58 = local_54 - local_56;
	float3 local_59 = normalize(local_58);
	float4 local_60 = calc_terrain_diffuse_blend(local_5, local_6, local_7, local_11);
	float3 local_71 = local_60.xyz;
	float local_72 = local_60.w;
	const int local_73 = 0;
	float local_74 = weather_intensity[local_73];
	const float local_75 = 0.0f;
	const float local_76 = 1.0f;
	const int local_77 = 1;
	float local_78 = weather_intensity[local_77];
	const int local_79 = 2;
	float local_80 = weather_intensity[local_79];
	float local_81 = weather_intensity[local_77];
	float3 local_82 = local_20 - psIN.v_world_normal;
	const float local_83 = 2.0f;
	float3 local_84 = { local_83, local_83, local_83 };
	float3 local_85 = local_82 * local_84;
	float3 local_86 = { local_72, local_72, local_72 };
	float3 local_87;
	float3 local_88;
	float local_89;
	float3 local_90;
	calc_weather_info(sam_other0, FrameTime, local_20, local_85, local_71, local_86, local_56, local_22, local_74, local_75, local_76, local_78, local_80, local_81, local_87, local_88, local_89, local_90);
	float local_215 = local_90.x;
	float local_216 = local_90.y;
	float local_217 = local_90.z;
	float4 local_218 = { local_88.x, local_88.y, local_88.z, local_215 };
	float4 local_219 = gamma_correct_began(local_218);
	float4 local_223 = calc_terrain_specular(local_219);
	float3 local_232 = local_223.xyz;
	float local_233 = local_223.w;
	float3 local_234 = local_219.xyz;
	float local_235 = local_219.w;
	float3 local_236 = calc_brdf_diffuse(local_233, local_234);
	float3 local_241 = get_static_light(psIN);
	float4 local_264 = { local_241.x, local_241.y, local_241.z, local_76 };
	float3 local_265 = shadow_color.xyz;
	float local_266 = shadow_color.w;
	float3 local_267 = calc_lighting_terrain(psIN,lightmap_scale, psIN.v_texture5, local_56, local_59, local_87, local_89, local_232, local_236, local_264, local_265, local_267);

	float3 local_398 = gamma_correct_ended(local_267);
	float3 local_402 = apply_fog(psIN, local_398);
	float4 local_451 = { local_402.x, local_402.y, local_402.z, local_76 };
	final_color = local_451;
	return final_color;
}
