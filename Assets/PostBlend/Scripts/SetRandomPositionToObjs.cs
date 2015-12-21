using UnityEngine;
using System.Collections;

public class SetRandomPositionToObjs : MonoBehaviour
{
	public Transform[] targets;
	// Use this for initialization
	void Start ()
	{
		var c = Camera.main;
		foreach (var t in targets) {
			var pos = new Vector3 (Random.value, Random.value, Mathf.Lerp (c.nearClipPlane, c.farClipPlane, 0.2f + 0.5f * Random.value));
			pos = c.ViewportToWorldPoint (pos);
			t.position = pos;
		}
	}
}
