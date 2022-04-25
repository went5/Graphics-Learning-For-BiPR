using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class MeshGeneratorWithColor : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        CubeWithColor();
    }

    void CubeWithColor()
    {
        List<Vector3> vertices = new List<Vector3>() {
            // 0
            new Vector3(0.0f, 0.0f, 0.0f), // ³–Ê
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(1.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 0.0f),
            // 4
            new Vector3(1.0f, 1.0f, 0.0f), // ã–Ê
            new Vector3(0.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 1.0f, 1.0f),
            // 8
            new Vector3(1.0f, 0.0f, 0.0f), // ‰E–Ê
            new Vector3(1.0f, 1.0f, 0.0f),
            new Vector3(1.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 0.0f, 1.0f),
            // 12
            new Vector3(0.0f, 0.0f, 0.0f), // ¶–Ê
            new Vector3(0.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 1.0f),
            new Vector3(0.0f, 0.0f, 1.0f),
            // 16
            new Vector3(0.0f, 1.0f, 1.0f), // ”w–Ê
            new Vector3(1.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 0.0f, 1.0f),
            new Vector3(0.0f, 0.0f, 1.0f),
            // 20
            new Vector3(0.0f, 0.0f, 0.0f), // ‰º–Ê
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(1.0f, 0.0f, 1.0f),
            new Vector3(0.0f, 0.0f, 1.0f),

        };
        List<int> triangles = new List<int> {
            0, 3, 2,  0, 2, 1, //‘O–Ê ( 0 -  3)
            5, 6, 7,  5, 7, 4, //ã–Ê ( 4 -  7)
            8, 9,10,  8,10,11, //‰E–Ê ( 8 - 11)
           15,14,13, 15,13,12, //¶–Ê (12 - 15)
           16,18,17, 16,19,18, //‰œ–Ê (16 - 19)
           23,20,21, 23,21,22, //‰º–Ê (20 - 23)
        };
        List<Color> colors = new List<Color>
        {
            Color.blue,
            Color.cyan,
            Color.gray,
            Color.green,
            Color.grey,
            Color.magenta,
            Color.red,
            Color.yellow,

            Color.blue, 
            Color.cyan,
            Color.gray,
            Color.green,
            Color.grey,
            Color.magenta,
            Color.red,
            Color.yellow,

            Color.blue,
            Color.cyan,
            Color.gray,
            Color.green,
            Color.grey,
            Color.magenta,
            Color.red,
            Color.yellow,
        };
        
        

        Mesh mesh = new Mesh();             // ƒƒbƒVƒ…‚ðì¬
        mesh.Clear();                       // ƒƒbƒVƒ…‰Šú‰»
        mesh.SetVertices(vertices);         // ƒƒbƒVƒ…‚É’¸“_‚ð“o˜^‚·‚é
        mesh.SetColors(colors);             // ’¸“_ƒJƒ‰[‚ð“o˜^
        mesh.SetTriangles(triangles, 0);    // ƒƒbƒVƒ…‚ÉƒCƒ“ƒfƒbƒNƒXƒŠƒXƒg‚ð“o˜^‚·‚é
        mesh.RecalculateNormals();          // –@ü‚ÌÄŒvŽZ

        // ì¬‚µ‚½ƒƒbƒVƒ…‚ðƒƒbƒVƒ…ƒtƒBƒ‹ƒ^[‚ÉÝ’è‚·‚é
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = mesh;
    }
}
