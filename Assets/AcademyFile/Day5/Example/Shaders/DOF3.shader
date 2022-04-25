Shader "Day5/DOF3"
{
    Properties{
        _MainTex("Texture", 2D) = "white" {}
    }

    CGINCLUDE
    #include "UnityCG.cginc"

    sampler2D _MainTex;
    float4 _MainTex_ST;
    float2 _MainTex_TexelSize;  // テクセルサイズ

    sampler2D _CameraDepthTexture; // カメラの深度テクスチャ

    // Vertex Input
    struct appdata {
        float4 vertex : POSITION;
        float2 uv     : TEXCOORD0;
    };

    // Vertex to Fragment
    struct v2f {
        float4 pos : SV_POSITION;
        float2 uv  : TEXCOORD0;
    };

    // 頂点シェーダー(全Pass共通)
    v2f vert(appdata v) {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        return o;
    }
    ENDCG

    SubShader
    {
        Cull Off        // カリングは不要
        ZTest Always    // ZTestは常に通す
        ZWrite Off      // ZWriteは不要

        Tags { "RenderType" = "Opaque" }

        //0: ガウシアンブラー
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float2 _direction;         // ガウシアンブラーをかける方向
            static const int WEIGHT_SIZE = 8;

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
                float2 dir = _direction * _MainTex_TexelSize.xy;

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

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _focalDistance;
            sampler2D _bokeTexture;

            fixed4  frag(v2f i) : SV_Target
            {
		        float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
		        depth = Linear01Depth(depth);
		
                if (depth - _focalDistance < 0) {
                    return tex2D(_MainTex, i.uv);
                }
                else {
                    fixed4 boke = tex2D(_bokeTexture, i.uv);
                    boke.a = min(1.0f, depth);
                    return boke;
                }
            }
            ENDCG
        }
    }
}
