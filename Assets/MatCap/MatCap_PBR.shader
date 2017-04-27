// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// MatCap Shader, (c) 2015 Jean Moreno
//http://graphicrants.blogspot.com/2013/08/specular-brdf-reference.html
Shader "MatCap/PBR"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color("Color",Color) = (1,1,1,1)
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_MatCap ("MatCap (RGB)", 2D) = "white" {}
		_MatcapBrightness("Matcap Brightness",float) = 4

		_MetallicRoughness("Metallic(R) And Roughness(G)",2D) = "black"{}
		_MetallicRoughnessColor("Metallic Roughness Color",Color) = (1,1,1,1)
	}
	
	Subshader
	{
		Tags { "RenderType"="Opaque" }
		
		Pass
		{
			Tags { "LightMode" = "Always" }
			Cull Off
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#include "UnityCG.cginc"
				
				struct v2f
				{
					float4 pos	: SV_POSITION;
					float2 uv : TEXCOORD0;
					float2 uv_bump : TEXCOORD1;
					
					fixed3 tSpace0 : TEXCOORD2;
					fixed3 tSpace1 : TEXCOORD3;
					fixed3 tSpace2 : TEXCOORD4;

					float3 worldPos : TEXCOORD5;
				};
				
				uniform float4 _MainTex_ST;
				uniform float4 _BumpMap_ST;
				
				v2f vert (appdata_tan v)
				{
					v2f o;
					o.pos = UnityObjectToClipPos (v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.uv_bump = TRANSFORM_TEX(v.texcoord,_BumpMap);
					
					fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
					fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
					fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
					o.tSpace0 = fixed3(worldTangent.x, worldBinormal.x, worldNormal.x);
					o.tSpace1 = fixed3(worldTangent.y, worldBinormal.y, worldNormal.y);
					o.tSpace2 = fixed3(worldTangent.z, worldBinormal.z, worldNormal.z);

					o.worldPos = mul(unity_ObjectToWorld, v.vertex);
					return o;
				}
				
				uniform sampler2D _MainTex;
				uniform sampler2D _BumpMap;
				uniform sampler2D _MatCap;
				uniform sampler2D _MetallicRoughness;
				float4 _MatCap_TexelSize;
				float4 _Color;
				float _MatcapBrightness;
				float4 _MetallicRoughnessColor;
				
				float4 gamma_correct_began(float4 color)
				{
					return color*color;
				}

				float4 gamma_correct_ended(float4 color)
				{
					return sqrt(color);
				}

				fixed4 frag (v2f i) : COLOR
				{
					fixed4 tex = gamma_correct_began(tex2D(_MainTex, i.uv) * _Color);
					//return gamma_correct_ended(tex);
					fixed3 normals = UnpackNormal(tex2D(_BumpMap, i.uv_bump));
					float4 mr = tex2D(_MetallicRoughness, i.uv) * _MetallicRoughnessColor;
					float3 worldNorm;
					worldNorm.x = dot(i.tSpace0.xyz, normals);
					worldNorm.y = dot(i.tSpace1.xyz, normals);
					worldNorm.z = dot(i.tSpace2.xyz, normals);

					float3 view = normalize(i.worldPos - _WorldSpaceCameraPos);
					float3 right = normalize(cross(view, float3(0, -1, 0)));
					float3 up = normalize(cross(view, right));
					float2 uv = float2(dot(worldNorm, right), dot(worldNorm, up)) * 0.5 + 0.5;

					float3 h = normalize(-view + worldNorm);

					float metallic = mr.x;
					float roughness = 1-mr.y;
					float reflection = mr.z;

					float f0 = 0.1;//lerp(0, 0.2, reflection);
					float fresnel = f0 + (1 - f0)*pow(1 - dot(-view,h), 2);
					int maxMipmapLevel = log2(_MatCap_TexelSize.w / 16);
					int mipmap = roughness * maxMipmapLevel;
					float4 lightRough = gamma_correct_began(tex2Dlod(_MatCap, float4(uv, maxMipmapLevel, maxMipmapLevel))) * _MatcapBrightness;
					float4 lightGlossy = gamma_correct_began(tex2Dlod(_MatCap, float4(uv, mipmap, mipmap))) * _MatcapBrightness;
					float4 lightSpecular = (lightGlossy - lightRough);

					float4 finalColor = metallic * lightGlossy * tex + (1- metallic) * (lightRough * tex * (1-fresnel) + lightSpecular * fresnel);

					//float refFactor = lerp(fresnel,1,metallic);
					//float4 refColor = lerp(pow(lightGlossy,3) * 1, lightGlossy*tex, metallic);
					//
					//float4 finalColor = refFactor*refColor + tex*(1 - refFactor)*lightRough;
					return gamma_correct_ended(finalColor);
				}
			ENDCG
		}
	}
	
	Fallback "VertexLit"
}