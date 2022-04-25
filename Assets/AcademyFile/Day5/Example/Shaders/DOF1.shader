Shader "Day5/DOF1"
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

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _bokeTexture;

            fixed4  frag(v2f i) : SV_Target
            {
                float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);

                return depth;
            }
            ENDCG
        }
    }
}
