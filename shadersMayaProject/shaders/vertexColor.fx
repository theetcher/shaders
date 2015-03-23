float4x4 MtxWorldViewProjection : WorldViewProjection;

////////////////
// Structs
////////////////

struct app2vertex {
    float4 oPos : POSITION;
	float4 vColor0 : COLOR0;
	float4 vColor1 : COLOR1;
};

struct vertex2pixel {
    float4 pPos : SV_Position;
	float4 vColor0 : COLOR0;
	float4 vColor1 : COLOR1;
};

////////////////
// VERTEX SHADER
////////////////

vertex2pixel vs(app2vertex In) {
	vertex2pixel Out;
	Out.pPos = mul(In.oPos, MtxWorldViewProjection);
    Out.vColor0 = In.vColor0;
    Out.vColor1 = In.vColor1;
	return  Out;
};


////////////////
// PIXEL SHADER
////////////////

float4 ps(vertex2pixel In): SV_Target {
	return In.vColor0 + In.vColor1;

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