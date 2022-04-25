using UnityEngine;

[RequireComponent(typeof(Camera)), ImageEffectAllowedInSceneView]
public class ImageEffect : MonoBehaviour
{
    public Material _material;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        // _MainTexにセットする
        Graphics.Blit(src, dest, _material);
    }
}