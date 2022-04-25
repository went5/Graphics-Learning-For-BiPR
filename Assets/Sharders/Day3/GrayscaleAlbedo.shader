Shader "Custom/GrayscaleAlbedo"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("_MainTex", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            // Directional Lightのみ
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "Assets/Sharders/util.cginc"

            sampler2D _MainTex;


            struct appdata
            {
                float4 vertex:POSITION;
                float2 uv:TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex:SV_POSITION;
                float2 uv:TEXCOORD0;
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
                fixed4 color = tex2D(_MainTex, i.uv);
                fixed grayscale = dot(color, half3(0.299, 0.587, 0.114));
                return grayscale;
            }
            ENDCG
        }
    }
}