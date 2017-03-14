#ifndef NEOX_DEBUG_DEFERED_STATIC_LIGHT
#define NEOX_DEBUG_DEFERED_STATIC_LIGHT 0
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
float4 weather_intensity;
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
//float4x4 ViewProjection;
#endif
#if FOG_TYPE == FOG_TYPE_LINEAR || FOG_TYPE == FOG_TYPE_HEIGHT
float4 FogColor;
#endif
float4 lightmap_weight;
float4 shadow_color;
#if SHADOW_MAP_ENABLE
float4 ShadowInfo;
#endif
float AlphaMtl;
//float4 ShadowLightAttr[LIGHT_ATTR_ITEM_NUM];
float4 PointLightAttrs[LIGHT_ATTR_ITEM_NUM*LIGHT_NUM];
#if XRAY_EX_ENABLE
float FrameTime;
#endif
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
sampler2D sam_diffuse: register(s0);
sampler2D sam_lightmap: register(s2);
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
sampler2D sam_light_buffer: register(s3);
#endif
#if SHADOW_MAP_ENABLE
sampler sam_shadow: register(s4);
#endif
#if XRAY_EX_ENABLE
sampler2D sam_other0: register(s5);
#endif
//struct PS_INPUT
//{
//	float4 final_position: POSITION;
//	float2 uv0: TEXCOORD0;
//	float2 uv1: TEXCOORD1;
//	float4 v_world_position: TEXCOORD2;
//	float3 v_world_normal: TEXCOORD3;
//#if SHADOW_MAP_ENABLE
//	float4 v_texture3: TEXCOORD4;
//#endif
//	float4 fog_factor_info: TEXCOORD5;
//	float4 v_texture5: TEXCOORD6;
//};

#include "NxCommon.cginc"

float4 ps_main(PS_INPUT psIN) : COLOR
{
	float4 final_color;
	float4 local_0 = tex2D(sam_diffuse, psIN.uv0);
	float3 local_1 = local_0.xyz;
	float local_2 = local_0.w;
	float3 local_3 = gamma_correct_began(local_1);
	float local_8 = weather_intensity[2];
	float3 local_9 = apply_snow_low(psIN.v_world_normal, local_3, local_8);
	#if ALPHA_TEST_ENABLE
	if (local_2 - alphaRef < 0.0)
	{
		discard;
	}
	#else
	#endif
	float local_53 = get_shadow_map_light(psIN);
	float3 local_108 = get_static_light(psIN);
	float4 local_131 = { local_108.xyz, local_53 };
	float3 local_134 = calc_lighting_common_low(psIN,psIN.v_texture5, local_9, psIN.v_world_position, local_131, shadow_color.xyz);
	float3 local_243 = get_xray_color(psIN);
	float3 local_330 = local_134 + local_243;
	float3 local_331 = gamma_correct_ended(local_330);
	float3 local_335 = apply_fog(psIN,local_331);
	float local_384 = local_2 * AlphaMtl;
	float4 local_385 = { local_335.xyz, local_384 };
	final_color = local_385;
	return final_color;
}
