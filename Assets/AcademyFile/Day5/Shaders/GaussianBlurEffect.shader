Shader "Custom/GaussianBlurEffect"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Radius ("Radius",Float) = 1
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
            half2 _Direction;
            half _Radius; // 0だった...
            static float weights[5] = {0.22702702702, 0.19459459459, 0.12162162162, 0.05405405405, 0.01621621621};

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                half4 texColor = tex2D(_MainTex, i.uv);
                float2 offset = _Direction * _MainTex_TexelSize * _Radius;
                fixed4 color = fixed4(texColor.rgb * weights[0], 1.0);

                color.rgb += tex2D(_MainTex, i.uv + offset * 1).rgb * weights[1];
                color.rgb += tex2D(_MainTex, i.uv - offset * 1).rgb * weights[1];
                color.rgb += tex2D(_MainTex, i.uv + offset * 2).rgb * weights[2];
                color.rgb += tex2D(_MainTex, i.uv - offset * 2).rgb * weights[2];
                color.rgb += tex2D(_MainTex, i.uv + offset * 3).rgb * weights[3];
                color.rgb += tex2D(_MainTex, i.uv - offset * 3).rgb * weights[3];
                color.rgb += tex2D(_MainTex, i.uv + offset * 4).rgb * weights[4];
                color.rgb += tex2D(_MainTex, i.uv - offset * 4).rgb * weights[4];



                return color;
            }
            ENDCG
        }
    }
}