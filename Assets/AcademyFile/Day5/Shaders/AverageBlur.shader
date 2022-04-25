Shader "Custom/AverageBlur"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
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
            float4 _MainTex_TexelSize; // x 1/width y 1/height

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);
                color += tex2D(_MainTex, i.uv - _MainTex_TexelSize.x);
                color += tex2D(_MainTex, i.uv + _MainTex_TexelSize.x);
                color += tex2D(_MainTex, i.uv + _MainTex_TexelSize.y);
                color += tex2D(_MainTex, i.uv - _MainTex_TexelSize.y);
                color += tex2D(_MainTex, i.uv + _MainTex_TexelSize.x + _MainTex_TexelSize.y);
                color += tex2D(_MainTex, i.uv + _MainTex_TexelSize.x - _MainTex_TexelSize.y);
                color += tex2D(_MainTex, i.uv - _MainTex_TexelSize.x + _MainTex_TexelSize.y);
                color += tex2D(_MainTex, i.uv - _MainTex_TexelSize.x - _MainTex_TexelSize.y);
color/=9;

                return color;
            }
            ENDCG
        }
    }
}