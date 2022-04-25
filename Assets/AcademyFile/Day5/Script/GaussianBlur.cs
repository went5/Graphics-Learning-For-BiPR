using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GaussianBlur : MonoBehaviour
{
    [SerializeField] private Material _material;
    private int _direction;

    private void Awake()
    {
        _direction = Shader.PropertyToID("_Direction");
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        var halfWidthSrc = RenderTexture.GetTemporary(src.width / 2, src.height);
        var halfHeightSrc = RenderTexture.GetTemporary(src.width, src.height / 2);
        var h = new Vector2(1, 0);
        var v = new Vector2(0, 1);


        // ガウシアンブラー

        // 垂直方向
        _material.SetVector(_direction, h);
        
        // 垂直方向に解像度を落としている
        Graphics.Blit(src, halfWidthSrc, _material);

        // 水平方向
        _material.SetVector(_direction, v);
        Graphics.Blit(halfWidthSrc, halfHeightSrc, _material);

        // 元の解像度に戻す
        Graphics.Blit(halfHeightSrc, dest);

        // 開放
        RenderTexture.ReleaseTemporary(halfWidthSrc);
        RenderTexture.ReleaseTemporary(halfHeightSrc);
    }
}