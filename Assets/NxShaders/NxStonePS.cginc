#ifndef NEOX_DEBUG_DEFERED_STATIC_LIGHT
#define NEOX_DEBUG_DEFERED_STATIC_LIGHT 0
#endif

#ifndef RAIN_ENABLE
#define RAIN_ENABLE 0
#endif

#ifndef SNOW_ENABLE
#define SNOW_ENABLE 0
#endif

#ifndef ALPHA_TEST_ENABLE
#define ALPHA_TEST_ENABLE 0
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

#ifndef SHADOW_MAP_ENABLE
#define SHADOW_MAP_ENABLE 0
#endif

#ifndef SPECULAR_ENABLE
#define SPECULAR_ENABLE 0
#endif

#ifndef SPECULAR_AA
#define SPECULAR_AA 0
#endif

#ifndef SYSTEM_DEPTH_RANGE_NEGATIVE
#define SYSTEM_DEPTH_RANGE_NEGATIVE 0
#endif

#ifndef XRAY_EX_ENABLE
#define XRAY_EX_ENABLE 0
#endif

#if XRAY_EX_ENABLE
float4x4 View;
#endif
//float4 camera_pos;
#if ALPHA_TEST_ENABLE
float alphaRef;
#endif
#if FOG_TYPE == FOG_TYPE_LINEAR || FOG_TYPE == FOG_TYPE_HEIGHT
float4 FogColor;
#endif
float4 weather_intensity;
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
//float4x4 ViewProjection;
#endif
float FrameTime;
float roughness_offset;
float normalmap_scale;
float4 lightmap_weight;
float4 shadow_color;
#if SHADOW_MAP_ENABLE
float4 ShadowInfo;
#endif
float AlphaMtl;
//float4 ShadowLightAttr[LIGHT_ATTR_ITEM_NUM];
//float4 PointLightAttrs[LIGHT_ATTR_ITEM_NUM*LIGHT_NUM];
#if XRAY_EX_ENABLE
float4 xray_color;
#endif
#if XRAY_EX_ENABLE
float xray_strength;
#endif
#if XRAY_EX_ENABLE
float xray_cycle;
#endif
#if XRAY_EX_ENABLE
float xray_pow_offset;
#endif
#if XRAY_EX_ENABLE
float xray_u;
#endif
#if XRAY_EX_ENABLE
float xray_v;
#endif
#if FOG_TYPE == FOG_TYPE_HEIGHT
sampler2D sam_fog_texture: register(s1);
#endif
sampler2D sam_other0: register(s2);
sampler2D sam_diffuse: register(s0);
sampler2D sam_lightmap: register(s3);
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
sampler2D sam_light_buffer: register(s5);
#endif
sampler2D sam_normal: register(s6);
sampler2D sam_metallic: register(s7);
#if SHADOW_MAP_ENABLE
sampler sam_shadow: register(s4);
#endif
#if XRAY_EX_ENABLE
sampler2D sam_other1: register(s8);
#endif
//struct PS_INPUT
//{
//	float4 final_position: POSITION;
//	float2 uv0: TEXCOORD0;
//	float2 uv1: TEXCOORD1;
//	float4 v_world_position: TEXCOORD2;
//	float3 v_world_normal: TEXCOORD3;
//	float3 v_world_tangent: TEXCOORD4;
//	float3 v_world_binormal: TEXCOORD5;
//#if SHADOW_MAP_ENABLE
//	float4 v_texture3: TEXCOORD6;
//#endif
//	float4 fog_factor_info: TEXCOORD7;
//	float4 v_texture2: TEXCOORD8;
//	float4 v_texture5: TEXCOORD9;
//};

#include "NxCommon.cginc"

float4 ps_main(PS_INPUT psIN) : COLOR
{
	float4 final_color;
	float4 diffuse_rgba = tex2D(sam_diffuse, psIN.uv0);
	float4 metallic_rgba = tex2D(sam_metallic, psIN.uv0);
	float3 diffuse_rgb = diffuse_rgba.xyz;
	float diffuse_a = diffuse_rgba.w;
	float3 metallic_rgb = metallic_rgba.xyz;
	float metallic_a = metallic_rgba.w;
	#if ALPHA_TEST_ENABLE
	if (diffuse_a - alphaRef < 0.0)
	{
		discard;
	}
	#else
	#endif
	float3 local_6;//world_normal
	float3 local_7;//world_tangent
	float local_8;//normal.a
	float3 local_9;//unpacked_normal
	calc_world_info(psIN, sam_normal, normalmap_scale,psIN.uv0, psIN.v_world_binormal, psIN.v_world_tangent, psIN.v_world_normal, local_6, local_7, local_8, local_9);
	float3 local_58 = camera_pos.xyz;
	float local_59 = camera_pos.w;
	float3 local_60 = psIN.v_world_position.xyz;
	float local_61 = psIN.v_world_position.w;
	float3 local_62 = local_58 - local_60;
	float3 local_63 = normalize(local_62);
	float local_64 = local_8 + roughness_offset;
	float local_65 = saturate(local_64);
	float local_67 = weather_intensity[0];
	const float local_68 = 0.0f;
	const float local_69 = 1.0f;
	float local_71 = weather_intensity[1];
	float local_73 = weather_intensity[2];
	float local_74 = weather_intensity[1];
	float3 local_75;//world_normal
	float3 local_76;//diffuse_rgb
	float local_77;//roughness
	float3 local_78;//metallic_rgb
	calc_weather_info(sam_other0, FrameTime,local_6,local_9,diffuse_rgb,metallic_rgb,local_60,local_65,local_67,local_68,local_69,local_71,local_73,local_74, local_75, local_76, local_77,local_78);

	float3 local_203 = gamma_correct_began(local_76);//diffuse_rgb
	float3 local_207 = gamma_correct_began(local_78);//metallic_rgb

	float3 local_211 = calc_brdf_diffuse_common(local_203, local_207);
	float local_218 = get_shadow_map_light(psIN);

	float3 local_273 = get_static_light(psIN);
	float4 local_296 = { local_273.xyz, local_218 };
	float3 local_297 = shadow_color.xyz;
	float local_298 = shadow_color.w;
	float3 local_299 = calc_lighting_common(psIN,psIN.v_texture5,psIN.v_texture2, local_60, local_63, local_75, local_77, local_207,local_211, local_296, local_297);
	float3 local_493 = get_xray_color(psIN);
	float3 local_580 = local_299 + local_493;
	float3 local_581 = gamma_correct_ended(local_580);

	float3 local_585 = apply_fog(psIN, local_581);
	float local_634 = diffuse_a * AlphaMtl;
	float4 local_635 = { local_585.x, local_585.y, local_585.z, local_634 };
	final_color = local_635;
	return final_color;
}
