float4x4 MtxWorld : World;
float4x4 MtxWorldViewProjection : WorldViewProjection;
float4x4 MtxWorldInverseTranspose : WorldInverseTranspose;

float gTime : Time < string UIWidget = "None"; >;

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

Texture2D gLayerTex <
	string UIName = "Layer Texture";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 10;
>;

float2 gTile <
	string UIName = "Tiling";
	int UIOrder = 11;
> = {1.0f, 1.0f};

float gAlphaScale <
	string UIName = "Alpha Scale";
	float UIMin = 0.0f;
	float UIMax = 5.0f;
	float UIStep = 0.001;
	int UIOrder = 21;
> = 1.0f;

float gAlphaOffset <
	string UIName = "Alpha Offset";
	float UIMin = -5.0f;
	float UIMax = 5.0f;
	float UIStep = 0.001;
	int UIOrder = 22;
> = 0.0f;

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

float4 ps0(vertex2pixel In): SV_Target {

    float3 N = normalize(In.wNormal);
    float3 L = normalize(In.wLightVec);
//	return float4(1.0f, 0.5f, 0.0f, 1.0f) * saturate(dot(N, L));
	return float4(float3(1.0f, 0.5f, 0.0f) * saturate(dot(N, L)), 1.0f) ;
}

float4 ps1(vertex2pixel In): SV_Target {

    float4 layerTex = gLayerTex.Sample(SamplerAnisoWrap, In.texCoord * gTile);
    float3 layerTexColor = layerTex.rgb;
    float layerAlpha = layerTex.a * gAlphaScale + gAlphaOffset;

    clip(layerAlpha);

	return color4(layerTexColor.rgb);
}

float4 ps2(vertex2pixel In): SV_Target {

    float4 layerTex = gLayerTex.Sample(SamplerAnisoWrap, In.texCoord * gTile);
    float3 layerTexColor = layerTex.rgb;
    float layerAlpha = layerTex.a * gAlphaScale + gAlphaOffset;

	return float4(layerTexColor.rgb, layerAlpha);
}

////////////////
// TECH
////////////////

RasterizerState rasterState {
    CullMode = Front;
};

BlendState blendState {
    BlendEnable[0] = TRUE;
    RenderTargetWriteMask[0] = 0x0F;
    AlphaToCoverageEnable = FALSE;
    SrcBlend = SRC_ALPHA;
    DestBlend = INV_SRC_ALPHA;
    BlendOp = ADD;
    SrcBlendAlpha = ZERO;
    DestBlendAlpha = ZERO;
    BlendOpAlpha = ADD;
};

technique11 alphaTest {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps0()));
    }

    pass P1 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps1()));
    }

};

technique11 blending {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps0()));
    }

    pass P1 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps2()));
        SetRasterizerState(rasterState);
        SetBlendState(blendState, float4( 0.0f, 0.0f, 0.0f, 0.0f ), 0xFFFFFFFF);
    }

};