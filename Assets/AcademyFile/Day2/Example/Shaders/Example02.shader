Shader "Example/02"
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
            #pragma vertex VSMain	   // ’¸“_ƒVƒF[ƒ_[‚Ì“ü‚èŒû
            #pragma fragment PSMain    // ƒtƒ‰ƒOƒƒ“ƒgƒVƒF[ƒ_[‚Ì“ü‚èŒû

            // ’¸“_ƒVƒF[ƒ_[‚Ö‚Ì“ü—Í’¸“_\‘¢‘Ì
            struct VSInput
            {
                float4 pos : SV_POSITION;
            };

            // 頂点シェーダー
            struct VSOutput
            {
                float4 pos : SV_POSITION;
            };

            // ’¸“_ƒVƒF[ƒ_[
            VSOutput VSMain(VSInput In)
            {
                VSOutput vsOut;
                vsOut.pos = UnityObjectToClipPos(In.pos);
                return vsOut;
            }

            // ƒ}ƒeƒŠƒAƒ‹‚ÅŽw’è‚µ‚½Color
            fixed4 _Color;

            // フラグメントシェーダー
            fixed4 PSMain(VSOutput vsOut) : SV_Target
            {
                // 頂点座標は1を超える
                return float4(vsOut.pos.x, vsOut.pos.y, vsOut.pos.z, 1); // ƒ}ƒeƒŠƒAƒ‹‚ÅŽw’è‚µ‚½Color‚ð•Ô‹p
            }
            ENDCG
        }
    }
}