Shader "Custom/PRRimLight"
{
    Properties
    {
        _Shininess ("Shininess",float) = 20
        _Color("Main Color", Color) = (1,1,1,1)
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
            #include "UnityCG.cginc"
            #include "Assets/Sharders/util.cginc"

            struct Input
            {
                float2 uv_MainTex;
            };

            struct appdata
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float4 vertex:SV_POSITION;
                float3 worldNormal:NORMAL;
                float4 worldPos:TEXCOORD0;
            };

            half _Shininess;
            fixed4 _Color;
            fixed _Power;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                half3 normal = normalize(i.worldNormal);
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                const half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                const half nDot = saturate(dot(i.worldNormal, lightDir));
                float3 reflectDir = reflect(-lightDir, normal);
                const fixed4 specularColor = pow(saturate(dot(viewDir, reflectDir)), _Shininess) * _LightColor0;
                const fixed4 diffuseColor = _LightColor0 * nDot * _Color;
                const fixed4 ambient = UNITY_LIGHTMODEL_AMBIENT * _Color;
                float c = UnlitRimLight(normal, i.worldPos, _Power);


                const fixed4 color = c + diffuseColor + specularColor + ambient;
                return color;
            }
            ENDCG
        }
    }
}