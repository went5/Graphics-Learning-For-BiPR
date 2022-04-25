using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NormalSandbox : MonoBehaviour
{
    [SerializeField] private GameObject _sphere0;
    [SerializeField] private GameObject _sphere1;

    [SerializeField] private GameObject _sphere2;

    [SerializeField] private Vector3 _v1;
    [SerializeField] private Vector3 _v2;
    private Vector3 n;

    // Start is called before the first frame update
    void Start()
    {
        Vector3 vv1 = _sphere1.transform.localPosition - _sphere0.transform.localPosition;
        Vector3 vv2 = _sphere2.transform.localPosition - _sphere1.transform.localPosition;
        n = Vector3.Cross(vv1, vv2);
        n.Normalize();
    }

    // Update is called once per frame
    void Update()
    {
        Debug.DrawLine(Vector3.zero, n, new Color(0, 0, 1));
        var nn = Vector3.Cross(_v1, _v2);
        //nn.Normalize();

        Debug.DrawLine(Vector3.zero, nn, new Color(1, 0, 0));
    }

    void OnDrawGizmos()
    {
        Gizmos.DrawSphere(_v1, 0.1f);
        Gizmos.DrawSphere(_v2, 0.1f);
    }
}