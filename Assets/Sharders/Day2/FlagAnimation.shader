Shader "Custom/FlagAnimation"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _WaveFreq ("Wave Freq",float ) = 1.0
        _TimeSpeed ("Time Speed",float ) = 1.0
    }
    SubShader
    {
        Pass
        {
            Cull Off

            Tags
            {
                "RenderType"="Opaque"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            float _WaveFreq;
            float _TimeSpeed;

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
                v.vertex.y = sin(v.vertex.x * _WaveFreq + _Time.y * _TimeSpeed) * v.uv.x;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i): SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}