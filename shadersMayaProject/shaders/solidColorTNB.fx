// INPUTS
float3 attrColor : COLOR <
    string UIName =  "Color";
    string UIWidget = "Color";
> = {1.0, 0.0, 0.0};

float4x4 MtxWorldViewProjection : WorldViewProjection;


// INOUT STRUCTS
struct app2vs {
    float4 pos : POSITION;
    float4 norm : NORMAL;
	float4 tang : TANGENT;
	float4 binorm : BINORMAL;
};

struct vs2ps {
    float4 pos : SV_Position;
    float4 norm : NORMAL;
	float4 tang : TANGENT;
	float4 binorm : BINORMAL;
};


// VERTEX SHADER
vs2ps vs(app2vs In) {
	vs2ps Out;
	Out.pos = mul(In.pos, MtxWorldViewProjection);
    Out.norm = In.norm;
	Out.tang = In.tang;
	Out.binorm = In.binorm;
	return Out;
};


// PIXEL SHADERS
float4 ps_techColor(vs2ps In): COLOR {
	return float4(attrColor, 1.0);
}

float4 ps_techNorm(vs2ps In): COLOR {
	return In.norm;
}

float4 ps_techTang(vs2ps In): COLOR {
	return In.tang;
}

float4 ps_techBinorm(vs2ps In): COLOR {
	return In.binorm;
}

// TECHS
technique11 color {
    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps_techColor()));
    }
}

technique11 normals {
    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps_techNorm()));
    }
}

technique11 tangents {
    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps_techTang()));
    }
}

technique11 binormals {
    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        SetPixelShader(CompileShader(ps_5_0, ps_techBinorm()));
    }
}