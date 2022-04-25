Shader "Custom/GlarePostEffect"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Threshold("Threshold", Range (0.0,1.0)) = 0.5
        _Intensity("Insensity", Range (0.0,10.0)) = 1.0
        _Attenuation("Attenuation", Range (0.5,0.95)) = 0.9
    }

    SubShader
    {
        Cull Off
        ZTest Always
        ZWrite Off

        Tags
        {
            "RenderType" = "Opaque"
        }

        // 0: 明度抽出
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
            float4 _MainTex_TexelSize; // x 1/width y 1/height
            half _Threshold;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half4 color = tex2D(_MainTex, i.uv);
                half brightness = max(color.r, max(color.g, color.b));
                half contribution = max(0, brightness - _Threshold);
                contribution /= max(brightness, 0.00001);
                return color * contribution;
            }
            ENDCG
        }
        // 1: グレア
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
                half2 uvOffset:TEXCOORD1;
                half pathFactor:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize; // x 1/width y 1/height
            half _Threshold;
            // offset,pathIndex
            int3 _Params;
            float _Attenuation;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.pathFactor = pow(4, _Params.z); // ??
                o.uvOffset = half2(_Params.x, _Params.y) * _MainTex_TexelSize.xy * o.pathFactor;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half4 color = half4(0, 0, 0, 1);
                half2 uv = i.uv;
                for (int j = 0; j < 4; j++)
                {
                    color.rgb += tex2D(_MainTex, uv) * pow(_Attenuation, j * i.pathFactor);
                    uv += i.uvOffset;
                }

                return color;
            }
            ENDCG
        }
        // 2: 加算合成
        Pass
        {
            Blend One One
            ColorMask RGB
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
            float _Intensity;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                return tex2D(_MainTex, i.uv) * _Intensity;
            }
            ENDCG

        }
    }
}