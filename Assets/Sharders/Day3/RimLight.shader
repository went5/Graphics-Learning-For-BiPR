Shader "Custom/RimLight"
{
    Properties
    {
        _Power ("Rim Power",float) = 5.0
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
            fixed _Power;

            struct appdata
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float4 vertex:SV_POSITION;
                float3 normal:NORMAL;
                float4 worldPos:TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                float3 normal = normalize(i.normal);
                float3 viewDir = normalize(i.worldPos.xyz - _WorldSpaceCameraPos.xyz);

                float OneMinusNdotV = 1 - max(0,(dot(normal, -viewDir)));
                float OneMinusNdotL = 1 - max(0,dot(_WorldSpaceLightPos0, normal));
                float rimPower = pow(OneMinusNdotV * OneMinusNdotL, _Power);

                return rimPower;
            }
            ENDCG
        }
    }
}