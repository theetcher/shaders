float4x4 MtxWorld : World;
float4x4 MtxWorldViewProjection : WorldViewProjection;
float4x4 MtxWorldInverseTranspose : WorldInverseTranspose;

// UI

// without this variable shader will be black without viewport's "Use All Lights" option
int light0Type : LIGHTTYPE
<
	string Object = "Light 0";
	string UIName = "Light 0 Type";
	string UIWidget = "None";
	int UIOrder = 0;
> = 2; // follows LightParameterInfo::ELightType -> spot = 2, point = 3, directional = 4, ambient = 5

float3 light0Pos : POSITION 
< 
	string Object = "Light 0";
	string UIName = "Light 0 Position"; 
	string Space = "World"; 
	int UIOrder = 1;
> = {100.0f, 100.0f, 100.0f}; 

float3 light0Color : LIGHTCOLOR 
<
	string Object = "Light 0";
	string UIName = "Light 0 Color"; 
	string UIWidget = "Color"; 
	int UIOrder = 2;
> = { 1.0f, 1.0f, 1.0f};

Texture2D diffuseTex <
	string ResourceName = "";
	string UIName = "Diffuse Map";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 0;
>;

Texture2D normalTex <
	string ResourceName = "";
	string UIName = "Normal Map";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 0;
>;

float2 tile <
	string UIName = "Tiling";
	int UIOrder = 1;
> = {1.0f, 1.0f};

// Sampler
SamplerState SamplerAnisoWrap
{
	Filter = ANISOTROPIC;
	AddressU = Wrap;
	AddressV = Wrap;
};

// Structs
struct app2vs {
    float4 oPos : POSITION;
	float2 texCoord : TEXCOORD0;
	float3 oNormal : NORMAL;
	float3 oBinormal : BINORMAL;
	float3 oTangent : TANGENT;
};

struct vs2ps {
    float4 pos : SV_Position;
	float2 texCoord : TEXCOORD0;
	float3 wNormal : TEXCOORD1;
	float3 wBinormal : TEXCOORD2;
	float3 wTangent : TEXCOORD3;
	float3 lightVec : TEXCOORD4;
};

// VERTEX SHADER
vs2ps vs(app2vs In) {
	vs2ps Out;
	Out.pos = mul(In.oPos, MtxWorldViewProjection);
	Out.wNormal = mul(In.oNormal, MtxWorldInverseTranspose);
	Out.wBinormal = mul(In.oBinormal, MtxWorldInverseTranspose);
	Out.wTangent = mul(In.oTangent, MtxWorldInverseTranspose);
	Out.texCoord = In.texCoord;

	float3 vtxPositionWorldSpace = mul(In.oPos, MtxWorld);
	Out.lightVec = normalize(light0Pos - vtxPositionWorldSpace);

	return  Out;
};

// PIXEL SHADER
float4 ps(vs2ps In): SV_Target {
	float4 diffuse = diffuseTex.Sample(SamplerAnisoWrap, In.texCoord * tile);
	float3 tsNormal = normalTex.Sample(SamplerAnisoWrap, In.texCoord * tile) * 2 - 1;
	float3 wNormal = normalize((tsNormal.x * In.wTangent) + (tsNormal.y * In.wBinormal) + (tsNormal.z * In.wNormal));
	return saturate(dot(wNormal, In.lightVec)) * diffuse;
}

// TECH
technique11 main {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        //SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, ps()));
    }

}