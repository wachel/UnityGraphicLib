// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

void InitVSVariables() {
	WorldViewProjection = transpose(UNITY_MATRIX_MVP);
	World = transpose(unity_ObjectToWorld);
#if FOG_TYPE == FOG_TYPE_LINEAR
	Projection = UNITY_MATRIX_P;
#endif
	TexTransform0[0] = float4(1, 0, 0, 0);
	TexTransform0[1] = float4(0, 1, 0, 0);
	TexTransform0[2] = float4(0, 0, 1, 0);
#if INSTANCE_TYPE == INSTANCE_TYPE_NONE || INSTANCE_TYPE == INSTANCE_TYPE_PRS
	//float4x4 LightMapTransform;
#endif
#if FOG_TYPE == FOG_TYPE_HEIGHT || 1
	camera_pos = float4(_WorldSpaceCameraPos,0);
#endif
#if INSTANCE_TYPE == INSTANCE_TYPE_PRS || INSTANCE_TYPE == INSTANCE_TYPE_PRS_LM || NEOX_DEBUG_DEFERED_STATIC_LIGHT
	ViewProjection = UNITY_MATRIX_VP;
#endif
#if FOG_TYPE == FOG_TYPE_LINEAR || FOG_TYPE == FOG_TYPE_HEIGHT
	FogInfo = float4(600,1800,0 ,-500);
#endif
#if FOG_TYPE == FOG_TYPE_HEIGHT
	//float4 FogInfoEX;
#endif
#if GPU_SKIN_ENABLE
	//float4 SkinBones[MAX_BONE_UNIFORM_COUNT];
#endif
#if INSTANCE_TYPE == INSTANCE_TYPE_NONE || INSTANCE_TYPE == INSTANCE_TYPE_PRS
	//float4 lightmap_scale;
#endif
#if SHADOW_MAP_ENABLE
	//float4x4 lvp;
#endif
#if FOG_TYPE == FOG_TYPE_HEIGHT || SHADOW_MAP_ENABLE || 1
	//float4 ShadowLightAttr[LIGHT_ATTR_ITEM_NUM];
#endif
	//float4 PointLightAttrs[LIGHT_ATTR_ITEM_NUM*LIGHT_NUM];
}

fixed4 _LightColor0;
float4 _LightDir;

void InitPSVariables() {

#if XRAY_EX_ENABLE
	View = UNITY_MATRIX_V;
#endif
	camera_pos = float4(_WorldSpaceCameraPos, 0);
#if ALPHA_TEST_ENABLE
	//float alphaRef;
#endif
#if FOG_TYPE == FOG_TYPE_LINEAR || FOG_TYPE == FOG_TYPE_HEIGHT
	FogColor = unity_FogColor;
#endif
#if _SHADER_TYPE_SKIN
	envSHR[0] = float4(-0.3811421,0.1253233, -0.2120648,	0.9987546);
	envSHR[1] = float4(0.01569627,	0.2915865,	0.1830021,	0.9387445);
	envSHR[2] = float4(12.43346,	4.941399, -7.84583,	0.9973654);
	envSHR[3] = float4(-0.135363,	0.2052939,	0.1272737,	0.960902);

	envSHG[0] = float4(12.94772,	3.035883,	2.703927	,0.9974604);
	envSHG[1] = float4(-0.06056262,	0.1262439, -0.07551359,	0.9872651);
	envSHG[2] = float4(-0.7253556 ,-0.7759171,	4.277917,	0.9988876);
	envSHG[3] = float4(0.002827288,	0.09157144,	0.0007941324,	0.9957942);

	envSHB[0] = float4(-0.3813243,	0.1264055, -0.2110212,	0.9987284);
	envSHB[1] = float4(0.07998216,	0.263601,	0.1670418,	0.946686);
	envSHB[2] = float4(10.89685,	4.948893, -10.46802,	0.9975024);
	envSHB[3] = float4(0.03248122,	0.2385394, -0.0455861,	0.9695184);

	envRot[0] = float4(-2.064811, -0.2667427, -2.645338	,0.9988711);
	envRot[1] = float4(-0.03466783,	0.2669055,	0.04465825	,0.962063);
	envRot[2] = float4(4.908224, -0.3392715,	0.9801533,	0.9993413);

	character_light_factor = 0.04893278;
	change_color_bright_add = 3.728522;
	bright_color = float4(-0.01523539,	0.3198986, -0.1025653,	0.9417607);
	change_color_bright = -5.3792;
	u_speed = -0.1108199;
	v_speed = -3.833528;
	change_color_scaled = -0.2035225;
	tint_color1 = float4(-4.313719,	8.065851	,13.70261,	0.9974493);
	tint_color2 = float4( -0.2142183,	0.3488694, -0.2171365	,0.8861446);
	metallic_offset = -5.352693;
	//roughness_offset = -0.2420081;
	//normalmap_scale = -4.964819;
	sss_warp0 = -0.2694022;
	sss_scatter_color0 = float4(-6.480323,	12.98367,	14.65904,	0.9964634);
	sss_scatter0 = 0.0003060505;
#else
	//lightmap_weight = float4(1, 0, 0, 0);	
	//shadow_color = float4(0, 0, 0, 0);
	//roughness_offset = -0.18;
#endif
#if NEOX_DEBUG_DEFERED_STATIC_LIGHT
	ViewProjection = transpose(UNITY_MATRIX_VP);
#endif
	//roughness_offset = -0.18;
	//normalmap_scale = 1;
	//sam_lightmap = samplerunity_Lightmap;

#if SHADOW_MAP_ENABLE
	ShadowInfo = float4(1,1,1,1);
#endif
	float AlphaMtl = 1;
	//ShadowLightAttr[0] = float4(0,0,0,0);
	////float3 lightColor = _LightColor0.xyz;
	//float3 lightColor = float3(2, 1.890196, 1.733333);
	//ShadowLightAttr[1] = float4(lightColor, 3);
	//ShadowLightAttr[2] = float4(0, 0, 0, 0);
	ShadowLightAttr[0] = ShadowLightAttr0;
	ShadowLightAttr[1] = ShadowLightAttr1;
	ShadowLightAttr[2] = ShadowLightAttr2;

	//float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
	//float3 lightDir = normalize(float3(-0.2,-1,0));
	ShadowLightAttr[3] = float4(_LightDir.xyz, 0.001);
	PointLightAttrs[0] = float4(0, 0, 0, 0);
	PointLightAttrs[1] = float4(1.289804, 1.208235, 1.147059, 1);
	PointLightAttrs[2] = float4(10, 0, 0, 0);
	PointLightAttrs[3] = float4(2921.323, 580.1978, 4497.58, 180);
#if XRAY_EX_ENABLE
	//float4 xray_color;
	//float xray_strength;
	//float xray_cycle;
	//float xray_pow_offset;
	//float xray_u;
	//float xray_v;
#endif
}