Shader "Custom/Mosaic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MosaicResolution("Mosaic Resolution", Range(2, 100)) = 32
        _MosaicResolutionX("X Mosaic Resolution", Range(1, 4)) = 1
        _MosaicResolutionY("Y Mosaic Resolution", Range(1, 4)) = 1

    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

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
            int _MosaicResolution; //高いほどモザイクが細かくなる
            int _MosaicResolutionX;
            int _MosaicResolutionY;
            static float2 _Mosaic = _MosaicResolution * float2(_MosaicResolutionX, _MosaicResolutionY);

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                i.uv = floor(i.uv * _Mosaic) / _Mosaic;
                fixed4 color = tex2D(_MainTex, i.uv);

                clip(color.a - 0.1);
                return color;
            }
            ENDCG
        }
    }
}