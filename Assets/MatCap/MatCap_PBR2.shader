// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// MatCap Shader, (c) 2015 Jean Moreno
//http://graphicrants.blogspot.com/2013/08/specular-brdf-reference.html
Shader "MatCap/PBR2"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_MatCap ("MatCap (RGB)", 2D) = "white" {}
		//_X("x",Range(0,1)) = 0
		_Brightness("Brightness",float) = 2
	}
	
	Subshader
	{
		Tags { "RenderType"="Opaque" }
		
		Pass
		{
			Tags { "LightMode" = "Always" }
			
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
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
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
				float _X;
				float _Brightness;
				
				fixed4 frag (v2f i) : COLOR
				{
					fixed4 tex = tex2D(_MainTex, i.uv);
					fixed3 normals = UnpackNormal(tex2D(_BumpMap, i.uv_bump));

					float3 worldNorm;
					worldNorm.x = dot(i.tSpace0.xyz, normals);
					worldNorm.y = dot(i.tSpace1.xyz, normals);
					worldNorm.z = dot(i.tSpace2.xyz, normals);

					float3 view = normalize(i.worldPos - _WorldSpaceCameraPos);
					float3 right = normalize(cross(view, float3(0, -1, 0)));
					float3 up = normalize(cross(view, right));
					float2 uv = float2(dot(worldNorm, right), dot(worldNorm, up)) * 0.5 + 0.5;

					int index = min(int(pow(tex.a,1/1.4) * 4 + 0.5),3);//why 1.4?
					float4 colorAdd = tex2D(_MatCap, float2(uv.x * 0.25 + index * 0.25, uv.y * 0.5));
					float4 colorMul = tex2D(_MatCap, float2(uv.x * 0.25 + index * 0.25, uv.y * 0.5 + 0.5));

					return fixed4(colorMul.rgb * tex.rgb + colorAdd.rgb,1) * _Brightness;
				}
			ENDCG
		}
	}
	
	Fallback "VertexLit"
}