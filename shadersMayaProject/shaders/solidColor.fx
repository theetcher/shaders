float4x4 MtxWorldViewProjection : WorldViewProjection /*<string UIWidget="None";>*/;

struct app2vs {
    float4 pos : POSITION;
};

struct vs2ps {
    float4 pos : POSITION;
};

// VERTEX SHADER
vs2ps vs(app2vs In) {
	vs2ps Out;
	Out.pos = mul(In.pos, MtxWorldViewProjection);
	return  Out;
};

// PIXEL SHADER
float4 ps(vs2ps In): COLOR {
	return float4(1.0, 1.0, 0.0, 1.0);
}

// TECH
technique11 main {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        //SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, ps()));
    }

}