float UnlitRimLight(float3 normal, float3 worldPos, float rimPower)
{
    // 視線ベクトルを求める
    float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);

    //dotで値が0だと垂直で、1だと平行 1-して値を逆にする
    float NdotV = 1 - saturate(dot(normal, viewDir));

    float lim = 1 - saturate(dot(_WorldSpaceLightPos0, normal));

    return pow(NdotV * lim, rimPower);
}

float specular(float3 normal, float3 viewDir, float3 lightDir, float specularPower)
{
    normal = normalize(normal);
    float3 lightRefl = reflect(-lightDir, normal);
    half spefularLength = saturate(dot(viewDir, lightRefl));
    return pow(spefularLength, specularPower);
}
