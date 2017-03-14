#ifndef LIGHT_MAP_ENABLE
#define LIGHT_MAP_ENABLE 0
#endif

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

#ifndef INSTANCE_TYPE_NONE
#define INSTANCE_TYPE_NONE 0
#endif

#ifndef INSTANCE_TYPE_PRS
#define INSTANCE_TYPE_PRS 1
#endif

#ifndef INSTANCE_TYPE_PRS_LM
#define INSTANCE_TYPE_PRS_LM 2
#endif

#ifndef INSTANCE_TYPE
#define INSTANCE_TYPE INSTANCE_TYPE_NONE
#endif

#ifndef SHADOW_MAP_ENABLE
#define SHADOW_MAP_ENABLE 0
#endif

#ifndef SYSTEM_UV_ORIGIN_LEFT_BOTTOM
#define SYSTEM_UV_ORIGIN_LEFT_BOTTOM 0
#endif

#if INSTANCE_TYPE == INSTANCE_TYPE_NONE
float4x4 WorldViewProjection;
#endif
#if INSTANCE_TYPE == INSTANCE_TYPE_NONE
float4x4 World;
#endif
#if FOG_TYPE == FOG_TYPE_LINEAR
float4x4 Projection;
#endif
float4x4 TexTransform0;
#if INSTANCE_TYPE == INSTANCE_TYPE_NONE || INSTANCE_TYPE == INSTANCE_TYPE_PRS
float4x4 LightMapTransform;
#endif
#if FOG_TYPE == FOG_TYPE_HEIGHT || 1
float4 camera_pos;
#endif
#if INSTANCE_TYPE == INSTANCE_TYPE_PRS || INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM || NEOX_DEBUG_DEFERED_STATIC_LIGHT
float4x4 ViewProjection;
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
#if INSTANCE_TYPE == INSTANCE_TYPE_NONE || INSTANCE_TYPE == INSTANCE_TYPE_PRS
float4 lightmap_scale;
#endif
#if SHADOW_MAP_ENABLE
float4x4 lvp;
#endif
#if FOG_TYPE == FOG_TYPE_HEIGHT || SHADOW_MAP_ENABLE || 1
float4 ShadowLightAttr[LIGHT_ATTR_ITEM_NUM];
#endif
struct VS_INPUT
{
#if GPU_SKIN_ENABLE || !(GPU_SKIN_ENABLE)
	float4 a_position: POSITION;
#endif
	float4 a_texture0: TEXCOORD0;
#if INSTANCE_TYPE == INSTANCE_TYPE_NONE || INSTANCE_TYPE == INSTANCE_TYPE_PRS || INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM
	float4 a_texture1: TEXCOORD1;
#endif
#if GPU_SKIN_ENABLE || !(GPU_SKIN_ENABLE)
	float4 a_normal: NORMAL;
#endif
#if GPU_SKIN_ENABLE
	float4 a_blendindices: BLENDINDICES;
#endif
#if GPU_SKIN_ENABLE
	float4 a_blendweight: BLENDWEIGHT;
#endif
#if INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM
	float4 a_texture3: TEXCOORD3;
#endif
#if INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM
	float4 a_texture4: TEXCOORD4;
#endif
#if INSTANCE_TYPE == INSTANCE_TYPE_PRS || INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM
	float4 a_texture5: TEXCOORD5;
#endif
#if INSTANCE_TYPE == INSTANCE_TYPE_PRS || INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM
	float4 a_texture6: TEXCOORD6;
#endif
#if INSTANCE_TYPE == INSTANCE_TYPE_PRS || INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM
	float4 a_texture7: TEXCOORD7;
#endif
};
struct PS_INPUT
{
	float4 final_position: POSITION;
	float2 uv0: TEXCOORD0;
#if INSTANCE_TYPE == INSTANCE_TYPE_NONE || INSTANCE_TYPE == INSTANCE_TYPE_PRS || INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM
	float2 uv1: TEXCOORD1;
#endif
	float4 v_world_position: TEXCOORD2;
	float3 v_world_normal: TEXCOORD3;
#if SHADOW_MAP_ENABLE
	float4 v_texture3: TEXCOORD4;
#endif
	float4 fog_factor_info: TEXCOORD5;
#if INSTANCE_TYPE == INSTANCE_TYPE_NONE || INSTANCE_TYPE == INSTANCE_TYPE_PRS || INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM
	float4 v_texture5: TEXCOORD6;
#endif
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
	float4 local_220;
	float4 local_221;
	float3 local_222;
#if INSTANCE_TYPE==INSTANCE_TYPE_NONE
	float4 local_223 = mul(local_0, WorldViewProjection);
	float4 local_224 = mul(local_0, World);
	float3 local_225 = local_1.xyz;
	float local_226 = local_1.w;
	float3x3 local_227 = (float3x3)World;
	float3 local_228 = mul(local_225, local_227);
	float3 local_229 = normalize(local_228);
	local_220 = local_223;
	local_221 = local_224;
	local_222 = local_229;
#elif INSTANCE_TYPE==INSTANCE_TYPE_PRS
	float local_230 = vsIN.a_texture5.x;
	float local_231 = vsIN.a_texture5.y;
	float local_232 = vsIN.a_texture5.z;
	float local_233 = vsIN.a_texture5.w;
	float local_234 = vsIN.a_texture6.x;
	float local_235 = vsIN.a_texture6.y;
	float local_236 = vsIN.a_texture6.z;
	float local_237 = vsIN.a_texture6.w;
	float local_238 = vsIN.a_texture7.x;
	float local_239 = vsIN.a_texture7.y;
	float local_240 = vsIN.a_texture7.z;
	float local_241 = vsIN.a_texture7.w;
	const float local_242 = 0.0f;
	float4 local_243 = { local_230, local_234, local_238, local_242 };
	float4 local_244 = { local_231, local_235, local_239, local_242 };
	float4 local_245 = { local_232, local_236, local_240, local_242 };
	const float local_246 = 1.0f;
	float4 local_247 = { local_233, local_237, local_241, local_246 };
	float4x4 local_248 = float4x4(local_243, local_244, local_245, local_247);
	float4 local_249 = mul(local_0, local_248);
	float4 local_250 = mul(local_249, ViewProjection);
	float3 local_251 = local_1.xyz;
	float local_252 = local_1.w;
	float3x3 local_253 = (float3x3)local_248;
	float3 local_254 = mul(local_251, local_253);
	float3 local_255 = normalize(local_254);
	local_220 = local_250;
	local_221 = local_249;
	local_222 = local_255;
#elif INSTANCE_TYPE==INSTANCE_TYPE_PRS_LM
	float local_256 = vsIN.a_texture5.x;
	float local_257 = vsIN.a_texture5.y;
	float local_258 = vsIN.a_texture5.z;
	float local_259 = vsIN.a_texture5.w;
	float local_260 = vsIN.a_texture6.x;
	float local_261 = vsIN.a_texture6.y;
	float local_262 = vsIN.a_texture6.z;
	float local_263 = vsIN.a_texture6.w;
	float local_264 = vsIN.a_texture7.x;
	float local_265 = vsIN.a_texture7.y;
	float local_266 = vsIN.a_texture7.z;
	float local_267 = vsIN.a_texture7.w;
	const float local_268 = 0.0f;
	float4 local_269 = { local_256, local_260, local_264, local_268 };
	float4 local_270 = { local_257, local_261, local_265, local_268 };
	float4 local_271 = { local_258, local_262, local_266, local_268 };
	const float local_272 = 1.0f;
	float4 local_273 = { local_259, local_263, local_267, local_272 };
	float4x4 local_274 = float4x4(local_269, local_270, local_271, local_273);
	float4 local_275 = mul(local_0, local_274);
	float4 local_276 = mul(local_275, ViewProjection);
	float3 local_277 = local_1.xyz;
	float local_278 = local_1.w;
	float3x3 local_279 = (float3x3)local_274;
	float3 local_280 = mul(local_277, local_279);
	float3 local_281 = normalize(local_280);
	local_220 = local_276;
	local_221 = local_275;
	local_222 = local_281;
#endif
	psIN.final_position = local_220;
#if LIGHT_MAP_ENABLE
#else
#endif
	psIN.v_world_position = local_221;
	psIN.v_world_normal = local_222;
	float4 local_282;
#if FOG_TYPE==FOG_TYPE_NONE
	const float local_283 = 0.0f;
	float4 local_284 = { local_283, local_283, local_283, local_283 };
	local_282 = local_284;
#elif FOG_TYPE==FOG_TYPE_LINEAR
	float local_285;
	// Function calc_fog_factor Begin 
	{
		float local_287 = FogInfo.x;
		float local_288 = FogInfo.y;
		float local_289 = FogInfo.z;
		float local_290 = FogInfo.w;
		const int local_291 = 2;
		float local_292 = local_220[local_291];
		const int local_293 = 1;
		float local_294 = local_221[local_293];
		float local_295;
		// Function get_fog_height Begin 
		{
			float local_297;
			// Function get_fog_linear Begin 
			{
				const float local_299 = 0.0f;
				const float local_300 = 1.0f;
				float4 local_301 = { local_299, local_299, local_287, local_300 };
				float4 local_302 = mul(local_301, Projection);
				float2 local_303 = local_302.xy;
				float local_304 = local_302.z;
				float local_305 = local_302.w;
				float4 local_306 = { local_299, local_299, local_288, local_300 };
				float4 local_307 = mul(local_306, Projection);
				float2 local_308 = local_307.xy;
				float local_309 = local_307.z;
				float local_310 = local_307.w;
				float local_311 = smoothstep(local_304, local_309, local_292);
				float local_312 = saturate(local_311);
				local_297 = local_312;
			}
			// Function get_fog_linear End
			float local_314 = local_294 - local_289;
			float local_315 = local_290 - local_289;
			float local_316 = local_314 / local_315;
			float local_317 = saturate(local_316);
			float local_318 = max(local_297, local_317);
			local_295 = local_318;
		}
		// Function get_fog_height End
		local_285 = local_295;
	}
	// Function calc_fog_factor End
	const float local_321 = 0.0f;
	float3 local_322 = { local_321, local_321, local_321 };
	float4 local_323 = { local_285, local_322.x, local_322.y, local_322.z };
	local_282 = local_323;
#elif FOG_TYPE==FOG_TYPE_HEIGHT
	const int local_324 = 3;
	float4 local_325 = ShadowLightAttr[local_324];
	float4 local_326;
	// Function calc_fog_textured_factor Begin 
	{
		float3 local_328 = local_221.xyz;
		float local_329 = local_221.w;
		float3 local_330 = camera_pos.xyz;
		float local_331 = camera_pos.w;
		float3 local_332 = local_328 - local_330;
		float3 local_333 = normalize(local_332);
		float local_334 = length(local_332);
		float local_335 = FogInfo.x;
		float local_336 = FogInfo.y;
		float local_337 = FogInfo.z;
		float local_338 = FogInfo.w;
		float local_339 = local_334 - local_337;
		float local_340 = local_338 - local_337;
		float local_341 = local_339 / local_340;
		float local_342 = saturate(local_341);
		float local_343 = pow(local_342, local_336);
		float local_344 = local_335 * local_343;
		const float local_345 = 0.5f;
		float local_346 = local_333.x;
		float local_347 = local_333.y;
		float local_348 = local_333.z;
		const float local_349 = 1.0f;
		float local_350 = local_347 + local_349;
		float local_351 = local_345 * local_350;
		float local_352 = FogInfoEX.x;
		float local_353 = FogInfoEX.y;
		float local_354 = FogInfoEX.z;
		float local_355 = FogInfoEX.w;
		float local_356;
		float local_357;
		float local_358;
		// Function calc_fog_height_factor Begin 
		{
			const float local_360 = 0.001f;
			float local_361 = local_354 - local_355;
			float local_362 = max(local_360, local_361);
			const float local_363 = 1.0f;
			float local_364 = local_363 / local_362;
			float local_365 = camera_pos.x;
			float local_366 = camera_pos.y;
			float2 local_367 = camera_pos.zw;
			float local_368 = local_333.x;
			float local_369 = local_333.y;
			float local_370 = local_333.z;
			float local_371 = local_366 - local_354;
			float local_372 = -(local_369);
			float local_373 = saturate(local_372);
			float local_374 = max(local_373, local_360);
			float local_375 = local_371 / local_374;
			float local_376 = abs(local_371);
			float local_377 = saturate(local_369);
			float local_378 = max(local_377, local_360);
			float local_379 = local_376 / local_378;
			const float local_380 = 0.0f;
			float local_381 = max(local_380, local_375);
			float local_382 = min(local_334, local_379);
			float local_383 = max(local_382, local_381);
			float local_384 = local_383 - local_381;
			float local_385 = local_384 * local_364;
			float local_386 = local_354 - local_366;
			float local_387 = local_386 * local_364;
			float local_388 = saturate(local_387);
			float local_389 = local_388 * local_385;
			const float local_390 = 0.5f;
			float local_391 = local_390 * local_385;
			float local_392 = local_391 * local_385;
			float local_393 = local_392 * local_369;
			float local_394 = local_389 - local_393;
			const float local_395 = 0.1f;
			float local_396 = local_395 * local_352;
			float local_397 = max(local_360, local_396);
			float local_398 = local_394 * local_397;
			float local_399 = saturate(local_398);
			const float local_400 = 2.0f;
			float local_401 = local_400 * local_397;
			float local_402 = local_363 / local_401;
			float local_403 = local_388 * local_388;
			float local_404 = local_400 * local_369;
			float local_405 = local_404 * local_402;
			float local_406 = local_403 - local_405;
			float local_407 = saturate(local_406);
			float local_408 = sqrt(local_407);
			float local_409 = local_388 - local_408;
			float local_410 = local_409 / local_369;
			float local_411 = local_410 * local_362;
			float local_412 = local_381 + local_411;
			float local_413 = local_410 * local_369;
			float local_414 = local_388 - local_413;
			float local_415 = saturate(local_414);
			local_356 = local_399;
			local_357 = local_415;
			local_358 = local_412;
		}
		// Function calc_fog_height_factor End
		float local_417 = local_344 * local_344;
		float local_418 = local_356 * local_356;
		float local_419 = local_417 + local_418;
		float local_420 = sqrt(local_419);
		float local_421 = saturate(local_420);
		float local_422 = local_338 / local_358;
		float local_423 = saturate(local_422);
		float local_424 = local_356 * local_423;
		float2 local_425 = local_325.xy;
		float local_426 = local_325.z;
		float local_427 = local_325.w;
		float local_428 = local_325.x;
		float local_429 = local_325.y;
		float local_430 = local_325.z;
		float local_431 = local_325.w;
		float local_432 = atan2(local_426, local_428);
		const float local_433 = 0.159f;
		float local_434 = local_432 * local_433;
		float4 local_435 = { local_421, local_351, local_424, local_434 };
		local_326 = local_435;
	}
	// Function calc_fog_textured_factor End
	local_282 = local_326;
#endif
	float2 local_437 = vsIN.a_texture0.xy;
	float2 local_438 = vsIN.a_texture0.zw;
	const float local_439 = 1.0f;
	const float local_440 = 0.0f;
	float4 local_441 = { local_437.x, local_437.y, local_439, local_440 };
	float4 local_442 = mul(local_441, TexTransform0);
	float2 local_443 = local_442.xy;
	float2 local_444 = local_442.zw;
	psIN.uv0 = local_443;
	psIN.fog_factor_info = local_282;
#if INSTANCE_TYPE==INSTANCE_TYPE_NONE
	float2 local_445 = vsIN.a_texture1.xy;
	float2 local_446 = vsIN.a_texture1.zw;
	const float local_447 = 1.0f;
	const float local_448 = 0.0f;
	float4 local_449 = { local_445.x, local_445.y, local_447, local_448 };
	float4 local_450 = mul(local_449, LightMapTransform);
	float2 local_451 = local_450.xy;
	float2 local_452 = local_450.zw;
	psIN.uv1 = local_451;
	psIN.v_texture5 = lightmap_scale;
#elif INSTANCE_TYPE==INSTANCE_TYPE_PRS
	float2 local_453 = vsIN.a_texture1.xy;
	float2 local_454 = vsIN.a_texture1.zw;
	const float local_455 = 1.0f;
	const float local_456 = 0.0f;
	float4 local_457 = { local_453.x, local_453.y, local_455, local_456 };
	float4 local_458 = mul(local_457, LightMapTransform);
	float2 local_459 = local_458.xy;
	float2 local_460 = local_458.zw;
	psIN.uv1 = local_459;
	psIN.v_texture5 = lightmap_scale;
#elif INSTANCE_TYPE==INSTANCE_TYPE_PRS_LM
	float2 local_461 = vsIN.a_texture1.xy;
	float2 local_462 = vsIN.a_texture1.zw;
	float2 local_463 = vsIN.a_texture4.xy;
	float2 local_464 = vsIN.a_texture4.zw;
	float2 local_465 = local_461 * local_463;
	float2 local_466 = local_465 + local_464;
	psIN.uv1 = local_466;
	psIN.v_texture5 = vsIN.a_texture3;
#endif
#if SHADOW_MAP_ENABLE
	const int local_467 = 3;
	float4 local_468 = ShadowLightAttr[local_467];
	float4 local_469;
	// Function calc_shadowmap_info Begin 
	{
		float3 local_471 = local_468.xyz;
		float local_472 = local_468.w;
		float2 local_473;
		float local_474;
		float local_475;
		// Function calc_shadow_info Begin 
		{
			float4 local_477 = mul(local_221, lvp);
			float3 local_478 = local_477.xyz;
			float local_479 = local_477.w;
			float3 local_480 = { local_479, local_479, local_479 };
			float3 local_481 = local_478 / local_480;
			float2 local_482 = local_481.xy;
			float local_483 = local_481.z;
			float2 local_484;
#if SYSTEM_UV_ORIGIN_LEFT_BOTTOM
			const float local_485 = 0.5f;
			float2 local_486 = { local_485, local_485 };
			local_484 = local_486;
#else
			const float local_487 = 0.5f;
			float local_488 = -(local_487);
			float2 local_489 = { local_487, local_488 };
			local_484 = local_489;
#endif
			float2 local_490 = local_482 * local_484;
			const float local_491 = 0.5f;
			float2 local_492 = { local_491, local_491 };
			float2 local_493 = local_490 + local_492;
			float3 local_494 = -(local_222);
			float3 local_495 = normalize(local_471);
			float local_496 = dot(local_494, local_495);
			float local_497 = saturate(local_496);
			local_473 = local_493;
			local_474 = local_483;
			local_475 = local_497;
		}
		// Function calc_shadow_info End
		float4 local_499 = { local_473.x, local_473.y, local_474, local_475 };
		local_469 = local_499;
	}
	// Function calc_shadowmap_info End
	psIN.v_texture3 = local_469;
#else
#endif
	return psIN;
}
