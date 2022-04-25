Shader "Custom/Dither"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _DitherTex ("Dither Pattern (R)", 2D) = "white" {}
        _Alpha ("Alpha", Range(0.0, 1.0)) = 1.0
        _DitherSize("Dither Size",Int) = 2
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float2 texcoord: TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 clipPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _DitherTex;
            float _Alpha;
            int _DitherSize;
            sampler2D _DitherMaskLOD2D;

            v2f vert(appdata v)
            {
                v2f o = (v2f)0;
                o.pos = UnityObjectToClipPos(v.vertex);

                // クリップ座標を求める
                o.clipPos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }

            float4 frag(v2f i): COLOR
            {
                // クリップ座標からビューポート座標を求める 左上(0,0) ~ 右下(1,1) 
                float2 viewPortPos = i.clipPos.xy / i.clipPos.w * 0.5 + 0.5;
                // スクリーン座標を求める (左上(0,0) 右下(1980,1080))
                int2 screenPos = viewPortPos * _ScreenParams.xy;

                float4x4 bayerMatrix = {
                    0, 8, 2, 10,
                    12, 4, 14, 6,
                    3, 11, 1, 9,
                    15, 7, 13, 5
                };
                // 0.0 ~ 1.0
                bayerMatrix /= 16;
                bayerMatrix += 0.001;

                // fmod(a,b)はaをbで除算した正の剰余 浮動小数点数の余り
                // screenPosには、整数値のみ入る
                float2 ditherCoord = fmod(screenPos, _DitherSize);
                //float2 ditherCoord = fmod(i.uv * 1900, _DitherSize);


                float dither = bayerMatrix[ditherCoord.x][ditherCoord.y];
                //return fixed4(ditherCoord.x, ditherCoord.y, 1.0, 1.0);
                clip(_Alpha - dither);

                float4 color = tex2D(_MainTex, i.uv);

                return color;
            }
            ENDCG
        }
    }
}