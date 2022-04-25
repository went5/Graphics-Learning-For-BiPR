Shader "Day5/Monochrome"
{
    Properties{
        _MainTex("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Cull Off        // カリングは不要
        ZTest Always    // ZTestは常に通す
        ZWrite Off      // ZWriteは不要

        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 color = tex2D(_MainTex, i.uv);
                float Y = 0.299f * color.r + 0.587f * color.g + 0.114f * color.b;
                color.r = Y;
                color.g = Y;
                color.b = Y;
                return color;
            }
            ENDCG
        }
    }
}
