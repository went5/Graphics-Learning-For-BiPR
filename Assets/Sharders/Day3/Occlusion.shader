Shader "Custom/Occlusion"
{
    Properties
    {
        [NoScaleOffset]_OcclusionMap ("Occlusion",2D) = "white" {}
        [NoScaleOffset]_BaseColor ("_BaseColor",2D) = "white" {}
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
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv:TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv:TEXCOORD0;
            };

            sampler2D _BaseColor;
            sampler2D _OcclusionMap;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 _occlusionColor = tex2D(_OcclusionMap, i.uv);
                fixed4 baseColor = tex2D(_BaseColor, i.uv);
                return _occlusionColor * baseColor;
            }
            ENDCG
        }
    }
}