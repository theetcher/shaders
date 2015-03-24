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

float3 gWaveOrigin <
	string UIName = "Wave Origin";
	int UIOrder = 10;
> = {0.0f, 0.0f, 0.0f};

float gDisplacement <
	string UIName = "Displacement";
	float UIMin = 0.0f;
	float UIMax = 0.1f;
	float UIStep = 0.001;
	int UIOrder = 11;
> = 1.0f;

float gFrequency <
	string UIName = "Frequency";
	float UIMin = 0.0f;
	float UIMax = 100.0f;
	int UIOrder = 12;
> = 1.0f;

float gTimeScale <
	string UIName = "Time Scale";
	float UIMin = 0.0f;
	float UIMax = 100.0f;
	int UIOrder = 13;
> = 0.0f;


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
};

struct vertex2pixel {
    float4 pPos : SV_Position;
	float3 wNormal : TEXCOORD0;
	float3 wLightVec : TEXCOORD1;
};

//////////////////
// VERTEX SHADER
//////////////////

vertex2pixel vs(app2vertex In) {
	vertex2pixel Out;

	Out.wNormal = mul(In.oNormal, MtxWorldInverseTranspose);

	float3 vtxPositionWorldSpace = mul(In.oPos, MtxWorld);
	Out.wLightVec = normalize(gLight0Pos - vtxPositionWorldSpace);

    float phase = length(gWaveOrigin - vtxPositionWorldSpace);
    float3 oPos = In.oPos.xyz + In.oNormal * gDisplacement * sin(phase * gFrequency + gTime * gTimeScale);
	Out.pPos = mul(pos4(oPos), MtxWorldViewProjection);

	return Out;
};


//////////////////
// PIXEL SHADER
//////////////////

float4 ps(vertex2pixel In): SV_Target {
    float3 N = normalize(In.wNormal);
    float3 L = normalize(In.wLightVec);

	return dot(N, L) * color4(1.0f);

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