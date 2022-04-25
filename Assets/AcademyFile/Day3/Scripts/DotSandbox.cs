using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DotSandbox : MonoBehaviour
{
    [SerializeField] private Vector3 _v1;
    [SerializeField] private Vector3 _v2;
    private Vector3 n;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        Debug.DrawLine(Vector3.zero, n, new Color(0, 0, 1));
        var nn = Vector3.Dot(_v1, _v2);
        //nn.Normalize();
        Debug.DrawLine(Vector3.zero, new Vector3(nn, 0, 0), new Color(0, 0, 0));
        Debug.DrawLine(Vector3.zero, _v1, new Color(1, 0, 0));
        Debug.DrawLine(Vector3.zero, _v2, new Color(0, 1, 0));
        ConsoleProDebug.Watch("内積の値", $"{nn}");
    }

    void OnDrawGizmos()
    {
        var nn = Vector3.Dot(_v1, _v2);


        Gizmos.DrawSphere(_v1, 0.1f);
        Gizmos.DrawSphere(_v2, 0.1f);
        Gizmos.color = new Color(1, 0, 0);
        Gizmos.DrawLine(Vector3.zero, _v1);
        Gizmos.color = new Color(0, 1, 0);
        Gizmos.DrawLine(Vector3.zero, _v2);

        if (nn > 0)
        {
            Gizmos.color = new Color(1, 1, 0);

        }
        else
        {
            Gizmos.color = new Color(0, 0, 0);

        }
        Gizmos.DrawLine(Vector3.zero, new Vector3(nn, 0, 0));
    }
}