using System;
using UnityEngine;

[RequireComponent(typeof(Camera)), ImageEffectAllowedInSceneView]
public class BloomImageEffect : MonoBehaviour
{
    [SerializeField] private Material _material;

    private int _direction;
    private int _blurImage0;
    private int _blurImage1;
    private int _blurImage2;
    private int _blurImage3;

    private void Awake()
    {
        _direction = Shader.PropertyToID("_direction");
        _blurImage0 = Shader.PropertyToID("_blurImage0");
        _blurImage1 = Shader.PropertyToID("_blurImage1");
        _blurImage2 = Shader.PropertyToID("_blurImage2");
        _blurImage3 = Shader.PropertyToID("_blurImage3");
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // 照度抽出
        var rtLuminance = RenderTexture.GetTemporary(src.width, src.height, 0, RenderTextureFormat.ARGBFloat);
        Graphics.Blit(src, rtLuminance, _material, 0);

        // // ボケ画像作成
        // for (int i = 0; i < 4; i++)
        // {
        //     var rtBlurImage =
        //         RenderTexture.GetTemporary(src.width / 2, src.height / 2, 0, RenderTextureFormat.ARGBFloat);
        //     GaussianBlur(rtLuminance, rtBlurImage);
        //     _material.SetTexture(_blurImage0, rtBlurImage);
        //     RenderTexture.ReleaseTemporary(rtBlurImage);
        // }

        RenderTextureFormat rtformat = RenderTextureFormat.ARGBFloat;

        var rtBoke0 = RenderTexture.GetTemporary(src.width / 2, src.height / 2, 0, rtformat);
        GaussianBlur(rtLuminance, rtBoke0); // 輝度テクスチャにガウシアンブラーをかける
        var rtBoke1 = RenderTexture.GetTemporary(rtBoke0.width / 2, rtBoke0.height / 2, 0, rtformat);
        GaussianBlur(rtBoke0, rtBoke1);
        var rtBoke2 = RenderTexture.GetTemporary(rtBoke1.width / 2, rtBoke1.height / 2, 0, rtformat);
        GaussianBlur(rtBoke1, rtBoke2);
        var rtBoke3 = RenderTexture.GetTemporary(rtBoke2.width / 2, rtBoke2.height / 2, 0, rtformat);
        GaussianBlur(rtBoke2, rtBoke3);

        // 2:BloomFinal:ボケ画像を加算合成
        _material.SetTexture(_blurImage0, rtBoke0);
        _material.SetTexture(_blurImage1, rtBoke1);
        _material.SetTexture(_blurImage2, rtBoke2);
        _material.SetTexture(_blurImage3, rtBoke3);
        Graphics.Blit(src, dest, _material, 2);

        // テンポラリレンダーテスクチャの解放
        RenderTexture.ReleaseTemporary(rtBoke3);
        RenderTexture.ReleaseTemporary(rtBoke2);
        RenderTexture.ReleaseTemporary(rtBoke1);
        RenderTexture.ReleaseTemporary(rtBoke0);

        Graphics.Blit(src, dest, _material, 2);
    }

    void GaussianBlur(RenderTexture src, RenderTexture dest)
    {
        var halfWidthSrc = RenderTexture.GetTemporary(src.width / 2, src.height, 0, src.format);
        var halfHeightSrc = RenderTexture.GetTemporary(src.width, src.height / 2, 0, src.format);

        var h = new Vector2(1, 0);
        var v = new Vector2(0, 1);

        _material.SetVector(_direction, h);
        Graphics.Blit(src, halfWidthSrc, _material, 1);

        _material.SetVector(_direction, v);
        Graphics.Blit(halfWidthSrc, halfHeightSrc, _material, 1);

        Graphics.Blit(halfHeightSrc, dest, _material, 1);

        RenderTexture.ReleaseTemporary(halfWidthSrc);
        RenderTexture.ReleaseTemporary(halfHeightSrc);
    }
}