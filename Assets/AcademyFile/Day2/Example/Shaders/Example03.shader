Shader "Example/03"
{
    Properties
    {
        // ƒCƒ“ƒXƒyƒNƒ^[‚ÉuMain ColorvƒvƒƒpƒeƒB‚ð•\Ž¦‚µ‚Ü‚·B
        _Color("Main Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert	   // ’¸“_ƒVƒF[ƒ_[‚Ì“ü‚èŒû
            #pragma fragment frag    // ƒtƒ‰ƒOƒƒ“ƒgƒVƒF[ƒ_[‚Ì“ü‚èŒû

            // 頂点シェーダーの入力頂点
            struct appdata
            {
                float4 vertex : POSITION;
            };

            // ’¸“_ƒVƒF[ƒ_[‚Ìo—Í’¸“_\‘¢‘Ì
            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            // ’¸“_ƒVƒF[ƒ_[
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // ƒ}ƒeƒŠƒAƒ‹‚ÅŽw’è‚µ‚½Color
            fixed4 _Color;

            // ƒtƒ‰ƒOƒƒ“ƒgƒVƒF[ƒ_[
            fixed4 frag(v2f i) : SV_Target
            {
                return _Color; // ƒ}ƒeƒŠƒAƒ‹‚ÅŽw’è‚µ‚½Color‚ð•Ô‹p
            }
            ENDCG
        }
    }
}
