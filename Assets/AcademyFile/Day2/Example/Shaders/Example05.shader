Shader "Example/05"
{
    Properties
    {
        // ƒCƒ“ƒXƒyƒNƒ^[‚ÉuMain ColorvƒvƒƒpƒeƒB‚ð•\Ž¦‚µ‚Ü‚·B
        _Color("Main Color", Color) = (1,1,1,1)
        // ƒeƒNƒXƒ`ƒƒ‚ðÝ’è
        _MainTex("Texture", 2D) = "white" { }
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha // ˆê”Ê“I‚ÈƒAƒ‹ƒtƒ@‡¬
        ///Blend One OneMinusSrcAlpha // ƒvƒŠƒ}ƒ‹ƒ`ƒvƒ‰ƒCƒhEƒAƒ‹ƒtƒ@‡¬

        //BlendOp Add
        //BlendOp Sub 
        //BlendOp RevSub 
        //BlendOp Min 
        //BlendOp Max 

        Pass
        {

            CGPROGRAM
            #pragma vertex vert	   // ’¸“_ƒVƒF[ƒ_[‚Ì“ü‚èŒû
            #pragma fragment frag  // ƒtƒ‰ƒOƒƒ“ƒgƒVƒF[ƒ_[‚Ì“ü‚èŒû

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

            // ƒ}ƒeƒŠƒAƒ‹‚ÅŽw’è‚µ‚½Color
            fixed4 _Color;
            // ƒ}ƒeƒŠƒAƒ‹‚ÅÝ’è‚µ‚½ƒeƒNƒXƒ`ƒƒ
            sampler2D _MainTex;

            // ƒsƒNƒZƒ‹ƒVƒF[ƒ_[
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= _Color; // Color‚ðæŽZ
                return col;
            }
            ENDCG
        }
    }
}