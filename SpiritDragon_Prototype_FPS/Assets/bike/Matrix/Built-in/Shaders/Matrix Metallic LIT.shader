// Made with Amplify Shader Editor v1.9.0.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Matrix Metallic LIT"
{
	Properties
	{
		_ASEOutlineWidth( "Outline Width", Float ) = 0
		_ASEOutlineColor( "Outline Color", Color ) = (0,0,0,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector][Foldout(MatrixEffect,true,8)][Space]_MatrixEditorStart("Matrix Editor Start", Float) = 0
		[HDR]_MatrixColor("Matrix Color", Color) = (0.9098039,2.980392,0.5176471,0)
		[HDR][Header(Matrix Effect)][Space]_MatrixColor("Matrix Color", Color) = (0.9098039,2.980392,0.5176471,0)
		_Width("Width", Range( 0 , 0.6)) = 0.176
		_TimeScale("Letters Time Scale", Range( 0 , 0.005)) = 0
		_DropExponent("Drop Exponent", Range( 1 , 20)) = 1
		_DropSpeed("Drop Speed", Range( 0 , 5)) = 1
		_DropLength("Drop Length", Range( 0 , 30)) = 1
		_DropHeadShrink("Drop Head Shrink", Range( 0.1 , 1)) = 1
		[Toggle(_USETRIPLANAR_ON)] _UseTriplanar("Use Triplanar", Float) = 1
		_UVTilling("UV Tilling", Range( 0 , 1)) = 1
		[NoScaleOffset][SingleLineTexture]_Mask("Mask", 2D) = "white" {}
		[NoScaleOffset][SingleLineTexture]_Noise("Noise", 2D) = "white" {}
		[NoScaleOffset][SingleLineTexture]_Font("Font", 2D) = "white" {}
		[HideInInspector][Foldout(Main,true,8)][Space]_EditorStart("Editor Start", Float) = 0
		[HDR]_RimColor("RimColor", Color) = (0.5073529,0.3794856,0.2424849,0)
		_RimPower("RimPower", Range( 0 , 20)) = 0
		[SingleLineTexture]_MainTex("Albedo", 2D) = "white" {}
		_Tiling("Tiling", Range( 0 , 100)) = 1
		_Color("Color", Color) = (1,1,1,1)
		_Cutoff1("Alpha Clip Threshold", Range( 0 , 1)) = 0
		[NoScaleOffset][SingleLineTexture]_MetallicTexture("Metallic Texture", 2D) = "white" {}
		_MetallicValue("Metallic Value", Range( 0 , 1)) = 0
		_Glossiness("Smoothness Value", Range( 0 , 1)) = 0
		[KeywordEnum(AlbedoAlpha,MetallicAlpha)] _GlossSource("Source", Float) = 1
		[NoScaleOffset][Normal][SingleLineTexture]_BumpMap("Normal Texture", 2D) = "bump" {}
		[NoScaleOffset][SingleLineTexture]_OcclusionMap("Occlusion Map", 2D) = "white" {}
		[Toggle]_UseEmission("UseEmission", Float) = 0
		[NoScaleOffset][SingleLineTexture]_EmissionMap("Emission Texture", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[HideInInspector][Space][EndGroup()]_EditorEnd("Editor End", Float) = 0
		[HideInInspector][DrawSystemProperties]_AdvancedInpector("AdvancedInpector", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		float4 _ASEOutlineColor;
		float _ASEOutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _ASEOutlineColor.rgb;
			o.Alpha = 1;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _USETRIPLANAR_ON
		#pragma multi_compile _GLOSSSOURCE_ALBEDOALPHA _GLOSSSOURCE_METALLICALPHA
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _AdvancedInpector;
		uniform float _EditorStart;
		uniform float _EditorEnd;
		uniform float _MatrixEditorStart;
		uniform sampler2D _BumpMap;
		uniform float _Tiling;
		uniform sampler2D _MainTex;
		uniform float4 _Color;
		uniform float _RimPower;
		uniform float4 _RimColor;
		uniform float _UseEmission;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionColor;
		uniform sampler2D _Mask;
		uniform float _UVTilling;
		uniform float _Width;
		uniform sampler2D _Font;
		uniform sampler2D _Noise;
		uniform float _TimeScale;
		uniform float _DropHeadShrink;
		uniform float _DropLength;
		uniform float _DropSpeed;
		uniform float _DropExponent;
		uniform float4 _MatrixColor;
		uniform sampler2D _MetallicTexture;
		uniform float _MetallicValue;
		uniform float _Glossiness;
		uniform sampler2D _OcclusionMap;
		uniform float _Cutoff1;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (_Tiling).xx;
			float2 uv_TexCoord441 = i.uv_texcoord * temp_cast_0;
			float3 TangentNormal18 = UnpackNormal( tex2D( _BumpMap, uv_TexCoord441 ) );
			o.Normal = TangentNormal18;
			float4 tex2DNode19 = tex2D( _MainTex, uv_TexCoord441 );
			float3 normalizeResult430 = normalize( i.viewDir );
			float dotResult431 = dot( TangentNormal18 , normalizeResult430 );
			float4 AlbedoColor25 = ( ( tex2DNode19 * _Color ) + ( pow( ( 1.0 - saturate( dotResult431 ) ) , _RimPower ) * _RimColor ) );
			o.Albedo = AlbedoColor25.rgb;
			float4 EmissionColor32 = ( _UseEmission == 1.0 ? ( tex2D( _EmissionMap, uv_TexCoord441 ) * _EmissionColor ) : float4( 0,0,0,0 ) );
			float2 temp_cast_2 = (_UVTilling).xx;
			float2 uv_TexCoord85_g189 = i.uv_texcoord * temp_cast_2;
			float2 uvsmatrixeffect38_g196 = uv_TexCoord85_g189;
			float widthmatrixeffect41_g196 = _Width;
			float2 temp_output_4_0_g196 = ( uvsmatrixeffect38_g196 / widthmatrixeffect41_g196 );
			float mulTime6_g196 = _Time.y * _TimeScale;
			float2 break24_g197 = uvsmatrixeffect38_g196;
			float mulTime20_g197 = _Time.y * _DropSpeed;
			float temp_output_3_0_g197 = floor( ( break24_g197.x / widthmatrixeffect41_g196 ) );
			float DropSpeed8_g197 = ( ( cos( ( temp_output_3_0_g197 * 3.0 ) ) * 0.15 ) + 0.4 );
			float DropOffset11_g197 = sin( ( temp_output_3_0_g197 * 15.0 ) );
			float smoothstepResult26_g196 = smoothstep( 0.0 , _DropHeadShrink , pow( ( 1.0 - frac( ( ( break24_g197.y / _DropLength ) + ( mulTime20_g197 * DropSpeed8_g197 ) + DropOffset11_g197 ) ) ) , _DropExponent ));
			float3 ase_worldPos = i.worldPos;
			float2 appendResult19_g189 = (float2(ase_worldPos.x , ase_worldPos.y));
			float2 appendResult12_g189 = (float2(ase_worldPos.z , ase_worldPos.z));
			float2 FrontUvs31_g189 = ( ( appendResult19_g189 + sin( appendResult12_g189 ) ) * _UVTilling );
			float2 uvsmatrixeffect38_g194 = FrontUvs31_g189;
			float widthmatrixeffect41_g194 = _Width;
			float2 temp_output_4_0_g194 = ( uvsmatrixeffect38_g194 / widthmatrixeffect41_g194 );
			float mulTime6_g194 = _Time.y * _TimeScale;
			float2 break24_g195 = uvsmatrixeffect38_g194;
			float mulTime20_g195 = _Time.y * _DropSpeed;
			float temp_output_3_0_g195 = floor( ( break24_g195.x / widthmatrixeffect41_g194 ) );
			float DropSpeed8_g195 = ( ( cos( ( temp_output_3_0_g195 * 3.0 ) ) * 0.15 ) + 0.4 );
			float DropOffset11_g195 = sin( ( temp_output_3_0_g195 * 15.0 ) );
			float smoothstepResult26_g194 = smoothstep( 0.0 , _DropHeadShrink , pow( ( 1.0 - frac( ( ( break24_g195.y / _DropLength ) + ( mulTime20_g195 * DropSpeed8_g195 ) + DropOffset11_g195 ) ) ) , _DropExponent ));
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 normalizeResult7_g189 = normalize( abs( ase_worldNormal ) );
			float3 temp_output_13_0_g189 = pow( normalizeResult7_g189 , 40.0 );
			float3 break17_g189 = temp_output_13_0_g189;
			float3 TriplanarBlendWeight33_g189 = ( temp_output_13_0_g189 / ( break17_g189.x + break17_g189.y + break17_g189.z ) );
			float3 break50_g189 = TriplanarBlendWeight33_g189;
			float2 appendResult20_g189 = (float2(ase_worldPos.z , ase_worldPos.y));
			float2 appendResult14_g189 = (float2(ase_worldPos.x , ase_worldPos.x));
			float2 SideUvs32_g189 = ( ( appendResult20_g189 + sin( appendResult14_g189 ) ) * _UVTilling );
			float2 uvsmatrixeffect38_g190 = SideUvs32_g189;
			float widthmatrixeffect41_g190 = _Width;
			float2 temp_output_4_0_g190 = ( uvsmatrixeffect38_g190 / widthmatrixeffect41_g190 );
			float mulTime6_g190 = _Time.y * _TimeScale;
			float2 break24_g191 = uvsmatrixeffect38_g190;
			float mulTime20_g191 = _Time.y * _DropSpeed;
			float temp_output_3_0_g191 = floor( ( break24_g191.x / widthmatrixeffect41_g190 ) );
			float DropSpeed8_g191 = ( ( cos( ( temp_output_3_0_g191 * 3.0 ) ) * 0.15 ) + 0.4 );
			float DropOffset11_g191 = sin( ( temp_output_3_0_g191 * 15.0 ) );
			float smoothstepResult26_g190 = smoothstep( 0.0 , _DropHeadShrink , pow( ( 1.0 - frac( ( ( break24_g191.y / _DropLength ) + ( mulTime20_g191 * DropSpeed8_g191 ) + DropOffset11_g191 ) ) ) , _DropExponent ));
			float2 appendResult15_g189 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 appendResult11_g189 = (float2(ase_worldPos.y , ase_worldPos.y));
			float2 BackUvs34_g189 = ( ( appendResult15_g189 + sin( appendResult11_g189 ) ) * _UVTilling );
			float2 uvsmatrixeffect38_g192 = BackUvs34_g189;
			float widthmatrixeffect41_g192 = _Width;
			float2 temp_output_4_0_g192 = ( uvsmatrixeffect38_g192 / widthmatrixeffect41_g192 );
			float mulTime6_g192 = _Time.y * _TimeScale;
			float2 break24_g193 = uvsmatrixeffect38_g192;
			float mulTime20_g193 = _Time.y * _DropSpeed;
			float temp_output_3_0_g193 = floor( ( break24_g193.x / widthmatrixeffect41_g192 ) );
			float DropSpeed8_g193 = ( ( cos( ( temp_output_3_0_g193 * 3.0 ) ) * 0.15 ) + 0.4 );
			float DropOffset11_g193 = sin( ( temp_output_3_0_g193 * 15.0 ) );
			float smoothstepResult26_g192 = smoothstep( 0.0 , _DropHeadShrink , pow( ( 1.0 - frac( ( ( break24_g193.y / _DropLength ) + ( mulTime20_g193 * DropSpeed8_g193 ) + DropOffset11_g193 ) ) ) , _DropExponent ));
			#ifdef _USETRIPLANAR_ON
				float staticSwitch67_g189 = saturate( ( ( saturate( ( ( tex2D( _Mask, temp_output_4_0_g194 ).r * tex2D( _Font, ( ( ( frac( temp_output_4_0_g194 ) * 0.0614 ) + 0.0 ) + ( floor( ( tex2D( _Noise, ( ( floor( temp_output_4_0_g194 ) / float2( 512,512 ) ) + mulTime6_g194 ) ).r * 32.0 ) ) * 0.0625 ) ) ).r * saturate( smoothstepResult26_g194 ) ) + -0.03 ) ) * break50_g189.z ) + ( saturate( ( ( tex2D( _Mask, temp_output_4_0_g190 ).r * tex2D( _Font, ( ( ( frac( temp_output_4_0_g190 ) * 0.0614 ) + 0.0 ) + ( floor( ( tex2D( _Noise, ( ( floor( temp_output_4_0_g190 ) / float2( 512,512 ) ) + mulTime6_g190 ) ).r * 32.0 ) ) * 0.0625 ) ) ).r * saturate( smoothstepResult26_g190 ) ) + -0.03 ) ) * break50_g189.x ) + ( saturate( ( ( tex2D( _Mask, temp_output_4_0_g192 ).r * tex2D( _Font, ( ( ( frac( temp_output_4_0_g192 ) * 0.0614 ) + 0.0 ) + ( floor( ( tex2D( _Noise, ( ( floor( temp_output_4_0_g192 ) / float2( 512,512 ) ) + mulTime6_g192 ) ).r * 32.0 ) ) * 0.0625 ) ) ).r * saturate( smoothstepResult26_g192 ) ) + -0.03 ) ) * break50_g189.y ) ) );
			#else
				float staticSwitch67_g189 = saturate( ( ( tex2D( _Mask, temp_output_4_0_g196 ).r * tex2D( _Font, ( ( ( frac( temp_output_4_0_g196 ) * 0.0614 ) + 0.0 ) + ( floor( ( tex2D( _Noise, ( ( floor( temp_output_4_0_g196 ) / float2( 512,512 ) ) + mulTime6_g196 ) ).r * 32.0 ) ) * 0.0625 ) ) ).r * saturate( smoothstepResult26_g196 ) ) + -0.03 ) );
			#endif
			float4 MatrixOut50 = ( ( staticSwitch67_g189 * _MatrixColor ) * _MatrixColor );
			o.Emission = ( EmissionColor32 + MatrixOut50 ).rgb;
			float4 tex2DNode417 = tex2D( _MetallicTexture, uv_TexCoord441 );
			float MetallicValue13 = ( tex2DNode417.r * _MetallicValue );
			o.Metallic = MetallicValue13;
			#if defined(_GLOSSSOURCE_ALBEDOALPHA)
				float staticSwitch31 = tex2DNode19.a;
			#elif defined(_GLOSSSOURCE_METALLICALPHA)
				float staticSwitch31 = tex2DNode417.a;
			#else
				float staticSwitch31 = tex2DNode417.a;
			#endif
			float SmoothnessValue17 = ( _Glossiness * staticSwitch31 );
			o.Smoothness = SmoothnessValue17;
			float2 uv_OcclusionMap28 = i.uv_texcoord;
			float OcclusionMap26 = tex2D( _OcclusionMap, uv_OcclusionMap28 ).r;
			o.Occlusion = OcclusionMap26;
			float Alpha33 = AlbedoColor25.a;
			o.Alpha = Alpha33;
			float AlphaClipThreshold24 = _Cutoff1;
			clip( AlphaClipThreshold24 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "MarkupAttributes.Editor.MarkedUpShaderGUI"
}
/*ASEBEGIN
Version=19002
1920;0;1920;1019;3220.744;335.5915;2.027268;True;True
Node;AmplifyShaderEditor.RangedFloatNode;444;-1813.842,653.0863;Inherit;False;Property;_Tiling;Tiling;21;0;Create;True;0;0;0;False;0;False;1;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;441;-1485.619,633.4839;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;9;-952.8609,-505.6901;Inherit;False;1242.73;2053.751;;29;13;17;33;18;24;32;26;28;23;27;34;22;35;31;25;29;15;10;16;21;30;20;19;49;417;418;419;432;438;Standard Inputs;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;22;-807.9371,1288.142;Inherit;True;Property;_BumpMap;Normal Texture;29;3;[NoScaleOffset];[Normal];[SingleLineTexture];Create;False;0;0;0;True;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;429;-755.9761,1577.104;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;430;-506.2784,1597.005;Inherit;True;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-474.5272,1314.183;Inherit;False;TangentNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;431;-314.5775,1518.604;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;432;-139.3778,1494.104;Inherit;True;1;0;FLOAT;1.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;434;29.62465,1536.403;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;433;-109.991,1934.655;Float;False;Property;_RimPower;RimPower;19;0;Create;True;0;0;0;False;0;False;0;2.36;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-906.8608,-66.62833;Inherit;True;Property;_MainTex;Albedo;20;1;[SingleLineTexture];Create;False;1;PBR Settings;0;0;True;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;20;-872.2498,166.795;Inherit;False;Property;_Color;Color;22;0;Create;True;0;0;0;True;0;False;1,1,1,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;436;240.0482,1804.492;Float;False;Property;_RimColor;RimColor;18;1;[HDR];Create;True;0;0;0;False;0;False;0.5073529,0.3794856,0.2424849,0;0.485294,0.3002326,0.1998269,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;435;287.4222,1547.804;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-788.1799,1069.461;Inherit;False;Property;_EmissionColor;Emission Color;33;1;[HDR];Create;True;0;0;0;True;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;437;445.4247,1604.386;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-585.2881,146.9946;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;408;-1005.206,-1249.375;Inherit;False;807.866;425.3186;;5;291;305;50;427;449;Matrix Effect Implementation;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;30;-833.6708,878.0277;Inherit;True;Property;_EmissionMap;Emission Texture;32;2;[NoScaleOffset];[SingleLineTexture];Create;False;0;0;0;True;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-445.6333,882.5367;Inherit;False;Property;_UseEmission;UseEmission;31;1;[Toggle];Create;True;0;0;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;291;-973.5483,-1004.856;Inherit;False;Property;_MatrixColor;Matrix Color;2;1;[HDR];Create;True;0;0;0;False;0;False;0.9098039,2.980392,0.5176471,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;427;-985.3057,-1216.375;Inherit;False;MatrixEffectTriplanar;3;;189;a7f3f0914b1d1304e9f79bd817894b2d;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-522.0073,1012.446;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;438;-460.8867,267.9162;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;417;-858.1816,417.8832;Inherit;True;Property;_MetallicTexture;Metallic Texture;25;2;[NoScaleOffset];[SingleLineTexture];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;31;-480.8442,-14.54784;Inherit;False;Property;_GlossSource;Source;28;0;Create;False;0;0;0;True;0;False;1;1;1;True;;KeywordEnum;2;AlbedoAlpha;MetallicAlpha;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;305;-544.8671,-963.0187;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-459.1212,-136.7804;Inherit;False;Property;_Glossiness;Smoothness Value;27;0;Create;False;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;418;-636.4467,670.7469;Inherit;False;Property;_MetallicValue;Metallic Value;26;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-401.2237,136.636;Inherit;False;AlbedoColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Compare;34;-288.0961,959.4507;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;1;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;28;-826.4652,-455.6901;Inherit;True;Property;_OcclusionMap;Occlusion Map;30;2;[NoScaleOffset];[SingleLineTexture];Create;False;0;0;0;True;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-100.4252,988.4237;Inherit;False;EmissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-859.6588,-217.3625;Inherit;False;Property;_Cutoff1;Alpha Clip Threshold;24;0;Create;False;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-408.3872,-960.6335;Inherit;False;MatrixOut;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-164.542,-85.44913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;419;-339.1772,555.9651;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;23;-210.9217,141.3513;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-267.3202,434.8426;Inherit;False;MetallicValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;-29.42905,-36.28482;Inherit;False;SmoothnessValue;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;49;-231.1218,1227.685;Inherit;False;433.4464;170.6884;Editor;2;36;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;634.4279,-357.8918;Inherit;False;32;EmissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-526.7263,-419.5543;Inherit;False;OcclusionMap;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-68.07697,167.612;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;410;103.5973,-1170.175;Inherit;False;433.4464;170.6884;;2;412;411;Matrix Custom Editor;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;678.7649,-268.3811;Inherit;False;50;MatrixOut;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-561.4582,-225.3225;Inherit;False;AlphaClipThreshold;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;646.2156,100.644;Inherit;False;33;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;447;-1206.972,-1126.474;Inherit;False;Property;_MatrixDirection;Matrix Direction;23;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;46;710.2618,-439.0717;Inherit;False;18;TangentNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;414;910.5026,-289.0749;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;411;144.5974,-1101.488;Inherit;False;Property;_MatrixEditorStart;Matrix Editor Start;1;1;[HideInInspector];Create;True;0;0;0;True;3;Foldout(MatrixEffect,true,8);;Space;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;26.32461,1277.685;Inherit;False;Property;_EditorEnd;Editor End;34;1;[HideInInspector];Create;True;0;0;0;True;2;Space;EndGroup();False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;633.8675,-85.6996;Inherit;False;17;SmoothnessValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;899.592,-487.1311;Inherit;False;25;AlbedoColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;631.6222,8.594658;Inherit;False;26;OcclusionMap;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;682.1376,-169.8911;Inherit;False;13;MetallicValue;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-181.1218,1282.373;Inherit;False;Property;_EditorStart;Editor Start;17;1;[HideInInspector];Create;True;0;0;0;True;3;Foldout(Main,true,8);;Space;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;412;345.427,-1102.559;Inherit;False;Property;_MatrixEditorEnd;Matrix Editor End;16;1;[HideInInspector];Create;True;0;0;0;False;2;Space;EndGroup();False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;660.8085,162.3841;Inherit;False;24;AlphaClipThreshold;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;449;-997.9724,-1144.474;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;1036.884,190.9164;Inherit;False;Property;_AdvancedInpector;AdvancedInpector;35;1;[HideInInspector];Create;True;0;0;0;True;2;;DrawSystemProperties;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;428;1173.896,-314.0344;Float;False;True;-1;2;MarkupAttributes.Editor.MarkedUpShaderGUI;0;0;Standard;Matrix Metallic LIT;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;Opaque;;AlphaTest;ForwardOnly;18;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;True;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;441;0;444;0
WireConnection;22;1;441;0
WireConnection;430;0;429;0
WireConnection;18;0;22;0
WireConnection;431;0;18;0
WireConnection;431;1;430;0
WireConnection;432;0;431;0
WireConnection;434;0;432;0
WireConnection;19;1;441;0
WireConnection;435;0;434;0
WireConnection;435;1;433;0
WireConnection;437;0;435;0
WireConnection;437;1;436;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;30;1;441;0
WireConnection;10;0;30;0
WireConnection;10;1;16;0
WireConnection;438;0;21;0
WireConnection;438;1;437;0
WireConnection;417;1;441;0
WireConnection;31;1;19;4
WireConnection;31;0;417;4
WireConnection;305;0;427;0
WireConnection;305;1;291;0
WireConnection;25;0;438;0
WireConnection;34;0;29;0
WireConnection;34;2;10;0
WireConnection;32;0;34;0
WireConnection;50;0;305;0
WireConnection;27;0;15;0
WireConnection;27;1;31;0
WireConnection;419;0;417;1
WireConnection;419;1;418;0
WireConnection;23;0;25;0
WireConnection;13;0;419;0
WireConnection;17;0;27;0
WireConnection;26;0;28;1
WireConnection;33;0;23;3
WireConnection;24;0;35;0
WireConnection;414;0;42;0
WireConnection;414;1;51;0
WireConnection;449;0;447;0
WireConnection;428;0;39;0
WireConnection;428;1;46;0
WireConnection;428;2;414;0
WireConnection;428;3;45;0
WireConnection;428;4;44;0
WireConnection;428;5;41;0
WireConnection;428;9;40;0
WireConnection;428;10;43;0
ASEEND*/
//CHKSM=BC52674C7C96D9660AE2FD76A8D666C697264A6A