using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VisibleVertex : MonoBehaviour
{
    private void OnDrawGizmos()
    {
        Gizmos.color = new Color(0, 1, 0);
        Gizmos.matrix = transform.localToWorldMatrix;

        var mesh = GetComponent<MeshFilter>().sharedMesh;

        for (int i = 0; i < mesh.vertexCount; i++)
        {
            var from = mesh.vertices[i];
            Gizmos.DrawSphere(from, 0.01f);
        }
    }
}