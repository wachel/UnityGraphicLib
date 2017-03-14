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
float4x4 envSHR;
float4x4 envSHG;
float4x4 envSHB;
float4x4 envRot;
float env_exposure;
#if SHADOW_MAP_ENABLE
float4x4 lvp;
#endif
#if FOG_TYPE == FOG_TYPE_HEIGHT || SHADOW_MAP_ENABLE || 1
float4 ShadowLightAttr[LIGHT_ATTR_ITEM_NUM];
#endif
float4 PointLightAttrs[LIGHT_ATTR_ITEM_NUM*LIGHT_NUM];
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
	float4 a_tangent: TANGENT;
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
	float4 v_texture0: TEXCOORD0;
	float4 v_texture1: TEXCOORD1;
	float4 v_world_position: TEXCOORD2;
	float3 v_world_normal: TEXCOORD3;
	float3 v_world_tangent: TEXCOORD4;
	float3 v_world_binormal: TEXCOORD5;
#if SHADOW_MAP_ENABLE
	float4 v_texture3: TEXCOORD6;
#endif
	float4 fog_factor_info: TEXCOORD7;
	float3 v_texture5: TEXCOORD8;
	float4 v_texture6: TEXCOORD9;
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
		int local_6 = local_2.x;
		int local_7 = local_2.y;
		int local_8 = local_2.z;
		int local_9 = local_2.w;
		const int local_10 = 2;
		int local_11 = (int)local_10;
		int local_12 = local_6 * local_11;
		int local_13 = (int)local_10;
		int local_14 = local_7 * local_13;
		int local_15 = (int)local_10;
		int local_16 = local_8 * local_15;
		int local_17 = (int)local_10;
		int local_18 = local_9 * local_17;
		float4 local_19 = SkinBones[local_12];
		float local_20 = vsIN.a_blendweight.x;
		float local_21 = vsIN.a_blendweight.y;
		float local_22 = vsIN.a_blendweight.z;
		float local_23 = vsIN.a_blendweight.w;
		const int local_24 = 1;
		int local_25 = (int)local_24;
		int local_26 = local_12 + local_25;
		float4 local_27 = SkinBones[local_26];
		float3 local_28;
		float3 local_29;
		// Function dq_transform Begin 
		{
			float local_31 = dot(local_19, local_19);
			float local_32 = sign(local_31);
			float4 local_33 = mul(local_19, local_32);
			float3 local_34 = vsIN.a_position.xyz;
			float local_35 = vsIN.a_position.w;
			float3 local_36 = local_27.xyz;
			float local_37 = local_27.w;
			float3 local_38 = mul(local_34, local_37);
			float3 local_39;
			// Function quat_rot_vec3 Begin 
			{
				float3 local_41 = local_33.xyz;
				float local_42 = local_33.w;
				float3 local_43 = mul(local_38, local_42);
				float3 local_44 = cross(local_41, local_38);
				float3 local_45 = local_43 + local_44;
				float3 local_46 = cross(local_41, local_45);
				const float local_47 = 2.0f;
				float3 local_48 = mul(local_46, local_47);
				float3 local_49 = local_48 + local_38;
				local_39 = local_49;
			}
			// Function quat_rot_vec3 End
			float3 local_51 = local_39 + local_36;
			float3 local_52 = mul(local_51, local_20);
			float3 local_53 = vsIN.a_normal.xyz;
			float local_54 = vsIN.a_normal.w;
			float3 local_55;
			// Function quat_rot_vec3 Begin 
			{
				float3 local_57 = local_33.xyz;
				float local_58 = local_33.w;
				float3 local_59 = mul(local_53, local_58);
				float3 local_60 = cross(local_57, local_53);
				float3 local_61 = local_59 + local_60;
				float3 local_62 = cross(local_57, local_61);
				const float local_63 = 2.0f;
				float3 local_64 = mul(local_62, local_63);
				float3 local_65 = local_64 + local_53;
				local_55 = local_65;
			}
			// Function quat_rot_vec3 End
			float3 local_67 = mul(local_55, local_20);
			local_28 = local_52;
			local_29 = local_67;
		}
		// Function dq_transform End
		float4 local_69 = SkinBones[local_14];
		int local_70 = (int)local_24;
		int local_71 = local_14 + local_70;
		float4 local_72 = SkinBones[local_71];
		float3 local_73;
		float3 local_74;
		// Function dq_transform Begin 
		{
			float local_76 = dot(local_19, local_69);
			float local_77 = sign(local_76);
			float4 local_78 = mul(local_69, local_77);
			float3 local_79 = vsIN.a_position.xyz;
			float local_80 = vsIN.a_position.w;
			float3 local_81 = local_72.xyz;
			float local_82 = local_72.w;
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
			float3 local_97 = mul(local_96, local_21);
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
			float3 local_112 = mul(local_100, local_21);
			local_73 = local_97;
			local_74 = local_112;
		}
		// Function dq_transform End
		float4 local_114 = SkinBones[local_16];
		int local_115 = (int)local_24;
		int local_116 = local_16 + local_115;
		float4 local_117 = SkinBones[local_116];
		float3 local_118;
		float3 local_119;
		// Function dq_transform Begin 
		{
			float local_121 = dot(local_19, local_114);
			float local_122 = sign(local_121);
			float4 local_123 = mul(local_114, local_122);
			float3 local_124 = vsIN.a_position.xyz;
			float local_125 = vsIN.a_position.w;
			float3 local_126 = local_117.xyz;
			float local_127 = local_117.w;
			float3 local_128 = mul(local_124, local_127);
			float3 local_129;
			// Function quat_rot_vec3 Begin 
			{
				float3 local_131 = local_123.xyz;
				float local_132 = local_123.w;
				float3 local_133 = mul(local_128, local_132);
				float3 local_134 = cross(local_131, local_128);
				float3 local_135 = local_133 + local_134;
				float3 local_136 = cross(local_131, local_135);
				const float local_137 = 2.0f;
				float3 local_138 = mul(local_136, local_137);
				float3 local_139 = local_138 + local_128;
				local_129 = local_139;
			}
			// Function quat_rot_vec3 End
			float3 local_141 = local_129 + local_126;
			float3 local_142 = mul(local_141, local_22);
			float3 local_143 = vsIN.a_normal.xyz;
			float local_144 = vsIN.a_normal.w;
			float3 local_145;
			// Function quat_rot_vec3 Begin 
			{
				float3 local_147 = local_123.xyz;
				float local_148 = local_123.w;
				float3 local_149 = mul(local_143, local_148);
				float3 local_150 = cross(local_147, local_143);
				float3 local_151 = local_149 + local_150;
				float3 local_152 = cross(local_147, local_151);
				const float local_153 = 2.0f;
				float3 local_154 = mul(local_152, local_153);
				float3 local_155 = local_154 + local_143;
				local_145 = local_155;
			}
			// Function quat_rot_vec3 End
			float3 local_157 = mul(local_145, local_22);
			local_118 = local_142;
			local_119 = local_157;
		}
		// Function dq_transform End
		float4 local_159 = SkinBones[local_18];
		int local_160 = (int)local_24;
		int local_161 = local_18 + local_160;
		float4 local_162 = SkinBones[local_161];
		float3 local_163;
		float3 local_164;
		// Function dq_transform Begin 
		{
			float local_166 = dot(local_19, local_159);
			float local_167 = sign(local_166);
			float4 local_168 = mul(local_159, local_167);
			float3 local_169 = vsIN.a_position.xyz;
			float local_170 = vsIN.a_position.w;
			float3 local_171 = local_162.xyz;
			float local_172 = local_162.w;
			float3 local_173 = mul(local_169, local_172);
			float3 local_174;
			// Function quat_rot_vec3 Begin 
			{
				float3 local_176 = local_168.xyz;
				float local_177 = local_168.w;
				float3 local_178 = mul(local_173, local_177);
				float3 local_179 = cross(local_176, local_173);
				float3 local_180 = local_178 + local_179;
				float3 local_181 = cross(local_176, local_180);
				const float local_182 = 2.0f;
				float3 local_183 = mul(local_181, local_182);
				float3 local_184 = local_183 + local_173;
				local_174 = local_184;
			}
			// Function quat_rot_vec3 End
			float3 local_186 = local_174 + local_171;
			float3 local_187 = mul(local_186, local_23);
			float3 local_188 = vsIN.a_normal.xyz;
			float local_189 = vsIN.a_normal.w;
			float3 local_190;
			// Function quat_rot_vec3 Begin 
			{
				float3 local_192 = local_168.xyz;
				float local_193 = local_168.w;
				float3 local_194 = mul(local_188, local_193);
				float3 local_195 = cross(local_192, local_188);
				float3 local_196 = local_194 + local_195;
				float3 local_197 = cross(local_192, local_196);
				const float local_198 = 2.0f;
				float3 local_199 = mul(local_197, local_198);
				float3 local_200 = local_199 + local_188;
				local_190 = local_200;
			}
			// Function quat_rot_vec3 End
			float3 local_202 = mul(local_190, local_23);
			local_163 = local_187;
			local_164 = local_202;
		}
		// Function dq_transform End
		float3 local_204 = local_28 + local_73;
		float3 local_205 = local_204 + local_118;
		float3 local_206 = local_205 + local_163;
		float3 local_207 = vsIN.a_position.xyz;
		float local_208 = vsIN.a_position.w;
		float4 local_209 = { local_206.x, local_206.y, local_206.z, local_208 };
		float3 local_210 = local_29 + local_74;
		float3 local_211 = local_210 + local_119;
		float3 local_212 = local_211 + local_164;
		const float local_213 = 1.0f;
		float4 local_214 = { local_212.x, local_212.y, local_212.z, local_213 };
		local_3 = local_209;
		local_4 = local_214;
	}
	// Function gpu_skinning End
	local_0 = local_3;
	local_1 = local_4;
#else
	local_0 = vsIN.a_position;
	local_1 = vsIN.a_normal;
#endif
	float4 local_216;
	float4 local_217;
	float3 local_218;
	float3x3 local_219;
#if INSTANCE_TYPE==INSTANCE_TYPE_NONE
	float4 local_220 = mul(local_0, WorldViewProjection);
	float4 local_221 = mul(local_0, World);
	float3 local_222 = local_1.xyz;
	float local_223 = local_1.w;
	float3x3 local_224 = (float3x3)World;
	float3 local_225 = mul(local_222, local_224);
	float3 local_226 = normalize(local_225);
	float3x3 local_227 = (float3x3)World;
	local_216 = local_220;
	local_217 = local_221;
	local_218 = local_226;
	local_219 = local_227;
#elif INSTANCE_TYPE==INSTANCE_TYPE_PRS
	float local_228 = vsIN.a_texture5.x;
	float local_229 = vsIN.a_texture5.y;
	float local_230 = vsIN.a_texture5.z;
	float local_231 = vsIN.a_texture5.w;
	float local_232 = vsIN.a_texture6.x;
	float local_233 = vsIN.a_texture6.y;
	float local_234 = vsIN.a_texture6.z;
	float local_235 = vsIN.a_texture6.w;
	float local_236 = vsIN.a_texture7.x;
	float local_237 = vsIN.a_texture7.y;
	float local_238 = vsIN.a_texture7.z;
	float local_239 = vsIN.a_texture7.w;
	const float local_240 = 0.0f;
	float4 local_241 = { local_228, local_232, local_236, local_240 };
	float4 local_242 = { local_229, local_233, local_237, local_240 };
	float4 local_243 = { local_230, local_234, local_238, local_240 };
	const float local_244 = 1.0f;
	float4 local_245 = { local_231, local_235, local_239, local_244 };
	float4x4 local_246 = float4x4(local_241, local_242, local_243, local_245);
	float4 local_247 = mul(local_0, local_246);
	float4 local_248 = mul(local_247, ViewProjection);
	float3 local_249 = local_1.xyz;
	float local_250 = local_1.w;
	float3x3 local_251 = (float3x3)local_246;
	float3 local_252 = mul(local_249, local_251);
	float3 local_253 = normalize(local_252);
	float3x3 local_254 = (float3x3)local_246;
	local_216 = local_248;
	local_217 = local_247;
	local_218 = local_253;
	local_219 = local_254;
#elif INSTANCE_TYPE==INSTANCE_TYPE_PRS_LM
	float local_255 = vsIN.a_texture5.x;
	float local_256 = vsIN.a_texture5.y;
	float local_257 = vsIN.a_texture5.z;
	float local_258 = vsIN.a_texture5.w;
	float local_259 = vsIN.a_texture6.x;
	float local_260 = vsIN.a_texture6.y;
	float local_261 = vsIN.a_texture6.z;
	float local_262 = vsIN.a_texture6.w;
	float local_263 = vsIN.a_texture7.x;
	float local_264 = vsIN.a_texture7.y;
	float local_265 = vsIN.a_texture7.z;
	float local_266 = vsIN.a_texture7.w;
	const float local_267 = 0.0f;
	float4 local_268 = { local_255, local_259, local_263, local_267 };
	float4 local_269 = { local_256, local_260, local_264, local_267 };
	float4 local_270 = { local_257, local_261, local_265, local_267 };
	const float local_271 = 1.0f;
	float4 local_272 = { local_258, local_262, local_266, local_271 };
	float4x4 local_273 = float4x4(local_268, local_269, local_270, local_272);
	float4 local_274 = mul(local_0, local_273);
	float4 local_275 = mul(local_274, ViewProjection);
	float3 local_276 = local_1.xyz;
	float local_277 = local_1.w;
	float3x3 local_278 = (float3x3)local_273;
	float3 local_279 = mul(local_276, local_278);
	float3 local_280 = normalize(local_279);
	float3x3 local_281 = (float3x3)local_273;
	local_216 = local_275;
	local_217 = local_274;
	local_218 = local_280;
	local_219 = local_281;
#endif
	psIN.final_position = local_216;
#if LIGHT_MAP_ENABLE
#else
#endif
	psIN.v_world_position = local_217;
	psIN.v_world_normal = local_218;
	float3 local_282;
	// Function calc_brdf_env_diffuse Begin 
	{
		float3x3 local_284 = (float3x3)envRot;
		float3 local_285 = mul(local_218, local_284);
		float3 local_286 = normalize(local_285);
		const float local_287 = 1.0f;
		float4 local_288 = { local_286.x, local_286.y, local_286.z, local_287 };
		float4 local_289 = mul(local_288, envSHR);
		float local_290 = dot(local_288, local_289);
		float4 local_291 = mul(local_288, envSHG);
		float local_292 = dot(local_288, local_291);
		float4 local_293 = mul(local_288, envSHB);
		float local_294 = dot(local_288, local_293);
		float3 local_295 = { local_290, local_292, local_294 };
		float3 local_296 = mul(local_295, env_exposure);
		local_282 = local_296;
	}
	// Function calc_brdf_env_diffuse End
	psIN.v_texture5 = local_282;
	float4 local_298;
#if FOG_TYPE==FOG_TYPE_NONE
	const float local_299 = 0.0f;
	float4 local_300 = { local_299, local_299, local_299, local_299 };
	local_298 = local_300;
#elif FOG_TYPE==FOG_TYPE_LINEAR
	float local_301;
	// Function calc_fog_factor Begin 
	{
		float local_303 = FogInfo.x;
		float local_304 = FogInfo.y;
		float local_305 = FogInfo.z;
		float local_306 = FogInfo.w;
		const int local_307 = 2;
		float local_308 = local_216[local_307];
		const int local_309 = 1;
		float local_310 = local_217[local_309];
		float local_311;
		// Function get_fog_height Begin 
		{
			float local_313;
			// Function get_fog_linear Begin 
			{
				const float local_315 = 0.0f;
				const float local_316 = 1.0f;
				float4 local_317 = { local_315, local_315, local_303, local_316 };
				float4 local_318 = mul(local_317, Projection);
				float2 local_319 = local_318.xy;
				float local_320 = local_318.z;
				float local_321 = local_318.w;
				float4 local_322 = { local_315, local_315, local_304, local_316 };
				float4 local_323 = mul(local_322, Projection);
				float2 local_324 = local_323.xy;
				float local_325 = local_323.z;
				float local_326 = local_323.w;
				float local_327 = smoothstep(local_320, local_325, local_308);
				float local_328 = saturate(local_327);
				local_313 = local_328;
			}
			// Function get_fog_linear End
			float local_330 = local_310 - local_305;
			float local_331 = local_306 - local_305;
			float local_332 = local_330 / local_331;
			float local_333 = saturate(local_332);
			float local_334 = max(local_313, local_333);
			local_311 = local_334;
		}
		// Function get_fog_height End
		local_301 = local_311;
	}
	// Function calc_fog_factor End
	const float local_337 = 0.0f;
	float3 local_338 = { local_337, local_337, local_337 };
	float4 local_339 = { local_301, local_338.x, local_338.y, local_338.z };
	local_298 = local_339;
#elif FOG_TYPE==FOG_TYPE_HEIGHT
	const int local_340 = 3;
	float4 local_341 = ShadowLightAttr[local_340];
	float4 local_342;
	// Function calc_fog_textured_factor Begin 
	{
		float3 local_344 = local_217.xyz;
		float local_345 = local_217.w;
		float3 local_346 = camera_pos.xyz;
		float local_347 = camera_pos.w;
		float3 local_348 = local_344 - local_346;
		float3 local_349 = normalize(local_348);
		float local_350 = length(local_348);
		float local_351 = FogInfo.x;
		float local_352 = FogInfo.y;
		float local_353 = FogInfo.z;
		float local_354 = FogInfo.w;
		float local_355 = local_350 - local_353;
		float local_356 = local_354 - local_353;
		float local_357 = local_355 / local_356;
		float local_358 = saturate(local_357);
		float local_359 = pow(local_358, local_352);
		float local_360 = local_351 * local_359;
		const float local_361 = 0.5f;
		float local_362 = local_349.x;
		float local_363 = local_349.y;
		float local_364 = local_349.z;
		const float local_365 = 1.0f;
		float local_366 = local_363 + local_365;
		float local_367 = local_361 * local_366;
		float local_368 = FogInfoEX.x;
		float local_369 = FogInfoEX.y;
		float local_370 = FogInfoEX.z;
		float local_371 = FogInfoEX.w;
		float local_372;
		float local_373;
		float local_374;
		// Function calc_fog_height_factor Begin 
		{
			const float local_376 = 0.001f;
			float local_377 = local_370 - local_371;
			float local_378 = max(local_376, local_377);
			const float local_379 = 1.0f;
			float local_380 = local_379 / local_378;
			float local_381 = camera_pos.x;
			float local_382 = camera_pos.y;
			float2 local_383 = camera_pos.zw;
			float local_384 = local_349.x;
			float local_385 = local_349.y;
			float local_386 = local_349.z;
			float local_387 = local_382 - local_370;
			float local_388 = -(local_385);
			float local_389 = saturate(local_388);
			float local_390 = max(local_389, local_376);
			float local_391 = local_387 / local_390;
			float local_392 = abs(local_387);
			float local_393 = saturate(local_385);
			float local_394 = max(local_393, local_376);
			float local_395 = local_392 / local_394;
			const float local_396 = 0.0f;
			float local_397 = max(local_396, local_391);
			float local_398 = min(local_350, local_395);
			float local_399 = max(local_398, local_397);
			float local_400 = local_399 - local_397;
			float local_401 = local_400 * local_380;
			float local_402 = local_370 - local_382;
			float local_403 = local_402 * local_380;
			float local_404 = saturate(local_403);
			float local_405 = local_404 * local_401;
			const float local_406 = 0.5f;
			float local_407 = local_406 * local_401;
			float local_408 = local_407 * local_401;
			float local_409 = local_408 * local_385;
			float local_410 = local_405 - local_409;
			const float local_411 = 0.1f;
			float local_412 = local_411 * local_368;
			float local_413 = max(local_376, local_412);
			float local_414 = local_410 * local_413;
			float local_415 = saturate(local_414);
			const float local_416 = 2.0f;
			float local_417 = local_416 * local_413;
			float local_418 = local_379 / local_417;
			float local_419 = local_404 * local_404;
			float local_420 = local_416 * local_385;
			float local_421 = local_420 * local_418;
			float local_422 = local_419 - local_421;
			float local_423 = saturate(local_422);
			float local_424 = sqrt(local_423);
			float local_425 = local_404 - local_424;
			float local_426 = local_425 / local_385;
			float local_427 = local_426 * local_378;
			float local_428 = local_397 + local_427;
			float local_429 = local_426 * local_385;
			float local_430 = local_404 - local_429;
			float local_431 = saturate(local_430);
			local_372 = local_415;
			local_373 = local_431;
			local_374 = local_428;
		}
		// Function calc_fog_height_factor End
		float local_433 = local_360 * local_360;
		float local_434 = local_372 * local_372;
		float local_435 = local_433 + local_434;
		float local_436 = sqrt(local_435);
		float local_437 = saturate(local_436);
		float local_438 = local_354 / local_374;
		float local_439 = saturate(local_438);
		float local_440 = local_372 * local_439;
		float2 local_441 = local_341.xy;
		float local_442 = local_341.z;
		float local_443 = local_341.w;
		float local_444 = local_341.x;
		float local_445 = local_341.y;
		float local_446 = local_341.z;
		float local_447 = local_341.w;
		float local_448 = atan2(local_442, local_444);
		const float local_449 = 0.159f;
		float local_450 = local_448 * local_449;
		float4 local_451 = { local_437, local_367, local_440, local_450 };
		local_342 = local_451;
	}
	// Function calc_fog_textured_factor End
	local_298 = local_342;
#endif
	float2 local_453 = vsIN.a_texture0.xy;
	float2 local_454 = vsIN.a_texture0.zw;
	const float local_455 = 1.0f;
	const float local_456 = 0.0f;
	float4 local_457 = { local_453.x, local_453.y, local_455, local_456 };
	float4 local_458 = mul(local_457, TexTransform0);
	psIN.fog_factor_info = local_298;
	float4 local_459;
	float2 local_460;
#if INSTANCE_TYPE==INSTANCE_TYPE_NONE
	float2 local_461 = vsIN.a_texture1.xy;
	float2 local_462 = vsIN.a_texture1.zw;
	const float local_463 = 1.0f;
	const float local_464 = 0.0f;
	float4 local_465 = { local_461.x, local_461.y, local_463, local_464 };
	float4 local_466 = mul(local_465, LightMapTransform);
	float2 local_467 = local_466.xy;
	float2 local_468 = local_466.zw;
	local_459 = lightmap_scale;
	local_460 = local_467;
#elif INSTANCE_TYPE==INSTANCE_TYPE_PRS
	float2 local_469 = vsIN.a_texture1.xy;
	float2 local_470 = vsIN.a_texture1.zw;
	const float local_471 = 1.0f;
	const float local_472 = 0.0f;
	float4 local_473 = { local_469.x, local_469.y, local_471, local_472 };
	float4 local_474 = mul(local_473, LightMapTransform);
	float2 local_475 = local_474.xy;
	float2 local_476 = local_474.zw;
	local_459 = lightmap_scale;
	local_460 = local_475;
#elif INSTANCE_TYPE==INSTANCE_TYPE_PRS_LM
	float2 local_477 = vsIN.a_texture1.xy;
	float2 local_478 = vsIN.a_texture1.zw;
	float2 local_479 = vsIN.a_texture4.xy;
	float2 local_480 = vsIN.a_texture4.zw;
	float2 local_481 = local_477 * local_479;
	float2 local_482 = local_481 + local_480;
	local_459 = vsIN.a_texture3;
	local_460 = local_482;
#endif
	float2 local_483 = local_458.xy;
	float2 local_484 = local_458.zw;
	float2 local_485 = local_459.xy;
	float2 local_486 = local_459.zw;
	float4 local_487 = { local_483.x, local_483.y, local_485.x, local_485.y };
	psIN.v_texture0 = local_487;
	float4 local_488 = { local_460.x, local_460.y, local_486.x, local_486.y };
	psIN.v_texture1 = local_488;
	float3 local_489;
	float3 local_490;
	// Function calc_normal_info Begin 
	{
		float3 local_492 = vsIN.a_tangent.xyz;
		float local_493 = vsIN.a_tangent.w;
		float3 local_494 = mul(local_492, local_219);
		float3 local_495 = normalize(local_494);
		float3 local_496 = cross(local_218, local_495);
		float3 local_497 = normalize(local_496);
		float local_498 = dot(local_492, local_492);
		const float local_499 = 1.5f;
		float local_500 = local_498 - local_499;
		float3 local_501;
		if (local_500>0.0)
		{
			float3 local_502 = -(local_497);
			local_501 = local_502;
		}
		else
		{
			local_501 = local_497;
		}
		local_489 = local_495;
		local_490 = local_501;
	}
	// Function calc_normal_info End
	psIN.v_world_tangent = local_489;
	psIN.v_world_binormal = local_490;
#if SHADOW_MAP_ENABLE
	const int local_504 = 3;
	float4 local_505 = ShadowLightAttr[local_504];
	float4 local_506;
	// Function calc_shadowmap_info Begin 
	{
		float3 local_508 = local_505.xyz;
		float local_509 = local_505.w;
		float2 local_510;
		float local_511;
		float local_512;
		// Function calc_shadow_info Begin 
		{
			float4 local_514 = mul(local_217, lvp);
			float3 local_515 = local_514.xyz;
			float local_516 = local_514.w;
			float3 local_517 = { local_516, local_516, local_516 };
			float3 local_518 = local_515 / local_517;
			float2 local_519 = local_518.xy;
			float local_520 = local_518.z;
			float2 local_521;
#if SYSTEM_UV_ORIGIN_LEFT_BOTTOM
			const float local_522 = 0.5f;
			float2 local_523 = { local_522, local_522 };
			local_521 = local_523;
#else
			const float local_524 = 0.5f;
			float local_525 = -(local_524);
			float2 local_526 = { local_524, local_525 };
			local_521 = local_526;
#endif
			float2 local_527 = local_519 * local_521;
			const float local_528 = 0.5f;
			float2 local_529 = { local_528, local_528 };
			float2 local_530 = local_527 + local_529;
			float3 local_531 = -(local_218);
			float3 local_532 = normalize(local_508);
			float local_533 = dot(local_531, local_532);
			float local_534 = saturate(local_533);
			local_510 = local_530;
			local_511 = local_520;
			local_512 = local_534;
		}
		// Function calc_shadow_info End
		float4 local_536 = { local_510.x, local_510.y, local_511, local_512 };
		local_506 = local_536;
	}
	// Function calc_shadowmap_info End
	psIN.v_texture3 = local_506;
#else
#endif
	float3 local_538 = local_217.xyz;
	float local_539 = local_217.w;
	float4 local_540;
	// Function calc_point_light_atten Begin 
	{
		const int local_542 = 3;
		float4 local_543 = PointLightAttrs[local_542];
		const int local_544 = 4;
		float4 local_545 = PointLightAttrs[local_544];
		float3 local_546 = local_543.xyz;
		float local_547 = local_543.w;
		float3 local_548 = local_538 - local_546;
		float3 local_549 = { local_547, local_547, local_547 };
		float3 local_550 = local_548 / local_549;
		const float local_551 = 1.0f;
		float local_552 = dot(local_550, local_550);
		float local_553 = local_551 - local_552;
		float local_554 = saturate(local_553);
		float local_555 = local_545.x;
		float local_556 = local_545.y;
		float local_557 = local_545.z;
		float local_558 = local_545.w;
		const float local_559 = 0.001f;
		float local_560 = local_555 + local_559;
		float local_561 = pow(local_554, local_560);
		const int local_562 = 8;
		float4 local_563 = PointLightAttrs[local_562];
		const int local_564 = 9;
		float4 local_565 = PointLightAttrs[local_564];
		float3 local_566 = local_563.xyz;
		float local_567 = local_563.w;
		float3 local_568 = local_538 - local_566;
		float3 local_569 = { local_567, local_567, local_567 };
		float3 local_570 = local_568 / local_569;
		float local_571 = dot(local_570, local_570);
		float local_572 = local_551 - local_571;
		float local_573 = saturate(local_572);
		float local_574 = local_565.x;
		float local_575 = local_565.y;
		float local_576 = local_565.z;
		float local_577 = local_565.w;
		float local_578 = local_574 + local_559;
		float local_579 = pow(local_573, local_578);
		const int local_580 = 13;
		float4 local_581 = PointLightAttrs[local_580];
		const int local_582 = 14;
		float4 local_583 = PointLightAttrs[local_582];
		float3 local_584 = local_581.xyz;
		float local_585 = local_581.w;
		float3 local_586 = local_538 - local_584;
		float3 local_587 = { local_585, local_585, local_585 };
		float3 local_588 = local_586 / local_587;
		float local_589 = dot(local_588, local_588);
		float local_590 = local_551 - local_589;
		float local_591 = saturate(local_590);
		float local_592 = local_583.x;
		float local_593 = local_583.y;
		float local_594 = local_583.z;
		float local_595 = local_583.w;
		float local_596 = local_592 + local_559;
		float local_597 = pow(local_591, local_596);
		const int local_598 = 18;
		float4 local_599 = PointLightAttrs[local_598];
		const int local_600 = 19;
		float4 local_601 = PointLightAttrs[local_600];
		float3 local_602 = local_599.xyz;
		float local_603 = local_599.w;
		float3 local_604 = local_538 - local_602;
		float3 local_605 = { local_603, local_603, local_603 };
		float3 local_606 = local_604 / local_605;
		float local_607 = dot(local_606, local_606);
		float local_608 = local_551 - local_607;
		float local_609 = saturate(local_608);
		float local_610 = local_601.x;
		float local_611 = local_601.y;
		float local_612 = local_601.z;
		float local_613 = local_601.w;
		float local_614 = local_610 + local_559;
		float local_615 = pow(local_609, local_614);
		float4 local_616 = { local_561, local_579, local_597, local_615 };
		local_540 = local_616;
	}
	// Function calc_point_light_atten End
	psIN.v_texture6 = local_540;
	return psIN;
}
