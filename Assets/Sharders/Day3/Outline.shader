Shader "Custom/Outline"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _OutlineColor ("OutlineColor", Color) = (0,0,0,1)
        _OutlineWidth ("OutlineWidth", float) = 0.1
    }
    SubShader
    {
        //outlineのためにパスを増やす
        Pass
        {
            Name "OUTLINE"
            Tags
            {
                "LightMode"="Always"
            }
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                half4 vertex : POSITION;
                half3 normal : NORMAL;
            };

            struct v2f
            {
                half4 pos : SV_POSITION;
            };

            fixed4 _OutlineColor;
            float _OutlineWidth;

            v2f vert(appdata v):SV_POSITION
            {
                v2f o;
                v.vertex.xyz += v.normal * _OutlineWidth;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                return _OutlineColor;
            }
            ENDCG
        }
        Pass
        {
            Tags
            {
                "LightMode"="ForwardBase"
            }

            CGPROGRAM
            #pragma fragment frag;
            #pragma vertex vert;

            fixed4 _Color;

            float4 vert(float4 vertex:POSITION) :SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

            fixed4 frag(float4 v:SV_POSITION):SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}