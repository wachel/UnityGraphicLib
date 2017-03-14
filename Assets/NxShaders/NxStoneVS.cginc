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
	float2 uv0: TEXCOORD0;
#if INSTANCE_TYPE == INSTANCE_TYPE_NONE || INSTANCE_TYPE == INSTANCE_TYPE_PRS || INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM
	float2 uv1: TEXCOORD1;
#endif
	float4 v_world_position: TEXCOORD2;
	float3 v_world_normal: TEXCOORD3;
	float3 v_world_tangent: TEXCOORD4;
	float3 v_world_binormal: TEXCOORD5;
#if SHADOW_MAP_ENABLE
	float4 v_texture3: TEXCOORD6;
#endif
	float4 fog_factor_info: TEXCOORD7;
	float4 v_texture2: TEXCOORD8;
#if INSTANCE_TYPE == INSTANCE_TYPE_NONE || INSTANCE_TYPE == INSTANCE_TYPE_PRS || INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM
	float4 v_texture5: TEXCOORD9;
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
		float local_292 = local_216[local_291];
		const int local_293 = 1;
		float local_294 = local_217[local_293];
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
		float3 local_328 = local_217.xyz;
		float local_329 = local_217.w;
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
#if INSTANCE_TYPE==INSTANCE_TYPE_NONE
	float2 local_443 = vsIN.a_texture1.xy;
	float2 local_444 = vsIN.a_texture1.zw;
	const float local_445 = 1.0f;
	const float local_446 = 0.0f;
	float4 local_447 = { local_443.x, local_443.y, local_445, local_446 };
	float4 local_448 = mul(local_447, LightMapTransform);
	float2 local_449 = local_448.xy;
	float2 local_450 = local_448.zw;
	psIN.uv1 = local_449;
	psIN.v_texture5 = lightmap_scale;
#elif INSTANCE_TYPE==INSTANCE_TYPE_PRS
	float2 local_451 = vsIN.a_texture1.xy;
	float2 local_452 = vsIN.a_texture1.zw;
	const float local_453 = 1.0f;
	const float local_454 = 0.0f;
	float4 local_455 = { local_451.x, local_451.y, local_453, local_454 };
	float4 local_456 = mul(local_455, LightMapTransform);
	float2 local_457 = local_456.xy;
	float2 local_458 = local_456.zw;
	psIN.uv1 = local_457;
	psIN.v_texture5 = lightmap_scale;
#elif INSTANCE_TYPE==INSTANCE_TYPE_PRS_LM
	float2 local_459 = vsIN.a_texture1.xy;
	float2 local_460 = vsIN.a_texture1.zw;
	float2 local_461 = vsIN.a_texture4.xy;
	float2 local_462 = vsIN.a_texture4.zw;
	float2 local_463 = local_459 * local_461;
	float2 local_464 = local_463 + local_462;
	psIN.uv1 = local_464;
	psIN.v_texture5 = vsIN.a_texture3;
#endif
	float3 local_465;
	float3 local_466;
	// Function calc_normal_info Begin 
	{
		float3 local_468 = vsIN.a_tangent.xyz;
		float local_469 = vsIN.a_tangent.w;
		float3 local_470 = mul(local_468, local_219);
		float3 local_471 = normalize(local_470);
		float3 local_472 = cross(local_218, local_471);
		float3 local_473 = normalize(local_472);
		float local_474 = dot(local_468, local_468);
		const float local_475 = 1.5f;
		float local_476 = local_474 - local_475;
		float3 local_477;
		if (local_476>0.0)
		{
			float3 local_478 = -(local_473);
			local_477 = local_478;
		}
		else
		{
			local_477 = local_473;
		}
		local_465 = local_471;
		local_466 = local_477;
	}
	// Function calc_normal_info End
#if SHADOW_MAP_ENABLE
	const int local_480 = 3;
	float4 local_481 = ShadowLightAttr[local_480];
	float4 local_482;
	// Function calc_shadowmap_info Begin 
	{
		float3 local_484 = local_481.xyz;
		float local_485 = local_481.w;
		float2 local_486;
		float local_487;
		float local_488;
		// Function calc_shadow_info Begin 
		{
			float4 local_490 = mul(local_217, lvp);
			float3 local_491 = local_490.xyz;
			float local_492 = local_490.w;
			float3 local_493 = { local_492, local_492, local_492 };
			float3 local_494 = local_491 / local_493;
			float2 local_495 = local_494.xy;
			float local_496 = local_494.z;
			float2 local_497;
#if SYSTEM_UV_ORIGIN_LEFT_BOTTOM
			const float local_498 = 0.5f;
			float2 local_499 = { local_498, local_498 };
			local_497 = local_499;
#else
			const float local_500 = 0.5f;
			float local_501 = -(local_500);
			float2 local_502 = { local_500, local_501 };
			local_497 = local_502;
#endif
			float2 local_503 = local_495 * local_497;
			const float local_504 = 0.5f;
			float2 local_505 = { local_504, local_504 };
			float2 local_506 = local_503 + local_505;
			float3 local_507 = -(local_218);
			float3 local_508 = normalize(local_484);
			float local_509 = dot(local_507, local_508);
			float local_510 = saturate(local_509);
			local_486 = local_506;
			local_487 = local_496;
			local_488 = local_510;
		}
		// Function calc_shadow_info End
		float4 local_512 = { local_486.x, local_486.y, local_487, local_488 };
		local_482 = local_512;
	}
	// Function calc_shadowmap_info End
	psIN.v_texture3 = local_482;
#else
#endif
	float3 local_514 = local_217.xyz;
	float local_515 = local_217.w;
	float4 local_516;
	// Function calc_point_light_atten Begin 
	{
		const int local_518 = 3;
		float4 local_519 = PointLightAttrs[local_518];
		const int local_520 = 4;
		float4 local_521 = PointLightAttrs[local_520];
		float3 local_522 = local_519.xyz;
		float local_523 = local_519.w;
		float3 local_524 = local_514 - local_522;
		float3 local_525 = { local_523, local_523, local_523 };
		float3 local_526 = local_524 / local_525;
		const float local_527 = 1.0f;
		float local_528 = dot(local_526, local_526);
		float local_529 = local_527 - local_528;
		float local_530 = saturate(local_529);
		float local_531 = local_521.x;
		float local_532 = local_521.y;
		float local_533 = local_521.z;
		float local_534 = local_521.w;
		const float local_535 = 0.001f;
		float local_536 = local_531 + local_535;
		float local_537 = pow(local_530, local_536);
		const int local_538 = 8;
		float4 local_539 = PointLightAttrs[local_538];
		const int local_540 = 9;
		float4 local_541 = PointLightAttrs[local_540];
		float3 local_542 = local_539.xyz;
		float local_543 = local_539.w;
		float3 local_544 = local_514 - local_542;
		float3 local_545 = { local_543, local_543, local_543 };
		float3 local_546 = local_544 / local_545;
		float local_547 = dot(local_546, local_546);
		float local_548 = local_527 - local_547;
		float local_549 = saturate(local_548);
		float local_550 = local_541.x;
		float local_551 = local_541.y;
		float local_552 = local_541.z;
		float local_553 = local_541.w;
		float local_554 = local_550 + local_535;
		float local_555 = pow(local_549, local_554);
		const int local_556 = 13;
		float4 local_557 = PointLightAttrs[local_556];
		const int local_558 = 14;
		float4 local_559 = PointLightAttrs[local_558];
		float3 local_560 = local_557.xyz;
		float local_561 = local_557.w;
		float3 local_562 = local_514 - local_560;
		float3 local_563 = { local_561, local_561, local_561 };
		float3 local_564 = local_562 / local_563;
		float local_565 = dot(local_564, local_564);
		float local_566 = local_527 - local_565;
		float local_567 = saturate(local_566);
		float local_568 = local_559.x;
		float local_569 = local_559.y;
		float local_570 = local_559.z;
		float local_571 = local_559.w;
		float local_572 = local_568 + local_535;
		float local_573 = pow(local_567, local_572);
		const int local_574 = 18;
		float4 local_575 = PointLightAttrs[local_574];
		const int local_576 = 19;
		float4 local_577 = PointLightAttrs[local_576];
		float3 local_578 = local_575.xyz;
		float local_579 = local_575.w;
		float3 local_580 = local_514 - local_578;
		float3 local_581 = { local_579, local_579, local_579 };
		float3 local_582 = local_580 / local_581;
		float local_583 = dot(local_582, local_582);
		float local_584 = local_527 - local_583;
		float local_585 = saturate(local_584);
		float local_586 = local_577.x;
		float local_587 = local_577.y;
		float local_588 = local_577.z;
		float local_589 = local_577.w;
		float local_590 = local_586 + local_535;
		float local_591 = pow(local_585, local_590);
		float4 local_592 = { local_537, local_555, local_573, local_591 };
		local_516 = local_592;
	}
	// Function calc_point_light_atten End
	float3 local_594;
	// Function calc_point_light_diffuse Begin 
	{
		const int local_596 = 6;
		float4 local_597 = PointLightAttrs[local_596];
		const int local_598 = 8;
		float4 local_599 = PointLightAttrs[local_598];
		const int local_600 = 9;
		float4 local_601 = PointLightAttrs[local_600];
		float3 local_602;
		// Function point_light_common_diffuse_only Begin 
		{
			float local_604 = local_597.x;
			float local_605 = local_597.y;
			float local_606 = local_597.z;
			float local_607 = local_597.w;
			float local_608 = local_604 + local_605;
			float local_609 = local_608 + local_606;
			float3 local_610;
			if (local_609 == 0.0)
			{
				const float local_611 = 0.0f;
				float3 local_612 = { local_611, local_611, local_611 };
				local_610 = local_612;
			}
			else
			{
				float3 local_613 = local_599.xyz;
				float local_614 = local_599.w;
				float3 local_615 = local_514 - local_613;
				float3 local_616 = { local_614, local_614, local_614 };
				float3 local_617 = local_615 / local_616;
				float local_618 = dot(local_617, local_617);
				float local_619 = (float)1.0f - local_618;
				float local_620 = saturate(local_619);
				float3 local_621 = normalize(local_615);
				float local_622 = local_601.x;
				float local_623 = local_601.y;
				float local_624 = local_601.z;
				float local_625 = local_601.w;
				const float local_626 = 0.001f;
				float local_627 = local_622 + local_626;
				float local_628 = pow(local_620, local_627);
				float3 local_629 = -(local_621);
				float local_630 = dot(local_218, local_629);
				float local_631 = saturate(local_630);
				float3 local_632 = local_597.xyz;
				float local_633 = local_597.w;
				float3 local_634 = mul(local_632, local_631);
				float3 local_635 = mul(local_634, local_628);
				local_610 = local_635;
			}
			local_602 = local_610;
		}
		// Function point_light_common_diffuse_only End
		const int local_637 = 11;
		float4 local_638 = PointLightAttrs[local_637];
		const int local_639 = 13;
		float4 local_640 = PointLightAttrs[local_639];
		const int local_641 = 14;
		float4 local_642 = PointLightAttrs[local_641];
		float3 local_643;
		// Function point_light_common_diffuse_only Begin 
		{
			float local_645 = local_638.x;
			float local_646 = local_638.y;
			float local_647 = local_638.z;
			float local_648 = local_638.w;
			float local_649 = local_645 + local_646;
			float local_650 = local_649 + local_647;
			float3 local_651;
			if (local_650 == 0.0)
			{
				const float local_652 = 0.0f;
				float3 local_653 = { local_652, local_652, local_652 };
				local_651 = local_653;
			}
			else
			{
				float3 local_654 = local_640.xyz;
				float local_655 = local_640.w;
				float3 local_656 = local_514 - local_654;
				float3 local_657 = { local_655, local_655, local_655 };
				float3 local_658 = local_656 / local_657;
				float local_659 = dot(local_658, local_658);
				float local_660 = (float)1.0f - local_659;
				float local_661 = saturate(local_660);
				float3 local_662 = normalize(local_656);
				float local_663 = local_642.x;
				float local_664 = local_642.y;
				float local_665 = local_642.z;
				float local_666 = local_642.w;
				const float local_667 = 0.001f;
				float local_668 = local_663 + local_667;
				float local_669 = pow(local_661, local_668);
				float3 local_670 = -(local_662);
				float local_671 = dot(local_218, local_670);
				float local_672 = saturate(local_671);
				float3 local_673 = local_638.xyz;
				float local_674 = local_638.w;
				float3 local_675 = mul(local_673, local_672);
				float3 local_676 = mul(local_675, local_669);
				local_651 = local_676;
			}
			local_643 = local_651;
		}
		// Function point_light_common_diffuse_only End
		const int local_678 = 16;
		float4 local_679 = PointLightAttrs[local_678];
		const int local_680 = 18;
		float4 local_681 = PointLightAttrs[local_680];
		const int local_682 = 19;
		float4 local_683 = PointLightAttrs[local_682];
		float3 local_684;
		// Function point_light_common_diffuse_only Begin 
		{
			float local_686 = local_679.x;
			float local_687 = local_679.y;
			float local_688 = local_679.z;
			float local_689 = local_679.w;
			float local_690 = local_686 + local_687;
			float local_691 = local_690 + local_688;
			float3 local_692;
			if (local_691 == 0.0)
			{
				const float local_693 = 0.0f;
				float3 local_694 = { local_693, local_693, local_693 };
				local_692 = local_694;
			}
			else
			{
				float3 local_695 = local_681.xyz;
				float local_696 = local_681.w;
				float3 local_697 = local_514 - local_695;
				float3 local_698 = { local_696, local_696, local_696 };
				float3 local_699 = local_697 / local_698;
				float local_700 = dot(local_699, local_699);
				float local_701 = (float)1.0f - local_700;
				float local_702 = saturate(local_701);
				float3 local_703 = normalize(local_697);
				float local_704 = local_683.x;
				float local_705 = local_683.y;
				float local_706 = local_683.z;
				float local_707 = local_683.w;
				const float local_708 = 0.001f;
				float local_709 = local_704 + local_708;
				float local_710 = pow(local_702, local_709);
				float3 local_711 = -(local_703);
				float local_712 = dot(local_218, local_711);
				float local_713 = saturate(local_712);
				float3 local_714 = local_679.xyz;
				float local_715 = local_679.w;
				float3 local_716 = mul(local_714, local_713);
				float3 local_717 = mul(local_716, local_710);
				local_692 = local_717;
			}
			local_684 = local_692;
		}
		// Function point_light_common_diffuse_only End
		float3 local_719 = local_602 + local_643;
		float3 local_720 = local_719 + local_684;
		local_594 = local_720;
	}
	// Function calc_point_light_diffuse End
	psIN.v_world_position = local_217;
	float2 local_722 = local_442.xy;
	float2 local_723 = local_442.zw;
	psIN.uv0 = local_722;
	psIN.v_world_tangent = local_465;
	psIN.v_world_binormal = local_466;
	psIN.v_world_normal = local_218;
	psIN.fog_factor_info = local_282;
	float local_724 = local_516.x;
	float local_725 = local_516.y;
	float local_726 = local_516.z;
	float local_727 = local_516.w;
	float4 local_728 = { local_594.x, local_594.y, local_594.z, local_724 };
	psIN.v_texture2 = local_728;
	return psIN;
}
