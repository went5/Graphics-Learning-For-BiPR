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

        Mesh mesh = new Mesh();             // ���b�V�����쐬
        mesh.Clear();                       // ���b�V��������
        mesh.SetVertices(vertices);         // ���b�V���ɒ��_��o�^����
        mesh.SetTriangles(triangles, 0);    // ���b�V���ɃC���f�b�N�X���X�g��o�^����
        mesh.RecalculateNormals();          // �@���̍Čv�Z

        // �쐬�������b�V�������b�V���t�B���^�[�ɐݒ肷��
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

        Mesh mesh = new Mesh();             // ���b�V�����쐬
        mesh.Clear();                       // ���b�V��������
        mesh.SetVertices(vertices);         // ���b�V���ɒ��_��o�^����
        mesh.SetTriangles(triangles, 0);    // ���b�V���ɃC���f�b�N�X���X�g��o�^����
        mesh.SetColors(colors);             // ���_�J���[�̐ݒ�
        mesh.RecalculateNormals();          // �@���̍Čv�Z

        // �쐬�������b�V�������b�V���t�B���^�[�ɐݒ肷��
        MeshFilter meshFilter = GetComponent<MeshFilter>();
        meshFilter.mesh = mesh;
    }
}
