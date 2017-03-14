void sample_normal_map_with_roughness(sampler2D tex_normal,float normalmap_scale,float2 uv0, float3 world_binormal, float3 world_tangent, float3 world_normal,out float3 local_11,out float local_12,out float3 local_13)
{
	float4 normal_rgba = tex2D(tex_normal, uv0);
	float3 normal_rgb = normal_rgba.xyz;
	float normal_a = normal_rgba.w;
	float3 local_23 = normal_rgb * 2 - float3(1,1,1);
	float local_24;
#if SPECULAR_AA
	const float local_25 = 1.0f;
	float local_26 = length(local_23);
	float local_27 = local_25 - local_26;
	const float local_28 = 7.0f;
	float local_29 = local_27 * local_28;
	float local_30 = local_25 - local_29;
	const float local_31 = 0.0001f;
	float local_32 = clamp(local_30, local_31, local_25);
	float local_33 = (float)1.0f - local_32;
	float local_34 = local_33 / local_32;
	float local_35 = saturate(normal_a);
	float local_36 = (float)1.0f - local_35;
	float local_37 = local_36 * local_34;
	float local_38 = local_25 + local_37;
	float local_39 = local_36 / local_38;
	float local_40 = (float)1.0f - local_39;
	local_24 = local_40;
#else
	local_24 = normal_a;
#endif
	float local_41 = local_23.x;
	float local_42 = local_23.y;
	float local_43 = local_23.z;
	float local_44 = local_41 * normalmap_scale;
	float local_45 = local_42 * normalmap_scale;
	float3 local_46 = { local_44, local_45, local_43 };
	float local_47 = local_46.x;
	float local_48 = local_46.y;
	float local_49 = local_46.z;
	float3 local_50 = mul(world_binormal, local_48);
	float3 local_51 = mul(world_tangent, local_47);
	float3 local_52 = local_50 + local_51;
	float3 local_53 = mul(world_normal, local_49);
	float3 local_54 = local_52 + local_53;
	float3 local_55 = normalize(local_54);
	local_11 = local_55;
	local_12 = local_24;
	local_13 = local_23;
}

void calc_world_info(PS_INPUT psIN, sampler2D tex_normal,float normalmap_scale,float2 uv0,float3 world_binormal,float3 world_tangent,float3 world_normal, out float3 local_6, out float3 local_7, out float local_8, out float3 local_9)
{
	float3 local_11;
	float local_12;
	float3 local_13;
	// Function sample_normal_map_with_roughness Begin 
	sample_normal_map_with_roughness(tex_normal, normalmap_scale, uv0, world_binormal, world_tangent, world_normal, local_11, local_12, local_13);
	// Function sample_normal_map_with_roughness End
	local_6 = local_11;
	local_7 = world_tangent;
	local_8 = local_12;
	local_9 = local_13;
}
void calc_weather_info(sampler2D sam_other0,float FrameTime,float3 local_6,float3 local_9, float3 diffuse_rgb, float3 metallic_rgb,float3 local_60
	,float local_65,float local_67,float local_68,float local_69,float local_71,float local_73,float local_74, out float3 local_75, out float3 local_76, out float local_77, out float3 local_78)
{
	local_69 *= 20;//size
	local_71 /= 20;//height

	float3 local_80;
	float3 local_81;
	float local_82;
	float3 local_83;
#if RAIN_ENABLE
	float local_84 = local_60.x;
	float local_85 = local_60.y;
	float local_86 = local_60.z;
	float local_87 = local_84 + local_85;
	float2 local_88 = { local_87, local_86 };
	const float local_89 = 0.0048f;
	float local_90 = local_89 * local_69;
	float2 local_91 = { local_90, local_90 };
	float2 local_92 = local_88 * local_91;
	const float local_93 = 0.022f;
	const float local_94 = 0.0273f;
	float2 local_95 = { local_93, local_94 };
	float2 local_96 = { FrameTime, FrameTime };
	float2 local_97 = local_95 * local_96;
	float2 local_98 = local_92 + local_97;
	float local_99 = local_86 + local_85;
	float2 local_100 = { local_84, local_99 };
	const float local_101 = 0.00378f;
	float local_102 = local_101 * local_69;
	float2 local_103 = { local_102, local_102 };
	float2 local_104 = local_100 * local_103;
	const float local_105 = 0.033f;
	const float local_106 = 0.0184f;
	float2 local_107 = { local_105, local_106 };
	float2 local_108 = { FrameTime, FrameTime };
	float2 local_109 = local_107 * local_108;
	float2 local_110 = local_104 - local_109;
	float4 local_111 = tex2D(sam_other0, local_98);
	const float local_112 = 2.0f;
	float4 local_113 = { local_112, local_112, local_112, local_112 };
	float4 local_114 = local_111 * local_113;
	const float local_115 = 1.0f;
	float4 local_116 = { local_115, local_115, local_115, local_115 };
	float4 local_117 = local_114 - local_116;
	float4 local_118 = tex2D(sam_other0, local_110);
	float4 local_119 = { local_112, local_112, local_112, local_112 };
	float4 local_120 = local_118 * local_119;
	float4 local_121 = { local_115, local_115, local_115, local_115 };
	float4 local_122 = local_120 - local_121;
	float4 local_123 = local_117 * local_122;
	float local_124 = local_69 * local_71;
	float4 local_125 = { local_124, local_124, local_124, local_124 };
	float4 local_126 = local_123 * local_125;
	float local_127 = local_126.x;
	float local_128 = local_126.y;
	float local_129 = local_126.z;
	float local_130 = local_126.w;
	const float local_131 = 0.0f;
	float3 local_132 = { local_127, local_131, local_128 };
	float3 local_133 = local_6 + local_132;
	float3 local_134 = normalize(local_133);
	const float local_135 = 0.7f;
	const float local_136 = 0.3f;
	float local_137 = lerp(local_131, local_136, local_65);
	float local_138 = local_135 + local_137;
	const float local_139 = 0.4f;
	float local_140 = lerp(local_115, local_139, local_138);
	float local_141 = lerp(local_115, local_140, local_67);
	float local_142 = lerp(local_68, local_65, local_141);
	float local_143 = lerp(local_115, local_140, local_67);
	float3 local_144 = mul(local_143, diffuse_rgb);
	local_80 = local_134;
	local_81 = local_144;
	local_82 = local_142;
	local_83 = metallic_rgb;
#else
	local_80 = local_6;
	local_81 = diffuse_rgb;
	local_82 = local_65;
	local_83 = metallic_rgb;
#endif
	float3 local_145;
	float3 local_146;
	float local_147;
	float3 local_148;
#if SNOW_ENABLE
	float2 local_149 = local_9.xy;
	float local_150 = local_9.z;
	float local_151 = dot(local_149, local_149);
	const float local_152 = 0.1f;
	float local_153 = local_151 + local_152;
	const float local_154 = 2.0f;
	float local_155 = local_153 * local_154;
	float local_156 = local_81.x;
	float local_157 = local_81.y;
	float local_158 = local_81.z;
	float local_159 = max(local_156, local_157);
	float local_160 = max(local_159, local_158);
	float local_161 = min(local_156, local_157);
	float local_162 = min(local_161, local_158);
	const float local_163 = 1.0f;
	const float local_164 = 0.01f;
	float local_165 = local_164 + local_160;
	float local_166 = local_162 / local_165;
	float local_167 = local_163 - local_166;
	const float local_168 = 0.0f;
	float local_169 = local_80.x;
	float local_170 = local_80.y;
	float local_171 = local_80.z;
	float local_172 = local_170 - local_168;
	float local_173 = local_163 - local_168;
	float local_174 = local_172 / local_173;
	float local_175 = saturate(local_174);
	float local_176 = local_175 + local_152;
	float local_177 = local_163 - local_73;
	float local_178 = local_163 / local_177;
	float local_179 = local_178 - local_163;
	float local_180 = local_179 * local_167;
	float local_181 = local_180 * local_155;
	float local_182 = local_181 * local_176;
	float local_183 = saturate(local_182);
	float local_184 = local_183 + local_164;
	const float local_185 = 0.8f;
	float local_186 = local_185 * local_74;
	float local_187 = pow(local_184, local_186);
	float3 local_188 = { local_187, local_187, local_187 };
	float3 local_189 = { local_183, local_183, local_183 };
	float3 local_190 = lerp(local_81, local_188, local_189);
	const float local_191 = 0.5f;
	float3 local_192 = { local_191, local_191, local_191 };
	float3 local_193 = { local_183, local_183, local_183 };
	float3 local_194 = lerp(local_83, local_192, local_193);
	float local_195 = local_73 * local_74;
	float local_196 = lerp(local_65, local_155, local_195);
	float local_197 = local_167 * local_167;
	float local_198 = local_196 + local_197;
	float local_199 = local_163 - local_197;
	float local_200 = local_73 * local_199;
	float local_201 = lerp(local_82, local_198, local_200);
	local_145 = local_80;
	local_146 = local_190;
	local_147 = local_201;
	local_148 = local_194;
#else
	local_145 = local_80;
	local_146 = local_81;
	local_147 = local_82;
	local_148 = local_83;
#endif
	local_75 = local_145;//world_normal;
	local_76 = local_146;//diffuse_rgb;
	local_77 = local_147;//local_65;
	local_78 = local_148;//metallic_rgb;
}

void calc_world_info_terrain(float3 v_world_binormal, float3 v_world_tangent, float3 v_world_normal,float normalmap_scale,float4 local_8,float4 local_9, float4 local_10,float2 local_18, out float3 local_20,out float3 local_21,out float local_22)
{
	float local_24 = local_18.x;
	float local_25 = local_18.y;
	float4 local_26 = { local_24, local_24, local_24, local_24 };
	float4 local_27 = lerp(local_8, local_9, local_26);
	float4 local_28 = { local_25, local_25, local_25, local_25 };
	float4 local_29 = lerp(local_27, local_10, local_28);
	float3 local_30 = local_29.xyz;
	float local_31 = local_29.w;
	const float local_32 = 2.0f;
	float3 local_33 = { local_32, local_32, local_32 };
	float3 local_34 = local_30 * local_33;
	const float local_35 = 1.0f;
	float3 local_36 = { local_35, local_35, local_35 };
	float3 local_37 = local_34 - local_36;
	float local_38 = local_37.x;
	float local_39 = local_37.y;
	float local_40 = local_37.z;
	float local_41 = local_38 * normalmap_scale;
	float local_42 = local_39 * normalmap_scale;
	float3 local_43 = { local_41, local_42, local_40 };
	float local_44 = local_43.x;
	float local_45 = local_43.y;
	float local_46 = local_43.z;
	float3 local_47 = mul(v_world_binormal, local_45);
	float3 local_48 = mul(v_world_tangent, local_44);
	float3 local_49 = local_47 + local_48;
	float3 local_50 = mul(v_world_normal, local_46);
	float3 local_51 = local_49 + local_50;
	float3 local_52 = normalize(local_51);
	local_20 = local_52;
	local_21 = v_world_tangent;
	local_22 = local_31;
}

float4 calc_terrain_diffuse_blend(float4 local_5 ,float4 local_6,float4 local_7,float4 local_11)
{
	float local_62 = local_11.x;
	float local_63 = local_11.y;
	float local_64 = local_11.z;
	float local_65 = local_11.w;
	float4 local_66 = { local_62, local_62, local_62, local_62 };
	float4 local_67 = lerp(local_5, local_6, local_66);
	float4 local_68 = { local_63, local_63, local_63, local_63 };
	float4 local_69 = lerp(local_67, local_7, local_68);
	return local_69;
}

float4 calc_terrain_specular(float4 local_219)
{
	float4 local_225;
#if SPECULAR_ENABLE
	float3 local_226 = local_219.xyz;
	float local_227 = local_219.w;
	float4 local_228 = { local_227, local_227, local_227, local_227 };
	local_225 = local_228;
#else
	const float local_229 = 0.0f;
	float4 local_230 = { local_229, local_229, local_229, local_229 };
	local_225 = local_230;
#endif
	return local_225;
}

float3 calc_brdf_diffuse(float local_233,float3 local_234)
{
	float local_238 = (float)1.0f - local_233;
	float3 local_239 = mul(local_234, local_238);
	return local_239;
}

float3 gamma_correct_began(float3 color)
{
	//return color;
	return color*color;
}

float3 gamma_correct_ended(float3 color)
{
	//return color;
	return sqrt(color);
}

float4 gamma_correct_began(float4 color)
{
	//return color;
	return color*color;
}

float4 gamma_correct_ended(float4 color)
{
	//return color;
	return sqrt(color);
}

float3 calc_brdf_diffuse_common(float3 local_203/*diffuse_rgb*/,float local_207/*metallic_rgb*/)
{
	float3 local_215 = float3(1,1,1) - local_207;
	float3 local_216 = local_203 * local_215;
	return local_216;
}


#if SHADOW_MAP_ENABLE
float calc_shadowmap(PS_INPUT psIN, sampler2D sam_shadow, float local_220, float4 local_223)
{
	float2 local_226 = psIN.v_texture3.xy;
	float2 local_227 = psIN.v_texture3.zw;
	float local_228;
#if SYSTEM_DEPTH_RANGE_NEGATIVE
	float2 local_229 = psIN.v_texture3.xy;
	float local_230 = psIN.v_texture3.z;
	float local_231 = psIN.v_texture3.w;
	const float local_232 = 0.5f;
	float local_233 = local_230 * local_232;
	float local_234 = local_233 + local_232;
	local_228 = local_234;
#else
	float2 local_235 = psIN.v_texture3.xy;
	float local_236 = psIN.v_texture3.z;
	float local_237 = psIN.v_texture3.w;
	local_228 = local_236;
#endif
	float3 local_238 = local_223.xyz;
	float local_239 = local_223.w;
	float3 local_240 = -(local_238);
	float local_241 = dot(psIN.v_world_normal, local_240);
	float local_242 = saturate(local_241);
	const float local_243 = 0.001f;
	const float local_244 = 0.01f;
	const float local_245 = 1.0f;
	float local_246 = local_245 - local_242;
	float local_247 = local_244 * local_246;
	float local_248 = local_243 + local_247;
	float local_249 = local_228 - local_248;
	float4 local_250 = { local_226.x, local_226.y, local_249, local_245 };
	float local_251 = tex2Dproj(sam_shadow, local_250).x;
	float local_252 = local_226.x;
	float local_253 = local_226.y;
	float local_254 = local_245 - local_252;
	float local_255 = local_245 - local_253;
	float4 local_256 = { local_252, local_254, local_253, local_255 };
	float4 local_257 = sign(local_256);
	const float local_258 = 3.5f;
	float4 local_259 = { local_245, local_245, local_245, local_245 };
	float local_260 = dot(local_257, local_259);
	float local_261 = step(local_258, local_260);
	float local_262 = local_245 - local_261;
	float local_263 = local_251 + local_262;
	const float local_264 = 0.0f;
	float local_265 = clamp(local_263, local_264, local_245);
	float3 local_266 = psIN.v_texture3.xyz;
	float local_267 = psIN.v_texture3.w;
	float local_268 = local_220 * local_267;
	float local_269 = local_245 - local_268;
	float local_270 = lerp(local_269, local_245, local_265);
	return local_270;
}
#endif

//view_dir world_normal roughness light_dir metallic_rgb
float3 calc_brdf_specular_factor_common(float3 local_63, float3 local_75, float local_77, float3 local_427,float3 local_436)
{
	//float3 local_440 = -(local_427);//negative_light
	//float3 local_441 = local_63 + local_440;
	//float3 local_442 = normalize(local_441);//h
	//float local_443 = dot(local_75, local_440);
	//float local_444 = saturate(local_443);//NdotL 
	//float local_445 = dot(local_75, local_442);//NdotH 
	//float local_446 = saturate(local_445);
	//float local_447 = dot(local_440, local_442);
	//float local_448 = saturate(local_447);
	//float local_449 = local_77 * local_77;
	//const float local_450 = 0.49f;
	//float local_451 = local_449 * local_450;
	//const float local_452 = 0.002f;
	//float local_453 = max(local_451, local_452);
	//float local_454 = local_453 * local_453;
	//float local_455 = local_446 * local_454;
	//float local_456 = local_455 - local_446;
	//float local_457 = local_456 * local_446;
	//const float local_458 = 1.0f;
	//float local_459 = local_457 + local_458;
	//const float local_460 = 3.141593f;
	//float local_461 = local_460 * local_459;
	//float local_462 = local_461 * local_459;
	//float local_463 = local_454 / local_462;
	//const float local_464 = 4.0f;
	//float local_465 = local_464 * local_448;
	//float local_466 = local_465 * local_448;
	//const float local_467 = 0.5f;
	//float local_468 = local_77 + local_467;
	//float local_469 = local_466 * local_468;
	//float local_470 = local_458 / local_469;
	//float local_471 = local_470 * local_463;
	//float local_472 = local_471 * local_444;
	//float3 local_473 = { local_472, local_472, local_472 };
	//float3 local_474 = local_473 * local_436;
	//return local_474;
	
	//float3 view_dir = local_63;
	//float3 world_normal = local_75;
	//float roughness = local_77;
	//
	//float3 light_dir = -(local_427);//light_dir
	//float3 h = normalize(view_dir + light_dir);//h
	//float local_444 = saturate(dot(world_normal, light_dir));//n dot l
	//float local_446 = saturate(dot(world_normal, h));//n dot h 
	//float local_448 = saturate(dot(light_dir, h));//l dot h
	//float local_449 = roughness * roughness;
	//const float local_450 = 0.49f;
	//float local_451 = local_449 * local_450;
	//const float local_452 = 0.002f;
	//float local_453 = max(local_451, local_452);
	//float local_454 = local_453 * local_453;
	//float local_455 = local_446 * local_454;
	//float local_456 = local_455 - local_446;
	//float local_457 = local_456 * local_446;
	//const float local_458 = 1.0f;
	//float local_459 = local_457 + local_458;
	//const float local_460 = 3.141593f;
	//float local_461 = local_460 * local_459;
	//float local_462 = local_461 * local_459;
	//float local_463 = local_454 / local_462;
	//const float local_464 = 4.0f;
	//float local_465 = local_464 * local_448;
	//float local_466 = local_465 * local_448;
	//const float local_467 = 0.5f;
	//float local_468 = roughness + local_467;
	//float local_469 = local_466 * local_468;
	//float local_470 = local_458 / local_469;
	//float local_471 = local_470 * local_463;
	//float local_472 = local_471 * local_444;
	//float3 local_473 = { local_472, local_472, local_472 };
	//float3 local_474 = local_473 * local_436;
	//return local_474;


	//float3 view_dir = local_63;
	//float3 world_normal = local_75;
	//float roughness = local_77;
	//
	//
	//
	//float3 light_dir = -(local_427);//light_dir
	//float3 h = normalize(view_dir + light_dir);//h
	//float n_dot_l = saturate(dot(world_normal, light_dir));//n dot l
	//float n_dot_h = saturate(dot(world_normal, h));//n dot h 
	//float l_dot_h = saturate(dot(light_dir, h));//l dot h
	//
	//float local_453 = max(roughness * roughness * 0.49f, 0.002f);
	//float local_454 = local_453 * local_453;
	//float local_455 = n_dot_h * local_454;
	//float local_456 = local_455 - n_dot_h;
	//float local_457 = local_456 * n_dot_h;
	//float local_459 = local_457 + 1.0f;
	//const float pi = 3.141593f;
	//float local_461 = pi * local_459;
	//float local_462 = local_461 * local_459;
	//float local_463 = local_454 / local_462;
	//float local_465 = 4.0f * l_dot_h;
	//float local_466 = local_465 * l_dot_h;
	//float local_468 = roughness + 0.5f;
	//float local_469 = local_466 * local_468;
	//float local_470 = 1.0f / local_469;
	//float local_471 = local_470 * local_463;
	//float local_472 = local_471 * n_dot_l;
	//float3 local_473 = { local_472, local_472, local_472 };
	//float3 local_474 = local_473 * local_436;
	//return local_474;


	const float pi = 3.141593f;
	float3 view_dir = local_63;
	float3 world_normal = local_75;
	float roughness = local_77;
	float3 metallic_rgb = local_436;
	
	float3 light_dir = -(local_427);
	float3 h = normalize(view_dir + light_dir);
	float n_dot_l = saturate(dot(world_normal, light_dir));
	float n_dot_h = saturate(dot(world_normal, h)); 
	float l_dot_h = saturate(dot(light_dir, h));
	float n_dot_v = saturate(dot(world_normal, view_dir));
#if SPECULAR_TEST	//标准GGx
	float a = roughness * roughness;
	float a2 = a * a;
	float x = n_dot_h * n_dot_h * (a2 - 1) + 1;
	float d = a2 / (pi * x * x);
	return metallic_rgb * d / (4 * n_dot_l * n_dot_v);
#else				//镇魔曲算法
	float a = max(roughness * roughness * 0.49f, 0.002f);
	float a2 = a * a;
	float x = n_dot_h * n_dot_h * (a2 - 1) + 1;
	float d = a2 * n_dot_l / (pi * x * x);
	return metallic_rgb * d / (4.0f * l_dot_h * l_dot_h * (roughness + 0.5f));	

	//float a = max(roughness * roughness * 0.49f, 0.002f);
	//float a2 = a * a;
	//float power = 2 / a2 - 2;
	//float d = pow(n_dot_h, power) * 0.7 / (pi * a2);
	//return metallic_rgb * d / (4.0f * l_dot_h * l_dot_h * (roughness + 0.5f));
#endif
}

void point_light_common(float3 local_60,float3 local_63, float3 local_75, float local_77,float4 local_301,float4 local_406,float4 local_407,float local_409,out float3 local_410,out float3 local_411)
{
	float local_413 = local_406.x;
	float local_414 = local_406.y;
	float local_415 = local_406.z;
	float local_416 = local_406.w;
	float local_417 = local_413 + local_414;
	float local_418 = local_417 + local_415;
	float3 local_419;
	float3 local_420;
	if (local_418 == 0.0)
	{
		const float local_421 = 0.0f;
		float3 local_422 = { local_421, local_421, local_421 };
		float3 local_423 = { local_421, local_421, local_421 };
		local_419 = local_422;
		local_420 = local_423;
	}
	else
	{
		float3 local_424 = local_407.xyz;
		float local_425 = local_407.w;
		float3 local_426 = local_60 - local_424;
		float3 local_427 = normalize(local_426);
		float3 local_428 = -(local_427);
		float local_429 = dot(local_75, local_428);
		float local_430 = saturate(local_429);
		float3 local_431 = local_406.xyz;
		float local_432 = local_406.w;
		float3 local_433 = mul(local_431, local_430);
		float3 local_434 = mul(local_433, local_409);
		float3 local_435;
#if SPECULAR_ENABLE
		float3 local_436 = local_301.xyz;
		float local_437 = local_301.w;
		float3 local_438;
		// Function calc_brdf_specular_factor_common Begin 
		local_438 = calc_brdf_specular_factor_common(local_63, local_75, local_77, local_427, local_436);
		// Function calc_brdf_specular_factor_common End
		float3 local_476 = local_431 * local_438;
		float3 local_477 = mul(local_476, local_409);
		local_435 = local_477;
#else
		const float local_478 = 0.0f;
		float3 local_479 = { local_478, local_478, local_478 };
		local_435 = local_479;
#endif
		local_419 = local_434;
		local_420 = local_435;
	}
	local_410 = local_419;
	local_411 = local_420;
}

float3 point_light_common_diffuse_only(float3 v_world_normal,float3 local_49,float4 local_200,float4 local_201,float4 local_203) 
{
	float local_206 = local_200.x;
	float local_207 = local_200.y;
	float local_208 = local_200.z;
	float local_209 = local_200.w;
	float local_210 = local_206 + local_207;
	float local_211 = local_210 + local_208;
	float3 local_212;
	if (local_211 == 0.0)
	{
		const float local_213 = 0.0f;
		float3 local_214 = { local_213, local_213, local_213 };
		local_212 = local_214;
	}
	else
	{
		float3 local_215 = local_201.xyz;
		float local_216 = local_201.w;
		float3 local_217 = local_49 - local_215;
		float3 local_218 = { local_216, local_216, local_216 };
		float3 local_219 = local_217 / local_218;
		float local_220 = dot(local_219, local_219);
		float local_221 = (float)1.0f - local_220;
		float local_222 = saturate(local_221);
		float3 local_223 = normalize(local_217);
		float local_224 = local_203.x;
		float local_225 = local_203.y;
		float local_226 = local_203.z;
		float local_227 = local_203.w;
		const float local_228 = 0.001f;
		float local_229 = local_224 + local_228;
		float local_230 = pow(local_222, local_229);
		float3 local_231 = -(local_223);
		float local_232 = dot(v_world_normal, local_231);
		float local_233 = saturate(local_232);
		float3 local_234 = local_200.xyz;
		float local_235 = local_200.w;
		float3 local_236 = mul(local_234, local_233);
		float3 local_237 = mul(local_236, local_230);
		local_212 = local_237;
	}
	return local_212;
}

void shadow_light_low(float3 v_world_normal,float4 local_137,float4 local_141,out float3 local_142,out float3 local_143)
{
	float3 local_145 = local_141.xyz;
	float local_146 = local_141.w;
	float3 local_147 = -(local_145);
	float local_148 = dot(v_world_normal, local_147);
	float local_149 = saturate(local_148);
	float3 local_150 = local_137.xyz;
	float local_151 = local_137.w;
	float3 local_152 = mul(local_150, local_149);
	const float local_153 = 0.0f;
	float3 local_154 = { local_153, local_153, local_153 };
	local_142 = local_152;
	local_143 = local_154;
}

void shadow_light_common(float3 local_63,float3 local_75, float local_77,float4 local_301,float4 local_303, float4 local_305, out float3 local_306,out float3 local_307)
{
	float3 local_309 = local_305.xyz;
	float local_310 = local_305.w;
	float3 local_311 = -(local_309);//local_311:negative_light_dir
	float local_312 = dot(local_75, local_311);//local_75:world_normal
	float local_313 = saturate(local_312);
	float3 local_314 = local_303.xyz;//local_303:Shadow_Light_Attr[1],LightColor
	float local_315 = local_303.w;
	float3 local_316 = mul(local_314, local_313);
	float3 local_317;
#if SPECULAR_ENABLE
	float3 local_318 = local_301.xyz;//metallic_rgb
	float3 local_320 = calc_brdf_specular_factor_common(local_63, local_75, local_77, local_309, local_318);//view_dir world_normal roughness light_dir metallic_rgb
	float3 local_358 = local_314 * local_320;
	local_317 = local_358;
#else
	const float local_359 = 0.0f;
	float3 local_360 = { local_359, local_359, local_359 };
	local_317 = local_360;
#endif
	local_306 = local_316;
	local_307 = local_317;
}

void calc_lightmap(PS_INPUT psIN,float4 lightmap_scale,float4 local_296,float3 local_297,float3 local_306,float3 local_307,out float3 local_362,out float3 local_363)
{
	float4 local_365;//lightmap color
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
	float3 local_366 = local_296.xyz;
	float local_367 = local_296.w;
	const float local_368 = 1.0f;
	float local_369 = local_368 - local_367;
	const float local_370 = 256.0f;
	float local_371 = local_369 * local_370;
	float local_372 = saturate(local_371);
	float local_373 = local_368 - local_372;
	float4 local_374 = { local_366.x, local_366.y, local_366.z, local_373 };
	local_365 = local_374;
#else
	float4 local_375 = UNITY_SAMPLE_TEX2D(unity_Lightmap, psIN.uv1 * unity_LightmapST.xy + unity_LightmapST.zw);//tex2D(sam_lightmap, psIN.uv1);
	float local_376 = lightmap_scale.x;
	float3 local_377 = lightmap_scale.yzw;
	const float local_378 = 1.0f;
	float4 local_379 = { local_377.x, local_377.y, local_377.z, local_378 };
	float4 local_380 = local_375 * local_379;
	local_365 = local_380;
#endif
	float3 local_382 = local_365.xyz;	//lightmap.rgb
	float local_383 = local_365.w;		//lightmap.a
	float local_384 = 1.0f - local_383; //1 - lightmap.a
	float3 local_385 = { local_384, local_384, local_384 };
	float3 local_386 = local_297 * local_385;//shadow_color.xyz * float3(1 - lightmap.a)
	const float local_387 = 0.1f;
	float local_388 = max(local_387, local_383);
	float3 local_389 = mul(local_306, local_388);
	float local_390 = lightmap_weight.x;
	float local_391 = lightmap_weight.y;
	float local_392 = lightmap_weight.z;
	float local_393 = lightmap_weight.w;
	float3 local_394 = { local_390, local_390, local_390 };
	float3 local_395 = local_389 * local_394;
	float3 local_396 = { local_391, local_391, local_391 };
	float3 local_397 = local_382 * local_396;
	float3 local_398 = local_395 + local_397;
	float3 local_399 = local_398 + local_386;
	const float local_400 = 0.05f;
	float local_401 = max(local_383, local_400);
	float3 local_402 = mul(local_307, local_401);
	float3 local_403 = { local_390, local_390, local_390 };
	float3 local_404 = local_402 * local_403;
	local_362 = local_399;
	local_363 = local_404;
}

float3 calc_lighting_common(PS_INPUT psIN,float4 lightmap_scale, float4 v_texture2, float3 local_60, float3 local_63, float3 local_75, float local_77,float3 local_207,float3 local_211, float4 local_296, float3 local_297)
{
	float4 local_301 = { local_207.x, local_207.y, local_207.z, 0.0f };
	const int local_302 = 1;
	float4 local_303 = ShadowLightAttr[local_302];
	const int local_304 = 3;
	float4 local_305 = ShadowLightAttr[local_304];
	float3 local_306;
	float3 local_307;
	// Function shadow_light_common Begin 
	shadow_light_common(local_63, local_75, local_77, local_301, local_303, local_305, local_306, local_307);
	// Function shadow_light_common End
	float3 local_362;
	float3 local_363;
	// Function calc_lightmap Begin 
	calc_lightmap(psIN, lightmap_scale, local_296, local_297, local_306, local_307, local_362, local_363);
	// Function calc_lightmap End
	float4 local_406 = PointLightAttrs[local_302];
	float4 local_407 = PointLightAttrs[local_304];
	float3 local_408 = v_texture2.xyz;
	float local_409 = v_texture2.w;
	float3 local_410;
	float3 local_411;
	// Function point_light_common Begin 
	point_light_common(local_60, local_63, local_75, local_77, local_301, local_406, local_407, local_409, local_410, local_411);
	// Function point_light_common End
	float3 local_481 = local_362 + local_410;
	float3 local_482 = local_481 + local_408;
	float3 local_483 = local_363 + local_411;
	const int local_484 = 4;
	float4 local_485 = PointLightAttrs[local_484];
	float3 local_486 = local_482 * local_211;
	float3 local_487 = local_486 + local_483;
	float3 local_488 = local_485.xyz;
	float local_489 = local_485.w;
	float3 local_490 = local_487 + local_488;
	float3 local_491 = local_490 - local_488;
	return local_491;
}


float3 calc_lighting_common_low(PS_INPUT psIN,float4 lightmap_scale,float3 local_9, float3 local_49, float4 local_131, float3 local_132)
{
	float4 local_137 = ShadowLightAttr[1];
	float4 local_139 = ShadowLightAttr[2];
	float4 local_141 = ShadowLightAttr[3];
	float3 local_142;
	float3 local_143;
	shadow_light_low(psIN.v_world_normal, local_137, local_141, local_142, local_143);
	float3 local_156;
	float3 local_157;
	calc_lightmap(psIN, lightmap_scale, local_131, local_132, local_142, local_143, local_156, local_157);
	float4 local_200 = PointLightAttrs[1];
	float4 local_201 = PointLightAttrs[3];
	float4 local_203 = PointLightAttrs[4];
	float3 local_204;
	local_204 = point_light_common_diffuse_only(psIN.v_world_normal, local_49, local_200, local_201, local_203);
	float3 local_239 = local_156 + local_204;
	float3 local_240 = local_239 * local_9;
	float3 local_241 = local_240 + local_157;
	return local_241;
}

float3 calc_lighting_terrain(PS_INPUT psIN,float4 lightmap_scale, float4 v_texture5, float3 local_56, float3 local_59, float3 local_87, float local_89,float3 local_232, float3 local_236, float4 local_264, float3 local_265, float3 local_267)
{
	float4 local_269 = { local_232.x, local_232.y, local_232.z, 0.0f };
	const int local_270 = 1;
	float4 local_271 = ShadowLightAttr[local_270];
	const int local_272 = 3;
	float4 local_273 = ShadowLightAttr[local_272];
	float3 local_274;
	float3 local_275;
	// Function shadow_light_common Begin 
	shadow_light_common(local_59, local_87, local_89, local_269, local_271, local_273, local_274, local_275);
	// Function shadow_light_common End
	float3 local_330;
	float3 local_331;
	// Function calc_lightmap Begin 
	calc_lightmap(psIN, lightmap_scale, local_264, local_265, local_274, local_275, local_330, local_331);
	// Function calc_lightmap End
	float4 local_374 = PointLightAttrs[local_272];
	float4 local_375 = PointLightAttrs[local_270];
	float3 local_376 = local_374.xyz;
	float local_377 = local_374.w;
	float3 local_378 = local_376 - local_56;
	float local_379 = dot(local_87, local_378);
	float local_380 = saturate(local_379);
	float3 local_381 = v_texture5.xyz;
	float local_382 = v_texture5.w;
	float local_383 = local_380 * local_382;
	float3 local_384 = local_375.xyz;
	float local_385 = local_375.w;
	float3 local_386 = mul(local_384, local_383);
	float3 local_387 = local_330 + local_386;
	float3 local_388 = local_387 + local_381;
	const int local_389 = 4;
	float4 local_390 = PointLightAttrs[local_389];
	float3 local_391 = local_388 * local_236;
	float3 local_392 = local_391 + local_331;
	float3 local_393 = local_390.xyz;
	float local_394 = local_390.w;
	float3 local_395 = local_392 + local_393;
	float3 local_396 = local_395 - local_393;
	return local_396;
}


#if XRAY_EX_ENABLE
float3 xray_ex(PS_INPUT psIN, float3 local_496,float3 local_497,float2 local_499)
{
	const float local_502 = 0.05f;
	float local_503 = FrameTime * local_502;
	float local_504 = cos(local_503);
	float local_505 = FrameTime * local_502;
	float local_506 = sin(local_505);
	float local_507 = psIN.uv0.x;
	float local_508 = psIN.uv0.y;
	const float local_509 = 0.5f;
	float local_510 = local_507 - local_509;
	float local_511 = local_508 - local_509;
	float2 local_512 = { local_510, local_511 };
	float local_513 = local_512.x;
	float local_514 = local_512.y;
	float local_515 = local_513 * local_504;
	float local_516 = local_514 * local_506;
	float local_517 = local_515 + local_516;
	float local_518 = local_514 * local_504;
	float local_519 = local_513 * local_506;
	float local_520 = local_518 - local_519;
	float2 local_521 = { local_517, local_520 };
	float local_522 = local_521.x;
	float local_523 = local_521.y;
	float local_524 = local_522 + local_509;
	float local_525 = local_523 + local_509;
	float2 local_526 = { local_524, local_525 };
	float2 local_527 = mul(local_499, FrameTime);
	float2 local_528 = psIN.uv0 + local_527;
	float4 local_529 = tex2D(sam_other1, local_528);
	const float local_530 = 2.0f;
	float2 local_531 = mul(local_526, local_530);
	float2 local_532 = mul(local_499, FrameTime);
	float2 local_533 = mul(local_532, local_509);
	float2 local_534 = local_531 + local_533;
	float4 local_535 = tex2D(sam_other1, local_534);
	float2 local_536 = psIN.uv0 + local_526;
	const float local_537 = 3.0f;
	float2 local_538 = mul(local_536, local_537);
	float2 local_539 = mul(local_499, FrameTime);
	float2 local_540 = mul(local_539, local_509);
	float2 local_541 = local_538 - local_540;
	float4 local_542 = tex2D(sam_other1, local_541);
	const float local_543 = 1.0f;
	float local_544 = FrameTime * xray_cycle;
	float local_545 = sin(local_544);
	float local_546 = local_545 * local_509;
	float local_547 = local_543 + local_546;
	float local_548 = xray_strength * local_547;
	float local_549 = local_529.x;
	float local_550 = local_529.y;
	float local_551 = local_529.z;
	float local_552 = local_529.w;
	float local_553 = local_535.x;
	float local_554 = local_535.y;
	float2 local_555 = local_535.zw;
	float local_556 = local_549 + local_554;
	float2 local_557 = local_542.xy;
	float local_558 = local_542.z;
	float local_559 = local_542.w;
	float local_560 = local_556 + local_558;
	float local_561 = xray_pow_offset * local_560;
	const float local_562 = 0.3f;
	float local_563 = local_561 * local_562;
	float local_564 = local_543 + local_563;
	float2 local_565 = local_496.xy;
	float local_566 = local_496.z;
	float local_567 = local_564 + local_566;
	float local_568 = min(local_543, local_567);
	float local_569 = local_568 * local_568;
	float local_570 = local_569 * local_568;
	float local_571 = local_570 * local_570;
	float local_572 = local_571 * local_548;
	float3 local_573 = mul(local_497, local_572);
	float3 local_574 = mul(local_573, local_549);
	float3 local_575 = mul(local_574, local_554);
	float3 local_576 = mul(local_575, local_558);
	return local_576;
}
#endif


#if FOG_TYPE==FOG_TYPE_LINEAR
float3 calc_fog(float3 local_581, float local_586)
{
	float3 local_592 = FogColor.xyz;
	float local_593 = FogColor.w;
	float local_594 = local_586 * local_593;
	float3 local_595 = { local_594, local_594, local_594 };
	float3 local_596 = lerp(local_581, local_592, local_595);
	return local_596;
}
#elif FOG_TYPE == FOG_TYPE_HEIGHT
float calc_cylindrical_u(float3 local_63)
{
	float2 local_600 = local_63.xy;
	float local_601 = local_63.z;
	float local_602 = local_63.x;
	float local_603 = local_63.y;
	float local_604 = local_63.z;
	float local_605 = atan2(local_601, local_602);
	const float local_606 = 0.159f;
	float local_607 = local_605 * local_606;
	const float local_608 = 0.5f;
	float local_609 = local_607 + local_608;
	float local_610 = (float)1.0f - local_609;
	return local_610;
}
float3 calc_fog_textured(PS_INPUT psIN, float3 local_581,float local_598)
{
	float3 local_614 = psIN.fog_factor_info.xyz;
	float local_615 = psIN.fog_factor_info.w;
	float local_616 = local_598 + local_615;
	float local_617 = psIN.fog_factor_info.x;
	float local_618 = psIN.fog_factor_info.y;
	float2 local_619 = psIN.fog_factor_info.zw;
	float2 local_620 = { local_616, local_618 };
	float4 local_621 = tex2D(sam_fog_texture, local_620);
	float3 local_622 = local_621.xyz;
	float local_623 = local_621.w;
	float3 local_624 = FogColor.xyz;
	float local_625 = FogColor.w;
	float2 local_626 = psIN.fog_factor_info.xy;
	float local_627 = psIN.fog_factor_info.z;
	float local_628 = psIN.fog_factor_info.w;
	float3 local_629 = { local_627, local_627, local_627 };
	float3 local_630 = lerp(local_622, local_624, local_629);
	float3 local_631 = { local_617, local_617, local_617 };
	float3 local_632 = lerp(local_581, local_630, local_631);
	return local_632;
}
#endif

float get_shadow_map_light(PS_INPUT psIN)
{
	float local_218;
#if SHADOW_MAP_ENABLE
	float2 local_219 = ShadowInfo.xy;
	float local_220 = ShadowInfo.z;
	float local_221 = ShadowInfo.w;
	const int local_222 = 3;
	float4 local_223 = ShadowLightAttr[local_222];
	float local_224 = calc_shadowmap(psIN, calc_shadowmap, local_220, local_223);
	local_218 = local_224;
#else
	const float local_272 = 1.0f;
	local_218 = local_272;
#endif
	return local_218;
}

float3 get_static_light(PS_INPUT psIN)
{
	float3 local_273;
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
	float4 local_274 = mul(psIN.v_world_position, ViewProjection);
	float2 local_275 = local_274.xy;
	float2 local_276 = local_274.zw;
	float3 local_277 = local_274.xyz;
	float local_278 = local_274.w;
	float2 local_279 = { local_278, local_278 };
	float2 local_280 = local_275 / local_279;
	const float local_281 = 0.5f;
	float2 local_282 = { local_281, local_281 };
	float2 local_283 = local_280 * local_282;
	float2 local_284 = { local_281, local_281 };
	float2 local_285 = local_283 + local_284;
	float local_286 = local_285.x;
	float local_287 = local_285.y;
	const float local_288 = 1.0f;
	float local_289 = local_288 - local_287;
	float2 local_290 = { local_286, local_289 };
	float4 local_291 = tex2D(sam_light_buffer, local_290);
	float3 local_292 = local_291.xyz;
	float local_293 = local_291.w;
	local_273 = local_292;
#else
	local_273 = float3(0, 0, 0);
#endif
	return local_273;
}

float3 get_xray_color(PS_INPUT psIN)
{
	float3 local_493;
#if XRAY_EX_ENABLE
	float3x3 local_494 = (float3x3)View;
	float3 local_495 = mul(psIN.v_world_normal, local_494);
	float3 local_496 = normalize(local_495);
	float3 local_497 = xray_color.xyz;
	float local_498 = xray_color.w;
	float2 local_499 = { xray_u, xray_v };
	float3 local_500 = xray_ex(psIN, local_496, local_497, local_499);
	local_493 = local_500;
#else
	const float local_578 = 0.0f;
	float3 local_579 = { local_578, local_578, local_578 };
	local_493 = local_579;
#endif
	return local_493;
}

float3 apply_fog(PS_INPUT psIN, float3 local_581)
{
	float3 local_585;
#if FOG_TYPE==FOG_TYPE_NONE
	local_585 = local_581;
#elif FOG_TYPE==FOG_TYPE_LINEAR
	float local_586 = psIN.fog_factor_info.x;
	float local_587 = psIN.fog_factor_info.y;
	float local_588 = psIN.fog_factor_info.z;
	float local_589 = psIN.fog_factor_info.w;
	float3 local_590 = calc_fog(local_581, local_586);
	local_585 = local_590;
#elif FOG_TYPE==FOG_TYPE_HEIGHT
	float local_598 = calc_cylindrical_u(local_63);
	float3 local_612 = calc_fog_textured(psIN, local_581, local_598);
	local_585 = local_612;
#endif
	return local_585;
}

float3 apply_snow_low(float3 v_world_normal, float3 local_3,float local_8)
{
	float3 local_9;
#if SNOW_ENABLE
	float local_10 = local_3.x;
	float local_11 = local_3.y;
	float local_12 = local_3.z;
	float local_13 = max(local_10, local_11);
	float local_14 = max(local_13, local_12);
	float local_15 = min(local_10, local_11);
	float local_16 = min(local_15, local_12);
	const float local_17 = 1.0f;
	const float local_18 = 0.01f;
	float local_19 = local_18 + local_14;
	float local_20 = local_16 / local_19;
	float local_21 = local_17 - local_20;
	const float local_22 = 0.3f;
	const float local_23 = 0.6f;
	const float local_24 = 0.1f;
	float3 local_25 = { local_22, local_23, local_24 };
	float local_26 = dot(local_3, local_25);
	float local_27 = saturate(local_26);
	const float local_28 = 0.001f;
	float local_29 = v_world_normal.x;
	float local_30 = v_world_normal.y;
	float local_31 = v_world_normal.z;
	float local_32 = local_30 - local_28;
	float local_33 = local_17 - local_28;
	float local_34 = local_32 / local_33;
	float local_35 = saturate(local_34);
	float local_36 = local_35 + local_24;
	float local_37 = local_17 - local_8;
	float local_38 = local_17 / local_37;
	float local_39 = local_38 - local_17;
	float local_40 = local_39 * local_21;
	float local_41 = local_40 * local_27;
	float local_42 = local_41 * local_36;
	float local_43 = saturate(local_42);
	float3 local_44 = { local_17, local_17, local_17 };
	float3 local_45 = { local_43, local_43, local_43 };
	float3 local_46 = lerp(local_3, local_44, local_45);
	local_9 = local_46;
#else
	local_9 = local_3;
#endif
	return local_9;
}