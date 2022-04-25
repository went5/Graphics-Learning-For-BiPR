using UnityEngine;

// Main Cameraゲームオブジェクトにアタッチ
// ExecuteInEditMode            : プレイしなくても動作させることが可能になる
// ImageEffectAllowedInSceneView: シーンビューにポストエフェクトを反映
[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class Bloom : MonoBehaviour
{
    [SerializeField]
    private Material _material;

    // ブラーをかける方向を格納したシェーダー内プロパティID
    private int _Direction;

    // ボケ画像を格納したシェーダー内プロパティID
    private int _Boke0;
    private int _Boke1;
    private int _Boke2;
    private int _Boke3;

    private void Awake()
    {
        // プロパティIDを取得
        _Direction = Shader.PropertyToID("_Direction");

        _Boke0 = Shader.PropertyToID("_Boke0");
        _Boke1 = Shader.PropertyToID("_Boke1");
        _Boke2 = Shader.PropertyToID("_Boke2");
        _Boke3 = Shader.PropertyToID("_Boke3");
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        RenderTextureFormat rtformat = RenderTextureFormat.ARGBFloat;

        // 0: SamplingLuminance: 輝度の抽出
        var rtLuminance = RenderTexture.GetTemporary(src.width, src.height, 0, rtformat);
        Graphics.Blit(src, rtLuminance, _material, 0);

        // 1:GaussianBlur: ガウシアンブラーでボケ画像を作成
        // ボケ画像用レンダーテスクチャを作成
        var rtBoke0 = RenderTexture.GetTemporary(    src.width / 2,     src.height / 2, 0, rtformat);
        GaussianBlur(rtLuminance, rtBoke0); // 輝度テクスチャにガウシアンブラーをかける
        var rtBoke1 = RenderTexture.GetTemporary(rtBoke0.width / 2, rtBoke0.height / 2, 0, rtformat);
        GaussianBlur(rtBoke0, rtBoke1);
        var rtBoke2 = RenderTexture.GetTemporary(rtBoke1.width / 2, rtBoke1.height / 2, 0, rtformat);
        GaussianBlur(rtBoke1, rtBoke2);
        var rtBoke3 = RenderTexture.GetTemporary(rtBoke2.width / 2, rtBoke2.height / 2, 0, rtformat);
        GaussianBlur(rtBoke2, rtBoke3);

        // 2:BloomFinal:ボケ画像を加算合成
        _material.SetTexture(_Boke0, rtBoke0);
        _material.SetTexture(_Boke1, rtBoke1);
        _material.SetTexture(_Boke2, rtBoke2);
        _material.SetTexture(_Boke3, rtBoke3);
        Graphics.Blit(src, dest, _material, 2);

        // テンポラリレンダーテスクチャの解放
        RenderTexture.ReleaseTemporary(rtBoke3);
        RenderTexture.ReleaseTemporary(rtBoke2);
        RenderTexture.ReleaseTemporary(rtBoke1);
        RenderTexture.ReleaseTemporary(rtBoke0);
        RenderTexture.ReleaseTemporary(rtLuminance);
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