using UnityEngine;

// Main Cameraゲームオブジェクトにアタッチ
// ExecuteInEditMode            : プレイしなくても動作させることが可能になる
// ImageEffectAllowedInSceneView: シーンビューにポストエフェクトを反映
[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class DOF3 : MonoBehaviour
{
    [SerializeField]
    private Material _material;

    [SerializeField]
    // フォーカスする距離
    private float focalDistance=5;

    private Camera _camera;

    // シェーダのプロパティID
    private int _directionID;
    private int _bokeID;
    private int _forcalDistanceID;

    private void Awake()
    {
        _directionID = Shader.PropertyToID("_direction");
        _bokeID = Shader.PropertyToID("_bokeTexture");
        _forcalDistanceID = Shader.PropertyToID("_focalDistance");

        // 深度値の取得モードを設定
        _camera = GetComponent<Camera>();
        _camera.depthTextureMode |= DepthTextureMode.Depth;
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // ガウシアンブラーを掛ける
        var rtBoke = RenderTexture.GetTemporary(src.width , src.height);
        GaussianBlur(src, rtBoke);

        // 深度情報を元にDoF処理
        _material.SetTexture(_bokeID, rtBoke);
        _material.SetFloat(_forcalDistanceID, FocalDistance01(focalDistance));
        Graphics.Blit(src, dest, _material, 1);

        // レンダーテスクチャの解放
        RenderTexture.ReleaseTemporary(rtBoke);
    }

    // 指定されたdistanceを0～1空間に変換する
    private float FocalDistance01(float distance)
    {
        float start = (distance - _camera.nearClipPlane);
        float cliping = _camera.farClipPlane - _camera.nearClipPlane;
        Vector3 cameraToDistance = start * _camera.transform.forward + _camera.transform.position;
        float distance01 = _camera.WorldToViewportPoint(cameraToDistance).z;
        distance01 = distance01 / cliping;
        return distance01;
    }
    void GaussianBlur(RenderTexture src, RenderTexture dest)
    {
        // 横幅を半分にした作業用のレンダーテスクチャを作成
        var rth = RenderTexture.GetTemporary(src.width / 2, src.height, 0, src.format);

        // ブラー方向のベクトル
        var h = new Vector2(1, 0);
        var v = new Vector2(0, 1);

        // ブラー方向を設定
        _material.SetVector(_directionID, h);
        // ブラー処理を行う
        Graphics.Blit(src, rth, _material, 0);

        // 横幅を半分にしたレンダーテスクチャに対して、縦を半分にしたレンダーテスクチャを作成
        var rtv = RenderTexture.GetTemporary(rth.width, rth.height / 2, 0, src.format);
        // ブラー方向を設定
        _material.SetVector(_directionID, v);
        // ブラー処理を行う
        Graphics.Blit(rth, rtv, _material, 0);

        // 元のサイズに戻す(スケールアップ)
        Graphics.Blit(rtv, dest, _material, 0);

        // テンポラリレンダーテスクチャの解放
        RenderTexture.ReleaseTemporary(rtv);
        RenderTexture.ReleaseTemporary(rth);
    }

}