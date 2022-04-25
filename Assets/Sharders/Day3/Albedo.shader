Shader "Custom/Albedo"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("_MainTex", 2D) = "white" {}

    }
    SubShader
    {
        Pass
        {
            Cull Off
            Tags
            {
                "RenderType"="Opaque"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "Assets/Sharders/util.cginc"

            sampler2D _MainTex;


            struct appdata
            {
                float4 vertex:POSITION;
                float2 uv:TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex:SV_POSITION;
                float2 uv:TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);
                                clip(color.a - 0.1);
                return color;
            }
            ENDCG
        }
    }
}