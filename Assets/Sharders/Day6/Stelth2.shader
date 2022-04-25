Shader "Custom/Stealth"
{
    Properties
    {
        _Shift ("Shift", Range(0.0, 10.0)) = 0
        _RimColor("RimColor", Color) = (1, 1, 1, 1)
        _RimWidth ("RimWidth", Range(0.0, 10.0)) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
        }

        GrabPass
        {
            "_GrabPassTexture"
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 screenPosition : TEXCOORD1;
                float3 normal: TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                half4 grabPos : TEXCOORD4;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _GrabPassTexture;
            float _Shift;
            float _RimWidth;
            float4 _RimColor;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPosition = ComputeScreenPos(o.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal = UnityObjectToWorldNormal(v.normal);

                o.grabPos = ComputeGrabScreenPos(o.vertex + _Shift);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float rim = dot(i.normal, viewDir);
                rim = pow(rim, _RimWidth);

                // 淵に行くほど歪む
                // w除算省略のため tex2Dprojを使用
                float4 color = tex2Dproj(_GrabPassTexture, i.screenPosition);

                float4 rimColor = lerp(_RimColor,fixed4(1, 1, 1, 1), rim);
                return color * rimColor;
            }
            ENDCG
        }
    }
}