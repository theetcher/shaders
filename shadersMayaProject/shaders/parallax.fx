#define PI 3.1415926

float4x4 MtxWorld : World;
float4x4 MtxWorldInverse: WorldInverse;
float4x4 MtxWorldViewProjection : WorldViewProjection;
float4x4 MtxWorldInverseTranspose : WorldInverseTranspose;
float4x4 MtxViewInverse : ViewInverse;

////////////////
// UI
////////////////

// spot = 2, point = 3, directional = 4, ambient = 5
int gLight0Type : LIGHTTYPE
<
	string Object = "Light 0";
	string UIName = "Light 0 Type";
	string UIWidget = "None";
	int UIOrder = 0;
> = 2;

float3 gLight0Pos : POSITION
< 
	string Object = "Light 0";
	string UIName = "Light 0 Position"; 
	string Space = "World"; 
	int UIOrder = 1;
> = {100.0f, 100.0f, 100.0f}; 

float3 gLight0Color : LIGHTCOLOR
<
	string Object = "Light 0";
	string UIName = "Light 0 Color"; 
	string UIWidget = "Color"; 
	int UIOrder = 2;
> = { 1.0f, 1.0f, 1.0f};

float gLight0Intensity : LIGHTINTENSITY <
   string Object = "Light 0";
   string UIName = "Light 0 Intensity";
   string UIWidget = "slider";
   int UIOrder = 3;
> = 1.0f;

Texture2D gNormalTex <
	string ResourceName = "";
	string UIName = "Normal Map";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 10;
>;

Texture2D gHeightTex <
	string ResourceName = "";
	string UIName = "Height Map";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 11;
>;

float2 gTile <
	string UIName = "Normal Map Tiling";
	int UIOrder = 12;
> = {1.0f, 1.0f};

float gNormalScale <
	string UIName = "Normal Map Scale";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
	int UIOrder = 13;
> = 1.0f;

float3 gDiffuseColor <
	string UIName = "Diffuse Color";
	string UIWidget = "ColorPicker";
	int UIOrder = 21;
> = {1.0f, 1.0f, 1.0f};

float gHeightmapScale <
	string UIName = "Height Map Scale";
	float UIMin = 0.0f;
	float UIMax = 0.05f;
	int UIOrder = 23;
> = 1.0f;

////////////////
// Sampler
////////////////

SamplerState SamplerAnisoWrap
{
	Filter = ANISOTROPIC;
	AddressU = Wrap;
	AddressV = Wrap;
};

////////////////
// Functions
////////////////

float4 color4(float4 f4) {
	return float4(f4.rgb, 1.0f);
}

float4 color4(float3 f3) {
	return float4(f3, 1.0f);
}

float4 color4(float f) {
	return float4(f, f, f, 1.0f);
}

float4 vec4(float3 f) {
	return float4(f, 0.0f);
}

float4 vec4(float4 f) {
	return float4(f.xyz, 0.0f);
}

float4 pos4(float3 f) {
	return float4(f, 1.0f);
}

float4 pos4(float4 f) {
	return float4(f.xyz, 1.0f);
}

////////////////
// Structs
////////////////

struct app2vertex {
    float4 oPos : POSITION;
	float2 texCoord : TEXCOORD0;
	float3 oNormal : NORMAL;
	float3 oBinormal : BINORMAL;
	float3 oTangent : TANGENT;
};

struct vertex2pixel {
    float4 pPos : SV_Position;
	float4 wPos : TEXCOORD0;
	float2 texCoord : TEXCOORD1;
	float4 wNormal : TEXCOORD2;
	float4 wBinormal : TEXCOORD3;
	float4 wTangent : TEXCOORD4;
	float4 tEyeVec : TEXCOORD5;
};

////////////////
// VERTEX SHADER
////////////////

vertex2pixel vs(app2vertex In) {
	vertex2pixel Out;
	Out.pPos = mul(In.oPos, MtxWorldViewProjection);
	Out.wPos = pos4(mul(In.oPos, MtxWorld).xyz);
	Out.texCoord = In.texCoord;
	Out.wNormal = vec4(mul(In.oNormal, MtxWorldInverseTranspose));
	Out.wBinormal = vec4(mul(In.oBinormal, MtxWorldInverseTranspose));
	Out.wTangent = vec4(mul(In.oTangent, MtxWorldInverseTranspose));

    // calculate eye vector in tangent space
	float3x3 MtxObjToTangent;
	MtxObjToTangent[0] = In.oTangent.xyz;
	MtxObjToTangent[1] = In.oBinormal.xyz;
	MtxObjToTangent[2] = In.oNormal.xyz;
	float4 oEyePos = mul(MtxViewInverse[3], MtxWorldInverse);
    float3 objEyeVec = oEyePos.xyz - In.oPos.xyz;
	Out.tEyeVec = vec4(mul(MtxObjToTangent, objEyeVec));

	return  Out;
};

////////////////
// PIXEL SHADER
////////////////

float4 ps(vertex2pixel In): SV_Target {

    // normalize/prepare variables

	float4 wNormal = normalize(In.wNormal);
	float4 wBinormal = normalize(In.wBinormal);
	float4 wTangent = normalize(In.wTangent);

	float4 tEyeVec = normalize(In.tEyeVec);

	float4 mDiffColor = color4(gDiffuseColor);
	float4 lightPos = pos4(gLight0Pos);
	float4 lightColor = color4(gLight0Color);

	// height map and new coords
  	float height = gHeightTex.Sample(SamplerAnisoWrap, In.texCoord * gTile).r * 2 - 1;
    float2 texCoordHeight = (height * tEyeVec * gHeightmapScale) + In.texCoord;

	// calculate normal
	float3 tsNormal = gNormalTex.Sample(SamplerAnisoWrap, texCoordHeight * gTile) * 2 - 1;
	float4 N = vec4(normalize((tsNormal.r * wTangent) + (tsNormal.g * wBinormal) + (tsNormal.b * wNormal)));
	N = normalize(lerp(wNormal, N, gNormalScale));

    // light vector
    float4 L = vec4(normalize(lightPos - In.wPos));

    // final composition
	return mDiffColor * saturate(dot(N, L)) * gLight0Intensity * lightColor;

}

////////////////
// TECH
////////////////

technique11 main {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps()));
    }

}