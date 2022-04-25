Shader "Custom/NormalAndCubeMap"
{
    Properties
    {
        _ColorMap ("Main Tex", 2D) = "bump" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _CubeMap ("CUBE", CUBE) = "" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

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
                float3 posWorld : TEXCOORD3;
            };

            sampler2D _NormalMap;
            sampler2D _ColorMap;
            UNITY_DECLARE_TEXCUBE(_CubeMap);

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent = normalize(mul(unity_ObjectToWorld, v.tangent.xyz));
                o.binormal = normalize(cross(v.normal, v.tangent) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                float3x3 tangentTransform = float3x3(i.tangent, i.binormal, i.normal);
                float3 localNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
                float3 worldNormal = normalize(mul(localNormal, tangentTransform));

                // dir
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.posWorld);
                float3 reflectDir = reflect(-viewDir, i.normal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float3 NdotL = dot(worldNormal, lightDir);

                fixed3 texColor = tex2D(_ColorMap, i.uv);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT * texColor;
                fixed3 diffuse = texColor * NdotL;

                float3 cubeData = UNITY_SAMPLE_TEXCUBE(_CubeMap, reflectDir);

                fixed4 color = fixed4(cubeData + ambient, 1.0f);
                return color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}