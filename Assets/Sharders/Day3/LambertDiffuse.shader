Shader "Custom/LambertDiffuse"
{
    Properties
    {
        [NoScaleOffset]_MainTex("MainTex",2D) ="white" {}

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

            // _LightColor0が入っている
            #include "Lighting.cginc"


            struct appdata
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                float2 uv:TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex:SV_POSITION;
                float3 worldNormal:NORMAL;
                float2 uv:TEXCOORD0;
            };

            sampler2D _MainTex;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                const half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                const half nDot = saturate(dot(i.worldNormal, lightDir));

                fixed4 mainTex = tex2D(_MainTex, i.uv);
                const fixed4 Color = _LightColor0 * nDot * mainTex;
                return Color;
            }
            ENDCG
        }
    }
}