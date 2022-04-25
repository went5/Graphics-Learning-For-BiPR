using System;
using UnityEngine;

[RequireComponent(typeof(Camera)), ImageEffectAllowedInSceneView]
public class GlareImageEffect : MonoBehaviour
{
    [SerializeField] private Material _material;

    private int _direction;
    private int _paramsId;

    private Vector3[] offsets = new Vector3[]
        {new Vector3(-1, -1, 0), new Vector3(-1, 1, 0), new Vector3(1, -1, 0), new Vector3(1, 1, 0)};

    private void Awake()
    {
        _direction = Shader.PropertyToID("_direction");
        _paramsId = Shader.PropertyToID("_Params");
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        var rtTemp = RenderTexture.GetTemporary(src.width, src.height);
        var rtTemp2 = RenderTexture.GetTemporary(src.width, src.height);


        // SourceをDestにコピーしておく
        Graphics.Blit(src, dest);
        for (int i = 0; i < 4; i++)
        {
            Graphics.Blit(src, rtTemp, _material, 0);
            var currentSrc = rtTemp;
            var currentTarget = rtTemp2;

            for (int j = 0; j < 4; j++)
            {
                offsets[i].z = j;
                _material.SetVector(_paramsId, offsets[i]);

                Graphics.Blit(currentSrc, currentTarget, _material, 1);
                // 効果を上げるために、入れ替えする
                (currentSrc, currentTarget) = (currentTarget, currentSrc);
            }

            Graphics.Blit(currentSrc, dest, _material, 2);
        }

        RenderTexture.ReleaseTemporary(rtTemp);
        RenderTexture.ReleaseTemporary(rtTemp2);
    }
}