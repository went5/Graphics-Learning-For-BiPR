using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class TileMesh : MonoBehaviour
{
    [SerializeField] private Vector3 Vertices1;
    [SerializeField] private Vector3 Vertices2;
    [SerializeField] private Vector3 Vertices3;
    [SerializeField] private Vector3 Vertices4;

    void Start()
    {
        Tile();
    }

    void Tile()
    {
        List<int> triangles = new List<int>
        {
            0, 1, 2,
            0, 2, 3
        };

        Mesh mesh = new Mesh();
        mesh.Clear();

        List<Vector3> vertices = new List<Vector3>();
        vertices.Add(Vertices1);
        vertices.Add(Vertices2);
        vertices.Add(Vertices3);
        vertices.Add(Vertices4);

        mesh.SetVertices(vertices);
        mesh.SetIndices(triangles, MeshTopology.Triangles, 0); // メッシュにインデックスリストを登録
        mesh.RecalculateNormals(); // 法線の再計算
        // 作成したメッシュをメッシュフィルターに設定
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = mesh;
    }

    // Update is called once per frame
    void Update()
    {
    }
}