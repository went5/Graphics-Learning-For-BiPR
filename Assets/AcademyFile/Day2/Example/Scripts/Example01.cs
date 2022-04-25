using System.Collections.Generic;
using System.Linq;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class Example01 : MonoBehaviour
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

        Mesh mesh = new Mesh();             // ƒƒbƒVƒ…‚ðì¬
        mesh.Clear();                       // ƒƒbƒVƒ…‰Šú‰»
        mesh.SetVertices(vertices);         // ƒƒbƒVƒ…‚É’¸“_‚ð“o˜^‚·‚é
        mesh.SetTriangles(triangles, 0);    // ƒƒbƒVƒ…‚ÉƒCƒ“ƒfƒbƒNƒXƒŠƒXƒg‚ð“o˜^‚·‚é
        mesh.RecalculateNormals();          // –@ü‚ÌÄŒvŽZ

        // ì¬‚µ‚½ƒƒbƒVƒ…‚ðƒƒbƒVƒ…ƒtƒBƒ‹ƒ^[‚ÉÝ’è‚·‚é
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

        Mesh mesh = new Mesh();             // ƒƒbƒVƒ…‚ðì¬
        mesh.Clear();                       // ƒƒbƒVƒ…‰Šú‰»
        mesh.SetVertices(vertices);         // ƒƒbƒVƒ…‚É’¸“_‚ð“o˜^‚·‚é
        mesh.SetTriangles(triangles, 0);    // ƒƒbƒVƒ…‚ÉƒCƒ“ƒfƒbƒNƒXƒŠƒXƒg‚ð“o˜^‚·‚é
        mesh.SetColors(colors);             // ’¸“_ƒJƒ‰[‚ÌÝ’è
        mesh.RecalculateNormals();          // –@ü‚ÌÄŒvŽZ

        // ì¬‚µ‚½ƒƒbƒVƒ…‚ðƒƒbƒVƒ…ƒtƒBƒ‹ƒ^[‚ÉÝ’è‚·‚é
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = mesh;
    }
}
