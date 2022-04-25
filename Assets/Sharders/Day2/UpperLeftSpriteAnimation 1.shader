Shader "Custom/SpriteAnimation"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Main Texture", 2D) = "white" {}
        _Column ("Column",Int) = 0
        _Row ("Row",Int) = 0
        _Speed ("Speed",Int) = 10
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
            int _isUp;

            sampler2D _MainTex;
            int _Column;
            int _Row;
            int _Speed;
            static int _upNum = max(_isUp * _Row - 1, 0);

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
                int row = _Row - 1 - (uint)(_Time.y * _Speed) / _Row % _Row;
                int column = (uint)(_Time.y * _Speed) % _Column;


                i.uv = float2(i.uv.x / _Column + (float)column / _Column, i.uv.y / _Row + (float)row / _Row);

                fixed4 col = tex2D(_MainTex, i.uv);
                clip(col.a - 0.1);
                return col;
            }
            ENDCG
        }
    }
}