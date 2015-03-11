float4x4 MtxWorld : World;
float4x4 MtxWorldViewProjection : WorldViewProjection;
float4x4 MtxWorldInverseTranspose : WorldInverseTranspose;

////////////////
// UI
////////////////

// spot = 2, point = 3, directional = 4, ambient = 5
int light0Type : LIGHTTYPE
<
	string Object = "Light 0";
	string UIName = "Light 0 Type";
	string UIWidget = "None";
	int UIOrder = 0;
> = 2;

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

Texture2D normalTex <
	string ResourceName = "";
	string UIName = "Normal Map";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 10;
>;

float2 normalTile <
	string UIName = "Normal Map Tiling";
	int UIOrder = 11;
> = {1.0f, 1.0f};

float gNormalScale <
	string UIName = "Normal Map Scale";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
	int UIOrder = 12;
> = 1.0f;

float3 gDiffuseColor <
	string UIName = "Diffuse Color";
	string UIWidget = "ColorPicker";
	int UIOrder = 21;
> = {1.0f, 1.0f, 1.0f};

float3 gSpecularColor <
	string UIName = "Specular Color";
	string UIWidget = "ColorPicker";
	int UIOrder = 22;
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

float4 color4(float3 f3) {
	return float4(f3, 1.0f);
}

float4 vec4(float3 f3) {
	return float4(f3, 0.0f);
}

float4 pos4(float3 f3) {
	return float4(f3, 1.0f);
}

float cookTorrance() {
	return 0.0f;
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
	Out.wNormal = vec4(mul(In.oNormal, MtxWorldInverseTranspose).xyz);
	Out.wBinormal = vec4(mul(In.oBinormal, MtxWorldInverseTranspose).xyz);
	Out.wTangent = vec4(mul(In.oTangent, MtxWorldInverseTranspose).xyz);

	return  Out;
};

////////////////
// PIXEL SHADER
////////////////

float4 ps(vertex2pixel In): SV_Target {
	float4 wNormal = normalize(In.wNormal);
	float4 wBinormal = normalize(In.wBinormal);
	float4 wTangent = normalize(In.wTangent);

	float4 mDiffColor = color4(gDiffuseColor);
	float4 mSpecColor = color4(gSpecularColor);
	float4 lightPos = pos4(light0Pos);

	float3 tsNormal = normalTex.Sample(SamplerAnisoWrap, In.texCoord * normalTile) * 2 - 1;
	float4 wNormalNM = vec4(normalize((tsNormal.r * wTangent) + (tsNormal.g * wBinormal) + (tsNormal.b * wNormal)));
	wNormalNM = lerp(wNormal, wNormalNM, gNormalScale);

	float4 lightVec = normalize(lightPos - In.wPos);
	float diffuseValue = saturate(dot(wNormalNM, lightVec));
	float specularValue = cookTorrance();

	return mDiffColor * diffuseValue + mSpecColor * specularValue;

}

////////////////
// TECH
////////////////

technique11 main {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        //SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, ps()));
    }

}