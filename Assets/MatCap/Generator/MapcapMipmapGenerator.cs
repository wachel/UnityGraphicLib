using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class MapcapMipmapGenerator : EditorWindow
{
    [MenuItem("Window/MapcapMipmapGenerator")]
    static void Init()
    {
        // Get existing open window or if none, make a new one:
        MapcapMipmapGenerator window = (MapcapMipmapGenerator)EditorWindow.GetWindow(typeof(MapcapMipmapGenerator));
        window.Show();
    }

    public Texture2D matCapTex;

    public void OnGUI()
    {
        Texture2D targetTexture;
        matCapTex = (Texture2D)EditorGUILayout.ObjectField( "matcap texture",matCapTex, typeof(Texture2D),false);
        if (GUILayout.Button("Bake")) {
            Texture2D tex = matCapTex;
            targetTexture = new Texture2D(tex.width, tex.height, TextureFormat.ARGB32, true);
            targetTexture.SetPixels32(tex.GetPixels32(),0);
            int mipmapLevel = 1;
            Material bakeMat = new Material(Shader.Find("Hidden/BakeMipmap"));
            while (tex.width > 1) {
                RenderTexture rt = RenderTexture.GetTemporary(tex.width / 2, tex.height / 2, 0, RenderTextureFormat.ARGBFloat);
                RenderTexture.active = rt;
                bakeMat.SetFloat("_Glossiness", Mathf.Pow(1.0f / mipmapLevel,0.5f)*1.1f - 0.1f);
                Graphics.Blit(tex, rt, bakeMat, 0);
                Texture2D readTexture = new Texture2D(rt.width, rt.height, TextureFormat.RGBAFloat, false);
                readTexture.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
                readTexture.Apply(false,false);
                tex = readTexture;
                targetTexture.SetPixels32(tex.GetPixels32(), mipmapLevel);
                mipmapLevel++;
                RenderTexture.ReleaseTemporary(rt);
            }
            targetTexture.Apply(false,false);
            string path = EditorUtility.SaveFilePanelInProject("save texture", "", "asset", "");
            if (!string.IsNullOrEmpty(path)) {
                AssetDatabase.CreateAsset(targetTexture, path);
            }
        }
    }
}
