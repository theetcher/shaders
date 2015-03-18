float4x4 MtxWorld : World;
float4x4 MtxWorldViewProjection : WorldViewProjection;
float4x4 MtxWorldInverseTranspose : WorldInverseTranspose;
float4x4 MtxViewInverse : ViewInverse;

////////////////
// UI
////////////////

// spot = 2, point = 3, directional = 4, ambient = 5
Texture2D gNormalTex <
	string ResourceName = "";
	string UIName = "Normal Map";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 10;
>;

float2 gNormalTile <
	string UIName = "Normal Map Tiling";
	int UIOrder = 11;
> = {1.0f, 1.0f};

float gNormalScale <
	string UIName = "Normal Map Scale";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
	int UIOrder = 12;
> = 1.0f;

TextureCube ReflectionCubemap : environment
<
	string ResourceName = "";
	string UIWidget = "FilePicker";
	string UIName = "Reflection CubeMap";
	string ResourceType = "Cube";
	int mipmaplevels = 0; // Use max number of mip maps
	int UIOrder = 20;
>;

float gReflectionScale <
	string UIName = "Reflection Scale";
	float UIMin = 0.0f;
	float UIMax = 6.0f;
	int UIOrder = 23;
> = 1.0f;

float gReflectionBlur <
	string UIName = "Reflection Blur";
	float UIMin = 0.0f;
	float UIMax = 16.0f;
	int UIOrder = 24;
> = 0.0f;

////////////////
// Samplers
////////////////

SamplerState SamplerAnisoWrap
{
	Filter = ANISOTROPIC;
	AddressU = Wrap;
	AddressV = Wrap;
};

SamplerState CubeMapSampler
{
	Filter = ANISOTROPIC;
	AddressU = Clamp;
	AddressV = Clamp;
	AddressW = Clamp;
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

	// calculate normal
	float3 tsNormal = gNormalTex.Sample(SamplerAnisoWrap, In.texCoord * gNormalTile) * 2 - 1;
	float4 N = vec4(normalize((tsNormal.r * wTangent) + (tsNormal.g * wBinormal) + (tsNormal.b * wNormal)));
	N = normalize(lerp(wNormal, N, gNormalScale));

    // vectors
    float4 V = vec4(normalize(MtxViewInverse[3] - In.wPos));
    float4 R = vec4(normalize(reflect(-V, N)));

    // sample cubemap
    float4 reflectedColor = color4(ReflectionCubemap.SampleLevel(CubeMapSampler, R, gReflectionBlur));

    // final composition
	return reflectedColor * gReflectionScale;

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