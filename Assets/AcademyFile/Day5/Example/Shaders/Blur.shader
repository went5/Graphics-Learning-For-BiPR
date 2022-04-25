Shader "Day5/Blur"
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
            float2 _MainTex_TexelSize; // テクセルサイズ

            float2 _Direction;         // ガウシアンブラーをかける方向
            static const int WEIGHT_SIZE = 8;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {

                // ガウシアン関数で事前計算した重みテーブル
                float weights[WEIGHT_SIZE] = {
                    0.12445063, 0.116910554, 0.096922256, 0.070909835,
                    0.04578283, 0.02608627,  0.013117,    0.0058206334
                };

                // _MainTex_TexelSize
                // x : 1.0 / 幅
                // y : 1.0 / 高さ
                // z : 幅
                // w : 高さ
                float2 dir = _Direction * _MainTex_TexelSize.xy;

                fixed4 color = 0;
                for (int j = 0; j < WEIGHT_SIZE; j++) {
                    float2 offset = dir * ((j + 1) * 2 - 1);
                    color.rgb += tex2D(_MainTex, i.uv + offset) * weights[j];
                    color.rgb += tex2D(_MainTex, i.uv - offset) * weights[j];
                }
                color.a = 1;

                return color;
            }
            ENDCG
        }
    }
}
