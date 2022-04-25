Shader "Custom/Pixelize"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PixelSize ("Pixel Size", Range(0.001, 0.15)) = 0.001
        _FadeScale("Fade Scale", float) = 10
        _FadeColor("Fade Color",Color) = (0,0,0,0)
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
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _PixelSize;
            float _FadeScale;
            float _FadeColor;

            fixed4 frag(v2f_img i) : SV_Target
            {
                fixed4 col;


                float ratioX = (int)(i.uv.x / _PixelSize + 0.5) * _PixelSize;
                float ratioy = (int)(i.uv.y / _PixelSize + 0.5) * _PixelSize;

                col = tex2D(_MainTex, float2(ratioX, ratioy));

                // 暗くする
                col = lerp(col, _FadeColor, _PixelSize * _FadeScale);
                return col;
            }
            ENDCG
        }
    }
}