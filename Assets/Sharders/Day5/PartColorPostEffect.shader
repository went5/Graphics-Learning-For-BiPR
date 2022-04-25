Shader "Custom/PartColorPostEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PartColor("PartColor",Color) = (1,1,1,1)
        _Edge("Edge",Float) = 0.1
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

            fixed4 _PartColor;
            float _Edge;


            float getHue(fixed3 c)
            {
                float maxRGB = max(c.r, max(c.g, c.b));
                float minRGB = min(c.r, min(c.g, c.b));
                float delta = maxRGB - minRGB + 0.0001;
                if (c.r == maxRGB)
                {
                    return (c.g - c.b) / delta;
                }
                if (c.g == maxRGB)
                {
                    return 2 + (c.b - c.r) / delta;
                }
                return 4 + (c.r - c.g) / delta;
            }

            fixed HueDiff(fixed3 c1,fixed3 c2)
            {
                return abs(getHue(c1) - getHue(c2));
            }

            fixed4 frag(v2f i):SV_Target
            {
                float4 color = tex2D(_MainTex, i.uv);
                float4 gray = dot(color, half3(0.30, 0.59, 0.11));
                color = lerp(color, gray, step(_Edge, HueDiff(color.rgb, _PartColor)));
                return color;
            }
            ENDCG
        }

    }
    FallBack "Diffuse"
}