using UnityEngine;

// Main Cameraゲームオブジェクトにアタッチ
// ExecuteInEditMode            : プレイしなくても動作させることが可能になる
// ImageEffectAllowedInSceneView: シーンビューにポストエフェクトを反映
[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class DOF2 : MonoBehaviour
{
    [SerializeField]
    private Material _material;
    private void Awake()
    {
        // 深度値の取得モードを設定
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // ソースのRenderTextureからピクセルを読み込み、
        // マテリアルを適用し、更新された結果をデスティネーションの
        // RenderTextureにコピーします。
        Graphics.Blit(src, dest, _material);
    }
}