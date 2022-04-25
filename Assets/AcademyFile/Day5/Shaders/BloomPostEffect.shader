Shader "Custom/BloomPostEffect"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Clip("Clip",Float) = 1.0
    }

    CGINCLUDE
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

    v2f vert(appdata v)
    {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv = v.uv;
        return o;
    }
    ENDCG

    SubShader
    {
        Cull Off
        ZTest Always
        ZWrite Off

        Tags
        {
            "RenderType" = "Opaque"
        }


        // pass 0 照度のみ抽出
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            float _Clip;

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.uv);
                float Y = dot(color.xyz, float3(0.2125f, 0.7154f, 0.0721f));
                clip(Y - _Clip);

                return color;
            }
            ENDCG
        }

        // pass 1 ガウシアンブラー
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            float2 _Direction;
            static float weights[5] = {0.22702702702, 0.19459459459, 0.12162162162, 0.05405405405, 0.01621621621};
            float4 _MainTex_TexelSize;

            fixed4 frag(v2f i):SV_Target
            {
                half4 texColor = tex2D(_MainTex, i.uv);
                float2 offset = _Direction * _MainTex_TexelSize;
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

        // pass 2 ブラー画像の加算合成
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _blurImage0;

            fixed4 frag(v2f i): SV_Target
            {
                fixed4 color = tex2D(_blurImage0, i.uv);

                color += tex2D(_MainTex, i.uv) + color;
                color.a = 1.0f;

                return color;
            }
            ENDCG
        }
    }
}