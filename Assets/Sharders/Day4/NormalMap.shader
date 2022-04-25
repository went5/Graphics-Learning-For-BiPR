Shader "Custom/NormalMap"
{
    Properties
    {
        _NormalMap ("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "RenderType"="Opaque"
            }

            CGPROGRAM
            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag
            sampler2D _NormalMap;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent:TANGENT;
                float2 uv:TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal:NORMAL;
                float2 uv:TEXCOORD0;
                float3 tangent:TEXCOORD1;
                float3 binormal:TEXCOORD2;
            };


            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent = normalize(mul(unity_ObjectToWorld, v.tangent.xyz));
                o.binormal = normalize(cross(v.normal, v.tangent) * v.tangent.w);
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                float3x3 tangentTransform = float3x3(i.tangent, i.binormal, i.normal);
                float3 localNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
                float3 worldNormal = normalize(mul(localNormal, tangentTransform));

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = dot(worldNormal, lightDir);

                fixed4 color = fixed4(NdotL, NdotL, NdotL, 1.0);
                return color;
            }
            ENDCG
        }
    }
}