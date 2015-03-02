float4x4 MtxWorld : World;
float4x4 MtxWorldViewProjection : WorldViewProjection;
float4x4 MtxWorldInverseTranspose : WorldInverseTranspose;
float4x4 MtxViewInverse : ViewInverse;

// without this variable shader will be black without viewport's "Use All Lights" option
int gLight0Type : LIGHTTYPE
<
	string Object = "Light 0";
	string UIName = "Light 0 Type";
	string UIWidget = "None";
	int UIOrder = 0;
> = 2; // follows LightParameterInfo::ELightType -> spot = 2, point = 3, directional = 4, ambient = 5

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

Texture2D gDiffuseTex <
	string UIGroup = "Maps";
	string ResourceName = "";
	string UIName = "Diffuse Map";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 3;
>;

float2 gTileDiffuse <
	string UIGroup = "Maps";
	string UIName = "Diffuse Map Tiling";
	int UIOrder = 4;
> = {1.0f, 1.0f};

Texture2D gNormalTex <
	string UIGroup = "Maps";
	string ResourceName = "";
	string UIName = "Normal Map";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 5;
>;

float2 gTileNormal <
	string UIGroup = "Maps";
	string UIName = "Normal Map Tiling";
	int UIOrder = 6;
> = {1.0f, 1.0f};

float gNormalScale <
	string UIGroup = "Maps";
	string UIName = "Normal Map Scale";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
	int UIOrder = 7;
> = 1.0f;

float3 gAmbientColor <
	string UIGroup = "Params";
	string UIName = "Ambient Color";
	string UIWidget = "ColorPicker";
	int UIOrder = 8;
> = {0.0f, 0.0f, 0.0f};

float3 gDiffuseColor <
	string UIGroup = "Params";
	string UIName = "Diffuse Color";
	string UIWidget = "ColorPicker";
	int UIOrder = 9;
> = {1.0f, 1.0f, 1.0f};

int gSpecularModel <
	string UIGroup = "Params";
	string UIName = "Specular Model";
	string UIFieldNames ="Phong:Blinn";
	float UIMin = 0;
	float UIMax = 1;
	float UIStep = 1;
	int UIOrder = 10;
> = 0;

float3 gSpecularColor <
	string UIGroup = "Params";
	string UIName = "Specular Color";
	string UIWidget = "ColorPicker";
	int UIOrder = 11;
> = {1.0f, 1.0f, 1.0f};

float gSpecularPower <
	string UIGroup = "Params";
	string UIName = "Specular Power";
	string UIWidget = "slider";
	float UIMin = 1.0;
	float UIMax = 512.0;
	float UISoftMax = 64.0;
	float UIStep = 0.01;
	int UIOrder = 12;
> = 64.0f;


// Sampler
SamplerState SamplerAnisoWrap
{
	Filter = ANISOTROPIC;
	AddressU = Wrap;
	AddressV = Wrap;
};


// Structs
struct vertex_in {
    float4 oPos : POSITION;
	float2 texCoord : TEXCOORD0;
	float3 oNormal : NORMAL;
	float3 oBinormal : BINORMAL;
	float3 oTangent : TANGENT;
};

struct vertex_to_pixel {
    float4 wPos : SV_Position;
	float2 texCoord : TEXCOORD0;
	float3 wNormal : TEXCOORD1;
	float3 wBinormal : TEXCOORD2;
	float3 wTangent : TEXCOORD3;
	float3 wLightVec : TEXCOORD4;
	float3 wEyeVec : TEXCOORD5;
};


// VERTEX SHADER
vertex_to_pixel vs(vertex_in In) {
	vertex_to_pixel Out;
	Out.wPos = mul(In.oPos, MtxWorldViewProjection);
	Out.wNormal = mul(In.oNormal, MtxWorldInverseTranspose);
	Out.wBinormal = mul(In.oBinormal, MtxWorldInverseTranspose);
	Out.wTangent = mul(In.oTangent, MtxWorldInverseTranspose);
	Out.texCoord = In.texCoord;

	float3 vtxPositionWorldSpace = mul(In.oPos, MtxWorld);
	Out.wLightVec = normalize(gLight0Pos - vtxPositionWorldSpace);
	Out.wEyeVec = MtxViewInverse[3] - vtxPositionWorldSpace;

	return  Out;
};

// PIXEL SHADER

float specularPhong(float3 lightVec, float3 eyeVec, float3 normalVec){
	float3 lightReflectVec = normalize(dot(lightVec, normalVec) * normalVec * 2 - lightVec);
	float RdotV = saturate(dot(eyeVec, lightReflectVec));
	return pow(RdotV, gSpecularPower); 
};

float specularBlinn(float3 lightVec, float3 eyeVec, float3 normalVec){
	float3 wHalfwayVec = normalize(lightVec + eyeVec);
	float NdotH = saturate(dot(normalVec, wHalfwayVec));
	return pow(NdotH, gSpecularPower); 
};

float4 ps(vertex_to_pixel In): SV_Target {

	// normalize vectors
	float3 wNormal = normalize(In.wNormal);
	float3 wBinormal = normalize(In.wBinormal);
	float3 wTangent = normalize(In.wTangent);
	float3 wLightVec = normalize(In.wLightVec);
	float3 wEyeVec = normalize(In.wEyeVec);

	// light color
	float4 lightColor = float4(gLight0Color, 1.0f);

	// ambient color
	float4 ambientColor = float4(gAmbientColor, 1.0f);

	// diffuse color
	float4 diffuseColor = float4(gDiffuseColor, 1.0f);

	// specular color
	float4 specularColor = float4(gSpecularColor, 1.0f);

	// diff tex color
	float4 diffTexColor = gDiffuseTex.Sample(SamplerAnisoWrap, In.texCoord * gTileDiffuse);

	// normals with normal map
	float3 tsNormal = gNormalTex.Sample(SamplerAnisoWrap, In.texCoord * gTileNormal) * 2 - 1;
	float3 wNormalWithNM = normalize((tsNormal.x * wTangent) + (tsNormal.y * wBinormal) + (tsNormal.z * wNormal));
	wNormalWithNM = normalize(lerp(wNormal, wNormalWithNM, gNormalScale));

	// diffuse value
	float diffuse = saturate(dot(wNormalWithNM, wLightVec));

	// specular value
	float specular;
	if (gSpecularModel == 0) { // phong
		specular = specularPhong(wLightVec, wEyeVec, wNormalWithNM);
	}
	else if (gSpecularModel == 1) { // blinn
		specular = specularBlinn(wLightVec, wEyeVec, wNormalWithNM);
	}

	// final composition
	return ambientColor + ((diffTexColor * diffuseColor * diffuse) + (specularColor * specular)) * lightColor;

};

// TECH
technique11 main {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        //SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, ps()));
    }

}