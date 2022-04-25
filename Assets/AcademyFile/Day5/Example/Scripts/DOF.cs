using UnityEngine;

// Main Cameraゲームオブジェクトにアタッチ
// ExecuteInEditMode            : プレイしなくても動作させることが可能になる
// ImageEffectAllowedInSceneView: シーンビューにポストエフェクトを反映
[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class DOF : MonoBehaviour
{
    [SerializeField]
    private Material _material;

    // ブラーをかける方向を格納したシェーダー内プロパティID
    private int _Direction;

    // ボケ画像を格納したシェーダー内プロパティID
    private int _Boke;

    private void Awake()
    {
        // プロパティIDを取得
        _Direction = Shader.PropertyToID("_Direction");

        _Boke = Shader.PropertyToID("_bokeTexture");
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // ボケ画像レンダーテスクチャ
        var rtBoke = RenderTexture.GetTemporary(src.width , src.height);

        // 0:GaussianBlur: ガウシアンブラーでボケ画像を作成
        GaussianBlur(src, rtBoke);

        // 1:DoF
        _material.SetTexture(_Boke, rtBoke);
        Graphics.Blit(src, dest, _material, 1);

        // テンポラリレンダーテスクチャの解放
        RenderTexture.ReleaseTemporary(rtBoke);
    }

    void GaussianBlur(RenderTexture src, RenderTexture dest)
    {
        // 横幅を半分にした作業用のレンダーテスクチャを作成
        var rth = RenderTexture.GetTemporary(src.width / 2, src.height, 0, src.format);

        // ブラー方向のベクトル
        var h = new Vector2(1, 0);
        var v = new Vector2(0, 1);

        // ブラー方向を設定
        _material.SetVector(_Direction, h);
        // ブラー処理を行う
        Graphics.Blit(src, rth, _material, 1);

        // 横幅を半分にしたレンダーテスクチャに対して、縦を半分にしたレンダーテスクチャを作成
        var rtv = RenderTexture.GetTemporary(rth.width, rth.height / 2, 0, src.format);
        // ブラー方向を設定
        _material.SetVector(_Direction, v);
        // ブラー処理を行う
        Graphics.Blit(rth, rtv, _material, 1);

        // 元のサイズに戻す(スケールアップ)
        Graphics.Blit(rtv, dest, _material, 1);

        // テンポラリレンダーテスクチャの解放
        RenderTexture.ReleaseTemporary(rtv);
        RenderTexture.ReleaseTemporary(rth);
    }
}