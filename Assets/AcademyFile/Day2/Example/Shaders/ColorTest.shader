Shader "Sandbox/UVColor"
{
    Properties {}
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

            #include "UnityCG.cginc"


            struct appdata
            {
                float4 vertex:POSITION;
                float4 uv:TEXCOORD0;
            };

            // 頂点シェーダー
            appdata vert(appdata a)
            {
                a.vertex = UnityObjectToClipPos(a.vertex);
                return a;
            }

            fixed4 frag(appdata a) : SV_Target
            {
                return fixed4(a.uv.x, a.uv.y, abs(_SinTime.z), 1.0);
            }
            ENDCG
        }
    }
}