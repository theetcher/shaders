float4x4 MtxWorld : World;
float4x4 MtxWorldViewProjection : WorldViewProjection;
float4x4 MtxWorldInverseTranspose : WorldInverseTranspose;

////////////////
// UI
////////////////

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

Texture2D gDiffuseTex <
	string UIName = "Diffuse Texture";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 10;
>;

float2 gTile <
	string UIName = "Tiling";
	int UIOrder = 11;
> = {1.0f, 1.0f};

float gBurnout <
	string UIName = "Burnout";
	float UIMin = -1.1f;
	float UIMax = 1.1f;
	float UIStep = 0.001;
	int UIOrder = 21;
> = 0.0f;

float gBurnEdgeScale <
	string UIName = "Burn Edge Scale";
	float UIMin = 0.0f;
	float UIMax = 10.0f;
	float UIStep = 0.001;
	int UIOrder = 22;
> = 1.0f;

float3 gBurnoutFront <
	string UIName = "Burnout Front";
	string UIWidget = "ColorPicker";
	int UIOrder = 23;
> = {1.0f, 1.0f, 1.0f};

float3 gBurnoutBack <
	string UIName = "Burnout Back";
	string UIWidget = "ColorPicker";
	int UIOrder = 24;
> = {1.0f, 1.0f, 1.0f};

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
	float3 oNormal : NORMAL;
	float2 texCoord : TEXCOORD0;
};

struct vertex2pixel {
    float4 pPos : SV_Position;
	float2 texCoord : TEXCOORD0;
	float3 wNormal : TEXCOORD1;
	float3 wLightVec : TEXCOORD2;
};

//////////////////
// VERTEX SHADER
//////////////////

vertex2pixel vs(app2vertex In) {
	vertex2pixel Out;

	Out.wNormal = mul(In.oNormal, MtxWorldInverseTranspose);

	float3 vtxPositionWorldSpace = mul(In.oPos, MtxWorld);
	Out.wLightVec = normalize(gLight0Pos - vtxPositionWorldSpace);

	Out.pPos = mul(In.oPos, MtxWorldViewProjection);

	Out.texCoord = In.texCoord;

	return Out;
};


//////////////////
// PIXEL SHADER
//////////////////

float4 ps(vertex2pixel In): SV_Target {

    float4 diffuseTex = gDiffuseTex.Sample(SamplerAnisoWrap, In.texCoord * gTile);
    float3 diffuseTexColor = diffuseTex.rgb;
    float burnAlpha = diffuseTex.a;

    clip(burnAlpha - gBurnout);

    float3 N = normalize(In.wNormal);
    float3 L = normalize(In.wLightVec);

    float3 burnEdge = lerp(gBurnoutFront, gBurnoutBack, saturate((burnAlpha - gBurnout) * gBurnEdgeScale));

	return color4(diffuseTexColor.rgb * saturate(dot(N, L)) + burnEdge);

}

////////////////
// TECH
////////////////
RasterizerState rasterState {
    CullMode = NONE;
};

technique11 main {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps()));
        SetRasterizerState(rasterState);
    }

}