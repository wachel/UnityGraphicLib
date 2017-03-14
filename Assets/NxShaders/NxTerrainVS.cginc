#ifndef LIGHT_MAP_ENABLE
#define LIGHT_MAP_ENABLE 0
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

float4x4 WorldViewProjection;
float4x4 World;
#if FOG_TYPE == FOG_TYPE_LINEAR
float4x4 Projection;
#endif
float4x4 TexTransform0;
float4x4 LightMapTransform;
float4 uv_transform;
#if FOG_TYPE == FOG_TYPE_HEIGHT || 1
float4 camera_pos;
#endif
#if FOG_TYPE == FOG_TYPE_LINEAR || FOG_TYPE == FOG_TYPE_HEIGHT
float4 FogInfo;
#endif
#if FOG_TYPE == FOG_TYPE_HEIGHT
float4 FogInfoEX;
#endif
#if FOG_TYPE == FOG_TYPE_HEIGHT || 1
float4 ShadowLightAttr[LIGHT_ATTR_ITEM_NUM];
#endif
float4 PointLightAttrs[LIGHT_ATTR_ITEM_NUM*LIGHT_NUM];
struct VS_INPUT
{
	float4 pos_local: POSITION;
	float4 a_texture0: TEXCOORD0;
	float4 a_texture1: TEXCOORD1;
	float4 nor_local: NORMAL;
	float4 a_tangent: TANGENT;
};
struct PS_INPUT
{
	float4 final_position: POSITION;
	float2 uv0: TEXCOORD0;
	float2 uv1: TEXCOORD1;
	float2 terrain_uv0: TEXCOORD2;
	float4 v_texture3: TEXCOORD3;
	float4 v_texture4: TEXCOORD4;
	float4 v_world_position: TEXCOORD5;
	float3 v_world_normal: TEXCOORD6;
	float3 v_world_tangent: TEXCOORD7;
	float3 v_world_binormal: TEXCOORD8;
	float4 v_texture5: TEXCOORD9;
};
PS_INPUT vs_main(VS_INPUT vsIN)
{
	PS_INPUT psIN = (PS_INPUT)0;
	float4 local_0 = mul(vsIN.pos_local, WorldViewProjection);
	psIN.final_position = local_0;
#if LIGHT_MAP_ENABLE
#else
#endif
	float4 local_1 = mul(vsIN.pos_local, World);
	float3x3 local_2 = (float3x3)World;
	float3 local_3 = vsIN.nor_local.xyz;
	float local_4 = vsIN.nor_local.w;
	float3 local_5 = mul(local_3, local_2);
	float3 local_6 = normalize(local_5);
	float4 local_7;
#if FOG_TYPE==FOG_TYPE_NONE
	const float local_8 = 0.0f;
	float4 local_9 = { local_8, local_8, local_8, local_8 };
	local_7 = local_9;
#elif FOG_TYPE==FOG_TYPE_LINEAR
	float local_10;
	// Function calc_fog_factor Begin 
	{
		float local_12 = FogInfo.x;
		float local_13 = FogInfo.y;
		float local_14 = FogInfo.z;
		float local_15 = FogInfo.w;
		const int local_16 = 2;
		float local_17 = local_0[local_16];
		const int local_18 = 1;
		float local_19 = local_1[local_18];
		float local_20;
		// Function get_fog_height Begin 
		{
			float local_22;
			// Function get_fog_linear Begin 
			{
				const float local_24 = 0.0f;
				const float local_25 = 1.0f;
				float4 local_26 = { local_24, local_24, local_12, local_25 };
				float4 local_27 = mul(local_26, Projection);
				float2 local_28 = local_27.xy;
				float local_29 = local_27.z;
				float local_30 = local_27.w;
				float4 local_31 = { local_24, local_24, local_13, local_25 };
				float4 local_32 = mul(local_31, Projection);
				float2 local_33 = local_32.xy;
				float local_34 = local_32.z;
				float local_35 = local_32.w;
				float local_36 = smoothstep(local_29, local_34, local_17);
				float local_37 = saturate(local_36);
				local_22 = local_37;
			}
			// Function get_fog_linear End
			float local_39 = local_19 - local_14;
			float local_40 = local_15 - local_14;
			float local_41 = local_39 / local_40;
			float local_42 = saturate(local_41);
			float local_43 = max(local_22, local_42);
			local_20 = local_43;
		}
		// Function get_fog_height End
		local_10 = local_20;
	}
	// Function calc_fog_factor End
	const float local_46 = 0.0f;
	float3 local_47 = { local_46, local_46, local_46 };
	float4 local_48 = { local_10, local_47.x, local_47.y, local_47.z };
	local_7 = local_48;
#elif FOG_TYPE==FOG_TYPE_HEIGHT
	const int local_49 = 3;
	float4 local_50 = ShadowLightAttr[local_49];
	float4 local_51;
	// Function calc_fog_textured_factor Begin 
	{
		float3 local_53 = local_1.xyz;
		float local_54 = local_1.w;
		float3 local_55 = camera_pos.xyz;
		float local_56 = camera_pos.w;
		float3 local_57 = local_53 - local_55;
		float3 local_58 = normalize(local_57);
		float local_59 = length(local_57);
		float local_60 = FogInfo.x;
		float local_61 = FogInfo.y;
		float local_62 = FogInfo.z;
		float local_63 = FogInfo.w;
		float local_64 = local_59 - local_62;
		float local_65 = local_63 - local_62;
		float local_66 = local_64 / local_65;
		float local_67 = saturate(local_66);
		float local_68 = pow(local_67, local_61);
		float local_69 = local_60 * local_68;
		const float local_70 = 0.5f;
		float local_71 = local_58.x;
		float local_72 = local_58.y;
		float local_73 = local_58.z;
		const float local_74 = 1.0f;
		float local_75 = local_72 + local_74;
		float local_76 = local_70 * local_75;
		float local_77 = FogInfoEX.x;
		float local_78 = FogInfoEX.y;
		float local_79 = FogInfoEX.z;
		float local_80 = FogInfoEX.w;
		float local_81;
		float local_82;
		float local_83;
		// Function calc_fog_height_factor Begin 
		{
			const float local_85 = 0.001f;
			float local_86 = local_79 - local_80;
			float local_87 = max(local_85, local_86);
			const float local_88 = 1.0f;
			float local_89 = local_88 / local_87;
			float local_90 = camera_pos.x;
			float local_91 = camera_pos.y;
			float2 local_92 = camera_pos.zw;
			float local_93 = local_58.x;
			float local_94 = local_58.y;
			float local_95 = local_58.z;
			float local_96 = local_91 - local_79;
			float local_97 = -(local_94);
			float local_98 = saturate(local_97);
			float local_99 = max(local_98, local_85);
			float local_100 = local_96 / local_99;
			float local_101 = abs(local_96);
			float local_102 = saturate(local_94);
			float local_103 = max(local_102, local_85);
			float local_104 = local_101 / local_103;
			const float local_105 = 0.0f;
			float local_106 = max(local_105, local_100);
			float local_107 = min(local_59, local_104);
			float local_108 = max(local_107, local_106);
			float local_109 = local_108 - local_106;
			float local_110 = local_109 * local_89;
			float local_111 = local_79 - local_91;
			float local_112 = local_111 * local_89;
			float local_113 = saturate(local_112);
			float local_114 = local_113 * local_110;
			const float local_115 = 0.5f;
			float local_116 = local_115 * local_110;
			float local_117 = local_116 * local_110;
			float local_118 = local_117 * local_94;
			float local_119 = local_114 - local_118;
			const float local_120 = 0.1f;
			float local_121 = local_120 * local_77;
			float local_122 = max(local_85, local_121);
			float local_123 = local_119 * local_122;
			float local_124 = saturate(local_123);
			const float local_125 = 2.0f;
			float local_126 = local_125 * local_122;
			float local_127 = local_88 / local_126;
			float local_128 = local_113 * local_113;
			float local_129 = local_125 * local_94;
			float local_130 = local_129 * local_127;
			float local_131 = local_128 - local_130;
			float local_132 = saturate(local_131);
			float local_133 = sqrt(local_132);
			float local_134 = local_113 - local_133;
			float local_135 = local_134 / local_94;
			float local_136 = local_135 * local_87;
			float local_137 = local_106 + local_136;
			float local_138 = local_135 * local_94;
			float local_139 = local_113 - local_138;
			float local_140 = saturate(local_139);
			local_81 = local_124;
			local_82 = local_140;
			local_83 = local_137;
		}
		// Function calc_fog_height_factor End
		float local_142 = local_69 * local_69;
		float local_143 = local_81 * local_81;
		float local_144 = local_142 + local_143;
		float local_145 = sqrt(local_144);
		float local_146 = saturate(local_145);
		float local_147 = local_63 / local_83;
		float local_148 = saturate(local_147);
		float local_149 = local_81 * local_148;
		float2 local_150 = local_50.xy;
		float local_151 = local_50.z;
		float local_152 = local_50.w;
		float local_153 = local_50.x;
		float local_154 = local_50.y;
		float local_155 = local_50.z;
		float local_156 = local_50.w;
		float local_157 = atan2(local_151, local_153);
		const float local_158 = 0.159f;
		float local_159 = local_157 * local_158;
		float4 local_160 = { local_146, local_76, local_149, local_159 };
		local_51 = local_160;
	}
	// Function calc_fog_textured_factor End
	local_7 = local_51;
#endif
	float2 local_162 = vsIN.a_texture0.xy;
	float2 local_163 = vsIN.a_texture0.zw;
	const float local_164 = 1.0f;
	const float local_165 = 0.0f;
	float4 local_166 = { local_162.x, local_162.y, local_164, local_165 };
	float4 local_167 = mul(local_166, TexTransform0);
	float4 local_168;
	// Function calc_lightmap_info Begin 
	{
		float2 local_170 = vsIN.a_texture1.xy;
		float2 local_171 = vsIN.a_texture1.zw;
		const float local_172 = 1.0f;
		const float local_173 = 0.0f;
		float4 local_174 = { local_170.x, local_170.y, local_172, local_173 };
		float4 local_175 = mul(local_174, LightMapTransform);
		local_168 = local_175;
	}
	// Function calc_lightmap_info End
	float local_177 = uv_transform.x;
	float local_178 = uv_transform.y;
	float local_179 = uv_transform.z;
	float local_180 = uv_transform.w;
	float2 local_181 = mul(local_162, local_177);
	float2 local_182 = mul(local_162, local_178);
	float2 local_183 = mul(local_162, local_179);
	float3 local_184;
	float3 local_185;
	// Function calc_normal_info Begin 
	{
		float3 local_187 = vsIN.a_tangent.xyz;
		float local_188 = vsIN.a_tangent.w;
		float3 local_189 = mul(local_187, local_2);
		float3 local_190 = normalize(local_189);
		float3 local_191 = cross(local_6, local_190);
		float3 local_192 = normalize(local_191);
		float local_193 = dot(local_187, local_187);
		const float local_194 = 1.5f;
		float local_195 = local_193 - local_194;
		float3 local_196;
		if (local_195>0.0)
		{
			float3 local_197 = -(local_192);
			local_196 = local_197;
		}
		else
		{
			local_196 = local_192;
		}
		local_184 = local_190;
		local_185 = local_196;
	}
	// Function calc_normal_info End
	float3 local_199 = local_1.xyz;
	float local_200 = local_1.w;
	float4 local_201;
	// Function calc_point_light_atten Begin 
	{
		const int local_203 = 3;
		float4 local_204 = PointLightAttrs[local_203];
		const int local_205 = 4;
		float4 local_206 = PointLightAttrs[local_205];
		float3 local_207 = local_204.xyz;
		float local_208 = local_204.w;
		float3 local_209 = local_199 - local_207;
		float3 local_210 = { local_208, local_208, local_208 };
		float3 local_211 = local_209 / local_210;
		const float local_212 = 1.0f;
		float local_213 = dot(local_211, local_211);
		float local_214 = local_212 - local_213;
		float local_215 = saturate(local_214);
		float local_216 = local_206.x;
		float local_217 = local_206.y;
		float local_218 = local_206.z;
		float local_219 = local_206.w;
		const float local_220 = 0.001f;
		float local_221 = local_216 + local_220;
		float local_222 = pow(local_215, local_221);
		const int local_223 = 8;
		float4 local_224 = PointLightAttrs[local_223];
		const int local_225 = 9;
		float4 local_226 = PointLightAttrs[local_225];
		float3 local_227 = local_224.xyz;
		float local_228 = local_224.w;
		float3 local_229 = local_199 - local_227;
		float3 local_230 = { local_228, local_228, local_228 };
		float3 local_231 = local_229 / local_230;
		float local_232 = dot(local_231, local_231);
		float local_233 = local_212 - local_232;
		float local_234 = saturate(local_233);
		float local_235 = local_226.x;
		float local_236 = local_226.y;
		float local_237 = local_226.z;
		float local_238 = local_226.w;
		float local_239 = local_235 + local_220;
		float local_240 = pow(local_234, local_239);
		const int local_241 = 13;
		float4 local_242 = PointLightAttrs[local_241];
		const int local_243 = 14;
		float4 local_244 = PointLightAttrs[local_243];
		float3 local_245 = local_242.xyz;
		float local_246 = local_242.w;
		float3 local_247 = local_199 - local_245;
		float3 local_248 = { local_246, local_246, local_246 };
		float3 local_249 = local_247 / local_248;
		float local_250 = dot(local_249, local_249);
		float local_251 = local_212 - local_250;
		float local_252 = saturate(local_251);
		float local_253 = local_244.x;
		float local_254 = local_244.y;
		float local_255 = local_244.z;
		float local_256 = local_244.w;
		float local_257 = local_253 + local_220;
		float local_258 = pow(local_252, local_257);
		const int local_259 = 18;
		float4 local_260 = PointLightAttrs[local_259];
		const int local_261 = 19;
		float4 local_262 = PointLightAttrs[local_261];
		float3 local_263 = local_260.xyz;
		float local_264 = local_260.w;
		float3 local_265 = local_199 - local_263;
		float3 local_266 = { local_264, local_264, local_264 };
		float3 local_267 = local_265 / local_266;
		float local_268 = dot(local_267, local_267);
		float local_269 = local_212 - local_268;
		float local_270 = saturate(local_269);
		float local_271 = local_262.x;
		float local_272 = local_262.y;
		float local_273 = local_262.z;
		float local_274 = local_262.w;
		float local_275 = local_271 + local_220;
		float local_276 = pow(local_270, local_275);
		float4 local_277 = { local_222, local_240, local_258, local_276 };
		local_201 = local_277;
	}
	// Function calc_point_light_atten End
	float3 local_279;
	// Function calc_point_light_diffuse Begin 
	{
		const int local_281 = 6;
		float4 local_282 = PointLightAttrs[local_281];
		const int local_283 = 8;
		float4 local_284 = PointLightAttrs[local_283];
		const int local_285 = 9;
		float4 local_286 = PointLightAttrs[local_285];
		float3 local_287;
		// Function point_light_common_diffuse_only Begin 
		{
			float local_289 = local_282.x;
			float local_290 = local_282.y;
			float local_291 = local_282.z;
			float local_292 = local_282.w;
			float local_293 = local_289 + local_290;
			float local_294 = local_293 + local_291;
			float3 local_295;
			if (local_294 == 0.0)
			{
				const float local_296 = 0.0f;
				float3 local_297 = { local_296, local_296, local_296 };
				local_295 = local_297;
			}
			else
			{
				float3 local_298 = local_284.xyz;
				float local_299 = local_284.w;
				float3 local_300 = local_199 - local_298;
				float3 local_301 = { local_299, local_299, local_299 };
				float3 local_302 = local_300 / local_301;
				float local_303 = dot(local_302, local_302);
				float local_304 = (float)1.0f - local_303;
				float local_305 = saturate(local_304);
				float3 local_306 = normalize(local_300);
				float local_307 = local_286.x;
				float local_308 = local_286.y;
				float local_309 = local_286.z;
				float local_310 = local_286.w;
				const float local_311 = 0.001f;
				float local_312 = local_307 + local_311;
				float local_313 = pow(local_305, local_312);
				float3 local_314 = -(local_306);
				float local_315 = dot(local_6, local_314);
				float local_316 = saturate(local_315);
				float3 local_317 = local_282.xyz;
				float local_318 = local_282.w;
				float3 local_319 = mul(local_317, local_316);
				float3 local_320 = mul(local_319, local_313);
				local_295 = local_320;
			}
			local_287 = local_295;
		}
		// Function point_light_common_diffuse_only End
		const int local_322 = 11;
		float4 local_323 = PointLightAttrs[local_322];
		const int local_324 = 13;
		float4 local_325 = PointLightAttrs[local_324];
		const int local_326 = 14;
		float4 local_327 = PointLightAttrs[local_326];
		float3 local_328;
		// Function point_light_common_diffuse_only Begin 
		{
			float local_330 = local_323.x;
			float local_331 = local_323.y;
			float local_332 = local_323.z;
			float local_333 = local_323.w;
			float local_334 = local_330 + local_331;
			float local_335 = local_334 + local_332;
			float3 local_336;
			if (local_335 == 0.0)
			{
				const float local_337 = 0.0f;
				float3 local_338 = { local_337, local_337, local_337 };
				local_336 = local_338;
			}
			else
			{
				float3 local_339 = local_325.xyz;
				float local_340 = local_325.w;
				float3 local_341 = local_199 - local_339;
				float3 local_342 = { local_340, local_340, local_340 };
				float3 local_343 = local_341 / local_342;
				float local_344 = dot(local_343, local_343);
				float local_345 = (float)1.0f - local_344;
				float local_346 = saturate(local_345);
				float3 local_347 = normalize(local_341);
				float local_348 = local_327.x;
				float local_349 = local_327.y;
				float local_350 = local_327.z;
				float local_351 = local_327.w;
				const float local_352 = 0.001f;
				float local_353 = local_348 + local_352;
				float local_354 = pow(local_346, local_353);
				float3 local_355 = -(local_347);
				float local_356 = dot(local_6, local_355);
				float local_357 = saturate(local_356);
				float3 local_358 = local_323.xyz;
				float local_359 = local_323.w;
				float3 local_360 = mul(local_358, local_357);
				float3 local_361 = mul(local_360, local_354);
				local_336 = local_361;
			}
			local_328 = local_336;
		}
		// Function point_light_common_diffuse_only End
		const int local_363 = 16;
		float4 local_364 = PointLightAttrs[local_363];
		const int local_365 = 18;
		float4 local_366 = PointLightAttrs[local_365];
		const int local_367 = 19;
		float4 local_368 = PointLightAttrs[local_367];
		float3 local_369;
		// Function point_light_common_diffuse_only Begin 
		{
			float local_371 = local_364.x;
			float local_372 = local_364.y;
			float local_373 = local_364.z;
			float local_374 = local_364.w;
			float local_375 = local_371 + local_372;
			float local_376 = local_375 + local_373;
			float3 local_377;
			if (local_376 == 0.0)
			{
				const float local_378 = 0.0f;
				float3 local_379 = { local_378, local_378, local_378 };
				local_377 = local_379;
			}
			else
			{
				float3 local_380 = local_366.xyz;
				float local_381 = local_366.w;
				float3 local_382 = local_199 - local_380;
				float3 local_383 = { local_381, local_381, local_381 };
				float3 local_384 = local_382 / local_383;
				float local_385 = dot(local_384, local_384);
				float local_386 = (float)1.0f - local_385;
				float local_387 = saturate(local_386);
				float3 local_388 = normalize(local_382);
				float local_389 = local_368.x;
				float local_390 = local_368.y;
				float local_391 = local_368.z;
				float local_392 = local_368.w;
				const float local_393 = 0.001f;
				float local_394 = local_389 + local_393;
				float local_395 = pow(local_387, local_394);
				float3 local_396 = -(local_388);
				float local_397 = dot(local_6, local_396);
				float local_398 = saturate(local_397);
				float3 local_399 = local_364.xyz;
				float local_400 = local_364.w;
				float3 local_401 = mul(local_399, local_398);
				float3 local_402 = mul(local_401, local_395);
				local_377 = local_402;
			}
			local_369 = local_377;
		}
		// Function point_light_common_diffuse_only End
		float3 local_404 = local_287 + local_328;
		float3 local_405 = local_404 + local_369;
		local_279 = local_405;
	}
	// Function calc_point_light_diffuse End
	psIN.v_world_position = local_1;
	float2 local_407 = local_167.xy;
	float2 local_408 = local_167.zw;
	psIN.uv0 = local_407;
	float2 local_409 = local_168.xy;
	float2 local_410 = local_168.zw;
	psIN.uv1 = local_409;
	psIN.terrain_uv0 = local_181;
	float2 local_411 = local_7.xy;
	float2 local_412 = local_7.zw;
	float4 local_413 = { local_182.x, local_182.y, local_411.x, local_411.y };
	psIN.v_texture3 = local_413;
	float4 local_414 = { local_183.x, local_183.y, local_412.x, local_412.y };
	psIN.v_texture4 = local_414;
	psIN.v_world_tangent = local_184;
	psIN.v_world_binormal = local_185;
	psIN.v_world_normal = local_6;
	float local_415 = local_201.x;
	float local_416 = local_201.y;
	float local_417 = local_201.z;
	float local_418 = local_201.w;
	float4 local_419 = { local_279.x, local_279.y, local_279.z, local_415 };
	psIN.v_texture5 = local_419;
	return psIN;
}
