﻿Shader "MRT/Additive"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("color", Color) = (1,1,0,0.5)
	}
	CGINCLUDE
		#include "UnityCG.cginc"
		#include "Assets/PostBlend/CGINC/PostBlendCommon.cginc"
		
		struct appdata
		{
			float4 vertex : POSITION;
			float2 uv : TEXCOORD0;
		};

		struct v2f
		{
			float4 vertex : SV_POSITION;
			float2 uv : TEXCOORD0;
			float z : TEXCOORD1;
		};

		sampler2D _MainTex;
		float4 _MainTex_ST;
		half4 _Color;
		
		v2f vert (appdata v)
		{
			half4 vPos = mul(UNITY_MATRIX_MV, v.vertex);
			v2f o;
			o.vertex = mul(UNITY_MATRIX_P, vPos);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			o.z = abs(vPos.z);
			return o;
		}
		
		pOut fragBlend (v2f i)
		{
			half4 c = _Color;
			return additiveBlend(c);
		}
		pOut fragDepth (v2f i)
		{
			half4 c = _Color;
			return additiveDepth(c, i.z);
		}
	ENDCG
	
	SubShader
	{
		LOD 200
		Lighting Off ZWrite Off Fog { Mode Off }
		Blend One One
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragBlend
			#pragma target 3.0
			ENDCG
		}
		
		LOD 200
		Lighting Off ZWrite Off Fog { Mode Off }
		BlendOp Max
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment fragDepth
			#pragma target 3.0
			ENDCG
		}
	}
}
