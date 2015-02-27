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


// Structs
struct app2vs {
    float4 pos : POSITION;
	float2 texCoord : TEXCOORD0;
	float4 oNormal : NORMAL;
};

struct vs2ps {
    float4 pos : SV_Position;
	float4 wNormal : TEXCOORD0;
	float4 lightVec : TEXCOORD1;
};

// VERTEX SHADER
vs2ps vs(app2vs In) {
	vs2ps Out;
	Out.pos = mul(In.pos, MtxWorldViewProjection);
	Out.wNormal = mul(In.oNormal, MtxWorldInverseTranspose);

	float4 vtxPositionWorldSpace = mul(In.pos, MtxWorld);
	float4 lPos = float4(light0Pos, 1.0f);
	Out.lightVec = normalize(lPos - vtxPositionWorldSpace);

	return  Out;
};

// PIXEL SHADER
float4 ps(vs2ps In): SV_Target {
	return dot(normalize(In.wNormal), normalize(In.lightVec)) * float4(1.0f, 1.0f, 1.0f, 1.0f);
}

// TECH
technique11 main {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        //SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, ps()));
    }

}