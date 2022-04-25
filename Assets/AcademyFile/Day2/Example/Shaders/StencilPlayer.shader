Shader "Example/StencilPlayer"
{
    Properties
    {
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Texture", 2D) = "white" {}
    }
        SubShader
    {
        Tags {"Queue" = "Geometry+1" }

        // ƒXƒeƒ“ƒVƒ‹ƒoƒbƒtƒ@‚ÌXV‚Ì‚Ý
        Pass
        {
            ZTest Always        // [“x‚É¶‰E‚³‚ê‚¸‚É‘‚«ž‚Þ
            Stencil
            {
                Ref 1
                Comp Equal      // 1‚Æˆê’v‚·‚é‚à‚Ì‚É‘Î‚µ‚Äˆ—
                Pass IncrSat    // ƒCƒ“ƒNƒŠƒƒ“ƒg‚·‚é(1 + 1 = 2)
            }
            ColorMask 0         // ƒXƒeƒ“ƒVƒ‹‚Ì‚Ý‘‚«ž‚Ý
            ZWrite Off          // ƒfƒvƒXƒoƒbƒtƒ@‚É‘‚«ž‚Ü‚È‚¢
        }

        // ‰B‚ê‚Ä‚¢‚È‚¢•”•ª‚ð•`‰æ
        Pass{
            Stencil
            {
                Ref 3
                Comp Always     // ZTest Always‚Å‚Í‚È‚¢‚Ì‚Å‰B‚ê‚Ä‚¢‚é•”•ª‚Í‘ÎÛŠO
                Pass Replace    // ƒXƒeƒ“ƒVƒ‹ƒoƒbƒtƒ@‚ð3‚É‘‚«Š·‚¦
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // ’¸“_ƒVƒF[ƒ_[‚Ö‚Ì“ü—Í’¸“_\‘¢‘Ì
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // ’¸“_ƒVƒF[ƒ_[‚Ìo—Í’¸“_\‘¢‘Ì
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            // ’¸“_ƒVƒF[ƒ_[
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 _Color;
            sampler2D _MainTex;

            fixed4 frag(v2f i) : COLOR
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Color;
                return col;
            }
            ENDCG
        }

        Pass
        {
            ZTest Always    // [“x‚ÉŠÖ‚í‚ç‚¸•`‰æ
            Stencil
            {
                Ref 2
                Comp Equal  // 2‚Æˆê’v‚·‚é‚à‚Ì
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // ’¸“_ƒVƒF[ƒ_[‚Ö‚Ì“ü—Í’¸“_\‘¢‘Ì
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // ’¸“_ƒVƒF[ƒ_[‚Ìo—Í’¸“_\‘¢‘Ì
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            // ’¸“_ƒVƒF[ƒ_[
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 _Color;
            sampler2D _MainTex;

            fixed4 frag(v2f i) : COLOR
            {
                float alpha = tex2D(_MainTex, i.uv).a;
                fixed4 col = fixed4(0,0,0,alpha);
                return col;
            }
            ENDCG
        }
    }
}