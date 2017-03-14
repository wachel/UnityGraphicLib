#ifndef GPU_SKIN_ENABLE
#define GPU_SKIN_ENABLE 0
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

#ifndef UNIFORMS_120
#define UNIFORMS_120 120
#endif

#ifndef UNIFORMS_180
#define UNIFORMS_180 180
#endif

#ifndef MAX_BONE_UNIFORM_COUNT
#define MAX_BONE_UNIFORM_COUNT UNIFORMS_180
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

#ifndef SYSTEM_UV_ORIGIN_LEFT_BOTTOM
#define SYSTEM_UV_ORIGIN_LEFT_BOTTOM 0
#endif

float4x4 WorldViewProjection;
float4x4 World;
#if FOG_TYPE == FOG_TYPE_LINEAR
float4x4 Projection;
#endif
float4x4 TexTransform0;
#if FOG_TYPE == FOG_TYPE_HEIGHT || 1
float4 camera_pos;
#endif
#if FOG_TYPE == FOG_TYPE_LINEAR || FOG_TYPE == FOG_TYPE_HEIGHT
float4 FogInfo;
#endif
#if FOG_TYPE == FOG_TYPE_HEIGHT
float4 FogInfoEX;
#endif
#if GPU_SKIN_ENABLE
float4 SkinBones[MAX_BONE_UNIFORM_COUNT];
#endif
#if SHADOW_MAP_ENABLE
float4x4 lvp;
#endif
float4 ShadowLightAttr[LIGHT_ATTR_ITEM_NUM];
float4 PointLightAttrs[LIGHT_ATTR_ITEM_NUM*LIGHT_NUM];
float4 shadow_light_newdir;
float4 shadow_light_new;
struct VS_INPUT
{
#if GPU_SKIN_ENABLE || !(GPU_SKIN_ENABLE)
	float4 a_position: POSITION;
#endif
	float4 a_texture0: TEXCOORD0;
#if GPU_SKIN_ENABLE || !(GPU_SKIN_ENABLE)
	float4 a_normal: NORMAL;
#endif
	float4 a_tangent: TANGENT;
#if GPU_SKIN_ENABLE
	float4 a_blendindices: BLENDINDICES;
#endif
#if GPU_SKIN_ENABLE
	float4 a_blendweight: BLENDWEIGHT;
#endif
};
struct PS_INPUT
{
	float4 final_position: POSITION;
	float2 uv0: TEXCOORD0;
	float4 v_world_position: TEXCOORD1;
	float3 v_world_normal: TEXCOORD2;
	float3 v_world_tangent: TEXCOORD3;
	float3 v_world_binormal: TEXCOORD4;
#if SHADOW_MAP_ENABLE
	float4 v_texture3: TEXCOORD5;
#endif
	float4 fog_factor_info: TEXCOORD6;
	float4 v_texture6: TEXCOORD7;
	float4 v_texture1: TEXCOORD8;
	float4 v_texture2: TEXCOORD9;
};
PS_INPUT vs_main(VS_INPUT vsIN)
{
	PS_INPUT psIN = (PS_INPUT)0;
	float4 local_0;
	float4 local_1;
#if GPU_SKIN_ENABLE
	int4 local_2 = { (int)vsIN.a_blendindices.x, (int)vsIN.a_blendindices.y, (int)vsIN.a_blendindices.z, (int)vsIN.a_blendindices.w };
	float4 local_3;
	float4 local_4;
	// Function gpu_skinning Begin 
	{
		const float local_6 = 0.0f;
		float3 local_7 = { local_6, local_6, local_6 };
		float3 local_8 = local_7;
		float3 local_9 = local_7;
		int local_10;
		local_10 = 0;
		float local_11 = vsIN.a_blendweight[local_10];
		const int local_12 = 0;
		int local_13 = local_2[local_12];
		const int local_14 = 2;
		int local_15 = (int)local_14;
		int local_16 = local_13 * local_15;
		int local_17 = local_2[local_10];
		int local_18 = (int)local_14;
		int local_19 = local_17 * local_18;
		float4 local_20 = SkinBones[local_16];
		float4 local_21 = SkinBones[local_19];
		const int local_22 = 1;
		int local_23 = local_19 + local_22;
		float4 local_24 = SkinBones[local_23];
		float local_25 = dot(local_20, local_21);
		float local_26 = sign(local_25);
		float4 local_27 = mul(local_21, local_26);
		float3 local_28 = vsIN.a_position.xyz;
		float local_29 = vsIN.a_position.w;
		float3 local_30 = local_24.xyz;
		float local_31 = local_24.w;
		float3 local_32 = mul(local_28, local_31);
		float3 local_33;
		// Function quat_rot_vec3 Begin 
		{
			float3 local_35 = local_27.xyz;
			float local_36 = local_27.w;
			float3 local_37 = mul(local_32, local_36);
			float3 local_38 = cross(local_35, local_32);
			float3 local_39 = local_37 + local_38;
			float3 local_40 = cross(local_35, local_39);
			const float local_41 = 2.0f;
			float3 local_42 = mul(local_40, local_41);
			float3 local_43 = local_42 + local_32;
			local_33 = local_43;
		}
		// Function quat_rot_vec3 End
		float3 local_45 = local_33 + local_30;
		float3 local_46 = mul(local_45, local_11);
		float3 local_47 = vsIN.a_normal.xyz;
		float local_48 = vsIN.a_normal.w;
		float3 local_49;
		// Function quat_rot_vec3 Begin 
		{
			float3 local_51 = local_27.xyz;
			float local_52 = local_27.w;
			float3 local_53 = mul(local_47, local_52);
			float3 local_54 = cross(local_51, local_47);
			float3 local_55 = local_53 + local_54;
			float3 local_56 = cross(local_51, local_55);
			const float local_57 = 2.0f;
			float3 local_58 = mul(local_56, local_57);
			float3 local_59 = local_58 + local_47;
			local_49 = local_59;
		}
		// Function quat_rot_vec3 End
		float3 local_61 = mul(local_49, local_11);
		local_8 += local_46;
		local_9 += local_61;
		local_10 = 1;
		float local_62 = vsIN.a_blendweight[local_10];
		const int local_63 = 0;
		int local_64 = local_2[local_63];
		const int local_65 = 2;
		int local_66 = (int)local_65;
		int local_67 = local_64 * local_66;
		int local_68 = local_2[local_10];
		int local_69 = (int)local_65;
		int local_70 = local_68 * local_69;
		float4 local_71 = SkinBones[local_67];
		float4 local_72 = SkinBones[local_70];
		const int local_73 = 1;
		int local_74 = local_70 + local_73;
		float4 local_75 = SkinBones[local_74];
		float local_76 = dot(local_71, local_72);
		float local_77 = sign(local_76);
		float4 local_78 = mul(local_72, local_77);
		float3 local_79 = vsIN.a_position.xyz;
		float local_80 = vsIN.a_position.w;
		float3 local_81 = local_75.xyz;
		float local_82 = local_75.w;
		float3 local_83 = mul(local_79, local_82);
		float3 local_84;
		// Function quat_rot_vec3 Begin 
		{
			float3 local_86 = local_78.xyz;
			float local_87 = local_78.w;
			float3 local_88 = mul(local_83, local_87);
			float3 local_89 = cross(local_86, local_83);
			float3 local_90 = local_88 + local_89;
			float3 local_91 = cross(local_86, local_90);
			const float local_92 = 2.0f;
			float3 local_93 = mul(local_91, local_92);
			float3 local_94 = local_93 + local_83;
			local_84 = local_94;
		}
		// Function quat_rot_vec3 End
		float3 local_96 = local_84 + local_81;
		float3 local_97 = mul(local_96, local_62);
		float3 local_98 = vsIN.a_normal.xyz;
		float local_99 = vsIN.a_normal.w;
		float3 local_100;
		// Function quat_rot_vec3 Begin 
		{
			float3 local_102 = local_78.xyz;
			float local_103 = local_78.w;
			float3 local_104 = mul(local_98, local_103);
			float3 local_105 = cross(local_102, local_98);
			float3 local_106 = local_104 + local_105;
			float3 local_107 = cross(local_102, local_106);
			const float local_108 = 2.0f;
			float3 local_109 = mul(local_107, local_108);
			float3 local_110 = local_109 + local_98;
			local_100 = local_110;
		}
		// Function quat_rot_vec3 End
		float3 local_112 = mul(local_100, local_62);
		local_8 += local_97;
		local_9 += local_112;
		local_10 = 2;
		float local_113 = vsIN.a_blendweight[local_10];
		const int local_114 = 0;
		int local_115 = local_2[local_114];
		const int local_116 = 2;
		int local_117 = (int)local_116;
		int local_118 = local_115 * local_117;
		int local_119 = local_2[local_10];
		int local_120 = (int)local_116;
		int local_121 = local_119 * local_120;
		float4 local_122 = SkinBones[local_118];
		float4 local_123 = SkinBones[local_121];
		const int local_124 = 1;
		int local_125 = local_121 + local_124;
		float4 local_126 = SkinBones[local_125];
		float local_127 = dot(local_122, local_123);
		float local_128 = sign(local_127);
		float4 local_129 = mul(local_123, local_128);
		float3 local_130 = vsIN.a_position.xyz;
		float local_131 = vsIN.a_position.w;
		float3 local_132 = local_126.xyz;
		float local_133 = local_126.w;
		float3 local_134 = mul(local_130, local_133);
		float3 local_135;
		// Function quat_rot_vec3 Begin 
		{
			float3 local_137 = local_129.xyz;
			float local_138 = local_129.w;
			float3 local_139 = mul(local_134, local_138);
			float3 local_140 = cross(local_137, local_134);
			float3 local_141 = local_139 + local_140;
			float3 local_142 = cross(local_137, local_141);
			const float local_143 = 2.0f;
			float3 local_144 = mul(local_142, local_143);
			float3 local_145 = local_144 + local_134;
			local_135 = local_145;
		}
		// Function quat_rot_vec3 End
		float3 local_147 = local_135 + local_132;
		float3 local_148 = mul(local_147, local_113);
		float3 local_149 = vsIN.a_normal.xyz;
		float local_150 = vsIN.a_normal.w;
		float3 local_151;
		// Function quat_rot_vec3 Begin 
		{
			float3 local_153 = local_129.xyz;
			float local_154 = local_129.w;
			float3 local_155 = mul(local_149, local_154);
			float3 local_156 = cross(local_153, local_149);
			float3 local_157 = local_155 + local_156;
			float3 local_158 = cross(local_153, local_157);
			const float local_159 = 2.0f;
			float3 local_160 = mul(local_158, local_159);
			float3 local_161 = local_160 + local_149;
			local_151 = local_161;
		}
		// Function quat_rot_vec3 End
		float3 local_163 = mul(local_151, local_113);
		local_8 += local_148;
		local_9 += local_163;
		local_10 = 3;
		float local_164 = vsIN.a_blendweight[local_10];
		const int local_165 = 0;
		int local_166 = local_2[local_165];
		const int local_167 = 2;
		int local_168 = (int)local_167;
		int local_169 = local_166 * local_168;
		int local_170 = local_2[local_10];
		int local_171 = (int)local_167;
		int local_172 = local_170 * local_171;
		float4 local_173 = SkinBones[local_169];
		float4 local_174 = SkinBones[local_172];
		const int local_175 = 1;
		int local_176 = local_172 + local_175;
		float4 local_177 = SkinBones[local_176];
		float local_178 = dot(local_173, local_174);
		float local_179 = sign(local_178);
		float4 local_180 = mul(local_174, local_179);
		float3 local_181 = vsIN.a_position.xyz;
		float local_182 = vsIN.a_position.w;
		float3 local_183 = local_177.xyz;
		float local_184 = local_177.w;
		float3 local_185 = mul(local_181, local_184);
		float3 local_186;
		// Function quat_rot_vec3 Begin 
		{
			float3 local_188 = local_180.xyz;
			float local_189 = local_180.w;
			float3 local_190 = mul(local_185, local_189);
			float3 local_191 = cross(local_188, local_185);
			float3 local_192 = local_190 + local_191;
			float3 local_193 = cross(local_188, local_192);
			const float local_194 = 2.0f;
			float3 local_195 = mul(local_193, local_194);
			float3 local_196 = local_195 + local_185;
			local_186 = local_196;
		}
		// Function quat_rot_vec3 End
		float3 local_198 = local_186 + local_183;
		float3 local_199 = mul(local_198, local_164);
		float3 local_200 = vsIN.a_normal.xyz;
		float local_201 = vsIN.a_normal.w;
		float3 local_202;
		// Function quat_rot_vec3 Begin 
		{
			float3 local_204 = local_180.xyz;
			float local_205 = local_180.w;
			float3 local_206 = mul(local_200, local_205);
			float3 local_207 = cross(local_204, local_200);
			float3 local_208 = local_206 + local_207;
			float3 local_209 = cross(local_204, local_208);
			const float local_210 = 2.0f;
			float3 local_211 = mul(local_209, local_210);
			float3 local_212 = local_211 + local_200;
			local_202 = local_212;
		}
		// Function quat_rot_vec3 End
		float3 local_214 = mul(local_202, local_164);
		local_8 += local_199;
		local_9 += local_214;
		float3 local_215 = vsIN.a_position.xyz;
		float local_216 = vsIN.a_position.w;
		float4 local_217 = { local_8.x, local_8.y, local_8.z, local_216 };
		float4 local_218 = { local_9.x, local_9.y, local_9.z, 0.0f };
		local_3 = local_217;
		local_4 = local_218;
	}
	// Function gpu_skinning End
	local_0 = local_3;
	local_1 = local_4;
#else
	local_0 = vsIN.a_position;
	local_1 = vsIN.a_normal;
#endif
	float4 local_220 = mul(local_0, WorldViewProjection);
	psIN.final_position = local_220;
	float4 local_221 = mul(local_0, World);
	psIN.v_world_position = local_221;
	float3x3 local_222 = (float3x3)World;
	float3 local_223 = local_1.xyz;
	float local_224 = local_1.w;
	float3 local_225 = mul(local_223, local_222);
	float3 local_226 = normalize(local_225);
	psIN.v_world_normal = local_226;
	float4 local_227;
#if FOG_TYPE==FOG_TYPE_NONE
	const float local_228 = 0.0f;
	float4 local_229 = { local_228, local_228, local_228, local_228 };
	local_227 = local_229;
#elif FOG_TYPE==FOG_TYPE_LINEAR
	float local_230;
	// Function calc_fog_factor Begin 
	{
		float local_232 = FogInfo.x;
		float local_233 = FogInfo.y;
		float local_234 = FogInfo.z;
		float local_235 = FogInfo.w;
		const int local_236 = 2;
		float local_237 = local_220[local_236];
		const int local_238 = 1;
		float local_239 = local_221[local_238];
		float local_240;
		// Function get_fog_height Begin 
		{
			float local_242;
			// Function get_fog_linear Begin 
			{
				const float local_244 = 0.0f;
				const float local_245 = 1.0f;
				float4 local_246 = { local_244, local_244, local_232, local_245 };
				float4 local_247 = mul(local_246, Projection);
				float2 local_248 = local_247.xy;
				float local_249 = local_247.z;
				float local_250 = local_247.w;
				float4 local_251 = { local_244, local_244, local_233, local_245 };
				float4 local_252 = mul(local_251, Projection);
				float2 local_253 = local_252.xy;
				float local_254 = local_252.z;
				float local_255 = local_252.w;
				float local_256 = smoothstep(local_249, local_254, local_237);
				float local_257 = saturate(local_256);
				local_242 = local_257;
			}
			// Function get_fog_linear End
			float local_259 = local_239 - local_234;
			float local_260 = local_235 - local_234;
			float local_261 = local_259 / local_260;
			float local_262 = saturate(local_261);
			float local_263 = max(local_242, local_262);
			local_240 = local_263;
		}
		// Function get_fog_height End
		local_230 = local_240;
	}
	// Function calc_fog_factor End
	const float local_266 = 0.0f;
	float3 local_267 = { local_266, local_266, local_266 };
	float4 local_268 = { local_230, local_267.x, local_267.y, local_267.z };
	local_227 = local_268;
#elif FOG_TYPE==FOG_TYPE_HEIGHT
	const int local_269 = 3;
	float4 local_270 = ShadowLightAttr[local_269];
	float4 local_271;
	// Function calc_fog_textured_factor Begin 
	{
		float3 local_273 = local_221.xyz;
		float local_274 = local_221.w;
		float3 local_275 = camera_pos.xyz;
		float local_276 = camera_pos.w;
		float3 local_277 = local_273 - local_275;
		float3 local_278 = normalize(local_277);
		float local_279 = length(local_277);
		float local_280 = FogInfo.x;
		float local_281 = FogInfo.y;
		float local_282 = FogInfo.z;
		float local_283 = FogInfo.w;
		float local_284 = local_279 - local_282;
		float local_285 = local_283 - local_282;
		float local_286 = local_284 / local_285;
		float local_287 = saturate(local_286);
		float local_288 = pow(local_287, local_281);
		float local_289 = local_280 * local_288;
		const float local_290 = 0.5f;
		float local_291 = local_278.x;
		float local_292 = local_278.y;
		float local_293 = local_278.z;
		const float local_294 = 1.0f;
		float local_295 = local_292 + local_294;
		float local_296 = local_290 * local_295;
		float local_297 = FogInfoEX.x;
		float local_298 = FogInfoEX.y;
		float local_299 = FogInfoEX.z;
		float local_300 = FogInfoEX.w;
		float local_301;
		float local_302;
		float local_303;
		// Function calc_fog_height_factor Begin 
		{
			const float local_305 = 0.001f;
			float local_306 = local_299 - local_300;
			float local_307 = max(local_305, local_306);
			const float local_308 = 1.0f;
			float local_309 = local_308 / local_307;
			float local_310 = camera_pos.x;
			float local_311 = camera_pos.y;
			float2 local_312 = camera_pos.zw;
			float local_313 = local_278.x;
			float local_314 = local_278.y;
			float local_315 = local_278.z;
			float local_316 = local_311 - local_299;
			float local_317 = -(local_314);
			float local_318 = saturate(local_317);
			float local_319 = max(local_318, local_305);
			float local_320 = local_316 / local_319;
			float local_321 = abs(local_316);
			float local_322 = saturate(local_314);
			float local_323 = max(local_322, local_305);
			float local_324 = local_321 / local_323;
			const float local_325 = 0.0f;
			float local_326 = max(local_325, local_320);
			float local_327 = min(local_279, local_324);
			float local_328 = max(local_327, local_326);
			float local_329 = local_328 - local_326;
			float local_330 = local_329 * local_309;
			float local_331 = local_299 - local_311;
			float local_332 = local_331 * local_309;
			float local_333 = saturate(local_332);
			float local_334 = local_333 * local_330;
			const float local_335 = 0.5f;
			float local_336 = local_335 * local_330;
			float local_337 = local_336 * local_330;
			float local_338 = local_337 * local_314;
			float local_339 = local_334 - local_338;
			const float local_340 = 0.1f;
			float local_341 = local_340 * local_297;
			float local_342 = max(local_305, local_341);
			float local_343 = local_339 * local_342;
			float local_344 = saturate(local_343);
			const float local_345 = 2.0f;
			float local_346 = local_345 * local_342;
			float local_347 = local_308 / local_346;
			float local_348 = local_333 * local_333;
			float local_349 = local_345 * local_314;
			float local_350 = local_349 * local_347;
			float local_351 = local_348 - local_350;
			float local_352 = saturate(local_351);
			float local_353 = sqrt(local_352);
			float local_354 = local_333 - local_353;
			float local_355 = local_354 / local_314;
			float local_356 = local_355 * local_307;
			float local_357 = local_326 + local_356;
			float local_358 = local_355 * local_314;
			float local_359 = local_333 - local_358;
			float local_360 = saturate(local_359);
			local_301 = local_344;
			local_302 = local_360;
			local_303 = local_357;
		}
		// Function calc_fog_height_factor End
		float local_362 = local_289 * local_289;
		float local_363 = local_301 * local_301;
		float local_364 = local_362 + local_363;
		float local_365 = sqrt(local_364);
		float local_366 = saturate(local_365);
		float local_367 = local_283 / local_303;
		float local_368 = saturate(local_367);
		float local_369 = local_301 * local_368;
		float2 local_370 = local_270.xy;
		float local_371 = local_270.z;
		float local_372 = local_270.w;
		float local_373 = local_270.x;
		float local_374 = local_270.y;
		float local_375 = local_270.z;
		float local_376 = local_270.w;
		float local_377 = atan2(local_371, local_373);
		const float local_378 = 0.159f;
		float local_379 = local_377 * local_378;
		float4 local_380 = { local_366, local_296, local_369, local_379 };
		local_271 = local_380;
	}
	// Function calc_fog_textured_factor End
	local_227 = local_271;
#endif
	float2 local_382 = vsIN.a_texture0.xy;
	float2 local_383 = vsIN.a_texture0.zw;
	const float local_384 = 1.0f;
	const float local_385 = 0.0f;
	float4 local_386 = { local_382.x, local_382.y, local_384, local_385 };
	float4 local_387 = mul(local_386, TexTransform0);
	float2 local_388 = local_387.xy;
	float2 local_389 = local_387.zw;
	psIN.uv0 = local_388;
	psIN.fog_factor_info = local_227;
	float3 local_390;
	float3 local_391;
	// Function calc_normal_info Begin 
	{
		float3 local_393 = vsIN.a_tangent.xyz;
		float local_394 = vsIN.a_tangent.w;
		float3 local_395 = mul(local_393, local_222);
		float3 local_396 = normalize(local_395);
		float3 local_397 = cross(local_226, local_396);
		float3 local_398 = normalize(local_397);
		float local_399 = dot(local_393, local_393);
		const float local_400 = 1.5f;
		float local_401 = local_399 - local_400;
		float3 local_402;
		if (local_401>0.0)
		{
			float3 local_403 = -(local_398);
			local_402 = local_403;
		}
		else
		{
			local_402 = local_398;
		}
		local_390 = local_396;
		local_391 = local_402;
	}
	// Function calc_normal_info End
	psIN.v_world_tangent = local_390;
	psIN.v_world_binormal = local_391;
#if SHADOW_MAP_ENABLE
	const int local_405 = 3;
	float4 local_406 = ShadowLightAttr[local_405];
	float4 local_407;
	// Function calc_shadowmap_info Begin 
	{
		float3 local_409 = local_406.xyz;
		float local_410 = local_406.w;
		float2 local_411;
		float local_412;
		float local_413;
		// Function calc_shadow_info Begin 
		{
			float4 local_415 = mul(local_221, lvp);
			float3 local_416 = local_415.xyz;
			float local_417 = local_415.w;
			float3 local_418 = { local_417, local_417, local_417 };
			float3 local_419 = local_416 / local_418;
			float2 local_420 = local_419.xy;
			float local_421 = local_419.z;
			float2 local_422;
#if SYSTEM_UV_ORIGIN_LEFT_BOTTOM
			const float local_423 = 0.5f;
			float2 local_424 = { local_423, local_423 };
			local_422 = local_424;
#else
			const float local_425 = 0.5f;
			float local_426 = -(local_425);
			float2 local_427 = { local_425, local_426 };
			local_422 = local_427;
#endif
			float2 local_428 = local_420 * local_422;
			const float local_429 = 0.5f;
			float2 local_430 = { local_429, local_429 };
			float2 local_431 = local_428 + local_430;
			float3 local_432 = -(local_226);
			float3 local_433 = normalize(local_409);
			float local_434 = dot(local_432, local_433);
			float local_435 = saturate(local_434);
			local_411 = local_431;
			local_412 = local_421;
			local_413 = local_435;
		}
		// Function calc_shadow_info End
		float4 local_437 = { local_411.x, local_411.y, local_412, local_413 };
		local_407 = local_437;
	}
	// Function calc_shadowmap_info End
	psIN.v_texture3 = local_407;
#else
#endif
	float3 local_439 = local_221.xyz;
	float local_440 = local_221.w;
	float4 local_441;
	// Function calc_point_light_atten Begin 
	{
		const int local_443 = 3;
		float4 local_444 = PointLightAttrs[local_443];
		const int local_445 = 4;
		float4 local_446 = PointLightAttrs[local_445];
		float3 local_447 = local_444.xyz;
		float local_448 = local_444.w;
		float3 local_449 = local_439 - local_447;
		float3 local_450 = { local_448, local_448, local_448 };
		float3 local_451 = local_449 / local_450;
		const float local_452 = 1.0f;
		float local_453 = dot(local_451, local_451);
		float local_454 = local_452 - local_453;
		float local_455 = saturate(local_454);
		float local_456 = local_446.x;
		float local_457 = local_446.y;
		float local_458 = local_446.z;
		float local_459 = local_446.w;
		const float local_460 = 0.001f;
		float local_461 = local_456 + local_460;
		float local_462 = pow(local_455, local_461);
		const int local_463 = 8;
		float4 local_464 = PointLightAttrs[local_463];
		const int local_465 = 9;
		float4 local_466 = PointLightAttrs[local_465];
		float3 local_467 = local_464.xyz;
		float local_468 = local_464.w;
		float3 local_469 = local_439 - local_467;
		float3 local_470 = { local_468, local_468, local_468 };
		float3 local_471 = local_469 / local_470;
		float local_472 = dot(local_471, local_471);
		float local_473 = local_452 - local_472;
		float local_474 = saturate(local_473);
		float local_475 = local_466.x;
		float local_476 = local_466.y;
		float local_477 = local_466.z;
		float local_478 = local_466.w;
		float local_479 = local_475 + local_460;
		float local_480 = pow(local_474, local_479);
		const int local_481 = 13;
		float4 local_482 = PointLightAttrs[local_481];
		const int local_483 = 14;
		float4 local_484 = PointLightAttrs[local_483];
		float3 local_485 = local_482.xyz;
		float local_486 = local_482.w;
		float3 local_487 = local_439 - local_485;
		float3 local_488 = { local_486, local_486, local_486 };
		float3 local_489 = local_487 / local_488;
		float local_490 = dot(local_489, local_489);
		float local_491 = local_452 - local_490;
		float local_492 = saturate(local_491);
		float local_493 = local_484.x;
		float local_494 = local_484.y;
		float local_495 = local_484.z;
		float local_496 = local_484.w;
		float local_497 = local_493 + local_460;
		float local_498 = pow(local_492, local_497);
		const int local_499 = 18;
		float4 local_500 = PointLightAttrs[local_499];
		const int local_501 = 19;
		float4 local_502 = PointLightAttrs[local_501];
		float3 local_503 = local_500.xyz;
		float local_504 = local_500.w;
		float3 local_505 = local_439 - local_503;
		float3 local_506 = { local_504, local_504, local_504 };
		float3 local_507 = local_505 / local_506;
		float local_508 = dot(local_507, local_507);
		float local_509 = local_452 - local_508;
		float local_510 = saturate(local_509);
		float local_511 = local_502.x;
		float local_512 = local_502.y;
		float local_513 = local_502.z;
		float local_514 = local_502.w;
		float local_515 = local_511 + local_460;
		float local_516 = pow(local_510, local_515);
		float4 local_517 = { local_462, local_480, local_498, local_516 };
		local_441 = local_517;
	}
	// Function calc_point_light_atten End
	psIN.v_texture6 = local_441;
	const int local_519 = 3;
	float4 local_520 = ShadowLightAttr[local_519];
	const int local_521 = 1;
	float4 local_522 = ShadowLightAttr[local_521];
	float3 local_523 = shadow_light_newdir.xyz;
	float local_524 = shadow_light_newdir.w;
	float4 local_525 = { local_524, local_524, local_524, local_524 };
	float4 local_526 = lerp(local_522, shadow_light_new, local_525);
	float3 local_527 = local_520.xyz;
	float local_528 = local_520.w;
	float3 local_529 = { local_524, local_524, local_524 };
	float3 local_530 = lerp(local_527, local_523, local_529);
	float3 local_531 = normalize(local_530);
	float4 local_532 = { local_531.x, local_531.y, local_531.z, local_528 };
	psIN.v_texture1 = local_532;
	psIN.v_texture2 = local_526;
	return psIN;
}
