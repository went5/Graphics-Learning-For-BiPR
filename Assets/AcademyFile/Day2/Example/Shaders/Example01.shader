Shader "Example/01"
{
    Properties
    {
        // ?C?“?X?y?N?^?[???uMain Color?v?v???p?e?B???\?????????B
        //_Color("Main Color", Color) = (1,1,1,1)
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert		// 頂点シェーダーの入り口
            #pragma fragment frag	// フラグメントシェーダーの入り口

            // 頂点シェーダー
            float4 vert(float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

            // マテリアルで指定した値
            fixed4 _Color:COLOR;

            // フラグメントシェーダー
            fixed4 frag() : SV_Target
            {
                return fixed4(1.0, 0.0, 0.0, 1.0); // ?}?e???A?????w’?????Color?????p
            }
            ENDCG
        }
    }
}