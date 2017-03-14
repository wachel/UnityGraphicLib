using UnityEngine;
using System.Collections;
using UnityEditor;
using UnityEngine.SceneManagement;
using System.IO;
using System.Collections.Generic;

public class EditorCoroutine
{
    public static EditorCoroutine start(IEnumerator _routine)
    {
        EditorCoroutine coroutine = new EditorCoroutine(_routine);
        coroutine.start();
        return coroutine;
    }

    readonly IEnumerator routine;
    EditorCoroutine(IEnumerator _routine)
    {
        routine = _routine;
    }

    void start()
    {
        //Debug.Log("start");
        EditorApplication.update += update;
    }
    public void stop()
    {
        //Debug.Log("stop");
        EditorApplication.update -= update;
    }

    void update()
    {
        /* NOTE: no need to try/catch MoveNext,
         * if an IEnumerator throws its next iteration returns false.
         * Also, Unity probably catches when calling EditorApplication.update.
         */

        //Debug.Log("update");
        if (!routine.MoveNext()) {
            stop();
        }
    }
}

[CustomEditor(typeof(LightmapBaker))]
public class LightmapBakerEditor : Editor
{
    private LightmapBaker baker;
    public void OnEnable() 
    {
        baker = this.target as LightmapBaker;
    }
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        GUILayout.BeginHorizontal();
        {
            if (GUILayout.Button("Bake")) {
                //Clear();
                EditorCoroutine.start(BakeDirectionLight());

                //RenderSettings.ambientMode = UnityEngine.Rendering.AmbientMode.Flat;
                //RenderSettings.ambientSkyColor = baker.ambientColor;
                //
                //baker.mainLight.gameObject.SetActive(false);
                //if (baker.otherLights) {
                //    baker.otherLights.gameObject.SetActive(true);
                //}
                //
                //
                //Lightmapping.BakeAsync();
                //Lightmapping.completed = () => {
                //    CopyAmbientTexture();
                //    
                //    RenderSettings.ambientSkyColor = Color.black;
                //    baker.mainLight.gameObject.SetActive(true);
                //    if (baker.otherLights) {
                //        baker.otherLights.gameObject.SetActive(false);
                //    }
                //    //Save();
                //    Lightmapping.BakeAsync();
                //    Lightmapping.completed = () => {
                //        CopyDirectLightTexture();
                //        Save();
                //        Lightmapping.completed = null;
                //    };
                //};
            }

            if (GUILayout.Button("Clear")) {
                Clear();
            }
        }
        GUILayout.EndHorizontal();
    }

    public IEnumerator BakeDirectionLight()
    {
        yield return null;
        RenderSettings.ambientMode = UnityEngine.Rendering.AmbientMode.Flat;
        RenderSettings.ambientSkyColor = baker.ambientColor;

        baker.mainLight.gameObject.SetActive(false);
        if (baker.otherLights) {
            baker.otherLights.gameObject.SetActive(true);
        }
        yield return null;
        Lightmapping.completed = () =>{
            EditorCoroutine.start(DelayCopyAmbient());
        };

        Lightmapping.BakeAsync();
    }

    public IEnumerator DelayCopyAmbient()
    {
        yield return null;
        CopyAmbientTexture();
        EditorCoroutine.start(BakeAmbient());
    }

    public IEnumerator BakeAmbient()
    {
        yield return null;
        RenderSettings.ambientSkyColor = Color.black;
        baker.mainLight.gameObject.SetActive(true);
        if (baker.otherLights) {
            baker.otherLights.gameObject.SetActive(false);
        }
        Lightmapping.completed = () => {
            EditorCoroutine.start(DelayCopyDirection());
        };
        Lightmapping.BakeAsync();
    }

    public IEnumerator DelayCopyDirection()
    {
        yield return null;
        CopyDirectLightTexture();
        Save();
        Lightmapping.completed = null;
    }

    public void Save()
    {
        for (int i = 0; i < baker.lightmaps.Length; i++) {
            string pathToSave = SceneManager.GetActiveScene().path.Remove(SceneManager.GetActiveScene().path.Length - 6);
            string path = pathToSave + "/lightmap_" + i.ToString() + ".png";
            byte[] bytes = baker.lightmaps[i].EncodeToPNG();
            File.WriteAllBytes(path, bytes);
            AssetDatabase.Refresh(); 
            baker.lightmaps[i] = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
            SetTextureImporterFormat(baker.lightmaps[i], false, false, TextureWrapMode.Clamp);
        }
        baker.SetLightmap();
    }
    
    public static void SetTextureImporterFormat(Texture2D texture, bool isReadable,bool mipmapEnabled, TextureWrapMode wrapMode)
    {
        if (null == texture) return;

        string assetPath = AssetDatabase.GetAssetPath(texture);
        var tImporter = AssetImporter.GetAtPath(assetPath) as TextureImporter;
        if (tImporter != null) {
            tImporter.isReadable = isReadable;
            tImporter.mipmapEnabled = mipmapEnabled;
            tImporter.wrapMode = wrapMode;
            AssetDatabase.ImportAsset(assetPath);
            AssetDatabase.Refresh();
        }
    }

    public static Texture2D[] GetLightmaps()
    {
        Texture2D[] rlt = new Texture2D[LightmapSettings.lightmaps.Length];
        for(int i = 0; i < rlt.Length; i++) {
            rlt[i] = LightmapSettings.lightmaps[i].lightmapLight;
        }
        return rlt;
    }

    public static Texture2D[] ReadTextures(Texture2D[] textures)
    {
        Material mat = new Material(Shader.Find("Hidden/ReadLightmap"));
        Texture2D[] result = new Texture2D[textures.Length];
        RenderTexture[] rts = new RenderTexture[textures.Length];
        for (int i = 0; i < textures.Length; i++) {
            if (textures[i] != null) {
                rts[i] = RenderTexture.GetTemporary(textures[i].width, textures[i].height, 0, RenderTextureFormat.ARGBFloat);
                RenderTexture.active = rts[i];
                Graphics.Blit(textures[i], mat);
            }
        }
        for (int i = 0; i < textures.Length; i++) {
            if (rts[i] != null) {
                RenderTexture.active = rts[i];
                result[i] = new Texture2D(textures[i].width, textures[i].height, TextureFormat.RGBAFloat,false);
                result[i].ReadPixels(new Rect(0, 0, textures[i].width, textures[i].height), 0, 0);
                result[i].Apply();
                RenderTexture.ReleaseTemporary(rts[i]);
            }
        }
        RenderTexture.active = null;
        return result;
    }


    public void CopyAmbientTexture()
    {
        //收集最后的光照信息
        Texture2D[] unityLightmaps = ReadTextures(GetLightmaps());

        Texture2D[] finalTextures = new Texture2D[unityLightmaps.Length];
        for (int i = 0; i < unityLightmaps.Length; i++) {
            Texture2D unityLightmap = unityLightmaps[i];
            finalTextures[i] = new Texture2D(unityLightmap.width, unityLightmap.height, TextureFormat.RGBAFloat, false);
            finalTextures[i].wrapMode = TextureWrapMode.Clamp;
            Color[] tempColors = unityLightmap.GetPixels();
            for (int c = 0; c < tempColors.Length; c++) {
                tempColors[c] = (tempColors[c]);
            }
            finalTextures[i].SetPixels(tempColors);
            finalTextures[i].Apply();
        }
        
        baker.lightmaps = finalTextures;
        baker.SetLightmap();
    }

    public void CopyDirectLightTexture()
    {
        //收集最后的光照信息
        Texture2D[] unityLightmaps = ReadTextures(GetLightmaps());
        Texture2D[] finalTextures = new Texture2D[unityLightmaps.Length];
        for (int i = 0; i < unityLightmaps.Length; i++) {
            Texture2D unityLightmap = unityLightmaps[i];
            finalTextures[i] = new Texture2D(unityLightmap.width, unityLightmap.height, TextureFormat.RGBAFloat, false);
            finalTextures[i].wrapMode = TextureWrapMode.Clamp;
            Color[] tempDirColors = unityLightmap.GetPixels();
            Color[] tempAmbientColors = baker.lightmaps[i].GetPixels();

            for (int c = 0; c < tempDirColors.Length; c++) {
                tempAmbientColors[c].a = (tempDirColors[c]).grayscale;
            }
            finalTextures[i].SetPixels(tempAmbientColors);
            finalTextures[i].Apply();
        }

        baker.lightmaps = finalTextures;
        baker.SetLightmap();
    }

    public void Clear()
    {
        Lightmapping.Clear();
        Lightmapping.ClearLightingDataAsset();

        for (int i = 0; i < 100; i++) {
            string assetPath = System.IO.Path.GetDirectoryName(SceneManager.GetActiveScene().path) + "/" + SceneManager.GetActiveScene().name + "/lightmap_" + i.ToString();
            AssetDatabase.DeleteAsset(assetPath);
        }
    }
}
