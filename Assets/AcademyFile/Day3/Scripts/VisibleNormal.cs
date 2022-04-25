using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VisibleNormal : MonoBehaviour
{
    private void OnDrawGizmos()
    {
        Gizmos.color = new Color(1, 1, 0);
        Gizmos.matrix = transform.localToWorldMatrix;

        // 法線方向にラインを描画
        var mesh = GetComponent<MeshFilter>().sharedMesh;

        // 全法線取得できる！
        for (int i = 0; i < mesh.normals.Length; i++)
        {
            var from = mesh.vertices[i];
            var to = from + mesh.normals[i];
            var normalizedNormal = to.normalized;
            Gizmos.color = new Color(0, 1, 0);

            Gizmos.DrawLine(from, to);
            Gizmos.color = new Color(1, 1, 0);

            Gizmos.DrawLine(from, normalizedNormal);
        }
    }
}