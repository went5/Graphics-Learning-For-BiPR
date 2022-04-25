Shader "Day3/One"
{
    Properties
    {
        _Shininess ("Shininess",float) = 20
        _MainTex("Texture",2D) = "white" {}
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

            // _LightColor0が入っている
            #include "Lighting.cginc"

            sampler2D _MainTex;
            half _Shininess;

            struct Input
            {
                float2 uv_MainTex;
            };

            struct appdata
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex:SV_POSITION;
                float3 normal:NORMAL;
                float4 posWorld:TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // ワールド座標系ｊに変換する
                // 平行移動成分の除去 同じ回転成分 逆の拡大縮小成分が必要
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                // ライト方向
                const half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                // 法線の方向とライトの方向の内積 ０以下なら0にする
                const half nDot = saturate(dot(i.normal, lightDir));
                const fixed3 diffuse = _LightColor0.rgb * nDot;

                // specular
                half3 normal = normalize(i.normal);
                float3 reflectDir = reflect(-lightDir, normal);
                // 視線方向
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld);
                // 鏡面反射の強さ
                half speqularLength = saturate(dot(viewDir, reflectDir));
                fixed3 specular = pow(speqularLength, _Shininess);
                // マテリアルに設定したカラー値
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT;
                // カラーを求める
                fixed4 texColor = tex2D(_MainTex, i.uv);
                fixed4 outColor = fixed4((ambient.xyz + diffuse.xyz) * texColor.xyz + specular.xyz, 1.0);
                return outColor;
            }
            ENDCG
        }

    }

}