float4x4 MtxWorldViewProjection : WorldViewProjection /*<string UIWidget="None";>*/;

// UI
Texture2D diffuseTex <
	string ResourceName = "";
	string UIName = "Diffuse Texture";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 0;
>;

float2 diffuseTile <
	string UIName = "Diffuse Tiling";
	int UIOrder = 1;
> = {1.0f, 1.0f};

Texture2D detailTex <
	string ResourceName = "";
	string UIName = "Detail Texture";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 2;
>;

float2 detailTile <
	string UIName = "Detail Tiling";
	int UIOrder = 3;
> = {1.0f, 1.0f};

// Sampler
SamplerState SamplerAnisoWrap
{
	Filter = ANISOTROPIC;
	AddressU = Wrap;
	AddressV = Wrap;
};

// VS PS Structs
struct app2vs {
    float4 pos : POSITION;
	float2 texCoord : TEXCOORD0;
};

struct vs2ps {
    float4 pos : SV_Position; //SV_Position is now a semantic for VS output http://www.gamedev.net/topic/579610-hlsl-semantics-position-vs-sv_position/
	float2 texCoord : TEXCOORD0;
};

// VERTEX SHADER
vs2ps vs(app2vs In) {
	vs2ps Out;
	Out.pos = mul(In.pos, MtxWorldViewProjection);
	Out.texCoord = In.texCoord;
	return  Out;
};

// PIXEL SHADER
float4 ps(vs2ps In): SV_Target {
	float4 texColor = diffuseTex.Sample(SamplerAnisoWrap, In.texCoord * diffuseTile);
	float4 detColor = detailTex.Sample(SamplerAnisoWrap, In.texCoord * detailTile);
	texColor *= detColor;
	return texColor;
}

// TECH
technique11 main {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        //SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, ps()));
    }

}