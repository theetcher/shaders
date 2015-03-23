float4x4 MtxWorld : World;
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

int gBlendMethod <
   string UIName = "Detail Blend Method";
   string UIFieldNames ="None:Linear:Overlay:Partial Derivative:Whiteout:UDN:Reoriented Normal Mapping:Unity";
   float UIMin = 0;
   float UIMax = 6;
   float UIStep = 1;
   int UIOrder = 20;
> = 0;

Texture2D gDetailTex <
	string ResourceName = "";
	string UIName = "Detail Normal Map";
	string UIWidget = "FilePicker";
	string ResourceType = "2D";
	int UIOrder = 21;
>;

float gDetailDensity <
	string UIName = "Detail Density";
	float UIMin = 0.1f;
	float UIMax = 5.0f;
	int UIOrder = 22;
> = 1.0f;

float gDetailScale <
	string UIName = "Detail Scale";
	float UIMin = 0.0f;
	float UIMax = 1.0f;
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
	float3 wPos : TEXCOORD0;
	float2 texCoord : TEXCOORD1;
	float3 wNormal : TEXCOORD2;
	float3 wBinormal : TEXCOORD3;
	float3 wTangent : TEXCOORD4;
};

////////////////
// VERTEX SHADER
////////////////

vertex2pixel vs(app2vertex In) {
	vertex2pixel Out;
	Out.pPos = mul(In.oPos, MtxWorldViewProjection);
	Out.wPos = mul(In.oPos, MtxWorld);
	Out.texCoord = In.texCoord;
	Out.wNormal = mul(In.oNormal, MtxWorldInverseTranspose);
	Out.wBinormal = mul(In.oBinormal, MtxWorldInverseTranspose);
	Out.wTangent = mul(In.oTangent, MtxWorldInverseTranspose);

	return  Out;
};

////////////////
// PIXEL SHADER
////////////////

float3 normalRange(float3 cN) {
    return cN * 2 - 1;
};

float3 linearBlend(float3 cN1, float3 cN2) {
	return normalize(normalRange(cN1) + normalRange(cN2));
};

float3 overlayBlend(float3 cN1, float3 cN2) {
    float3 r  = cN1 < 0.5 ? 2 * cN1 * cN2 : 1 - 2*(1 - cN1)*(1 - cN2);
    return normalize(normalRange(r));
};

float3 partialDerivativeBlend(float3 cN1, float3 cN2) {
    cN1 = normalRange(cN1);
    cN2 = normalRange(cN2);
    float2 pd = cN1.xy/cN1.z + cN2.xy/cN2.z;
    return normalize(float3(pd, 1));
};

float3 whiteoutBlend(float3 cN1, float3 cN2) {
    cN1 = normalRange(cN1);
    cN2 = normalRange(cN2);
    return normalize(float3(cN1.xy + cN2.xy, cN1.z * cN2.z));
};

float3 udnBlend(float3 cN1, float3 cN2) {
    cN1 = normalRange(cN1);
    cN2 = normalRange(cN2);
    return normalize(float3(cN1.xy + cN2.xy, cN1.z));
};

float3 rnmBlend(float3 cN1, float3 cN2) {
    float3 t = cN1 * float3( 2,  2, 2) + float3(-1, -1,  0);
    float3 u = cN2 * float3(-2, -2, 2) + float3( 1,  1, -1);
    return normalize(t * dot(t, u) - u * t.z);
};

float3 unityBlend(float3 cN1, float3 cN2) {
    cN1 = normalRange(cN1);
    cN2 = normalRange(cN2);
    float3x3 nBasis = float3x3(
        float3(cN1.z, cN1.y, -cN1.x),
        float3(cN1.x, cN1.z, -cN1.y),
        float3(cN1.x, cN1.y,  cN1.z));
    return normalize(cN2.x*nBasis[0] + cN2.y*nBasis[1] + cN2.z*nBasis[2]);
};


float4 ps(vertex2pixel In): SV_Target {

    // normalize/prepare variables

	float3 wNormal = normalize(In.wNormal);
	float3 wBinormal = normalize(In.wBinormal);
	float3 wTangent = normalize(In.wTangent);

	float3 lightPos = gLight0Pos;
    float3 L = normalize(lightPos - In.wPos);

	// get normal colors
    float3 cN1 = gNormalTex.Sample(SamplerAnisoWrap, In.texCoord * gNormalTile);
	float3 cN2 = gDetailTex.Sample(SamplerAnisoWrap, In.texCoord * (gNormalTile * gDetailDensity));
	cN2 = lerp(float3(0.5f, 0.5f, 1.0f), cN2, gDetailScale);

	// blend detail map
	float3 tsN;
    if (gBlendMethod == 0) { // None
        tsN = normalRange(cN1);
    } else if (gBlendMethod == 1) { // Linear
        tsN = linearBlend(cN1, cN2);
    } else if (gBlendMethod == 2) { // Overlay
        tsN = overlayBlend(cN1, cN2);
    } else if (gBlendMethod == 3) { // Partial Derivative
        tsN = partialDerivativeBlend(cN1, cN2);
    } else if (gBlendMethod == 4) { // Whiteout
        tsN = whiteoutBlend(cN1, cN2);
    } else if (gBlendMethod == 5) { // UDN
        tsN = udnBlend(cN1, cN2);
    } else if (gBlendMethod == 6) { // RNM
        tsN = rnmBlend(cN1, cN2);
    } else if (gBlendMethod == 7) { // Unity
        tsN = unityBlend(cN1, cN2);
    };

	float3 N = normalize((tsN.r * wTangent) + (tsN.g * wBinormal) + (tsN.b * wNormal));
	N = normalize(lerp(wNormal, N, gNormalScale));

    // final composition
	return color4(saturate(dot(N, L))) * gLight0Intensity;

}

////////////////
// TECH
////////////////

technique11 main <int texture_mipmaplevels = 0;> {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps()));
    }

}