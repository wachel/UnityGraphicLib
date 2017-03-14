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
float metallic_offset;
float roughness_offset;
float normalmap_scale;
float4 lightmap_weight;
float4 shadow_color;
//float4x4 envRot;
//float env_exposure;
#if SHADOW_MAP_ENABLE
float4 ShadowInfo;
#endif
float AlphaMtl;
//float4 ShadowLightAttr[LIGHT_ATTR_ITEM_NUM];
//float4 PointLightAttrs[LIGHT_ATTR_ITEM_NUM*LIGHT_NUM];
sampler2D sam_other0: register(s1);
#if FOG_TYPE == FOG_TYPE_HEIGHT
sampler2D sam_fog_texture: register(s2);
#endif
sampler2D sam_diffuse: register(s0);
sampler2D sam_lightmap: register(s3);
sampler2D sam_environment_reflect: register(s5);
sampler2D sam_normal: register(s6);
sampler2D sam_metallic: register(s7);
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
sampler2D sam_light_buffer: register(s8);
#endif
#if SHADOW_MAP_ENABLE
sampler sam_shadow: register(s4);
#endif
//struct PS_INPUT
//{
//	float4 final_position: POSITION;
//	float4 v_texture0: TEXCOORD0;
//	float4 v_texture1: TEXCOORD1;
//	float4 v_world_position: TEXCOORD2;
//	float3 v_world_normal: TEXCOORD3;
//	float3 v_world_tangent: TEXCOORD4;
//	float3 v_world_binormal: TEXCOORD5;
//#if SHADOW_MAP_ENABLE
//	float4 v_texture3: TEXCOORD6;
//#endif
//	float4 fog_factor_info: TEXCOORD7;
//	float3 v_texture5: TEXCOORD8;
//	float4 v_texture6: TEXCOORD9;
//};
float4 ps_main(PS_INPUT psIN) : COLOR
{
	float4 final_color;
float2 local_0 = psIN.v_texture0.xy;
float2 local_1 = psIN.v_texture0.zw;
float2 local_2 = psIN.v_texture1.xy;
float2 local_3 = psIN.v_texture1.zw;
float4 local_4 = { local_1.x, local_1.y, local_3.x, local_3.y };
float4 local_5 = tex2D(sam_diffuse, local_0);
float4 local_6 = tex2D(sam_metallic, local_0);
float3 local_7 = local_5.xyz;
float local_8 = local_5.w;
#if ALPHA_TEST_ENABLE
if (local_8 - alphaRef < 0.0)
{
	discard;
}
#else
#endif
float3 local_9;
float3 local_10;
float local_11;
float3 local_12;
// Function calc_world_info Begin 
{
	float3 local_14;
	float local_15;
	float3 local_16;
	// Function sample_normal_map_with_roughness Begin 
	{
		float4 local_18 = tex2D(sam_normal, local_0);
		float3 local_19 = local_18.xyz;
		float local_20 = local_18.w;
		const float local_21 = 2.0f;
		float3 local_22 = { local_21, local_21, local_21 };
		float3 local_23 = local_19 * local_22;
		const float local_24 = 1.0f;
		float3 local_25 = { local_24, local_24, local_24 };
		float3 local_26 = local_23 - local_25;
		float local_27;
#if SPECULAR_AA
		const float local_28 = 1.0f;
		float local_29 = length(local_26);
		float local_30 = local_28 - local_29;
		const float local_31 = 7.0f;
		float local_32 = local_30 * local_31;
		float local_33 = local_28 - local_32;
		const float local_34 = 0.0001f;
		float local_35 = clamp(local_33, local_34, local_28);
		float local_36 = (float)1.0f - local_35;
		float local_37 = local_36 / local_35;
		float local_38 = saturate(local_20);
		float local_39 = (float)1.0f - local_38;
		float local_40 = local_39 * local_37;
		float local_41 = local_28 + local_40;
		float local_42 = local_39 / local_41;
		float local_43 = (float)1.0f - local_42;
		local_27 = local_43;
#else
		local_27 = local_20;
#endif
		float local_44 = local_26.x;
		float local_45 = local_26.y;
		float local_46 = local_26.z;
		float local_47 = local_44 * normalmap_scale;
		float local_48 = local_45 * normalmap_scale;
		float3 local_49 = { local_47, local_48, local_46 };
		float local_50 = local_49.x;
		float local_51 = local_49.y;
		float local_52 = local_49.z;
		float3 local_53 = mul(psIN.v_world_binormal, local_51);
		float3 local_54 = mul(psIN.v_world_tangent, local_50);
		float3 local_55 = local_53 + local_54;
		float3 local_56 = mul(psIN.v_world_normal, local_52);
		float3 local_57 = local_55 + local_56;
		float3 local_58 = normalize(local_57);
		local_14 = local_58;
		local_15 = local_27;
		local_16 = local_26;
	}
	// Function sample_normal_map_with_roughness End
	local_9 = local_14;
	local_10 = psIN.v_world_tangent;
	local_11 = local_15;
	local_12 = local_16;
}
// Function calc_world_info End
float3 local_61 = camera_pos.xyz;
float local_62 = camera_pos.w;
float3 local_63 = psIN.v_world_position.xyz;
float local_64 = psIN.v_world_position.w;
float3 local_65 = local_61 - local_63;
float3 local_66 = normalize(local_65);
float local_67 = local_11 + roughness_offset;
float local_68 = saturate(local_67);
float local_69 = local_6.x;
float local_70 = local_6.y;
float local_71 = local_6.z;
float local_72 = local_6.w;
float local_73 = local_69 + metallic_offset;
float local_74 = saturate(local_73);
float3 local_75;
// Function gamma_correct_began Begin 
{
	float3 local_77 = local_7 * local_7;
	local_75 = local_77;
}
// Function gamma_correct_began End
const int local_79 = 0;
float local_80 = weather_intensity[local_79];
const float local_81 = 0.0f;
const float local_82 = 3.0f;
const int local_83 = 1;
float local_84 = weather_intensity[local_83];
const int local_85 = 2;
float local_86 = weather_intensity[local_85];
float local_87 = weather_intensity[local_83];
const float local_88 = 1.0f;
float3 local_89 = { local_88, local_88, local_88 };
float3 local_90;
float3 local_91;
float local_92;
float3 local_93;
// Function calc_weather_info Begin 
{
	float3 local_95;
	float3 local_96;
	float local_97;
	float3 local_98;
#if RAIN_ENABLE
	float local_99 = local_63.x;
	float local_100 = local_63.y;
	float local_101 = local_63.z;
	float local_102 = local_99 + local_100;
	float2 local_103 = { local_102, local_101 };
	const float local_104 = 0.0048f;
	float local_105 = local_104 * local_82;
	float2 local_106 = { local_105, local_105 };
	float2 local_107 = local_103 * local_106;
	const float local_108 = 0.022f;
	const float local_109 = 0.0273f;
	float2 local_110 = { local_108, local_109 };
	float2 local_111 = { FrameTime, FrameTime };
	float2 local_112 = local_110 * local_111;
	float2 local_113 = local_107 + local_112;
	float local_114 = local_101 + local_100;
	float2 local_115 = { local_99, local_114 };
	const float local_116 = 0.00378f;
	float local_117 = local_116 * local_82;
	float2 local_118 = { local_117, local_117 };
	float2 local_119 = local_115 * local_118;
	const float local_120 = 0.033f;
	const float local_121 = 0.0184f;
	float2 local_122 = { local_120, local_121 };
	float2 local_123 = { FrameTime, FrameTime };
	float2 local_124 = local_122 * local_123;
	float2 local_125 = local_119 - local_124;
	float4 local_126 = tex2D(sam_other0, local_113);
	const float local_127 = 2.0f;
	float4 local_128 = { local_127, local_127, local_127, local_127 };
	float4 local_129 = local_126 * local_128;
	const float local_130 = 1.0f;
	float4 local_131 = { local_130, local_130, local_130, local_130 };
	float4 local_132 = local_129 - local_131;
	float4 local_133 = tex2D(sam_other0, local_125);
	float4 local_134 = { local_127, local_127, local_127, local_127 };
	float4 local_135 = local_133 * local_134;
	float4 local_136 = { local_130, local_130, local_130, local_130 };
	float4 local_137 = local_135 - local_136;
	float4 local_138 = local_132 * local_137;
	float local_139 = local_82 * local_84;
	float4 local_140 = { local_139, local_139, local_139, local_139 };
	float4 local_141 = local_138 * local_140;
	float local_142 = local_141.x;
	float local_143 = local_141.y;
	float local_144 = local_141.z;
	float local_145 = local_141.w;
	const float local_146 = 0.0f;
	float3 local_147 = { local_142, local_146, local_143 };
	float3 local_148 = local_9 + local_147;
	float3 local_149 = normalize(local_148);
	const float local_150 = 0.7f;
	const float local_151 = 0.3f;
	float local_152 = lerp(local_146, local_151, local_11);
	float local_153 = local_150 + local_152;
	const float local_154 = 0.4f;
	float local_155 = lerp(local_130, local_154, local_153);
	float local_156 = lerp(local_130, local_155, local_80);
	float local_157 = lerp(local_81, local_11, local_156);
	float local_158 = lerp(local_130, local_155, local_80);
	float3 local_159 = mul(local_158, local_75);
	local_95 = local_149;
	local_96 = local_159;
	local_97 = local_157;
	local_98 = local_89;
#else
	local_95 = local_9;
	local_96 = local_75;
	local_97 = local_11;
	local_98 = local_89;
#endif
	float3 local_160;
	float3 local_161;
	float local_162;
	float3 local_163;
#if SNOW_ENABLE
	float2 local_164 = local_12.xy;
	float local_165 = local_12.z;
	float local_166 = dot(local_164, local_164);
	const float local_167 = 0.1f;
	float local_168 = local_166 + local_167;
	const float local_169 = 2.0f;
	float local_170 = local_168 * local_169;
	float local_171 = local_96.x;
	float local_172 = local_96.y;
	float local_173 = local_96.z;
	float local_174 = max(local_171, local_172);
	float local_175 = max(local_174, local_173);
	float local_176 = min(local_171, local_172);
	float local_177 = min(local_176, local_173);
	const float local_178 = 1.0f;
	const float local_179 = 0.01f;
	float local_180 = local_179 + local_175;
	float local_181 = local_177 / local_180;
	float local_182 = local_178 - local_181;
	const float local_183 = 0.0f;
	float local_184 = local_95.x;
	float local_185 = local_95.y;
	float local_186 = local_95.z;
	float local_187 = local_185 - local_183;
	float local_188 = local_178 - local_183;
	float local_189 = local_187 / local_188;
	float local_190 = saturate(local_189);
	float local_191 = local_190 + local_167;
	float local_192 = local_178 - local_86;
	float local_193 = local_178 / local_192;
	float local_194 = local_193 - local_178;
	float local_195 = local_194 * local_182;
	float local_196 = local_195 * local_170;
	float local_197 = local_196 * local_191;
	float local_198 = saturate(local_197);
	float local_199 = local_198 + local_179;
	const float local_200 = 0.8f;
	float local_201 = local_200 * local_87;
	float local_202 = pow(local_199, local_201);
	float3 local_203 = { local_202, local_202, local_202 };
	float3 local_204 = { local_198, local_198, local_198 };
	float3 local_205 = lerp(local_96, local_203, local_204);
	const float local_206 = 0.5f;
	float3 local_207 = { local_206, local_206, local_206 };
	float3 local_208 = { local_198, local_198, local_198 };
	float3 local_209 = lerp(local_98, local_207, local_208);
	float local_210 = local_86 * local_87;
	float local_211 = lerp(local_11, local_170, local_210);
	float local_212 = local_182 * local_182;
	float local_213 = local_211 + local_212;
	float local_214 = local_178 - local_212;
	float local_215 = local_86 * local_214;
	float local_216 = lerp(local_97, local_213, local_215);
	local_160 = local_95;
	local_161 = local_205;
	local_162 = local_216;
	local_163 = local_209;
#else
	local_160 = local_95;
	local_161 = local_96;
	local_162 = local_97;
	local_163 = local_98;
#endif
	local_90 = local_160;
	local_91 = local_161;
	local_92 = local_162;
	local_93 = local_163;
}
// Function calc_weather_info End
float3 local_218;
// Function calc_brdf_diffuse Begin 
{
	float local_220 = (float)1.0f - local_74;
	float3 local_221 = mul(local_91, local_220);
	local_218 = local_221;
}
// Function calc_brdf_diffuse End
float3 local_223;
// Function calc_brdf_specular Begin 
{
	const float local_225 = 0.04f;
	float3 local_226 = { local_225, local_225, local_225 };
	float3 local_227 = { local_74, local_74, local_74 };
	float3 local_228 = lerp(local_226, local_91, local_227);
	local_223 = local_228;
}
// Function calc_brdf_specular End
float local_230;
#if SHADOW_MAP_ENABLE
float2 local_231 = ShadowInfo.xy;
float local_232 = ShadowInfo.z;
float local_233 = ShadowInfo.w;
const int local_234 = 3;
float4 local_235 = ShadowLightAttr[local_234];
float local_236;
// Function calc_shadowmap Begin 
{
	float2 local_238 = psIN.v_texture3.xy;
	float2 local_239 = psIN.v_texture3.zw;
	float local_240;
#if SYSTEM_DEPTH_RANGE_NEGATIVE
	float2 local_241 = psIN.v_texture3.xy;
	float local_242 = psIN.v_texture3.z;
	float local_243 = psIN.v_texture3.w;
	const float local_244 = 0.5f;
	float local_245 = local_242 * local_244;
	float local_246 = local_245 + local_244;
	local_240 = local_246;
#else
	float2 local_247 = psIN.v_texture3.xy;
	float local_248 = psIN.v_texture3.z;
	float local_249 = psIN.v_texture3.w;
	local_240 = local_248;
#endif
	float3 local_250 = local_235.xyz;
	float local_251 = local_235.w;
	float3 local_252 = -(local_250);
	float local_253 = dot(psIN.v_world_normal, local_252);
	float local_254 = saturate(local_253);
	const float local_255 = 0.001f;
	const float local_256 = 0.01f;
	const float local_257 = 1.0f;
	float local_258 = local_257 - local_254;
	float local_259 = local_256 * local_258;
	float local_260 = local_255 + local_259;
	float local_261 = local_240 - local_260;
	float4 local_262 = { local_238.x, local_238.y, local_261, local_257 };
	float local_263 = tex2Dproj(sam_shadow, local_262).x;
	float local_264 = local_238.x;
	float local_265 = local_238.y;
	float local_266 = local_257 - local_264;
	float local_267 = local_257 - local_265;
	float4 local_268 = { local_264, local_266, local_265, local_267 };
	float4 local_269 = sign(local_268);
	const float local_270 = 3.5f;
	float4 local_271 = { local_257, local_257, local_257, local_257 };
	float local_272 = dot(local_269, local_271);
	float local_273 = step(local_270, local_272);
	float local_274 = local_257 - local_273;
	float local_275 = local_263 + local_274;
	const float local_276 = 0.0f;
	float local_277 = clamp(local_275, local_276, local_257);
	float3 local_278 = psIN.v_texture3.xyz;
	float local_279 = psIN.v_texture3.w;
	float local_280 = local_232 * local_279;
	float local_281 = local_257 - local_280;
	float local_282 = lerp(local_281, local_257, local_277);
	local_236 = local_282;
}
// Function calc_shadowmap End
local_230 = local_236;
#else
const float local_284 = 1.0f;
local_230 = local_284;
#endif
float3 local_285;
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
float4 local_286 = mul(psIN.v_world_position, ViewProjection);
float2 local_287 = local_286.xy;
float2 local_288 = local_286.zw;
float3 local_289 = local_286.xyz;
float local_290 = local_286.w;
float2 local_291 = { local_290, local_290 };
float2 local_292 = local_287 / local_291;
const float local_293 = 0.5f;
float2 local_294 = { local_293, local_293 };
float2 local_295 = local_292 * local_294;
float2 local_296 = { local_293, local_293 };
float2 local_297 = local_295 + local_296;
float local_298 = local_297.x;
float local_299 = local_297.y;
const float local_300 = 1.0f;
float local_301 = local_300 - local_299;
float2 local_302 = { local_298, local_301 };
float4 local_303 = tex2D(sam_light_buffer, local_302);
float3 local_304 = local_303.xyz;
float local_305 = local_303.w;
local_285 = local_304;
#else
const float local_306 = 0.0f;
float3 local_307 = { local_306, local_306, local_306 };
local_285 = local_307;
#endif
float4 local_308 = { local_285.x, local_285.y, local_285.z, local_230 };
float3 local_309 = shadow_color.xyz;
float local_310 = shadow_color.w;
float3 local_311;
// Function calc_lighting_common_metallic Begin 
{
	float4 local_313 = { local_223.x, local_223.y, local_223.z, 0.0f };
	const int local_314 = 1;
	float4 local_315 = ShadowLightAttr[local_314];
	const int local_316 = 3;
	float4 local_317 = ShadowLightAttr[local_316];
	float3 local_318;
	float3 local_319;
	// Function shadow_light_char Begin 
	{
		float3 local_321 = local_317.xyz;
		float local_322 = local_317.w;
		float3 local_323 = -(local_321);
		float local_324 = dot(local_90, local_323);
		float local_325 = saturate(local_324);
		float3 local_326 = local_315.xyz;
		float local_327 = local_315.w;
		float3 local_328 = mul(local_326, local_325);
		float3 local_329;
#if SPECULAR_ENABLE
		float3 local_330 = local_313.xyz;
		float local_331 = local_313.w;
		float3 local_332;
		// Function calc_brdf_specular_factor_char Begin 
		{
			float3 local_334 = -(local_321);
			float3 local_335 = local_66 + local_334;
			float3 local_336 = normalize(local_335);
			float local_337 = dot(local_90, local_334);
			float local_338 = saturate(local_337);
			float local_339 = dot(local_90, local_336);
			float local_340 = saturate(local_339);
			float local_341 = dot(local_334, local_336);
			float local_342 = saturate(local_341);
			float local_343 = local_68 * local_68;
			const float local_344 = 0.002f;
			float local_345 = max(local_343, local_344);
			float local_346 = local_345 * local_345;
			float local_347 = local_340 * local_346;
			float local_348 = local_347 - local_340;
			float local_349 = local_348 * local_340;
			const float local_350 = 1.0f;
			float local_351 = local_349 + local_350;
			const float local_352 = 3.141593f;
			float local_353 = local_352 * local_351;
			float local_354 = local_353 * local_351;
			float local_355 = local_346 / local_354;
			const float local_356 = 4.0f;
			float local_357 = local_356 * local_342;
			float local_358 = local_357 * local_342;
			const float local_359 = 0.5f;
			float local_360 = local_68 + local_359;
			float local_361 = local_358 * local_360;
			float local_362 = local_350 / local_361;
			float local_363 = local_362 * local_355;
			float local_364 = local_363 * local_338;
			float3 local_365 = { local_364, local_364, local_364 };
			float3 local_366 = local_365 * local_330;
			local_332 = local_366;
		}
		// Function calc_brdf_specular_factor_char End
		float3 local_368 = local_326 * local_332;
		local_329 = local_368;
#else
		const float local_369 = 0.0f;
		float3 local_370 = { local_369, local_369, local_369 };
		local_329 = local_370;
#endif
		local_318 = local_328;
		local_319 = local_329;
	}
	// Function shadow_light_char End
	float3 local_372;
	float3 local_373;
	// Function calc_lightmap Begin 
	{
		float4 local_375;
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
		float3 local_376 = local_308.xyz;
		float local_377 = local_308.w;
		const float local_378 = 1.0f;
		float local_379 = local_378 - local_377;
		const float local_380 = 256.0f;
		float local_381 = local_379 * local_380;
		float local_382 = saturate(local_381);
		float local_383 = local_378 - local_382;
		float4 local_384 = { local_376.x, local_376.y, local_376.z, local_383 };
		local_375 = local_384;
#else
		float4 local_385 = tex2D(sam_lightmap, local_2);
		float local_386 = local_4.x;
		float3 local_387 = local_4.yzw;
		const float local_388 = 1.0f;
		float4 local_389 = { local_387.x, local_387.y, local_387.z, local_388 };
		float4 local_390 = local_385 * local_389;
		local_375 = local_390;
#endif
		const float local_391 = 1.0f;
		float3 local_392 = local_375.xyz;
		float local_393 = local_375.w;
		float local_394 = local_391 - local_393;
		float3 local_395 = { local_394, local_394, local_394 };
		float3 local_396 = local_309 * local_395;
		const float local_397 = 0.1f;
		float local_398 = max(local_397, local_393);
		float3 local_399 = mul(local_318, local_398);
		float local_400 = lightmap_weight.x;
		float local_401 = lightmap_weight.y;
		float local_402 = lightmap_weight.z;
		float local_403 = lightmap_weight.w;
		float3 local_404 = { local_400, local_400, local_400 };
		float3 local_405 = local_399 * local_404;
		float3 local_406 = { local_401, local_401, local_401 };
		float3 local_407 = local_392 * local_406;
		float3 local_408 = local_405 + local_407;
		float3 local_409 = local_408 + local_396;
		const float local_410 = 0.05f;
		float local_411 = max(local_393, local_410);
		float3 local_412 = mul(local_319, local_411);
		float3 local_413 = { local_400, local_400, local_400 };
		float3 local_414 = local_412 * local_413;
		local_372 = local_409;
		local_373 = local_414;
	}
	// Function calc_lightmap End
	float4 local_416 = PointLightAttrs[local_314];
	float4 local_417 = PointLightAttrs[local_316];
	float local_418 = psIN.v_texture6.x;
	float local_419 = psIN.v_texture6.y;
	float local_420 = psIN.v_texture6.z;
	float local_421 = psIN.v_texture6.w;
	float3 local_422;
	float3 local_423;
	// Function point_light_char Begin 
	{
		float local_425 = local_416.x;
		float local_426 = local_416.y;
		float local_427 = local_416.z;
		float local_428 = local_416.w;
		float local_429 = local_425 + local_426;
		float local_430 = local_429 + local_427;
		float3 local_431;
		float3 local_432;
		if (local_430 == 0.0)
		{
			const float local_433 = 0.0f;
			float3 local_434 = { local_433, local_433, local_433 };
			float3 local_435 = { local_433, local_433, local_433 };
			local_431 = local_434;
			local_432 = local_435;
		}
		else
		{
			float3 local_436 = local_417.xyz;
			float local_437 = local_417.w;
			float3 local_438 = local_63 - local_436;
			float3 local_439 = normalize(local_438);
			float3 local_440 = -(local_439);
			float local_441 = dot(local_90, local_440);
			float local_442 = saturate(local_441);
			float3 local_443 = local_416.xyz;
			float local_444 = local_416.w;
			float3 local_445 = mul(local_443, local_442);
			float3 local_446 = mul(local_445, local_418);
			float3 local_447;
#if SPECULAR_ENABLE
			float3 local_448 = local_313.xyz;
			float local_449 = local_313.w;
			float3 local_450;
			// Function calc_brdf_specular_factor_char Begin 
			{
				float3 local_452 = -(local_439);
				float3 local_453 = local_66 + local_452;
				float3 local_454 = normalize(local_453);
				float local_455 = dot(local_90, local_452);
				float local_456 = saturate(local_455);
				float local_457 = dot(local_90, local_454);
				float local_458 = saturate(local_457);
				float local_459 = dot(local_452, local_454);
				float local_460 = saturate(local_459);
				float local_461 = local_68 * local_68;
				const float local_462 = 0.002f;
				float local_463 = max(local_461, local_462);
				float local_464 = local_463 * local_463;
				float local_465 = local_458 * local_464;
				float local_466 = local_465 - local_458;
				float local_467 = local_466 * local_458;
				const float local_468 = 1.0f;
				float local_469 = local_467 + local_468;
				const float local_470 = 3.141593f;
				float local_471 = local_470 * local_469;
				float local_472 = local_471 * local_469;
				float local_473 = local_464 / local_472;
				const float local_474 = 4.0f;
				float local_475 = local_474 * local_460;
				float local_476 = local_475 * local_460;
				const float local_477 = 0.5f;
				float local_478 = local_68 + local_477;
				float local_479 = local_476 * local_478;
				float local_480 = local_468 / local_479;
				float local_481 = local_480 * local_473;
				float local_482 = local_481 * local_456;
				float3 local_483 = { local_482, local_482, local_482 };
				float3 local_484 = local_483 * local_448;
				local_450 = local_484;
			}
			// Function calc_brdf_specular_factor_char End
			float3 local_486 = local_443 * local_450;
			float3 local_487 = mul(local_486, local_418);
			local_447 = local_487;
#else
			const float local_488 = 0.0f;
			float3 local_489 = { local_488, local_488, local_488 };
			local_447 = local_489;
#endif
			local_431 = local_446;
			local_432 = local_447;
		}
		local_422 = local_431;
		local_423 = local_432;
	}
	// Function point_light_char End
	const int local_491 = 6;
	float4 local_492 = PointLightAttrs[local_491];
	const int local_493 = 8;
	float4 local_494 = PointLightAttrs[local_493];
	float3 local_495;
	float3 local_496;
	// Function point_light_char Begin 
	{
		float local_498 = local_492.x;
		float local_499 = local_492.y;
		float local_500 = local_492.z;
		float local_501 = local_492.w;
		float local_502 = local_498 + local_499;
		float local_503 = local_502 + local_500;
		float3 local_504;
		float3 local_505;
		if (local_503 == 0.0)
		{
			const float local_506 = 0.0f;
			float3 local_507 = { local_506, local_506, local_506 };
			float3 local_508 = { local_506, local_506, local_506 };
			local_504 = local_507;
			local_505 = local_508;
		}
		else
		{
			float3 local_509 = local_494.xyz;
			float local_510 = local_494.w;
			float3 local_511 = local_63 - local_509;
			float3 local_512 = normalize(local_511);
			float3 local_513 = -(local_512);
			float local_514 = dot(local_90, local_513);
			float local_515 = saturate(local_514);
			float3 local_516 = local_492.xyz;
			float local_517 = local_492.w;
			float3 local_518 = mul(local_516, local_515);
			float3 local_519 = mul(local_518, local_419);
			float3 local_520;
#if SPECULAR_ENABLE
			float3 local_521 = local_313.xyz;
			float local_522 = local_313.w;
			float3 local_523;
			// Function calc_brdf_specular_factor_char Begin 
			{
				float3 local_525 = -(local_512);
				float3 local_526 = local_66 + local_525;
				float3 local_527 = normalize(local_526);
				float local_528 = dot(local_90, local_525);
				float local_529 = saturate(local_528);
				float local_530 = dot(local_90, local_527);
				float local_531 = saturate(local_530);
				float local_532 = dot(local_525, local_527);
				float local_533 = saturate(local_532);
				float local_534 = local_68 * local_68;
				const float local_535 = 0.002f;
				float local_536 = max(local_534, local_535);
				float local_537 = local_536 * local_536;
				float local_538 = local_531 * local_537;
				float local_539 = local_538 - local_531;
				float local_540 = local_539 * local_531;
				const float local_541 = 1.0f;
				float local_542 = local_540 + local_541;
				const float local_543 = 3.141593f;
				float local_544 = local_543 * local_542;
				float local_545 = local_544 * local_542;
				float local_546 = local_537 / local_545;
				const float local_547 = 4.0f;
				float local_548 = local_547 * local_533;
				float local_549 = local_548 * local_533;
				const float local_550 = 0.5f;
				float local_551 = local_68 + local_550;
				float local_552 = local_549 * local_551;
				float local_553 = local_541 / local_552;
				float local_554 = local_553 * local_546;
				float local_555 = local_554 * local_529;
				float3 local_556 = { local_555, local_555, local_555 };
				float3 local_557 = local_556 * local_521;
				local_523 = local_557;
			}
			// Function calc_brdf_specular_factor_char End
			float3 local_559 = local_516 * local_523;
			float3 local_560 = mul(local_559, local_419);
			local_520 = local_560;
#else
			const float local_561 = 0.0f;
			float3 local_562 = { local_561, local_561, local_561 };
			local_520 = local_562;
#endif
			local_504 = local_519;
			local_505 = local_520;
		}
		local_495 = local_504;
		local_496 = local_505;
	}
	// Function point_light_char End
	const int local_564 = 11;
	float4 local_565 = PointLightAttrs[local_564];
	const int local_566 = 13;
	float4 local_567 = PointLightAttrs[local_566];
	float3 local_568;
	float3 local_569;
	// Function point_light_char Begin 
	{
		float local_571 = local_565.x;
		float local_572 = local_565.y;
		float local_573 = local_565.z;
		float local_574 = local_565.w;
		float local_575 = local_571 + local_572;
		float local_576 = local_575 + local_573;
		float3 local_577;
		float3 local_578;
		if (local_576 == 0.0)
		{
			const float local_579 = 0.0f;
			float3 local_580 = { local_579, local_579, local_579 };
			float3 local_581 = { local_579, local_579, local_579 };
			local_577 = local_580;
			local_578 = local_581;
		}
		else
		{
			float3 local_582 = local_567.xyz;
			float local_583 = local_567.w;
			float3 local_584 = local_63 - local_582;
			float3 local_585 = normalize(local_584);
			float3 local_586 = -(local_585);
			float local_587 = dot(local_90, local_586);
			float local_588 = saturate(local_587);
			float3 local_589 = local_565.xyz;
			float local_590 = local_565.w;
			float3 local_591 = mul(local_589, local_588);
			float3 local_592 = mul(local_591, local_420);
			float3 local_593;
#if SPECULAR_ENABLE
			float3 local_594 = local_313.xyz;
			float local_595 = local_313.w;
			float3 local_596;
			// Function calc_brdf_specular_factor_char Begin 
			{
				float3 local_598 = -(local_585);
				float3 local_599 = local_66 + local_598;
				float3 local_600 = normalize(local_599);
				float local_601 = dot(local_90, local_598);
				float local_602 = saturate(local_601);
				float local_603 = dot(local_90, local_600);
				float local_604 = saturate(local_603);
				float local_605 = dot(local_598, local_600);
				float local_606 = saturate(local_605);
				float local_607 = local_68 * local_68;
				const float local_608 = 0.002f;
				float local_609 = max(local_607, local_608);
				float local_610 = local_609 * local_609;
				float local_611 = local_604 * local_610;
				float local_612 = local_611 - local_604;
				float local_613 = local_612 * local_604;
				const float local_614 = 1.0f;
				float local_615 = local_613 + local_614;
				const float local_616 = 3.141593f;
				float local_617 = local_616 * local_615;
				float local_618 = local_617 * local_615;
				float local_619 = local_610 / local_618;
				const float local_620 = 4.0f;
				float local_621 = local_620 * local_606;
				float local_622 = local_621 * local_606;
				const float local_623 = 0.5f;
				float local_624 = local_68 + local_623;
				float local_625 = local_622 * local_624;
				float local_626 = local_614 / local_625;
				float local_627 = local_626 * local_619;
				float local_628 = local_627 * local_602;
				float3 local_629 = { local_628, local_628, local_628 };
				float3 local_630 = local_629 * local_594;
				local_596 = local_630;
			}
			// Function calc_brdf_specular_factor_char End
			float3 local_632 = local_589 * local_596;
			float3 local_633 = mul(local_632, local_420);
			local_593 = local_633;
#else
			const float local_634 = 0.0f;
			float3 local_635 = { local_634, local_634, local_634 };
			local_593 = local_635;
#endif
			local_577 = local_592;
			local_578 = local_593;
		}
		local_568 = local_577;
		local_569 = local_578;
	}
	// Function point_light_char End
	const int local_637 = 16;
	float4 local_638 = PointLightAttrs[local_637];
	const int local_639 = 18;
	float4 local_640 = PointLightAttrs[local_639];
	float3 local_641;
	float3 local_642;
	// Function point_light_char Begin 
	{
		float local_644 = local_638.x;
		float local_645 = local_638.y;
		float local_646 = local_638.z;
		float local_647 = local_638.w;
		float local_648 = local_644 + local_645;
		float local_649 = local_648 + local_646;
		float3 local_650;
		float3 local_651;
		if (local_649 == 0.0)
		{
			const float local_652 = 0.0f;
			float3 local_653 = { local_652, local_652, local_652 };
			float3 local_654 = { local_652, local_652, local_652 };
			local_650 = local_653;
			local_651 = local_654;
		}
		else
		{
			float3 local_655 = local_640.xyz;
			float local_656 = local_640.w;
			float3 local_657 = local_63 - local_655;
			float3 local_658 = normalize(local_657);
			float3 local_659 = -(local_658);
			float local_660 = dot(local_90, local_659);
			float local_661 = saturate(local_660);
			float3 local_662 = local_638.xyz;
			float local_663 = local_638.w;
			float3 local_664 = mul(local_662, local_661);
			float3 local_665 = mul(local_664, local_421);
			float3 local_666;
#if SPECULAR_ENABLE
			float3 local_667 = local_313.xyz;
			float local_668 = local_313.w;
			float3 local_669;
			// Function calc_brdf_specular_factor_char Begin 
			{
				float3 local_671 = -(local_658);
				float3 local_672 = local_66 + local_671;
				float3 local_673 = normalize(local_672);
				float local_674 = dot(local_90, local_671);
				float local_675 = saturate(local_674);
				float local_676 = dot(local_90, local_673);
				float local_677 = saturate(local_676);
				float local_678 = dot(local_671, local_673);
				float local_679 = saturate(local_678);
				float local_680 = local_68 * local_68;
				const float local_681 = 0.002f;
				float local_682 = max(local_680, local_681);
				float local_683 = local_682 * local_682;
				float local_684 = local_677 * local_683;
				float local_685 = local_684 - local_677;
				float local_686 = local_685 * local_677;
				const float local_687 = 1.0f;
				float local_688 = local_686 + local_687;
				const float local_689 = 3.141593f;
				float local_690 = local_689 * local_688;
				float local_691 = local_690 * local_688;
				float local_692 = local_683 / local_691;
				const float local_693 = 4.0f;
				float local_694 = local_693 * local_679;
				float local_695 = local_694 * local_679;
				const float local_696 = 0.5f;
				float local_697 = local_68 + local_696;
				float local_698 = local_695 * local_697;
				float local_699 = local_687 / local_698;
				float local_700 = local_699 * local_692;
				float local_701 = local_700 * local_675;
				float3 local_702 = { local_701, local_701, local_701 };
				float3 local_703 = local_702 * local_667;
				local_669 = local_703;
			}
			// Function calc_brdf_specular_factor_char End
			float3 local_705 = local_662 * local_669;
			float3 local_706 = mul(local_705, local_421);
			local_666 = local_706;
#else
			const float local_707 = 0.0f;
			float3 local_708 = { local_707, local_707, local_707 };
			local_666 = local_708;
#endif
			local_650 = local_665;
			local_651 = local_666;
		}
		local_641 = local_650;
		local_642 = local_651;
	}
	// Function point_light_char End
	float3 local_710 = local_372 + local_422;
	float3 local_711 = local_710 + local_495;
	float3 local_712 = local_711 + local_568;
	float3 local_713 = local_712 + local_641;
	float3 local_714 = local_373 + local_423;
	float3 local_715 = local_714 + local_496;
	float3 local_716 = local_715 + local_569;
	float3 local_717 = local_716 + local_642;
	float3 local_718 = local_713 * local_218;
	float3 local_719 = local_718 + local_717;
	local_311 = local_719;
}
// Function calc_lighting_common_metallic End
float3 local_721;
// Function calc_brdf_env_specular_sim Begin 
{
	float3 local_723 = reflect(local_66, local_90);
	float3 local_724 = -(local_723);
	float3x3 local_725 = (float3x3)envRot;
	float3 local_726 = mul(local_724, local_725);
	float3 local_727 = normalize(local_726);
	float local_728 = dot(local_90, local_66);
	float local_729 = saturate(local_728);
	float local_730;
	if (local_68 < 0.05)
	{
		const float local_731 = 0.0f;
		local_730 = local_731;
	}
	else
	{
		const float local_732 = 9.0f;
		float local_733 = local_732 * local_68;
		local_730 = local_733;
		const float local_734 = 1.0f;
		float local_735 = local_734 - local_729;
		const float local_736 = 0.01f;
		float local_737 = local_68 + local_736;
		float local_738 = local_734 / local_737;
		float local_739 = pow(local_735, local_738);
		float local_740 = local_739 * local_733;
		const float local_741 = 0.3f;
		float local_742 = local_740 * local_741;
		const float local_743 = 3.0f;
		float local_744 = min(local_742, local_743);
		float local_745 = local_733 - local_744;
		const float local_746 = 0.0f;
		float local_747 = max(local_745, local_746);
	}
	float3 local_748;
	// Function env_sample_lod_sim Begin 
	{
		const float local_750 = 0.0f;
		const float local_751 = 9.0f;
		float local_752 = clamp(local_730, local_750, local_751);
		float local_753 = local_727.x;
		float local_754 = local_727.y;
		float local_755 = local_727.z;
		float2 local_756 = { local_753, local_755 };
		float local_757 = length(local_756);
		float local_758;
		if (local_757>0.0000001)
		{
			float local_759 = local_753 / local_757;
			local_758 = local_759;
		}
		else
		{
			const float local_760 = 0.0f;
			local_758 = local_760;
		}
		float2 local_761 = { local_758, local_754 };
		float2 local_762 = acos(local_761);
		const float local_763 = 0.3183099f;
		float2 local_764 = mul(local_762, local_763);
		float local_765 = local_764.x;
		float local_766 = local_764.y;
		const float local_767 = 0.5f;
		float local_768 = local_765 * local_767;
		float local_769;
		if (local_755 > 0.0)
		{
			local_769 = local_768;
		}
		else
		{
			const float local_770 = 1.0f;
			float local_771 = local_770 - local_768;
			local_769 = local_771;
		}
		float2 local_772 = { local_769, local_766 };
		float4 local_773 = tex2Dlod(sam_environment_reflect, float4(local_772.x, local_772.y, 0.0f, local_752));
		float3 local_774 = local_773.xyz;
		float local_775 = local_773.w;
		const float local_776 = 14.48538f;
		float local_777 = local_775 * local_776;
		const float local_778 = 3.621346f;
		float local_779 = local_777 - local_778;
		float local_780 = exp2(local_779);
		float3 local_781 = mul(local_774, local_780);
		local_748 = local_781;
	}
	// Function env_sample_lod_sim End
	float3 local_783;
	// Function env_approx Begin 
	{
		const float local_785 = 1.0f;
		float local_786 = -(local_785);
		const float local_787 = 0.0275f;
		float local_788 = -(local_787);
		const float local_789 = 0.572f;
		float local_790 = -(local_789);
		const float local_791 = 0.022f;
		float4 local_792 = { local_786, local_788, local_790, local_791 };
		const float local_793 = 0.0425f;
		const float local_794 = 1.04f;
		const float local_795 = 0.04f;
		float local_796 = -(local_795);
		float4 local_797 = { local_785, local_793, local_794, local_796 };
		float local_798 = -(local_794);
		float2 local_799 = { local_798, local_794 };
		float4 local_800 = mul(local_792, local_68);
		float4 local_801 = local_800 + local_797;
		float local_802 = local_801.x;
		float local_803 = local_801.y;
		float local_804 = local_801.z;
		float local_805 = local_801.w;
		float local_806 = local_802 * local_802;
		const float local_807 = 9.28f;
		float local_808 = -(local_807);
		float local_809 = local_808 * local_729;
		float local_810 = exp2(local_809);
		float local_811 = min(local_806, local_810);
		float local_812 = local_811 * local_802;
		float local_813 = local_812 + local_803;
		float2 local_814 = mul(local_799, local_813);
		float2 local_815 = local_801.xy;
		float2 local_816 = local_801.zw;
		float2 local_817 = local_814 + local_816;
		float local_818 = local_817.x;
		float local_819 = local_817.y;
		float3 local_820 = mul(local_223, local_818);
		float3 local_821 = { local_819, local_819, local_819 };
		float3 local_822 = local_820 + local_821;
		local_783 = local_822;
	}
	// Function env_approx End
	float3 local_824 = local_748 * local_783;
	local_721 = local_824;
}
// Function calc_brdf_env_specular_sim End
float3 local_826 = psIN.v_texture5 * local_218;
float3 local_827 = local_311 + local_826;
float3 local_828 = mul(local_721, env_exposure);
float3 local_829 = local_827 + local_828;
float3 local_830 = mul(local_829, local_230);
float3 local_831;
// Function gamma_correct_ended Begin 
{
	float3 local_833 = sqrt(local_830);
	local_831 = local_833;
}
// Function gamma_correct_ended End
float3 local_835;
#if FOG_TYPE==FOG_TYPE_NONE
local_835 = local_831;
#elif FOG_TYPE==FOG_TYPE_LINEAR
float local_836 = psIN.fog_factor_info.x;
float local_837 = psIN.fog_factor_info.y;
float local_838 = psIN.fog_factor_info.z;
float local_839 = psIN.fog_factor_info.w;
float3 local_840;
// Function calc_fog Begin 
{
	float3 local_842 = FogColor.xyz;
	float local_843 = FogColor.w;
	float local_844 = local_836 * local_843;
	float3 local_845 = { local_844, local_844, local_844 };
	float3 local_846 = lerp(local_831, local_842, local_845);
	local_840 = local_846;
}
// Function calc_fog End
local_835 = local_840;
#elif FOG_TYPE==FOG_TYPE_HEIGHT
float local_848;
// Function calc_cylindrical_u Begin 
{
	float2 local_850 = local_66.xy;
	float local_851 = local_66.z;
	float local_852 = local_66.x;
	float local_853 = local_66.y;
	float local_854 = local_66.z;
	float local_855 = atan2(local_851, local_852);
	const float local_856 = 0.159f;
	float local_857 = local_855 * local_856;
	const float local_858 = 0.5f;
	float local_859 = local_857 + local_858;
	float local_860 = (float)1.0f - local_859;
	local_848 = local_860;
}
// Function calc_cylindrical_u End
float3 local_862;
// Function calc_fog_textured Begin 
{
	float3 local_864 = psIN.fog_factor_info.xyz;
	float local_865 = psIN.fog_factor_info.w;
	float local_866 = local_848 + local_865;
	float local_867 = psIN.fog_factor_info.x;
	float local_868 = psIN.fog_factor_info.y;
	float2 local_869 = psIN.fog_factor_info.zw;
	float2 local_870 = { local_866, local_868 };
	float4 local_871 = tex2D(sam_fog_texture, local_870);
	float3 local_872 = local_871.xyz;
	float local_873 = local_871.w;
	float3 local_874 = FogColor.xyz;
	float local_875 = FogColor.w;
	float2 local_876 = psIN.fog_factor_info.xy;
	float local_877 = psIN.fog_factor_info.z;
	float local_878 = psIN.fog_factor_info.w;
	float3 local_879 = { local_877, local_877, local_877 };
	float3 local_880 = lerp(local_872, local_874, local_879);
	float3 local_881 = { local_867, local_867, local_867 };
	float3 local_882 = lerp(local_831, local_880, local_881);
	local_862 = local_882;
}
// Function calc_fog_textured End
local_835 = local_862;
#endif
float local_884 = local_8 * AlphaMtl;
float4 local_885 = { local_835.x, local_835.y, local_835.z, local_884 };
final_color = local_885;
return final_color;
}
