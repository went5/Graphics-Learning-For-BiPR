Shader "Custom/GrayScale"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex:SV_POSITION; // pos!
                float2 uv: TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                float4 color = tex2D(_MainTex, i.uv);
                float4 gray = dot(color, half3(0.30, 0.59, 0.11));
                return gray;
            }
            ENDCG
        }

    }
    FallBack "Diffuse"
}