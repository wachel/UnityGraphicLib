// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/BakeMipmap"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		[Toggle(SMOOTH)] SMOOTH("Smooth", float) = 1
		_Gamma("Gamma",float) = 2
		_Step("Step",int) = 400
		_Glossiness("_Glossiness",float) = 0.3
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature SMOOTH
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			float _Gamma;
			int _Step;
			float _Glossiness;

			float hash(float v) {
				return -1.0 + 2.0*frac(sin(v)*43758.5453123);
			}

			#define PI 3.141592654

			//取围绕dir的随机方向，glossiness控制随机范围
			float3 randDir(float randSeed, float3 dir, float glossiness)
			{
				float3 w = dir;
				float3 u = normalize(cross(float3(0,1,0), w));
				float3 v = normalize(cross(w, u));

				float shininess = pow(8192.0, glossiness);

				float a = acos(pow(1.0 - hash(randSeed + dir.x) * (shininess + 1.0) / (shininess + 2.0), 1.0 / (shininess + 1.0)));
				a *= PI * 0.5;
				float phi = hash(randSeed) * PI * 2.0;
				float3 rlt = (u * cos(phi) + v * sin(phi)) * sin(a) + w * cos(a);

				return rlt;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float2 xy = (i.uv - float2(0.5,0.5)) * 2;
				float z = sqrt(1 - xy.x * xy.x - xy.y * xy.y);
				float3 normal = length(xy) > 1? normalize(float3(xy,0)): float3(xy, z);
#if SMOOTH
				int step = _Step;
				float totalWeight = 0.00000001;
				float3 totalColor = float3(0, 0, 0);//pow(tex2D(_MainTex, normal.xy * 0.5 + float2(0.5, 0.5)), _Gamma);

				for (int x = 0;x < step;x++) {
					float randSeed = x*0.234 + i.uv.x * 5.3345 + i.uv.y * i.uv.y * 20.33;
					float3 dir = randDir(randSeed, normal, _Glossiness);

					if (dir.z > 0) {
						float weight = 1;//dot(dir, normal);
						totalColor += pow(tex2D(_MainTex, dir.xy * 0.5 + float2(0.5, 0.5)), _Gamma) * weight;
						totalWeight += 1;
					}
				}
				totalColor /= totalWeight;
				totalColor = pow(totalColor, 1 / _Gamma);
				return float4(totalColor,1);
#else
				return tex2D(_MainTex, normal.xy * 0.5 + float2(0.5,0.5));
				//return float4(tx, ty, tz, 1);
#endif
			}
			ENDCG
		}
	}
}
