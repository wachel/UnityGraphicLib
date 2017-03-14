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
#define SPECULAR_ENABLE 1
#endif

#ifndef SPECULAR_AA
#define SPECULAR_AA 1
#endif

#ifndef SYSTEM_DEPTH_RANGE_NEGATIVE
#define SYSTEM_DEPTH_RANGE_NEGATIVE 0
#endif

float4x4 View;
//float4 camera_pos;
#if ALPHA_TEST_ENABLE
float alphaRef;
#endif
#if FOG_TYPE == FOG_TYPE_LINEAR || FOG_TYPE == FOG_TYPE_HEIGHT
float4 FogColor;
#endif
float character_light_factor;
float change_color_bright_add;
float4 bright_color;
float change_color_bright;
float u_speed;
float v_speed;
float change_color_scaled;
float4 tint_color1;
float4 tint_color2;
float metallic_offset;
float roughness_offset;
float normalmap_scale;
float sss_warp0;
float4 sss_scatter_color0;
float sss_scatter0;
float4x4 envSHR;
float4x4 envSHG;
float4x4 envSHB;
float4x4 envRot;
float env_exposure;
#if SHADOW_MAP_ENABLE
float4 ShadowInfo;
#endif
#if SHADOW_MAP_ENABLE
float4 ShadowBlendAll;
#endif
float AlphaMtl;
float bloom_switch;
float point_light_scale;
//float4 PointLightAttrs[LIGHT_ATTR_ITEM_NUM*LIGHT_NUM];
float FrameTime;
#if FOG_TYPE == FOG_TYPE_HEIGHT
sampler2D sam_fog_texture: register(s1);
#endif
sampler2D sam_diffuse: register(s0);
sampler2D sam_environment_reflect: register(s2);
sampler2D sam_other0: register(s3);
sampler2D sam_normal: register(s5);
sampler2D sam_metallic: register(s6);
#if SHADOW_MAP_ENABLE
sampler sam_shadow: register(s4);
#endif
sampler2D sam_other1: register(s7);
//struct PS_INPUT
//{
//	float4 final_position: POSITION;
//	float2 uv0: TEXCOORD0;
//	float4 v_world_position: TEXCOORD1;
//	float3 v_world_normal: TEXCOORD2;
//	float3 v_world_tangent: TEXCOORD3;
//	float3 v_world_binormal: TEXCOORD4;
//#if SHADOW_MAP_ENABLE
//	float4 v_texture3: TEXCOORD5;
//#endif
//	float4 fog_factor_info: TEXCOORD6;
//	float4 v_texture6: TEXCOORD7;
//	float4 v_texture1: TEXCOORD8;
//	float4 v_texture2: TEXCOORD9;
//};
float4 ps_main(PS_INPUT psIN) : COLOR
{
	float4 final_color;
float4 local_0 = tex2D(sam_diffuse, psIN.uv0);
float4 local_1 = tex2D(sam_other0, psIN.uv0);
float4 local_2 = tex2D(sam_metallic, psIN.uv0);
float2 local_3 = { u_speed, v_speed };
float2 local_4 = { FrameTime, FrameTime };
float2 local_5 = local_3 * local_4;
float2 local_6 = psIN.uv0 + local_5;
float4 local_7 = tex2D(sam_other1, local_6);
float3 local_8 = local_7.xyz;
float local_9 = local_7.w;
float3 local_10 = local_1.xyz;
float local_11 = local_1.w;
float3 local_12 = local_0.xyz;
float local_13 = local_0.w;
#if ALPHA_TEST_ENABLE
if (local_13 - alphaRef < 0.0)
{
	discard;
}
#else
#endif
float3 local_14;
float3 local_15;
float local_16;
float3 local_17;
// Function calc_world_info Begin 
{
	float3 local_19;
	float local_20;
	float3 local_21;
	// Function sample_normal_map_with_roughness Begin 
	{
		float4 local_23 = tex2D(sam_normal, psIN.uv0);
		float3 local_24 = local_23.xyz;
		float local_25 = local_23.w;
		const float local_26 = 2.0f;
		float3 local_27 = { local_26, local_26, local_26 };
		float3 local_28 = local_24 * local_27;
		const float local_29 = 1.0f;
		float3 local_30 = { local_29, local_29, local_29 };
		float3 local_31 = local_28 - local_30;
		float local_32;
#if SPECULAR_AA
		const float local_33 = 1.0f;
		float local_34 = length(local_31);
		float local_35 = local_33 - local_34;
		const float local_36 = 7.0f;
		float local_37 = local_35 * local_36;
		float local_38 = local_33 - local_37;
		const float local_39 = 0.0001f;
		float local_40 = clamp(local_38, local_39, local_33);
		float local_41 = (float)1.0f - local_40;
		float local_42 = local_41 / local_40;
		float local_43 = saturate(local_25);
		float local_44 = (float)1.0f - local_43;
		float local_45 = local_44 * local_42;
		float local_46 = local_33 + local_45;
		float local_47 = local_44 / local_46;
		float local_48 = (float)1.0f - local_47;
		local_32 = local_48;
#else
		local_32 = local_25;
#endif
		float local_49 = local_31.x;
		float local_50 = local_31.y;
		float local_51 = local_31.z;
		float local_52 = local_49 * normalmap_scale;
		float local_53 = local_50 * normalmap_scale;
		float3 local_54 = { local_52, local_53, local_51 };
		float local_55 = local_54.x;
		float local_56 = local_54.y;
		float local_57 = local_54.z;
		float3 local_58 = mul(psIN.v_world_binormal, local_56);
		float3 local_59 = mul(psIN.v_world_tangent, local_55);
		float3 local_60 = local_58 + local_59;
		float3 local_61 = mul(psIN.v_world_normal, local_57);
		float3 local_62 = local_60 + local_61;
		float3 local_63 = normalize(local_62);
		local_19 = local_63;
		local_20 = local_32;
		local_21 = local_31;
	}
	// Function sample_normal_map_with_roughness End
	local_14 = local_19;
	local_15 = psIN.v_world_tangent;
	local_16 = local_20;
	local_17 = local_21;
}
// Function calc_world_info End
float3 local_66 = camera_pos.xyz;
float local_67 = camera_pos.w;
float3 local_68 = psIN.v_world_position.xyz;
float local_69 = psIN.v_world_position.w;
float3 local_70 = local_66 - local_68;
float3 local_71 = normalize(local_70);
float3x3 local_72 = (float3x3)View;
float3 local_73 = mul(local_14, local_72);
float3 local_74 = normalize(local_73);
float2 local_75 = local_74.xy;
float local_76 = local_74.z;
const float local_77 = 0.5f;
float local_78 = -(local_77);
float2 local_79 = { local_77, local_78 };
float2 local_80 = local_75 * local_79;
float2 local_81 = { local_77, local_77 };
float2 local_82 = local_80 + local_81;
float3 local_83;
// Function calc_brdf_env_diffuse Begin 
{
	float3x3 local_85 = (float3x3)envRot;
	float3 local_86 = mul(local_14, local_85);
	float3 local_87 = normalize(local_86);
	const float local_88 = 1.0f;
	float4 local_89 = { local_87.x, local_87.y, local_87.z, local_88 };
	float4 local_90 = mul(local_89, envSHR);
	float local_91 = dot(local_89, local_90);
	float4 local_92 = mul(local_89, envSHG);
	float local_93 = dot(local_89, local_92);
	float4 local_94 = mul(local_89, envSHB);
	float local_95 = dot(local_89, local_94);
	float3 local_96 = { local_91, local_93, local_95 };
	float3 local_97 = mul(local_96, env_exposure);
	local_83 = local_97;
}
// Function calc_brdf_env_diffuse End
float local_99 = local_16 + roughness_offset;
float local_100 = saturate(local_99);
float local_101 = local_2.x;
float local_102 = local_2.y;
float local_103 = local_2.z;
float local_104 = local_2.w;
float local_105 = local_101 + metallic_offset;
float local_106 = saturate(local_105);
float3 local_107;
// Function gamma_correct_began Begin 
{
	float3 local_109 = local_12 * local_12;
	local_107 = local_109;
}
// Function gamma_correct_began End
float2 local_111 = local_1.xy;
float2 local_112 = local_1.zw;
float3 local_113;
// Function calc_change_color Begin 
{
	const float local_115 = 0.299f;
	const float local_116 = 0.587f;
	const float local_117 = 0.114f;
	float3 local_118 = { local_115, local_116, local_117 };
	float local_119 = dot(local_107, local_118);
	const float local_120 = 0.01f;
	float local_121 = local_119 + local_120;
	float3 local_122 = tint_color1.xyz;
	float local_123 = tint_color1.w;
	float local_124 = local_121 / local_123;
	float3 local_125 = mul(local_122, local_124);
	const float local_126 = 3.0f;
	float3 local_127 = mul(local_125, local_126);
	float local_128 = local_111.x;
	float local_129 = local_111.y;
	float3 local_130 = mul(local_127, local_128);
	float3 local_131 = { local_128, local_128, local_128 };
	float3 local_132 = lerp(local_107, local_130, local_131);
	float local_133 = dot(local_132, local_118);
	float local_134 = local_133 + local_120;
	float3 local_135 = tint_color2.xyz;
	float local_136 = tint_color2.w;
	float local_137 = local_134 / local_136;
	float3 local_138 = mul(local_135, local_137);
	float3 local_139 = mul(local_138, local_126);
	float3 local_140 = mul(local_139, local_129);
	float3 local_141 = { local_129, local_129, local_129 };
	float3 local_142 = lerp(local_132, local_140, local_141);
	local_113 = local_142;
}
// Function calc_change_color End
float3 local_144;
// Function calc_brdf_diffuse Begin 
{
	float local_146 = (float)1.0f - local_106;
	float3 local_147 = mul(local_113, local_146);
	local_144 = local_147;
}
// Function calc_brdf_diffuse End
float3 local_149;
// Function calc_brdf_specular Begin 
{
	const float local_151 = 0.04f;
	float3 local_152 = { local_151, local_151, local_151 };
	float3 local_153 = { local_106, local_106, local_106 };
	float3 local_154 = lerp(local_152, local_113, local_153);
	local_149 = local_154;
}
// Function calc_brdf_specular End
float local_156;
float local_157;
#if SHADOW_MAP_ENABLE
float local_158;
// Function calc_shadowmap_character Begin 
{
	float local_160 = ShadowBlendAll.x;
	float local_161 = ShadowBlendAll.y;
	float2 local_162 = ShadowBlendAll.zw;
	const float local_163 = 1.0f;
	float3 local_164 = psIN.v_texture3.xyz;
	float local_165 = psIN.v_texture3.w;
	float local_166 = local_163 - local_165;
	float local_167 = local_161 * local_166;
	const float local_168 = 0.0005f;
	float local_169 = clamp(local_167, local_168, local_161);
	float2 local_170 = psIN.v_texture3.xy;
	float2 local_171 = psIN.v_texture3.zw;
	float2 local_172 = psIN.v_texture3.xy;
	float local_173 = psIN.v_texture3.z;
	float local_174 = psIN.v_texture3.w;
	float local_175 = local_173 - local_169;
	float local_176;
#if SYSTEM_DEPTH_RANGE_NEGATIVE
	const float local_177 = 0.5f;
	float local_178 = local_175 * local_177;
	float local_179 = local_178 + local_177;
	local_176 = local_179;
#else
	local_176 = local_175;
#endif
	float4 local_180 = { local_170.x, local_170.y, local_176, local_163 };
	float local_181 = tex2Dproj(sam_shadow, local_180).x;
	float local_182 = local_170.x;
	float local_183 = local_170.y;
	float local_184 = local_163 - local_182;
	float local_185 = local_163 - local_183;
	float4 local_186 = { local_182, local_184, local_183, local_185 };
	float4 local_187 = sign(local_186);
	const float local_188 = 3.5f;
	float4 local_189 = { local_163, local_163, local_163, local_163 };
	float local_190 = dot(local_187, local_189);
	float local_191 = step(local_188, local_190);
	float local_192 = local_163 - local_191;
	float local_193 = local_181 + local_192;
	const float local_194 = 0.0f;
	float local_195 = clamp(local_193, local_194, local_163);
	local_158 = local_195;
}
// Function calc_shadowmap_character End
float3 local_197 = psIN.v_texture3.xyz;
float local_198 = psIN.v_texture3.w;
const float local_199 = 1.0f;
float local_200 = local_199 - local_158;
float local_201 = local_198 * local_200;
float local_202 = local_199 - local_201;
local_156 = local_158;
local_157 = local_202;
#else
const float local_203 = 1.0f;
local_156 = local_203;
local_157 = local_203;
#endif
float3 local_204;
float3 local_205;
// Function calc_lighting_player Begin 
{
	float4 local_207 = { local_149.x, local_149.y, local_149.z, 0.0f };
	float3 local_208;
	float3 local_209;
	// Function shadow_light_player Begin 
	{
		float3 local_211 = psIN.v_texture1.xyz;
		float local_212 = psIN.v_texture1.w;
		float3 local_213;
		if (local_102 > 0.0)
		{
			float3 local_214;
			// Function calc_transmission_sss Begin 
			{
				float3 local_216 = -(local_211);
				float local_217 = dot(local_14, local_216);
				float local_218 = local_217 + sss_warp0;
				const float local_219 = 1.0f;
				float local_220 = local_219 + sss_warp0;
				float local_221 = local_218 / local_220;
				float local_222 = saturate(local_221);
				const float local_223 = 0.0f;
				const float local_224 = 0.001f;
				float local_225 = sss_scatter0 + local_224;
				float local_226 = smoothstep(local_223, local_225, local_222);
				const float local_227 = 2.0f;
				float local_228 = sss_scatter0 * local_227;
				float local_229 = lerp(local_228, sss_scatter0, local_222);
				float local_230 = local_226 * local_229;
				float3 local_231 = { local_222, local_222, local_222 };
				float3 local_232 = sss_scatter_color0.xyz;
				float local_233 = sss_scatter_color0.w;
				float3 local_234 = { local_230, local_230, local_230 };
				float3 local_235 = local_232 * local_234;
				float local_236 = saturate(local_217);
				float3 local_237 = { local_236, local_236, local_236 };
				float3 local_238 = local_231 + local_235;
				float local_239 = local_102 + local_224;
				float3 local_240 = { local_239, local_239, local_239 };
				float3 local_241 = lerp(local_237, local_238, local_240);
				local_214 = local_241;
			}
			// Function calc_transmission_sss End
			local_213 = local_214;
		}
		else
		{
			float3 local_243 = -(local_211);
			float local_244 = dot(local_14, local_243);
			float local_245 = saturate(local_244);
			float3 local_246 = { local_245, local_245, local_245 };
			local_213 = local_246;
		}
		float3 local_247 = psIN.v_texture2.xyz;
		float local_248 = psIN.v_texture2.w;
		float3 local_249 = local_247 * local_213;
		float3 local_250;
#if SPECULAR_ENABLE
		float3 local_251 = local_207.xyz;
		float local_252 = local_207.w;
		float3 local_253;
		// Function calc_brdf_specular_factor_char Begin 
		{
			float3 local_255 = -(local_211);
			float3 local_256 = local_71 + local_255;
			float3 local_257 = normalize(local_256);
			float local_258 = dot(local_14, local_255);
			float local_259 = saturate(local_258);
			float local_260 = dot(local_14, local_257);
			float local_261 = saturate(local_260);
			float local_262 = dot(local_255, local_257);
			float local_263 = saturate(local_262);
			float local_264 = local_100 * local_100;
			const float local_265 = 0.002f;
			float local_266 = max(local_264, local_265);
			float local_267 = local_266 * local_266;
			float local_268 = local_261 * local_267;
			float local_269 = local_268 - local_261;
			float local_270 = local_269 * local_261;
			const float local_271 = 1.0f;
			float local_272 = local_270 + local_271;
			const float local_273 = 3.141593f;
			float local_274 = local_273 * local_272;
			float local_275 = local_274 * local_272;
			float local_276 = local_267 / local_275;
			const float local_277 = 4.0f;
			float local_278 = local_277 * local_263;
			float local_279 = local_278 * local_263;
			const float local_280 = 0.5f;
			float local_281 = local_100 + local_280;
			float local_282 = local_279 * local_281;
			float local_283 = local_271 / local_282;
			float local_284 = local_283 * local_276;
			float local_285 = local_284 * local_259;
			float3 local_286 = { local_285, local_285, local_285 };
			float3 local_287 = local_286 * local_251;
			local_253 = local_287;
		}
		// Function calc_brdf_specular_factor_char End
		float3 local_289 = local_247 * local_253;
		local_250 = local_289;
#else
		const float local_290 = 0.0f;
		float3 local_291 = { local_290, local_290, local_290 };
		local_250 = local_291;
#endif
		local_208 = local_249;
		local_209 = local_250;
	}
	// Function shadow_light_player End
	const int local_293 = 1;
	float4 local_294 = PointLightAttrs[local_293];
	const int local_295 = 2;
	float4 local_296 = PointLightAttrs[local_295];
	const int local_297 = 3;
	float4 local_298 = PointLightAttrs[local_297];
	float local_299 = psIN.v_texture6.x;
	float local_300 = psIN.v_texture6.y;
	float local_301 = psIN.v_texture6.z;
	float local_302 = psIN.v_texture6.w;
	float3 local_303;
	float3 local_304;
	// Function point_light_player Begin 
	{
		float local_306 = local_296.x;
		float local_307 = local_296.y;
		float local_308 = local_296.z;
		float local_309 = local_296.w;
		float4 local_310;
		float4 local_311;
		if (local_306 > 1.0)
		{
			float4 local_312 = mul(local_294, point_light_scale);
			float4 local_313 = mul(local_207, point_light_scale);
			local_310 = local_312;
			local_311 = local_313;
		}
		else
		{
			local_310 = local_294;
			local_311 = local_207;
		}
		float local_314 = local_310.x;
		float local_315 = local_310.y;
		float local_316 = local_310.z;
		float local_317 = local_310.w;
		float local_318 = local_314 + local_315;
		float local_319 = local_318 + local_316;
		float3 local_320;
		float3 local_321;
		if (local_319 == 0.0)
		{
			const float local_322 = 0.0f;
			float3 local_323 = { local_322, local_322, local_322 };
			float3 local_324 = { local_322, local_322, local_322 };
			local_320 = local_323;
			local_321 = local_324;
		}
		else
		{
			float3 local_325 = local_298.xyz;
			float local_326 = local_298.w;
			float3 local_327 = local_68 - local_325;
			float3 local_328 = normalize(local_327);
			float3 local_329;
			// Function calc_transmission_sss Begin 
			{
				float3 local_331 = -(local_328);
				float local_332 = dot(local_14, local_331);
				float local_333 = local_332 + sss_warp0;
				const float local_334 = 1.0f;
				float local_335 = local_334 + sss_warp0;
				float local_336 = local_333 / local_335;
				float local_337 = saturate(local_336);
				const float local_338 = 0.0f;
				const float local_339 = 0.001f;
				float local_340 = sss_scatter0 + local_339;
				float local_341 = smoothstep(local_338, local_340, local_337);
				const float local_342 = 2.0f;
				float local_343 = sss_scatter0 * local_342;
				float local_344 = lerp(local_343, sss_scatter0, local_337);
				float local_345 = local_341 * local_344;
				float3 local_346 = { local_337, local_337, local_337 };
				float3 local_347 = sss_scatter_color0.xyz;
				float local_348 = sss_scatter_color0.w;
				float3 local_349 = { local_345, local_345, local_345 };
				float3 local_350 = local_347 * local_349;
				float local_351 = saturate(local_332);
				float3 local_352 = { local_351, local_351, local_351 };
				float3 local_353 = local_346 + local_350;
				float local_354 = local_102 + local_339;
				float3 local_355 = { local_354, local_354, local_354 };
				float3 local_356 = lerp(local_352, local_353, local_355);
				local_329 = local_356;
			}
			// Function calc_transmission_sss End
			float3 local_358 = local_310.xyz;
			float local_359 = local_310.w;
			float3 local_360 = local_358 * local_329;
			float3 local_361 = mul(local_360, local_299);
			float3 local_362;
#if SPECULAR_ENABLE
			float3 local_363 = local_311.xyz;
			float local_364 = local_311.w;
			float3 local_365;
			// Function calc_brdf_specular_factor_char Begin 
			{
				float3 local_367 = -(local_328);
				float3 local_368 = local_71 + local_367;
				float3 local_369 = normalize(local_368);
				float local_370 = dot(local_14, local_367);
				float local_371 = saturate(local_370);
				float local_372 = dot(local_14, local_369);
				float local_373 = saturate(local_372);
				float local_374 = dot(local_367, local_369);
				float local_375 = saturate(local_374);
				float local_376 = local_100 * local_100;
				const float local_377 = 0.002f;
				float local_378 = max(local_376, local_377);
				float local_379 = local_378 * local_378;
				float local_380 = local_373 * local_379;
				float local_381 = local_380 - local_373;
				float local_382 = local_381 * local_373;
				const float local_383 = 1.0f;
				float local_384 = local_382 + local_383;
				const float local_385 = 3.141593f;
				float local_386 = local_385 * local_384;
				float local_387 = local_386 * local_384;
				float local_388 = local_379 / local_387;
				const float local_389 = 4.0f;
				float local_390 = local_389 * local_375;
				float local_391 = local_390 * local_375;
				const float local_392 = 0.5f;
				float local_393 = local_100 + local_392;
				float local_394 = local_391 * local_393;
				float local_395 = local_383 / local_394;
				float local_396 = local_395 * local_388;
				float local_397 = local_396 * local_371;
				float3 local_398 = { local_397, local_397, local_397 };
				float3 local_399 = local_398 * local_363;
				local_365 = local_399;
			}
			// Function calc_brdf_specular_factor_char End
			float3 local_401 = local_358 * local_365;
			float3 local_402 = mul(local_401, local_299);
			local_362 = local_402;
#else
			const float local_403 = 0.0f;
			float3 local_404 = { local_403, local_403, local_403 };
			local_362 = local_404;
#endif
			local_320 = local_361;
			local_321 = local_362;
		}
		local_303 = local_320;
		local_304 = local_321;
	}
	// Function point_light_player End
	const int local_406 = 6;
	float4 local_407 = PointLightAttrs[local_406];
	const int local_408 = 7;
	float4 local_409 = PointLightAttrs[local_408];
	const int local_410 = 8;
	float4 local_411 = PointLightAttrs[local_410];
	float3 local_412;
	float3 local_413;
	// Function point_light_char Begin 
	{
		float local_415 = local_407.x;
		float local_416 = local_407.y;
		float local_417 = local_407.z;
		float local_418 = local_407.w;
		float local_419 = local_415 + local_416;
		float local_420 = local_419 + local_417;
		float3 local_421;
		float3 local_422;
		if (local_420 == 0.0)
		{
			const float local_423 = 0.0f;
			float3 local_424 = { local_423, local_423, local_423 };
			float3 local_425 = { local_423, local_423, local_423 };
			local_421 = local_424;
			local_422 = local_425;
		}
		else
		{
			float3 local_426 = local_411.xyz;
			float local_427 = local_411.w;
			float3 local_428 = local_68 - local_426;
			float3 local_429 = normalize(local_428);
			float3 local_430 = -(local_429);
			float local_431 = dot(local_14, local_430);
			float local_432 = saturate(local_431);
			float3 local_433 = local_407.xyz;
			float local_434 = local_407.w;
			float3 local_435 = mul(local_433, local_432);
			float3 local_436 = mul(local_435, local_300);
			float3 local_437;
#if SPECULAR_ENABLE
			float3 local_438 = local_409.xyz;
			float local_439 = local_409.w;
			float3 local_440;
			// Function calc_brdf_specular_factor_char Begin 
			{
				float3 local_442 = -(local_429);
				float3 local_443 = local_71 + local_442;
				float3 local_444 = normalize(local_443);
				float local_445 = dot(local_14, local_442);
				float local_446 = saturate(local_445);
				float local_447 = dot(local_14, local_444);
				float local_448 = saturate(local_447);
				float local_449 = dot(local_442, local_444);
				float local_450 = saturate(local_449);
				float local_451 = local_100 * local_100;
				const float local_452 = 0.002f;
				float local_453 = max(local_451, local_452);
				float local_454 = local_453 * local_453;
				float local_455 = local_448 * local_454;
				float local_456 = local_455 - local_448;
				float local_457 = local_456 * local_448;
				const float local_458 = 1.0f;
				float local_459 = local_457 + local_458;
				const float local_460 = 3.141593f;
				float local_461 = local_460 * local_459;
				float local_462 = local_461 * local_459;
				float local_463 = local_454 / local_462;
				const float local_464 = 4.0f;
				float local_465 = local_464 * local_450;
				float local_466 = local_465 * local_450;
				const float local_467 = 0.5f;
				float local_468 = local_100 + local_467;
				float local_469 = local_466 * local_468;
				float local_470 = local_458 / local_469;
				float local_471 = local_470 * local_463;
				float local_472 = local_471 * local_446;
				float3 local_473 = { local_472, local_472, local_472 };
				float3 local_474 = local_473 * local_438;
				local_440 = local_474;
			}
			// Function calc_brdf_specular_factor_char End
			float3 local_476 = local_433 * local_440;
			float3 local_477 = mul(local_476, local_300);
			local_437 = local_477;
#else
			const float local_478 = 0.0f;
			float3 local_479 = { local_478, local_478, local_478 };
			local_437 = local_479;
#endif
			local_421 = local_436;
			local_422 = local_437;
		}
		local_412 = local_421;
		local_413 = local_422;
	}
	// Function point_light_char End
	const int local_481 = 11;
	float4 local_482 = PointLightAttrs[local_481];
	const int local_483 = 12;
	float4 local_484 = PointLightAttrs[local_483];
	const int local_485 = 13;
	float4 local_486 = PointLightAttrs[local_485];
	float3 local_487;
	float3 local_488;
	// Function point_light_char Begin 
	{
		float local_490 = local_482.x;
		float local_491 = local_482.y;
		float local_492 = local_482.z;
		float local_493 = local_482.w;
		float local_494 = local_490 + local_491;
		float local_495 = local_494 + local_492;
		float3 local_496;
		float3 local_497;
		if (local_495 == 0.0)
		{
			const float local_498 = 0.0f;
			float3 local_499 = { local_498, local_498, local_498 };
			float3 local_500 = { local_498, local_498, local_498 };
			local_496 = local_499;
			local_497 = local_500;
		}
		else
		{
			float3 local_501 = local_486.xyz;
			float local_502 = local_486.w;
			float3 local_503 = local_68 - local_501;
			float3 local_504 = normalize(local_503);
			float3 local_505 = -(local_504);
			float local_506 = dot(local_14, local_505);
			float local_507 = saturate(local_506);
			float3 local_508 = local_482.xyz;
			float local_509 = local_482.w;
			float3 local_510 = mul(local_508, local_507);
			float3 local_511 = mul(local_510, local_301);
			float3 local_512;
#if SPECULAR_ENABLE
			float3 local_513 = local_484.xyz;
			float local_514 = local_484.w;
			float3 local_515;
			// Function calc_brdf_specular_factor_char Begin 
			{
				float3 local_517 = -(local_504);
				float3 local_518 = local_71 + local_517;
				float3 local_519 = normalize(local_518);
				float local_520 = dot(local_14, local_517);
				float local_521 = saturate(local_520);
				float local_522 = dot(local_14, local_519);
				float local_523 = saturate(local_522);
				float local_524 = dot(local_517, local_519);
				float local_525 = saturate(local_524);
				float local_526 = local_100 * local_100;
				const float local_527 = 0.002f;
				float local_528 = max(local_526, local_527);
				float local_529 = local_528 * local_528;
				float local_530 = local_523 * local_529;
				float local_531 = local_530 - local_523;
				float local_532 = local_531 * local_523;
				const float local_533 = 1.0f;
				float local_534 = local_532 + local_533;
				const float local_535 = 3.141593f;
				float local_536 = local_535 * local_534;
				float local_537 = local_536 * local_534;
				float local_538 = local_529 / local_537;
				const float local_539 = 4.0f;
				float local_540 = local_539 * local_525;
				float local_541 = local_540 * local_525;
				const float local_542 = 0.5f;
				float local_543 = local_100 + local_542;
				float local_544 = local_541 * local_543;
				float local_545 = local_533 / local_544;
				float local_546 = local_545 * local_538;
				float local_547 = local_546 * local_521;
				float3 local_548 = { local_547, local_547, local_547 };
				float3 local_549 = local_548 * local_513;
				local_515 = local_549;
			}
			// Function calc_brdf_specular_factor_char End
			float3 local_551 = local_508 * local_515;
			float3 local_552 = mul(local_551, local_301);
			local_512 = local_552;
#else
			const float local_553 = 0.0f;
			float3 local_554 = { local_553, local_553, local_553 };
			local_512 = local_554;
#endif
			local_496 = local_511;
			local_497 = local_512;
		}
		local_487 = local_496;
		local_488 = local_497;
	}
	// Function point_light_char End
	const int local_556 = 16;
	float4 local_557 = PointLightAttrs[local_556];
	const int local_558 = 17;
	float4 local_559 = PointLightAttrs[local_558];
	const int local_560 = 18;
	float4 local_561 = PointLightAttrs[local_560];
	float3 local_562;
	float3 local_563;
	// Function point_light_char Begin 
	{
		float local_565 = local_557.x;
		float local_566 = local_557.y;
		float local_567 = local_557.z;
		float local_568 = local_557.w;
		float local_569 = local_565 + local_566;
		float local_570 = local_569 + local_567;
		float3 local_571;
		float3 local_572;
		if (local_570 == 0.0)
		{
			const float local_573 = 0.0f;
			float3 local_574 = { local_573, local_573, local_573 };
			float3 local_575 = { local_573, local_573, local_573 };
			local_571 = local_574;
			local_572 = local_575;
		}
		else
		{
			float3 local_576 = local_561.xyz;
			float local_577 = local_561.w;
			float3 local_578 = local_68 - local_576;
			float3 local_579 = normalize(local_578);
			float3 local_580 = -(local_579);
			float local_581 = dot(local_14, local_580);
			float local_582 = saturate(local_581);
			float3 local_583 = local_557.xyz;
			float local_584 = local_557.w;
			float3 local_585 = mul(local_583, local_582);
			float3 local_586 = mul(local_585, local_302);
			float3 local_587;
#if SPECULAR_ENABLE
			float3 local_588 = local_559.xyz;
			float local_589 = local_559.w;
			float3 local_590;
			// Function calc_brdf_specular_factor_char Begin 
			{
				float3 local_592 = -(local_579);
				float3 local_593 = local_71 + local_592;
				float3 local_594 = normalize(local_593);
				float local_595 = dot(local_14, local_592);
				float local_596 = saturate(local_595);
				float local_597 = dot(local_14, local_594);
				float local_598 = saturate(local_597);
				float local_599 = dot(local_592, local_594);
				float local_600 = saturate(local_599);
				float local_601 = local_100 * local_100;
				const float local_602 = 0.002f;
				float local_603 = max(local_601, local_602);
				float local_604 = local_603 * local_603;
				float local_605 = local_598 * local_604;
				float local_606 = local_605 - local_598;
				float local_607 = local_606 * local_598;
				const float local_608 = 1.0f;
				float local_609 = local_607 + local_608;
				const float local_610 = 3.141593f;
				float local_611 = local_610 * local_609;
				float local_612 = local_611 * local_609;
				float local_613 = local_604 / local_612;
				const float local_614 = 4.0f;
				float local_615 = local_614 * local_600;
				float local_616 = local_615 * local_600;
				const float local_617 = 0.5f;
				float local_618 = local_100 + local_617;
				float local_619 = local_616 * local_618;
				float local_620 = local_608 / local_619;
				float local_621 = local_620 * local_613;
				float local_622 = local_621 * local_596;
				float3 local_623 = { local_622, local_622, local_622 };
				float3 local_624 = local_623 * local_588;
				local_590 = local_624;
			}
			// Function calc_brdf_specular_factor_char End
			float3 local_626 = local_583 * local_590;
			float3 local_627 = mul(local_626, local_302);
			local_587 = local_627;
#else
			const float local_628 = 0.0f;
			float3 local_629 = { local_628, local_628, local_628 };
			local_587 = local_629;
#endif
			local_571 = local_586;
			local_572 = local_587;
		}
		local_562 = local_571;
		local_563 = local_572;
	}
	// Function point_light_char End
	float3 local_631 = mul(local_208, local_156);
	float3 local_632 = mul(local_209, local_156);
	float3 local_633 = local_631 + local_303;
	float3 local_634 = local_633 + local_412;
	float3 local_635 = local_634 + local_487;
	float3 local_636 = local_635 + local_562;
	float3 local_637 = local_632 + local_304;
	float3 local_638 = local_637 + local_413;
	float3 local_639 = local_638 + local_488;
	float3 local_640 = local_639 + local_563;
	local_204 = local_636;
	local_205 = local_640;
}
// Function calc_lighting_player End
float3 local_642;
float3 local_643;
// Function calc_brdf_env_player Begin 
{
	float3 local_645;
	if (local_102 > 0.0)
	{
		float3 local_646;
		// Function calc_brdf_env_sss Begin 
		{
			local_646 = local_83;
			float3 local_648 = { sss_warp0, sss_warp0, sss_warp0 };
			float3 local_649 = local_83 + local_648;
			const float local_650 = 1.0f;
			float local_651 = local_650 + sss_warp0;
			float3 local_652 = { local_651, local_651, local_651 };
			float3 local_653 = local_649 / local_652;
			float3 local_654 = { sss_scatter0, sss_scatter0, sss_scatter0 };
			const float local_655 = 0.0f;
			float3 local_656 = { local_655, local_655, local_655 };
			float3 local_657 = lerp(local_656, local_654, local_653);
			const float local_658 = 2.0f;
			float3 local_659 = mul(local_654, local_658);
			float3 local_660 = lerp(local_659, local_654, local_653);
			float3 local_661 = local_657 * local_660;
			float3 local_662 = sss_scatter_color0.xyz;
			float local_663 = sss_scatter_color0.w;
			float3 local_664 = local_661 * local_662;
			float3 local_665 = local_653 + local_664;
		}
		// Function calc_brdf_env_sss End
		local_645 = local_646;
	}
	else
	{
		local_645 = local_83;
	}
	float3 local_667;
	// Function calc_brdf_env_specular_sim Begin 
	{
		float3 local_669 = reflect(local_71, local_14);
		float3 local_670 = -(local_669);
		float3x3 local_671 = (float3x3)envRot;
		float3 local_672 = mul(local_670, local_671);
		float3 local_673 = normalize(local_672);
		float local_674 = dot(local_14, local_71);
		float local_675 = saturate(local_674);
		float local_676;
		if (local_100 < 0.05)
		{
			const float local_677 = 0.0f;
			local_676 = local_677;
		}
		else
		{
			const float local_678 = 9.0f;
			float local_679 = local_678 * local_100;
			local_676 = local_679;
			const float local_680 = 1.0f;
			float local_681 = local_680 - local_675;
			const float local_682 = 0.01f;
			float local_683 = local_100 + local_682;
			float local_684 = local_680 / local_683;
			float local_685 = pow(local_681, local_684);
			float local_686 = local_685 * local_679;
			const float local_687 = 0.3f;
			float local_688 = local_686 * local_687;
			const float local_689 = 3.0f;
			float local_690 = min(local_688, local_689);
			float local_691 = local_679 - local_690;
			const float local_692 = 0.0f;
			float local_693 = max(local_691, local_692);
		}
		float3 local_694;
		// Function env_sample_lod_sim Begin 
		{
			const float local_696 = 0.0f;
			const float local_697 = 9.0f;
			float local_698 = clamp(local_676, local_696, local_697);
			float local_699 = local_673.x;
			float local_700 = local_673.y;
			float local_701 = local_673.z;
			float2 local_702 = { local_699, local_701 };
			float local_703 = length(local_702);
			float local_704;
			if (local_703>0.0000001)
			{
				float local_705 = local_699 / local_703;
				local_704 = local_705;
			}
			else
			{
				const float local_706 = 0.0f;
				local_704 = local_706;
			}
			float2 local_707 = { local_704, local_700 };
			float2 local_708 = acos(local_707);
			const float local_709 = 0.3183099f;
			float2 local_710 = mul(local_708, local_709);
			float local_711 = local_710.x;
			float local_712 = local_710.y;
			const float local_713 = 0.5f;
			float local_714 = local_711 * local_713;
			float local_715;
			if (local_701 > 0.0)
			{
				local_715 = local_714;
			}
			else
			{
				const float local_716 = 1.0f;
				float local_717 = local_716 - local_714;
				local_715 = local_717;
			}
			float2 local_718 = { local_715, local_712 };
			float4 local_719 = tex2Dlod(sam_environment_reflect, float4(local_718.x, local_718.y, 0.0f, local_698));
			float3 local_720 = local_719.xyz;
			float local_721 = local_719.w;
			const float local_722 = 14.48538f;
			float local_723 = local_721 * local_722;
			const float local_724 = 3.621346f;
			float local_725 = local_723 - local_724;
			float local_726 = exp2(local_725);
			float3 local_727 = mul(local_720, local_726);
			local_694 = local_727;
		}
		// Function env_sample_lod_sim End
		float3 local_729;
		// Function env_approx Begin 
		{
			const float local_731 = 1.0f;
			float local_732 = -(local_731);
			const float local_733 = 0.0275f;
			float local_734 = -(local_733);
			const float local_735 = 0.572f;
			float local_736 = -(local_735);
			const float local_737 = 0.022f;
			float4 local_738 = { local_732, local_734, local_736, local_737 };
			const float local_739 = 0.0425f;
			const float local_740 = 1.04f;
			const float local_741 = 0.04f;
			float local_742 = -(local_741);
			float4 local_743 = { local_731, local_739, local_740, local_742 };
			float local_744 = -(local_740);
			float2 local_745 = { local_744, local_740 };
			float4 local_746 = mul(local_738, local_100);
			float4 local_747 = local_746 + local_743;
			float local_748 = local_747.x;
			float local_749 = local_747.y;
			float local_750 = local_747.z;
			float local_751 = local_747.w;
			float local_752 = local_748 * local_748;
			const float local_753 = 9.28f;
			float local_754 = -(local_753);
			float local_755 = local_754 * local_675;
			float local_756 = exp2(local_755);
			float local_757 = min(local_752, local_756);
			float local_758 = local_757 * local_748;
			float local_759 = local_758 + local_749;
			float2 local_760 = mul(local_745, local_759);
			float2 local_761 = local_747.xy;
			float2 local_762 = local_747.zw;
			float2 local_763 = local_760 + local_762;
			float local_764 = local_763.x;
			float local_765 = local_763.y;
			float3 local_766 = mul(local_149, local_764);
			float3 local_767 = { local_765, local_765, local_765 };
			float3 local_768 = local_766 + local_767;
			local_729 = local_768;
		}
		// Function env_approx End
		float3 local_770 = local_694 * local_729;
		local_667 = local_770;
	}
	// Function calc_brdf_env_specular_sim End
	float3 local_772 = mul(local_667, env_exposure);
	local_642 = local_645;
	local_643 = local_772;
}
// Function calc_brdf_env_player End
float3 local_774 = { local_11, local_11, local_11 };
float3 local_775 = { change_color_bright_add, change_color_bright_add, change_color_bright_add };
float3 local_776 = bright_color.xyz;
float local_777 = bright_color.w;
float3 local_778 = local_776 * local_8;
float3 local_779 = { change_color_bright, change_color_bright, change_color_bright };
float3 local_780 = local_778 * local_779;
float3 local_781 = local_775 + local_780;
float3 local_782 = local_774 * local_781;
float3 local_783 = { character_light_factor, character_light_factor, character_light_factor };
float3 local_784 = local_204 * local_783;
float3 local_785 = { local_157, local_157, local_157 };
float3 local_786 = local_642 * local_785;
float3 local_787 = max(local_784, local_786);
float3 local_788 = { local_157, local_157, local_157 };
float3 local_789 = local_643 * local_788;
float3 local_790 = local_789 + local_205;
float3 local_791 = local_787 * local_144;
float3 local_792 = local_791 + local_790;
float3 local_793 = local_792 + local_782;
float3 local_794 = mul(change_color_scaled, local_793);
float3 local_795;
// Function gamma_correct_ended Begin 
{
	float3 local_797 = sqrt(local_794);
	local_795 = local_797;
}
// Function gamma_correct_ended End
float3 local_799;
#if FOG_TYPE==FOG_TYPE_NONE
local_799 = local_795;
#elif FOG_TYPE==FOG_TYPE_LINEAR
float local_800 = psIN.fog_factor_info.x;
float local_801 = psIN.fog_factor_info.y;
float local_802 = psIN.fog_factor_info.z;
float local_803 = psIN.fog_factor_info.w;
float3 local_804;
// Function calc_fog Begin 
{
	float3 local_806 = FogColor.xyz;
	float local_807 = FogColor.w;
	float local_808 = local_800 * local_807;
	float3 local_809 = { local_808, local_808, local_808 };
	float3 local_810 = lerp(local_795, local_806, local_809);
	local_804 = local_810;
}
// Function calc_fog End
local_799 = local_804;
#elif FOG_TYPE==FOG_TYPE_HEIGHT
float local_812;
// Function calc_cylindrical_u Begin 
{
	float2 local_814 = local_71.xy;
	float local_815 = local_71.z;
	float local_816 = local_71.x;
	float local_817 = local_71.y;
	float local_818 = local_71.z;
	float local_819 = atan2(local_815, local_816);
	const float local_820 = 0.159f;
	float local_821 = local_819 * local_820;
	const float local_822 = 0.5f;
	float local_823 = local_821 + local_822;
	float local_824 = (float)1.0f - local_823;
	local_812 = local_824;
}
// Function calc_cylindrical_u End
float3 local_826;
// Function calc_fog_textured Begin 
{
	float3 local_828 = psIN.fog_factor_info.xyz;
	float local_829 = psIN.fog_factor_info.w;
	float local_830 = local_812 + local_829;
	float local_831 = psIN.fog_factor_info.x;
	float local_832 = psIN.fog_factor_info.y;
	float2 local_833 = psIN.fog_factor_info.zw;
	float2 local_834 = { local_830, local_832 };
	float4 local_835 = tex2D(sam_fog_texture, local_834);
	float3 local_836 = local_835.xyz;
	float local_837 = local_835.w;
	float3 local_838 = FogColor.xyz;
	float local_839 = FogColor.w;
	float2 local_840 = psIN.fog_factor_info.xy;
	float local_841 = psIN.fog_factor_info.z;
	float local_842 = psIN.fog_factor_info.w;
	float3 local_843 = { local_841, local_841, local_841 };
	float3 local_844 = lerp(local_836, local_838, local_843);
	float3 local_845 = { local_831, local_831, local_831 };
	float3 local_846 = lerp(local_795, local_844, local_845);
	local_826 = local_846;
}
// Function calc_fog_textured End
local_799 = local_826;
#endif
float4 local_848;
// Function encode_rgbe Begin 
{
	const float local_850 = 128.0f;
	const float local_851 = 1.06f;
	const float local_852 = 1.0f;
	float3 local_853 = { local_852, local_852, local_852 };
	float local_854 = dot(local_790, local_853);
	float local_855 = log(local_854);
	float local_856 = log(local_851);
	float local_857 = local_855 / local_856;
	float local_858 = local_857 + local_850;
	const float local_859 = 256.0f;
	float local_860 = local_858 / local_859;
	float3 local_861 = { local_854, local_854, local_854 };
	float3 local_862 = local_790 / local_861;
	float4 local_863 = { local_862.x, local_862.y, local_862.z, local_860 };
	local_848 = local_863;
}
// Function encode_rgbe End
float local_865 = local_13 * AlphaMtl;
float4 local_866 = { local_799.x, local_799.y, local_799.z, local_865 };
float4 local_867 = { bloom_switch, bloom_switch, bloom_switch, bloom_switch };
float4 local_868 = lerp(local_866, local_848, local_867);
final_color = local_868;
return final_color;
}
