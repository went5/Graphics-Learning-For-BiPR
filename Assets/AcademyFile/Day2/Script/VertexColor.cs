using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VertexColor : MonoBehaviour
{
    // Start is called before the first frame update
    private int _vertexCount;
    private Mesh _mesh;

    void Start()
    {
        _mesh = GetComponent<MeshFilter>().sharedMesh;
        _vertexCount = _mesh.vertexCount;
        var colors = new Color[_vertexCount];

        for (int i = 0; i < _mesh.vertexCount; i++)
        {
            var v = Mathf.InverseLerp(0, _vertexCount, i);
            colors[i] = new Color(v, v, 1, 1);
        }

        _mesh.colors = colors;
    }
}