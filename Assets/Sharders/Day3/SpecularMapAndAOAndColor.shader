Shader "Custom/SpecularMap"
{
    Properties
    {

        [NoScaleOffset]_MainTex("MainTex",2D) ="white" {}
        [NoScaleOffset] _SpecularTex ("Specular Texture", 2D) = "white" {}
        [NoScaleOffset] _OcculusionTex ("Occulusion Texture", 2D) = "white" {}
        _Shininess ("Shininess",float) = 20

    }
    SubShader
    {
        Tags
        {
            "LightMode"="ForwardBase"
        }

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
                float2 uv:TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal:NORMAL;
                float2 uv:TEXCOORD0;
                float4 posWorld:TEXCOORD1;
            };

            half _Shininess;
            sampler2D _MainTex;
            sampler2D _SpecularTex;
            sampler2D _OcculusionTex;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Vector
                half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld);
                float3 normal = normalize(i.normal);
                float3 refrectDir = reflect(-lightDir, normal);

                // Dot
                half RdotV = saturate(dot(refrectDir, viewDir));
                half nDot = saturate(dot(normal, lightDir));

                // Map
                float specTex = tex2D(_SpecularTex, i.uv).r;
                fixed4 specular = _LightColor0 * specTex * pow(RdotV, _Shininess);
                fixed4 colorTex = tex2D(_MainTex, i.uv);
                fixed4 occlusionTex = tex2D(_OcculusionTex, i.uv);

                fixed4 ambient = UNITY_LIGHTMODEL_AMBIENT * colorTex;
                fixed4 diffuseColor = _LightColor0 * nDot * colorTex;
                fixed4 occlusionColor = occlusionTex;

                fixed4 color = (specular + diffuseColor + ambient) * occlusionColor;
                return color;
            }
            ENDCG
        }
    }
}