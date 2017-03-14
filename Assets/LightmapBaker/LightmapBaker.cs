using UnityEngine;
using System.Collections;
using UnityEngine.SceneManagement;

[ExecuteInEditMode]
public class LightmapBaker : MonoBehaviour
{
    public Color ambientColor;
    public Texture2D[] lightmaps;

    public Light mainLight;
    public Transform otherLights;

    [Range(0,1)]
    public float testTOD = 1;
    public Color shadowColor = Color.black;

    public Color sunColor = Color.white;
    public float brightness = 2;

    public void OnEnable()
    {
        SetLightmap();
    }

    public void SetLightmap()
    {
        LightmapData[] lightmapDatas = new LightmapData[LightmapSettings.lightmaps.Length];
        for (int i = 0; i < LightmapSettings.lightmaps.Length; i++) {
            lightmapDatas[i] = new LightmapData();
            lightmapDatas[i].lightmapLight = lightmaps[i];
        }
        LightmapSettings.lightmaps = lightmapDatas;
    }

    public void Update()
    {
        Shader.SetGlobalVector("lightmap_weight", Vector4.Lerp(new Vector4(0,1,0,0),new Vector4(1,1f,1,1),testTOD));
        Shader.SetGlobalVector("lightmap_scale", Vector4.Lerp(new Vector4(0, 1.1f, 1.4f, 2.5f),new Vector4(1,2,2,2),testTOD));
        Shader.SetGlobalVector("_LightDir", mainLight.transform.TransformDirection(Vector3.forward));
        Shader.SetGlobalColor("shadow_color", Color.Lerp(Color.black,shadowColor,testTOD));
        Color tempColor = sunColor * brightness;
        Shader.SetGlobalVector("ShadowLightAttr1", new Vector4(tempColor.r,tempColor.g,tempColor.b,3));
    }
}
