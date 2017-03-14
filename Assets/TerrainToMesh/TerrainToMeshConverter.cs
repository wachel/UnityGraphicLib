using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TerrainToMeshConverter : MonoBehaviour
{
    public Terrain terrain;
    public int gridSize = 64;
    public float error = 0.1f;
    public float alphaMapThreshold = 0.02f;
}
