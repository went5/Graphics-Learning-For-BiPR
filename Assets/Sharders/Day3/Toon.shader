Shader "Custom/Toon"
{
    Properties
    {
        _BaseColor ("BaseColor", Color) = (1,1,1,1)
        _ShadowColor ("ShadowColor", Color) = (1,1,1,1)

    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _BaseColor;
            fixed4 _ShadowColor;


            struct appdata
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float4 vertex:SV_POSITION;
                float3 normal:NORMAL;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                float3 normal = normalize(i.normal);
                half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                half NdotL = saturate(dot(normal, lightDir));
                fixed4 color = lerp(_ShadowColor, _BaseColor, step(0.5, NdotL));
                return color;
            }
            ENDCG
        }
    }
}