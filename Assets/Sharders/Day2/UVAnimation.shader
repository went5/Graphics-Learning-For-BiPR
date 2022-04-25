Shader "Custom/UVAnimation"
{
    Properties
    {
        [NoScaleOffset]_MainTex ("MainTex", 2D) = "white" {}
        _SpeedX("SpeedX",float) = 0.1
        _SpeedY("SpeedY",float) = 0.1
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
            #pragma vertex vert;
            #pragma fragment frag;

            sampler2D _MainTex;
            float _SpeedX;
            float _SpeedY;

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv:TexCOORD0;
            };

            struct v2f
            {
                float4 vertex: SV_POSITION;
                float2 uv:TexCOORD0;
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
                i.uv.x += _Time * _SpeedX;
                i.uv.y += _Time * _SpeedY;
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}