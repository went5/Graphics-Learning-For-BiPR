using System.Collections.Generic;
using System.Linq;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class Example02 : MonoBehaviour
{
    private Mesh _mesh;

    private void Start()
    {
        Traiangle1();
    }
    void Traiangle1()
    {
        List<Vector3> vertices = new List<Vector3>() {
            new Vector3(-0.5f, -0.5f, 0.0f),
            new Vector3(0.0f, 0.5f, 0.0f),
            new Vector3(0.5f, -0.5f, 0.0f),
        };
        List<int> triangles = new List<int> {
            0, 1, 2,
        };

        Mesh mesh = new Mesh();             // メッシュを作成
        mesh.Clear();                       // メッシュ初期化
        mesh.SetVertices(vertices);         // メッシュに頂点を登録する
        mesh.SetTriangles(triangles, 0);    // メッシュにインデックスリストを登録する
        mesh.RecalculateNormals();          // 法線の再計算

        // 作成したメッシュをメッシュフィルターに設定する
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = mesh;
    }
    void Traiangle2()
    {
        List<Vector3> vertices = new List<Vector3>() {
            new Vector3(-0.5f, -0.5f, 0.0f),
            new Vector3(0.0f, 0.5f, 0.0f),
            new Vector3(0.5f, -0.5f, 0.0f),
        };
        List<int> triangles = new List<int> {
            0, 1, 2,
        };
        List<Color> colors = new List<Color> {
            new Color(1.0f, 0.0f, 0.0f, 1.0f),
            new Color(0.0f, 1.0f, 0.0f, 1.0f),
            new Color(0.0f, 0.0f, 1.0f, 1.0f),
        };

        Mesh mesh = new Mesh();             // メッシュを作成
        mesh.Clear();                       // メッシュ初期化
        mesh.SetVertices(vertices);         // メッシュに頂点を登録する
        mesh.SetTriangles(triangles, 0);    // メッシュにインデックスリストを登録する
        mesh.SetColors(colors);             // 頂点カラーの設定
        mesh.RecalculateNormals();          // 法線の再計算

        // 作成したメッシュをメッシュフィルターに設定する
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = mesh;
    }
}
