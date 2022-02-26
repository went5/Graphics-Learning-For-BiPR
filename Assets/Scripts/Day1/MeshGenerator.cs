using System.Collections.Generic;
using System.Linq;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class MeshGenerator : MonoBehaviour
{
    private Mesh _mesh;

    private void Start()
    {
        Cube2();
    }

    void Cube1()
    {
        List<Vector3> vertices = new List<Vector3>()
        {
            new Vector3(0.0f, 0.0f, 0.0f),
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(1.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 0.0f, 1.0f),
            new Vector3(0.0f, 0.0f, 1.0f),
        };
        List<int> triangles = new List<int>
        {
            0, 2, 1, 0, 3, 2, // 正面
            2, 3, 5, 3, 4, 5, //���
            1, 2, 5, 1, 5, 6, //�E��
            0, 7, 4, 0, 4, 3, //����
            5, 4, 6, 4, 7, 6, //�w��
            7, 0, 1, 7, 1, 6, //����
        };

        Mesh mesh = new Mesh();
        mesh.Clear(); // 初期化
        mesh.SetVertices(vertices); // 頂点登録
        //        mesh.SetTriangles(triangles, 0);    // ���b�V���ɃC���f�b�N�X���X�g��o�^����
        mesh.SetIndices(triangles, MeshTopology.Triangles, 0); // メッシュにインデックスリストを登録
        mesh.RecalculateNormals(); // 法線の再計算

        // 作成したメッシュをメッシュフィルターに設定
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = mesh;
    }

    void Cube2()
    {
        List<Vector3> vertices = new List<Vector3>()
        {
            // 0
            new Vector3(0.0f, 0.0f, 0.0f), // ����
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(1.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 0.0f),
            // 4
            new Vector3(1.0f, 1.0f, 0.0f), // ���
            new Vector3(0.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 1.0f, 1.0f),
            // 8
            new Vector3(1.0f, 0.0f, 0.0f), // �E��
            new Vector3(1.0f, 1.0f, 0.0f),
            new Vector3(1.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 0.0f, 1.0f),
            // 12
            new Vector3(0.0f, 0.0f, 0.0f), // ����
            new Vector3(0.0f, 1.0f, 0.0f),
            new Vector3(0.0f, 1.0f, 1.0f),
            new Vector3(0.0f, 0.0f, 1.0f),
            // 16
            new Vector3(0.0f, 1.0f, 1.0f), // �w��
            new Vector3(1.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 0.0f, 1.0f),
            new Vector3(0.0f, 0.0f, 1.0f),
            // 20
            new Vector3(0.0f, 0.0f, 0.0f), // ����
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(1.0f, 0.0f, 1.0f),
            new Vector3(0.0f, 0.0f, 1.0f),
        };
        // 頂点番号をなぞる
        List<int> triangles = new List<int>
        {
            0, 3, 2, 0, 2, 1, //正面
            5, 6, 7, 5, 7, 4, //上
            8, 9, 10, 8, 10, 11, //�E�� ( 8 - 11)
            15, 14, 13, 15, 13, 12, //���� (12 - 15)
            16, 18, 17, 16, 19, 18, //���� (16 - 19)
            23, 20, 21, 23, 21, 22, //���� (20 - 23)
        };

        Mesh mesh = new Mesh(); // ���b�V�����쐬
        mesh.Clear(); // ���b�V��������
        mesh.SetVertices(vertices); // ���b�V���ɒ��_��o�^����
        mesh.SetTriangles(triangles, 0); // ���b�V���ɃC���f�b�N�X���X�g��o�^����
        mesh.RecalculateNormals(); // �@���̍Čv�Z

        // �쐬�������b�V�������b�V���t�B���^�[�ɐݒ肷��
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = mesh;
    }

    void Cube3()
    {
        var mesh = new Mesh();
        _mesh = mesh;

        var vertices = new List<Vector3>();
        var indices = new List<int>();

        var axis = new[] {Vector3.right, Vector3.up, Vector3.forward};
        for (var i = 0; i < 3; ++i)
        {
            var normal = axis[i];
            var binormal = axis[(i + 1) % 3];
            var tangent = Vector3.Cross(normal, binormal);

            vertices.AddRange(new[]
            {
                normal + binormal + tangent,
                normal - binormal + tangent,
                normal + binormal - tangent,
                normal - binormal - tangent,
                -normal + binormal + tangent,
                -normal - binormal + tangent,
                -normal + binormal - tangent,
                -normal - binormal - tangent,
            });

            indices.AddRange(new int[]
            {
                0, 1, 2,
                2, 1, 3,
                5, 4, 6,
                5, 6, 7
            }.Select(j => i * 8 + j));
        }

        mesh.SetVertices(vertices);
        mesh.SetIndices(indices.ToArray(), MeshTopology.Triangles, 0);

        mesh.RecalculateNormals();
        mesh.RecalculateBounds();
        mesh.RecalculateTangents();
        var meshFilter = GetComponent<MeshFilter>();
        meshFilter.sharedMesh = mesh;
    }
}