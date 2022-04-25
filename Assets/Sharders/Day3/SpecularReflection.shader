Shader "Custom/SpecularReflection"
{
    Properties
    {
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

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldNormal:NORMAL;
                float4 worldPos:TEXCOORD0;
            };

            half _Shininess;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // 正規化必須  
                half3 normal = normalize(i.worldNormal);
                // 視線方向
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                // ライト方向
                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float NdotL = dot(lightDir, normal);
                // 反射方向
                float3 reflectDir = 2 * NdotL * normal - lightDir;
                // 鏡面反射の強さ
                half speqular = pow(saturate(dot(viewDir, reflectDir)), _Shininess);
                fixed4 color = fixed4(speqular, speqular, speqular, 1.0);
                return color;
            }
            ENDCG
        }
    }
}