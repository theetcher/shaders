#define PI 3.1415926

float4x4 MtxWorld : World;
float4x4 MtxWorldViewProjection : WorldViewProjection;
float4x4 MtxWorldInverseTranspose : WorldInverseTranspose;
float4x4 MtxViewInverse : ViewInverse;


/////////////////////
// GLOBALS
/////////////////////


// Light 0

int gLight0Type : LIGHTTYPE <
   string Object = "Light 0";
   string UIName = "Light 0 Type";
   string UIWidget = "None";
   int UIOrder = 0;
> = 2; // follows LightParameterInfo::ELightType -> spot = 2, point = 3, directional = 4, ambient = 5

float3 gLight0Pos : POSITION < 
   string Object = "Light 0";
   string UIName = "Light 0 Position"; 
   string Space = "World"; 
   int UIOrder = 1;
> = {100.0f, 100.0f, 100.0f}; 

float3 gLight0Dir : DIRECTION < 
   string Object = "Light 0";
   string UIName = "Light 0 Direction"; 
   string Space = "World"; 
   int UIOrder = 2;
> = {100.0f, 100.0f, 100.0f}; 

float3 gLight0Color : LIGHTCOLOR <
   string Object = "Light 0";
   string UIName = "Light 0 Color"; 
   string UIWidget = "Color"; 
   int UIOrder = 3;
> = {1.0f, 1.0f, 1.0f};

float gLight0Intensity : LIGHTINTENSITY <
   string Object = "Light 0";
   string UIName = "Light 0 Intensity"; 
   string UIWidget = "slider"; 
   int UIOrder = 4;
> = 1.0f;

float gLight0Hotspot : HOTSPOT <
   string Object = "Light 0";
   string UIName = "Light 0 Cone Angle"; 
   float UIMin = 0;
   float UIMax = PI/2;
   int UIOrder = 5;
> = {0.46f};

float gLight0FallOff : FALLOFF <
   string Object = "Light 0";
   string UIName = "Light 0 Penumbra Angle"; 
   float UIMin = 0;
   float UIMax = PI/2;
   int UIOrder = 6;
> = {0.7f};

float gLight0DecayRate : DECAYRATE <
   string Object = "Light 0";
   string UIName = "Light 0 Decay";
   float UIMin = 0.0f;
   float UIMax = 10.0f;
   float UIStep = 0.01f;
   int UIOrder = 7;
> = {0.0f};

// Light 1

int gLight1Type : LIGHTTYPE <
   string Object = "Light 1";
   string UIName = "Light 1 Type";
   string UIWidget = "None";
   int UIOrder = 8;
> = 2; // follows LightParameterInfo::ELightType -> spot = 2, point = 3, directional = 4, ambient = 5

float3 gLight1Pos : POSITION < 
   string Object = "Light 1";
   string UIName = "Light 1 Position"; 
   string Space = "World"; 
   int UIOrder = 9;
> = {100.0f, 100.0f, 100.0f}; 

float3 gLight1Dir : DIRECTION < 
   string Object = "Light 1";
   string UIName = "Light 1 Direction"; 
   string Space = "World"; 
   int UIOrder = 10;
> = {100.0f, 100.0f, 100.0f}; 

float3 gLight1Color : LIGHTCOLOR <
   string Object = "Light 1";
   string UIName = "Light 1 Color"; 
   string UIWidget = "Color"; 
   int UIOrder = 11;
> = {1.0f, 1.0f, 1.0f};

float gLight1Intensity : LIGHTINTENSITY <
   string Object = "Light 1";
   string UIName = "Light 1 Intensity"; 
   string UIWidget = "slider"; 
   int UIOrder = 12;
> = 1.0f;

float gLight1Hotspot : HOTSPOT <
   string Object = "Light 1";
   string UIName = "Light 1 Cone Angle"; 
   float UIMin = 0;
   float UIMax = PI/2;
   int UIOrder = 13;
> = {0.46f};

float gLight1FallOff : FALLOFF <
   string Object = "Light 1";
   string UIName = "Light 1 Penumbra Angle"; 
   float UIMin = 0;
   float UIMax = PI/2;
   int UIOrder = 14;
> = {0.7f};

float gLight1DecayRate : DECAYRATE <
   string Object = "Light 1";
   string UIName = "Light 1 Decay";
   float UIMin = 0.0f;
   float UIMax = 10.0f;
   float UIStep = 0.01f;
   int UIOrder = 15;
> = {0.0f};

// light 2

int gLight2Type : LIGHTTYPE <
   string Object = "Light 2";
   string UIName = "Light 2 Type";
   string UIWidget = "None";
   int UIOrder = 16;
> = 2; // follows LightParameterInfo::ELightType -> spot = 2, point = 3, directional = 4, ambient = 5

float3 gLight2Pos : POSITION < 
   string Object = "Light 2";
   string UIName = "Light 2 Position"; 
   string Space = "World"; 
   int UIOrder = 17;
> = {100.0f, 100.0f, 100.0f}; 

float3 gLight2Dir : DIRECTION < 
   string Object = "Light 2";
   string UIName = "Light 2 Direction"; 
   string Space = "World"; 
   int UIOrder = 18;
> = {100.0f, 100.0f, 100.0f}; 

float3 gLight2Color : LIGHTCOLOR <
   string Object = "Light 2";
   string UIName = "Light 2 Color"; 
   string UIWidget = "Color"; 
   int UIOrder = 19;
> = {1.0f, 1.0f, 1.0f};

float gLight2Intensity : LIGHTINTENSITY <
   string Object = "Light 2";
   string UIName = "Light 2 Intensity"; 
   string UIWidget = "slider"; 
   int UIOrder = 20;
> = 1.0f;

float gLight2Hotspot : HOTSPOT <
   string Object = "Light 2";
   string UIName = "Light 2 Cone Angle"; 
   float UIMin = 0;
   float UIMax = PI/2;
   int UIOrder = 21;
> = {0.46f};

float gLight2FallOff : FALLOFF <
   string Object = "Light 2";
   string UIName = "Light 2 Penumbra Angle"; 
   float UIMin = 0;
   float UIMax = PI/2;
   int UIOrder = 22;
> = {0.7f};

float gLight2DecayRate : DECAYRATE <
   string Object = "Light 2";
   string UIName = "Light 2 Decay";
   float UIMin = 0.0f;
   float UIMax = 10.0f;
   float UIStep = 0.01f;
   int UIOrder = 23;
> = {0.0f};

// Maps

Texture2D gDiffuseTex <
   string UIGroup = "Maps";
   string ResourceName = "";
   string UIName = "Diffuse Map";
   string UIWidget = "FilePicker";
   string ResourceType = "2D";
   int UIOrder = 24;
>;

float2 gTileDiffuse <
   string UIGroup = "Maps";
   string UIName = "Diffuse Map Tiling";
   int UIOrder = 25;
> = {1.0f, 1.0f};

Texture2D gNormalTex <
   string UIGroup = "Maps";
   string ResourceName = "";
   string UIName = "Normal Map";
   string UIWidget = "FilePicker";
   string ResourceType = "2D";
   int UIOrder = 26;
>;

float2 gTileNormal <
   string UIGroup = "Maps";
   string UIName = "Normal Map Tiling";
   int UIOrder = 27;
> = {1.0f, 1.0f};

float gNormalScale <
   string UIGroup = "Maps";
   string UIName = "Normal Map Scale";
   float UIMin = 0.0f;
   float UIMax = 1.0f;
   int UIOrder = 28;
> = 1.0f;

// Params

float gLightingDecayScale <
   string UIGroup = "Params";
   string UIName = "Lighting Decay Scale";
   string UIWidget = "slider";
   float UIMin = 0.0;
   float UIMax = 1024;
   float UISoftMax = 1.0;
   float UIStep = 0.001;
   int UIOrder = 29;
> = 1.0f;

float3 gAmbientColor <
   string UIGroup = "Params";
   string UIName = "Ambient Color";
   string UIWidget = "ColorPicker";
   int UIOrder = 30;
> = {0.0f, 0.0f, 0.0f};

float3 gDiffuseColor <
   string UIGroup = "Params";
   string UIName = "Diffuse Color";
   string UIWidget = "ColorPicker";
   int UIOrder = 31;
> = {1.0f, 1.0f, 1.0f};

int gSpecularModel <
   string UIGroup = "Params";
   string UIName = "Specular Model";
   string UIFieldNames ="Phong:Blinn";
   float UIMin = 0;
   float UIMax = 1;
   float UIStep = 1;
   int UIOrder = 32;
> = 0;

float3 gSpecularColor <
   string UIGroup = "Params";
   string UIName = "Specular Color";
   string UIWidget = "ColorPicker";
   int UIOrder = 33;
> = {1.0f, 1.0f, 1.0f};

float gSpecularPower <
   string UIGroup = "Params";
   string UIName = "Specular Power";
   string UIWidget = "slider";
   float UIMin = 1.0;
   float UIMax = 512.0;
   float UISoftMax = 64.0;
   float UIStep = 0.01;
   int UIOrder = 34;
> = 64.0f;

/////////////////////
// Sampler
/////////////////////

SamplerState SamplerAnisoWrap
{
   Filter = ANISOTROPIC;
   AddressU = Wrap;
   AddressV = Wrap;
};


/////////////////////
// FUNCTIONS
/////////////////////

float lightCone(float coneHotspot, float coneFalloff, float3 light2pixel, float3 lightDir) { 
   coneFalloff = (coneFalloff < coneHotspot) ? coneHotspot : coneFalloff;
   float LdotDir = dot(light2pixel, lightDir); 
   return float(smoothstep(cos(coneFalloff), cos(coneHotspot), LdotDir));
};

void lightingFunction(
                  float3 eyeVec,
                  float3 normal,
                  float3 lightVec,
                  float lightVecLength,

                  int lightType,
                  float3 lightDir,
                  float4 lightColor,
                  float lightIntensity,
                  float lightHotspot,
                  float lightFallOff,
                  float lightDecayRate,

                  int specularModel,
                  float specularPower,
                  float lightingDecayScale,
                  
                  out float4 diff,
                  out float4 spec

                  ) {

   // if light is directional, light vector will be an inverse of light direction
   if (lightType == 4) {
      lightVec = -lightDir;
   }

   //diffuse value
   float diffuseValue = saturate(dot(normal, lightVec));

   // specular value
   float specularValue = 0.0f;
   if (diffuseValue > 0){
      if (specularModel == 0) { // phong
         float3 lightReflectVec = reflect(-lightVec, normal);
         float RdotV = saturate(dot(eyeVec, lightReflectVec));
         specularValue = pow(RdotV, specularPower); 
      }
      else if (specularModel == 1) { // blinn
         float3 wHalfwayVec = normalize(lightVec + eyeVec);
         float NdotH = saturate(dot(normal, wHalfwayVec));
         specularValue = pow(NdotH, specularPower); 
      }
   }

   // modulate diffuseValue and specularValue by cone factor if light is a spot
   if (lightType == 2) {
      float coneFactor = lightCone(lightHotspot, lightFallOff, -lightVec, lightDir);
      diffuseValue *= coneFactor;
      specularValue *= coneFactor;
   }

   // attenuation
   float attenuation = lightIntensity;
   if ( (lightType != 4) && (lightDecayRate > 0.0001f) ) {
      attenuation *= 1 / (1 + pow(lightVecLength * lightingDecayScale, lightDecayRate));
   }
   diffuseValue *= attenuation;
   specularValue *= attenuation;

   // result
   diff = diffuseValue * lightColor;
   spec = specularValue * lightColor;

};

/////////////////////
// Structs IN-OUT
/////////////////////

struct vertex_in {
   float4 oPos       : POSITION;
   float2 texCoord   : TEXCOORD0;
   float3 oNormal    : NORMAL;
   float3 oBinormal  : BINORMAL;
   float3 oTangent   : TANGENT;
};

struct vertex_to_pixel {
   float4 pPos       : SV_Position;
   float2 texCoord   : TEXCOORD0;
   float3 wNormal    : TEXCOORD1;
   float3 wBinormal  : TEXCOORD2;
   float3 wTangent   : TEXCOORD3;
   float3 wPos       : TEXCOORD4;
   //float3 wEyeVec    : TEXCOORD5;
};

/////////////////////
// VERTEX SHADER
/////////////////////

vertex_to_pixel vs(vertex_in In) {
   vertex_to_pixel Out;
   Out.pPos = mul(In.oPos, MtxWorldViewProjection);
   Out.wNormal = mul(In.oNormal, MtxWorldInverseTranspose);
   Out.wBinormal = mul(In.oBinormal, MtxWorldInverseTranspose);
   Out.wTangent = mul(In.oTangent, MtxWorldInverseTranspose);
   Out.texCoord = In.texCoord;
   Out.wPos = mul(In.oPos, MtxWorld);

   return  Out;
};

/////////////////////
// PIXEL SHADER
/////////////////////

float4 ps(vertex_to_pixel In): SV_Target {

   // normalize vectors
   float3 wNormal = normalize(In.wNormal);
   float3 wBinormal = normalize(In.wBinormal);
   float3 wTangent = normalize(In.wTangent);

   // colors to float4
   float4 lightColor0 = float4(gLight0Color, 1.0f);
   float4 lightColor1 = float4(gLight1Color, 1.0f);
   float4 lightColor2 = float4(gLight2Color, 1.0f);
   float4 ambientColor = float4(gAmbientColor, 1.0f);
   float4 diffuseColor = float4(gDiffuseColor, 1.0f);
   float4 specularColor = float4(gSpecularColor, 1.0f);

   // eye vector
   float3 wEyeVec = normalize(MtxViewInverse[3] - In.wPos);

   // diff tex color
   float4 diffTexColor = gDiffuseTex.Sample(SamplerAnisoWrap, In.texCoord * gTileDiffuse);

   // normals with normal map
   float3 tsNormal = gNormalTex.Sample(SamplerAnisoWrap, In.texCoord * gTileNormal) * 2 - 1;
   float3 wNormalWithNM = normalize((tsNormal.x * wTangent) + (tsNormal.y * wBinormal) + (tsNormal.z * wNormal));
   wNormalWithNM = normalize(lerp(wNormal, wNormalWithNM, gNormalScale));

   // lighting
   float4 diffuse0;
   float4 specular0;
   float3 wLigthVec0 = gLight0Pos - In.wPos;
   lightingFunction(	wEyeVec, wNormalWithNM, normalize(wLigthVec0), length(wLigthVec0),
                  gLight0Type, gLight0Dir, lightColor0, gLight0Intensity, gLight0Hotspot, gLight0FallOff, gLight0DecayRate,
                  gSpecularModel, gSpecularPower, gLightingDecayScale,
                  diffuse0, specular0
               );

   float4 diffuse1;
   float4 specular1;
   float3 wLigthVec1 = gLight1Pos - In.wPos;
   lightingFunction(	wEyeVec, wNormalWithNM, normalize(wLigthVec1), length(wLigthVec1),
                  gLight1Type, gLight1Dir, lightColor1, gLight1Intensity, gLight1Hotspot, gLight1FallOff, gLight1DecayRate,
                  gSpecularModel, gSpecularPower, gLightingDecayScale,
                  diffuse1, specular1
               );

   float4 diffuse2;
   float4 specular2;
   float3 wLigthVec2 = gLight2Pos - In.wPos;
   lightingFunction(	wEyeVec, wNormalWithNM, normalize(wLigthVec2), length(wLigthVec2),
                  gLight2Type, gLight2Dir, lightColor2, gLight2Intensity, gLight2Hotspot, gLight2FallOff, gLight2DecayRate,
                  gSpecularModel, gSpecularPower, gLightingDecayScale,
                  diffuse2, specular2
               );

   // final composition
   return ambientColor + (diffTexColor * diffuseColor * (diffuse0 + diffuse1 + diffuse2) + specularColor * (specular0 + specular1 + specular2));

};

/////////////////////
// TECH
/////////////////////

technique11 main {

    pass P0 {
        SetVertexShader(CompileShader(vs_5_0, vs()));
        //SetGeometryShader(NULL);
        SetPixelShader(CompileShader(ps_5_0, ps()));
    }

}