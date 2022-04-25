using UnityEngine;

// Main Cameraゲームオブジェクトにアタッチ
// ExecuteInEditMode            : プレイしなくても動作させることが可能になる
// ImageEffectAllowedInSceneView: シーンビューにポストエフェクトを反映
[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class Blur : MonoBehaviour
{
    [SerializeField]
    private Material _material;

    // ブラーをかける方向を格納したシェーダー内プロパティID
    private int _Direction;

    private void Awake()
    {
        // プロパティIDを取得
        _Direction = Shader.PropertyToID("_Direction");
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // 横幅を半分にした作業用のレンダーテスクチャを作成
        var rth = RenderTexture.GetTemporary(src.width / 2, src.height);

        // ブラー方向のベクトル
        var h = new Vector2(1, 0);
        var v = new Vector2(0, 1);

        // ブラー方向を設定
        _material.SetVector(_Direction, h);
        // ブラー処理を行う
        Graphics.Blit(src, rth, _material);

        // 横幅を半分にしたレンダーテスクチャに対して、縦を半分にしたレンダーテスクチャを作成
        var rtv = RenderTexture.GetTemporary(rth.width , rth.height / 2);
        // ブラー方向を設定
        _material.SetVector(_Direction, v);
        // ブラー処理を行う
        Graphics.Blit(rth, rtv, _material);

        // 元のサイズに戻す(スケールアップ)
        Graphics.Blit(rtv, dest, _material);

        // テンポラリレンダーテスクチャの開放
        RenderTexture.ReleaseTemporary(rtv);
        RenderTexture.ReleaseTemporary(rth);
    }
}