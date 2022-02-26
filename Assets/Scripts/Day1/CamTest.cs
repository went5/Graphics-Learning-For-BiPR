using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamTest : MonoBehaviour
{
    [SerializeField] private Camera _camera;

    void Start()
    {
        // このモデルからワールド空間に変換する行列
        Debug.Log("ワールド空間");

        var modelMatrix = transform.localToWorldMatrix;
        var vertex = new Vector4(2, 0, 0, 1);
        var mv = modelMatrix * vertex;
        Debug.Log($"{modelMatrix}");
        Debug.Log($"vertex {vertex}");
        Debug.Log($"mv {mv}");

        // カメラ空間は右手系から左手系に変わる
        var cameraMatrix = _camera.worldToCameraMatrix;
        var vp = cameraMatrix * modelMatrix;
        var targetPos = vp * vertex;
        // カメラ空間の座標系はxy平面における鏡映なので S(1,1,-1)
        targetPos.z *= -1;
        Debug.Log("==============");
        Debug.Log("カメラ空間");

        Debug.Log(vp);
        Debug.Log($"vertex {vertex}");
        Debug.Log($"targetPos {targetPos}");
    }

    // Update is called once per frame
    void Update()
    {
    }
}