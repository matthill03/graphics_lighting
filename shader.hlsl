cbuffer ConstantBuffer 
{
	matrix	worldViewProjection;
	matrix	world;
	float4	ambientLightColour;
	float4	directionalLightColour;
	float4	directionalLightVector;
};

struct VertexIn
{
	float3 InputPosition	: POSITION;
	float3 Normal			: NORMAL;
};

struct VertexOut
{
	float4 OutputPosition	: SV_POSITION;
	float4 Colour			: COLOR;
};

VertexOut VS(VertexIn vin)
{
	VertexOut vout;
	
	// Transform to homogeneous clip space.
	float4 vectorBackToLight = -directionalLightVector;
	float4 adjustedNormal = mul(world, float4(vin.Normal, 0.0f));
	float diffuseLight = saturate(normalize(dot(adjustedNormal, vectorBackToLight))); // saturate(normalize(dot()))
	float4 colour = saturate(ambientLightColour) + saturate(diffuseLight) * saturate(directionalLightColour);

	vout.OutputPosition = mul(worldViewProjection, float4(vin.InputPosition, 1.0f));
	vout.Colour = saturate(colour);

    return vout;
}

float4 PS(VertexOut pin) : SV_Target
{
	return pin.Colour;
}


