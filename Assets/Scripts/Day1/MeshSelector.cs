using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class MeshSelector : MonoBehaviour
{
    // 横の分割数
    [SerializeField] int _wDivNum = 6; //最低4

    // 縦の分割数
    [SerializeField] int _hDivNum = 4; //最低2

    // [Button("メッシュ更新")]
    // private void OnClick()
    // {
    //     Awake();
    // }

    // Start is called before the first frame update
    void Awake()
    {
        //createCircle();
        createSphere();
    }

    // Update is called once per frame
    void Update()
    {
    }

    void createCircle()
    {
        // 頂点作成
        var vertices = new List<Vector3>() {new Vector3(0, 0, 0)};
        // 単位円
        for (int i = 0; i <= 360; i += 30)
        {
            var rad = i * Mathf.Deg2Rad;
            vertices.Add(new Vector3(Mathf.Cos(rad), Mathf.Sin(rad), 0));
        }

        Debug.Log(vertices.Count - 2);


        // 三角形のインデックス
        List<int> triangles = new List<int>();

        for (int i = 0; i < vertices.Count - 1; i++)
        {
            triangles.Add(0);
            triangles.Add(i);
            triangles.Add(i + 1);
        }

        Debug.Log(triangles.Count - 2);
        Mesh mesh = new Mesh();
        mesh.Clear();
        mesh.SetVertices(vertices);
        mesh.SetTriangles(triangles, 0);
        mesh.RecalculateNormals();

        MeshFilter mF = GetComponent<MeshFilter>();
        mF.mesh = mesh;
    }

    void createSphere()
    {
        var height = 1;
        // 90度(一番高い頂点)
        var vertices = new List<Vector3>() {new Vector3(0, height, 0)};

        // 横に関して
        var betweenHDeg = 180 / _hDivNum;
        // 縦に関して
        var betweenWDeg = 360 / _wDivNum;
        var betweenWRad = betweenWDeg * Mathf.Deg2Rad;
        for (int i = 0; i < _hDivNum - 1; i++)
        {
            var nextYRad = (90 - betweenHDeg * (i + 1)) * Mathf.Deg2Rad;
            var nextY = Mathf.Sin(nextYRad);
            var nextCircleRange = Mathf.Abs(Mathf.Cos(nextYRad));

            // 分割数で回す
            for (int j = 0; j < _wDivNum; j++)
            {
                var nextX = nextCircleRange * Mathf.Cos(j * betweenWRad);
                var nextZ = nextCircleRange * Mathf.Sin(j * betweenWRad);
                vertices.Add(new Vector3(nextX, nextY, nextZ));
            }
        }

        // 一番低い頂点
        vertices.Add((new Vector3(0, -height, 0)));


        // // 一つした
        // var nextYDeg = 90 - betweenHDeg;
        // var nextYRad = nextYDeg * Mathf.Deg2Rad;
        // var nextY = Mathf.Cos(nextYRad);
        //
        // var nextCircleRange = Mathf.Sin(nextYRad);


        List<int> triangles1 = new List<int>();
        // 天面
        for (int i = 0; i < _wDivNum; i++)
        {
            triangles1.Add(0);
            triangles1.Add(overIndex(1, i + 2, _wDivNum));
            triangles1.Add(i + 1);
        }

        List<int> triangles2 = new List<int>();

        var maxSideNum = _hDivNum - 2;
        var downStartIndex = 0;
        // 1を修正する
        for (int sideNum = 0; sideNum < maxSideNum; sideNum++)
        {
            var upStartIndex = _wDivNum * sideNum + 1;
            downStartIndex = upStartIndex + _wDivNum;
            var downLimitIndex = downStartIndex + _wDivNum - 1;
            var startLimitIndex = downStartIndex - 1;
            for (int i = 0; i < _wDivNum; i++)
            {
                var upCurrentIndex = _wDivNum * sideNum + i + 1; // 1
                var downCurrentIndex = upCurrentIndex + _wDivNum; // 7

                // 側面
                // 順番かなり重要
                triangles2.Add(overIndex(upStartIndex, upCurrentIndex, startLimitIndex));
                triangles2.Add(overIndex(downStartIndex, downCurrentIndex + 1, downLimitIndex));
                triangles2.Add(overIndex(downStartIndex, downCurrentIndex, downLimitIndex));

                triangles2.Add(overIndex(upStartIndex, upCurrentIndex, downStartIndex));
                triangles2.Add(overIndex(upStartIndex, upCurrentIndex + 1, startLimitIndex));
                triangles2.Add(overIndex(downStartIndex, downCurrentIndex + 1, downLimitIndex));
            }
        }

        List<int> triangles3 = new List<int>();

        // 底面
        var bottomLimitIndex = downStartIndex + _wDivNum - 1;
        for (int i = 0; i < _wDivNum; i++)
        {
            triangles3.Add(vertices.Count - 1);
            triangles3.Add(overIndex(downStartIndex, downStartIndex + i, bottomLimitIndex));
            triangles3.Add(overIndex(downStartIndex, downStartIndex + i + 1, bottomLimitIndex));
        }

        var triangles = triangles1.Concat(triangles2).Concat(triangles3).ToList();
        createMesh(vertices, triangles);
    }

    void createMesh(List<Vector3> vertices, List<int> triangles)
    {
        Debug.Log(vertices);
        Debug.Log(triangles);
        Mesh mesh = new Mesh();
        mesh.Clear();
        mesh.SetVertices(vertices);

        mesh.SetTriangles(triangles, 0);
        // mesh.SetIndices(triangles, MeshTopology.Points, 0); // メッシュにインデックスリストを登録
        mesh.RecalculateNormals();

        MeshFilter mF = GetComponent<MeshFilter>();
        mF.mesh = mesh;
    }

    int overIndex(int startIndex, int currentIndex, int limitIndex)
    {
        return currentIndex > limitIndex ? currentIndex - limitIndex + startIndex - 1 : currentIndex;
    }
}